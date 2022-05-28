#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t offset_bits = _cache_config.get_num_block_offset_bits();
  uint32_t index_bits = _cache_config.get_num_index_bits();

    uint32_t offset = 0;
    uint32_t index = this->_index << offset_bits;
    uint32_t tag = this->get_tag() << (index_bits + offset_bits);
    return (tag | index | offset);
}
