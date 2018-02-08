package com.example.spnego.rest;

import com.example.spnego.ldap.realm.LdapRealm;
import com.example.spnego.ldap.realm.LdapUserDTO;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;

@Path("/protected")
public class ProtectedResources {

  private final static Logger LOGGER = Logger.getLogger(ProtectedResources.class.getName());
  @EJB
  private LdapRealm ldapRealm;

  @GET
  @Path("/resource")
  @Produces(MediaType.APPLICATION_JSON)
  public Response getProtectedResource(@Context SecurityContext sc, @Context HttpServletRequest req) throws
      NamingException {
    JsonResponse json = new JsonResponse();
    json.setStatus("SUCCESS");
    json.setMessage("Protected Resource!");
    json.setSessionID(req.getSession().getId());
    json.setAuthType(req.getAuthType());
    String principalName = sc.getUserPrincipal() == null ? "" : sc.getUserPrincipal().getName();
    json.setPrincipal(principalName);
    Enumeration<String> names = req.getHeaderNames();
    while (names.hasMoreElements()) {
      String name = names.nextElement();
      LOGGER.log(Level.INFO, "{0} = {1}", new Object[]{name, req.getHeader(name)});
      if ("authorization".equals(name)) {
        json.setToken(req.getHeader(name));
      }
    }
    LdapUserDTO ldapUser = ldapRealm.findKrbUser(principalName);
    json.setUser(ldapUser);
    LOGGER.log(Level.INFO, "Response: {0}", json);
    return Response.ok(json).build();
  }
}
