void groupMemoryBarrierWithGroupSync() {
  groupMemoryBarrier();
  barrier();
}