package com.github.bentaljaard.fulfilment;

import java.util.UUID;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import org.eclipse.microprofile.reactive.messaging.Message;
import org.eclipse.microprofile.reactive.messaging.Metadata;

import io.smallrye.reactive.messaging.ce.OutgoingCloudEventMetadata;
import io.smallrye.reactive.messaging.ce.impl.DefaultOutgoingCloudEventMetadata;
import net.datafaker.Faker;

@Path("/fulfilment-requests")
public class Generate {

    @Channel("fulfilment")
    Emitter<FulfilmentRequest> fulfilmentRequestEmitter;

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public GeneratorRequest generateRequests(GeneratorRequest req) {
        Faker faker = new Faker();
        FulfilmentRequest dummyRequest = null;
        for (int i = 0; i < req.getNumberOfRequests(); i++) {
            dummyRequest = new FulfilmentRequest(UUID.randomUUID().toString(),faker.expression("#{options.option 'EU','US'}"),UUID.randomUUID().toString(), faker.commerce().productName(), faker.number().numberBetween(1, 10) , faker.name().fullName(), faker.address().fullAddress());
            // System.out.println(dummyRequest.toString());
            OutgoingCloudEventMetadata md = OutgoingCloudEventMetadata.builder()
                .withSubject(dummyRequest.getFulfilmentCenter()).build();
            fulfilmentRequestEmitter.send(Message.of(dummyRequest,Metadata.of(md)));
        }
       
        return req;
    }
}