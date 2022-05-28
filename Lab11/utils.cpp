#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  auto offset = cache_config.get_num_block_offset_bits();
  auto tag = cache_config.get_num_tag_bits();
  auto idx = cache_config.get_num_index_bits();

  auto bitmask = ((1<<tag) - 1)<<(offset + idx);
  if(tag < 32){
    return (address & bitmask) >> (idx + offset);
  } else{
    return address;
  }
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  auto offset = cache_config.get_num_block_offset_bits();
  auto idx = cache_config.get_num_index_bits();
  auto bitmask = ((1 << idx) - 1) << (offset);
  if(idx < 32 ) {
    return (address & bitmask) >> (offset);
  } else {
    return 0;
  }
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  auto offset = cache_config.get_num_block_offset_bits();
  auto bitmask = ((1 << offset) - 1);
  if(offset < 32) {
    return (address & bitmask);
  } else {
    return 0;
  }
}
