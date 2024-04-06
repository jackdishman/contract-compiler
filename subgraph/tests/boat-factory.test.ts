import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address } from "@graphprotocol/graph-ts"
import { BoatCreated } from "../generated/schema"
import { BoatCreated as BoatCreatedEvent } from "../generated/BoatFactory/BoatFactory"
import { handleBoatCreated } from "../src/boat-factory"
import { createBoatCreatedEvent } from "./boat-factory-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let boatAddress = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let newBoatCreatedEvent = createBoatCreatedEvent(boatAddress)
    handleBoatCreated(newBoatCreatedEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("BoatCreated created and stored", () => {
    assert.entityCount("BoatCreated", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "BoatCreated",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "boatAddress",
      "0x0000000000000000000000000000000000000001"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
