package com.example.spnego.rest;

import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;

@Path("/unprotected")
public class UnprotectedResources {
  private final static Logger LOGGER = Logger.getLogger(UnprotectedResources.class.getName());
  
  @GET
  @Path("/resource")
  @Produces(MediaType.APPLICATION_JSON)
  public Response getUnprotectedResource(@Context SecurityContext sc, @Context HttpServletRequest req) {
    JsonResponse json = new JsonResponse();
    json.setStatus("SUCCESS");
    json.setMessage("Unprotected Resource");
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
    LOGGER.log(Level.INFO, "Response: {0}", json);
    return Response.ok(json).build();
  }
}
