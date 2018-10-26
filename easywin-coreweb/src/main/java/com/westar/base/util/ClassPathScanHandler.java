package com.westar.base.util;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.net.JarURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.Enumeration;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

/**
 * 扫描指定包（包括jar）下的class文件 
 */
public class ClassPathScanHandler {

    private static final Logger logger = Logger.getLogger(ClassPathScanHandler.class);

    //是否排除内部类 true是 false否
    private boolean excludeInner = true;
    
    //过滤规则适用情况 true搜索符合规则的 false排除符合规则的
    private boolean checkInOrEx = true;

    //过滤规则列表 如果是null或者空，即全部符合不过滤
    private List<String> classFilters = null;

    //无参构造器，默认是排除内部类、并搜索符合规则
    public ClassPathScanHandler() {
    	
    }

    public ClassPathScanHandler(Boolean excludeInner, Boolean checkInOrEx,List<String> classFilters) {
        this.excludeInner = excludeInner;
        this.checkInOrEx = checkInOrEx;
        this.classFilters = classFilters;

    }

    /**
     * 扫描包
     * @param basePackage
     * @param recursive
     * @return
     */
	@SuppressWarnings("unchecked")
	public Set<Class> getPackageAllClasses(String basePackage, boolean recursive) {
        Set<Class> classes = new LinkedHashSet<Class>();
        String packageName = basePackage;
        if (packageName.endsWith(".")) {
            packageName = packageName.substring(0, packageName.lastIndexOf('.'));
        }
        String package2Path = packageName.replace('.', '/');

        Enumeration<URL> dirs;
        try {
            dirs = Thread.currentThread().getContextClassLoader().getResources(package2Path);
            while (dirs.hasMoreElements()) {
                URL url = dirs.nextElement();
                String protocol = url.getProtocol();
                if ("file".equals(protocol)) {
                    logger.info("扫描file类型的class文件....");
                    String filePath = URLDecoder.decode(url.getFile(), "UTF-8");
                    doScanPackageClassesByFile(classes, packageName, filePath,recursive);
                } else if ("jar".equals(protocol)) {
                    logger.info("扫描jar文件中的class文件....");
                    doScanPackageClassesByJar(packageName, url, recursive,classes);
                }
            }
        } catch (IOException e) {
            logger.error("IOException error:", e);
        }

        return classes;
    }

    /**
     * 以jar的方式扫描包下的所有Class文件
     * @param basePackage
     * @param url
     * @param recursive
     * @param classes
     */
	@SuppressWarnings("unchecked")
	private void doScanPackageClassesByJar(String basePackage, URL url,final boolean recursive, Set<Class> classes) {
        String packageName = basePackage;
        String package2Path = packageName.replace('.', '/');
        JarFile jar;
        try {
            jar = ((JarURLConnection) url.openConnection()).getJarFile();
            Enumeration<JarEntry> entries = jar.entries();
            while (entries.hasMoreElements()) {
                JarEntry entry = entries.nextElement();
                String name = entry.getName();
                if (!name.startsWith(package2Path) || entry.isDirectory()) {
                    continue;
                }

                // 判断是否递归搜索子包
                if (!recursive&& name.lastIndexOf('/') != package2Path.length()) {
                    continue;
                }
                // 判断是否过滤 inner class
                if (this.excludeInner && name.indexOf('$') != -1) {
                    logger.info("exclude inner class with name:" + name);
                    continue;
                }
                String classSimpleName = name.substring(name.lastIndexOf('/') + 1);
                // 判定是否符合过滤条件
                if (this.filterClassName(classSimpleName)) {
                    String className = name.replace('/', '.');
                    className = className.substring(0, className.length() - 6);
                    try {
                        classes.add(Thread.currentThread().getContextClassLoader().loadClass(className));
                    } catch (ClassNotFoundException e) {
                        logger.error("Class.forName error:", e);
                    }
                }
            }
        } catch (IOException e) {
            logger.error("IOException error:", e);
        }
    }

    /**
     * 以文件的方式扫描包下的所有Class文件
     * @param classes
     * @param packageName
     * @param packagePath
     * @param recursive
     */
    @SuppressWarnings("unchecked")
	private void doScanPackageClassesByFile(Set<Class> classes,String packageName, String packagePath, boolean recursive) {
        File dir = new File(packagePath);
        if (!dir.exists() || !dir.isDirectory()) {
            return;
        }
        final boolean fileRecursive = recursive;
        File[] dirfiles = dir.listFiles(new FileFilter() {
            // 自定义文件过滤规则
            public boolean accept(File file) {
                if (file.isDirectory()) {
                    return fileRecursive;
                }
                String filename = file.getName();
                if (excludeInner && filename.indexOf('$') != -1) {
                    logger.info("exclude inner class with name:" + filename);
                    return false;
                }
                return filterClassName(filename);
            }
        });
        for (File file : dirfiles) {
            if (file.isDirectory()) {
                doScanPackageClassesByFile(classes, packageName + "."+ file.getName(), file.getAbsolutePath(), recursive);
            } else {
                String className = file.getName().substring(0,file.getName().length() - 6);
                try {
                    classes.add(Thread.currentThread().getContextClassLoader().loadClass(packageName + '.' + className));
                } catch (ClassNotFoundException e) {
                    logger.error("IOException error:", e);
                }
            }
        }
    }

    /**
     * 根据过滤规则判断类名
     * @param className
     * @return
     */
    private boolean filterClassName(String className) {
        if (!className.endsWith(".class")) {
            return false;
        }
        if (null == this.classFilters || this.classFilters.isEmpty()) {
            return true;
        }
        String tmpName = className.substring(0, className.length() - 6);
        boolean flag = false;
        for (String str : classFilters) {
            String tmpreg = "^" + str.replace("*", ".*") + "$";
            Pattern p = Pattern.compile(tmpreg);
            if (p.matcher(tmpName).find()) {
                flag = true;
                break;
            }
        }
        return (checkInOrEx && flag) || (!checkInOrEx && !flag);
    }

    public boolean isExcludeInner() {
        return excludeInner;
    }

    public boolean isCheckInOrEx() {
        return checkInOrEx;
    }

    public List<String> getClassFilters() {
        return classFilters;
    }

    public void setExcludeInner(boolean pExcludeInner) {
        excludeInner = pExcludeInner;
    }

    public void setCheckInOrEx(boolean pCheckInOrEx) {
        checkInOrEx = pCheckInOrEx;
    }

    public void setClassFilters(List<String> pClassFilters) {
        classFilters = pClassFilters;
    }
}