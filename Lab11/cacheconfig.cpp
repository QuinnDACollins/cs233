#include "cacheconfig.h"
#include "utils.h"
#include <math.h> 

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */ 
 this->_num_block_offset_bits = log2(block_size);
  this->_num_index_bits = log2(size / (associativity * block_size));
 this->_num_tag_bits = 32 - this->_num_index_bits - this->_num_block_offset_bits;
}
