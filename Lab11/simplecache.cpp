#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  auto &target = _cache[index];
  for(auto it = target.begin(); it != target.end(); ++it) {
    if(it->tag() == tag) {
      if(it->valid()) {
        return it->get_byte(block_offset);
      }
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")
  auto &target = _cache[index];
  for (auto it = target.begin(); it != target.end(); ++it) {
    if(!it->valid()) {
      it->replace(tag,data);
      return;
    }
  }
  target[0].replace(tag, data);
}