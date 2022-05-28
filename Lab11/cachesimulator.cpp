#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
	/**
	* TODO
	*
	* 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
	*    possibly have `address` cached.
	* 2. Loop through all these blocks to see if any one of them actually has
	*    `address` cached (i.e. the block is valid and the tags match).
	* 3. If you find the block, increment `_hits` and return a pointer to the
	*    block. Otherwise, return NULL.
	*/
	auto cf = _cache->get_config();
	auto blocks = _cache->get_blocks_in_set(extract_index(address, cf));
	for (auto i = 0; i < blocks.size(); i++) {
		if(blocks[i]->is_valid()) {
      if(blocks[i]->get_tag() == extract_tag(address, cf)){
        _hits++;
        return blocks[i];
      }
		}
	}
	return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
	/**
	* TODO
	*
	* 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
	*    cache `address`.
	* 2. Loop through all these blocks to find an invalid `block`. If found,
	*    skip to step 4.
	* 3. Loop through all these blocks to find the least recently used `block`.
	*    If the block is dirty, write it back to memory.
	* 4. Update the `block`'s tag. Read data into it from memory. Mark it as
	*    valid. Mark it as clean. Return a pointer to the `block`.
	*/
	auto cf = _cache->get_config();
	auto blocks = _cache->get_blocks_in_set(extract_index(address, cf));
	for (auto i = 0; i < blocks.size(); i++) {
		if(!blocks[i]->is_valid()){
			blocks[i]->set_tag(extract_tag(address, cf));
			blocks[i]->read_data_from_memory(_memory);
       blocks[i]->mark_as_valid();
			 blocks[i]->mark_as_clean();
			return blocks[i];
		}
	}



	 auto last = blocks[0]->get_last_used_time();
	 auto last_block = blocks[0];



	for (auto j = 0; j < blocks.size(); j++) {
      if(last > blocks[j]->get_last_used_time()){
        last = blocks[j]->get_last_used_time();

        last_block = blocks[j];
      }
	}



	if(last_block->is_dirty()){
		last_block->write_data_to_memory(_memory);
	}


	last_block->set_tag(extract_tag(address, cf));
	last_block->read_data_from_memory(_memory);
  last_block->mark_as_valid();
	last_block->mark_as_clean();

	return last_block;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {

  auto cf = _cache->get_config();
	auto b = find_block(address);

	if(b == NULL){
		b = bring_block_into_cache(address);
	}

	b->set_last_used_time(_use_clock.get_count());

	_use_clock++;
	return b->read_word_at_offset(extract_block_offset(address, cf));
	/**
	* TODO
	*
	* 1. Use `find_block` to find the `block` caching `address`.
	* 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
	* 3. Update the `last_used_time` for the `block`.
	* 4. Use `read_word_at_offset` to return the data at `address`.
	*/


}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {

    auto cf = _cache->get_config();
    auto b = find_block(address);


    if(b == NULL && _policy.is_write_allocate()){
        b = bring_block_into_cache(address);
      }
      else{
        _memory->write_word(address, word);
        return;
      }
    b->set_last_used_time(_use_clock.get_count());

    _use_clock++;

    b->write_word_at_offset(word, extract_block_offset(address, cf));


    if(_policy.is_write_back()){
      b->mark_as_dirty();
    }
    else{
      _memory->write_word(address, word);
    }
	/**
	* TODO
	*
	* 1. Use `find_block` to find the `block` caching `address`.
	* 2. If not found
	*    a. If the policy is write allocate, use `bring_block_into_cache`.
	*    a. Otherwise, directly write the `word` to `address` in the memory
	*       using `_memory->write_word` and return.
	* 3. Update the `last_used_time` for the `block`.
	* 4. Use `write_word_at_offset` to to write `word` to `address`.
	* 5. a. If the policy is write back, mark `block` as dirty.
	*    b. Otherwise, write `word` to `address` in memory.
	*/

}