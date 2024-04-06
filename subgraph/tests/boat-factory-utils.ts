import { newMockEvent } from "matchstick-as"
import { ethereum, Address } from "@graphprotocol/graph-ts"
import { BoatCreated } from "../generated/BoatFactory/BoatFactory"

export function createBoatCreatedEvent(boatAddress: Address): BoatCreated {
  let boatCreatedEvent = changetype<BoatCreated>(newMockEvent())

  boatCreatedEvent.parameters = new Array()

  boatCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "boatAddress",
      ethereum.Value.fromAddress(boatAddress)
    )
  )

  return boatCreatedEvent
}
