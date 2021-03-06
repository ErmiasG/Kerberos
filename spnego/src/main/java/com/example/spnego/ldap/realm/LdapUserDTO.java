
package com.example.spnego.ldap.realm;

import java.util.List;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class LdapUserDTO {
  private String entryUUID;
  private String uid;
  private String givenName;
  private String sn;
  private List<String> email;
  private List<String> roles;

  public LdapUserDTO() {
  }

  public LdapUserDTO(String entryUUID, String uid, String givenName, String sn, List<String> email) {
    this.entryUUID = entryUUID;
    this.uid = uid;
    this.givenName = givenName;
    this.sn = sn;
    this.email = email;
  }
  
  public String getEntryUUID() {
    return entryUUID;
  }

  public void setEntryUUID(String entryUUID) {
    this.entryUUID = entryUUID;
  }

  public String getUid() {
    return uid;
  }

  public void setUid(String uid) {
    this.uid = uid;
  }

  public String getGivenName() {
    return givenName;
  }

  public void setGivenName(String givenName) {
    this.givenName = givenName;
  }

  public String getSn() {
    return sn;
  }

  public void setSn(String sn) {
    this.sn = sn;
  }

  public List<String> getEmail() {
    return email;
  }

  public void setEmail(List<String> email) {
    this.email = email;
  }

  public List<String> getRoles() {
    return roles;
  }

  public void setRoles(List<String> roles) {
    this.roles = roles;
  }

  @Override
  public String toString() {
    return "LdapUserDTO{" + "entryUUID=" + entryUUID + ", uid=" + uid + ", givenName=" + givenName + ", sn=" + sn +
        ", email=" + email + ", roles=" + roles + '}';
  }

  
}
