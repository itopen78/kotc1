package com.kotc.vo;

import java.io.Serializable;
import java.util.Map;

public class LoginToken implements Serializable{
	private static final long serialVersionUID = -2446413544111281211L;
	private Map user;
	private String username;
	private String role;

	public LoginToken(Map user) {
		this.user = user;
	}

	public Map getUser() {
		return user;
	}

	public void setUser(Map user) {
		this.user = user;
	}
	
	public String getUsername() {
		return user.get("MAS_USER_ID").toString();
	}

	public String getRole() {
		//return user.getRole();
		return "";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((user == null) ? 0 : user.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		LoginToken other = (LoginToken) obj;
		if (user == null) {
			if (other.user != null)
				return false;
		} else if (!user.equals(other.user))
			return false;
		return true;
	}

}
