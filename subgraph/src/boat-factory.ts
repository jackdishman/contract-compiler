import { BoatCreated as BoatCreatedEvent } from "../generated/BoatFactory/BoatFactory"
import { BoatCreated } from "../generated/schema"

export function handleBoatCreated(event: BoatCreatedEvent): void {
  let entity = new BoatCreated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.boatAddress = event.params.boatAddress

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
