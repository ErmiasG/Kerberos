package com.example.spnego.rest;

import com.example.spnego.ldap.realm.LdapUserDTO;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class JsonResponse {
  private String status;
  private String message;
  private LdapUserDTO user;
  private String sessionID;
  private String principal;
  private String authType;
  private String token;

  public JsonResponse() {
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  public LdapUserDTO getUser() {
    return user;
  }

  public void setUser(LdapUserDTO user) {
    this.user = user;
  }

  public String getSessionID() {
    return sessionID;
  }

  public void setSessionID(String sessionID) {
    this.sessionID = sessionID;
  }

  public String getPrincipal() {
    return principal;
  }

  public void setPrincipal(String principal) {
    this.principal = principal;
  }

  public String getAuthType() {
    return authType;
  }

  public void setAuthType(String authType) {
    this.authType = authType;
  }

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }

  @Override
  public String toString() {
    return "JsonResponse{" + "status=" + status + ", message=" + message + ", user=" + user + ", sessionID=" + sessionID +
        ", principal=" + principal + ", authType=" + authType + ", token=" + token + '}';
  }
  
}
