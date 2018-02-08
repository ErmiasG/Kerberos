package com.example.spnego.rest.application.config;

import org.glassfish.jersey.server.ResourceConfig;

@javax.ws.rs.ApplicationPath("api")
public class ApplicationConfig extends ResourceConfig {
  public ApplicationConfig() {
    register(com.example.spnego.rest.ProtectedResources.class);
    register(com.example.spnego.rest.UnprotectedResources.class);
  }
}
