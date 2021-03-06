package com.westar.base.model;

import com.westar.base.annotation.DefaultFiled;
import com.westar.base.annotation.Filed;
import com.westar.base.annotation.Identity;
import com.westar.base.annotation.Table;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

/** 
 * 考勤机连接配置
 */
@Table
@JsonInclude(Include.NON_NULL)
public class AttenceConnSet {
	/** 
	* id主键
	*/
	@Identity
	private Integer id;
	/** 
	* 记录创建时间
	*/
	@DefaultFiled
	private String recordCreateTime;
	/** 
	* 企业编号
	*/
	@Filed
	private Integer comId;
	/** 
	* 连接IP
	*/
	@Filed
	private String connIP;
	/** 
	* 端口
	*/
	@Filed
	private Integer port;
	/** 
	* 1中控
	*/
	@Filed
	private Integer type;

	/****************以上主要为系统表字段********************/

	/****************以上为自己添加字段********************/
	/** 
	* id主键
	* @param id
	*/
	public void setId(Integer id) {
		this.id = id;
	}

	/** 
	* id主键
	* @return
	*/
	public Integer getId() {
		return id;
	}

	/** 
	* 记录创建时间
	* @param recordCreateTime
	*/
	public void setRecordCreateTime(String recordCreateTime) {
		this.recordCreateTime = recordCreateTime;
	}

	/** 
	* 记录创建时间
	* @return
	*/
	public String getRecordCreateTime() {
		return recordCreateTime;
	}

	/** 
	* 企业编号
	* @param comId
	*/
	public void setComId(Integer comId) {
		this.comId = comId;
	}

	/** 
	* 企业编号
	* @return
	*/
	public Integer getComId() {
		return comId;
	}

	/** 
	* 连接IP
	* @param connIP
	*/
	public void setConnIP(String connIP) {
		this.connIP = connIP;
	}

	/** 
	* 连接IP
	* @return
	*/
	public String getConnIP() {
		return connIP;
	}

	/** 
	* 端口
	* @param port
	*/
	public void setPort(Integer port) {
		this.port = port;
	}

	/** 
	* 端口
	* @return
	*/
	public Integer getPort() {
		return port;
	}

	/** 
	* 1中控
	* @param type
	*/
	public void setType(Integer type) {
		this.type = type;
	}

	/** 
	* 1中控
	* @return
	*/
	public Integer getType() {
		return type;
	}
}
