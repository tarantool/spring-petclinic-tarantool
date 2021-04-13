/*
 * Copyright 2012-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springframework.samples.petclinic.owner;


import org.springframework.data.tarantool.repository.Query;
import org.springframework.data.tarantool.repository.TarantoolRepository;

import java.util.UUID;

/**
 * Repository class for <code>Pet</code> domain objects All method names are compliant
 * with Spring Data naming conventions so this interface can easily be extended for Spring
 * Data. See:
 * https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#repositories.query-methods.query-creation
 *
 * @author Ken Krebs
 * @author Juergen Hoeller
 * @author Sam Brannen
 * @author Michael Isvy
 */
public interface PetRepository extends TarantoolRepository<Pet, UUID> {

	/**
	 * Retrieve a {@link Pet} from the data store by id and owner id. We need ownerId
	 * because we should know which bucket our pet is in.
	 * @param id the id to search for
	 * @return the {@link Pet} if found
	 */
	@Query(function = "find_pet_by_id")
	Pet findPetById(UUID id);

	/**
	 * Save a {@link Pet} to the data store, either inserting or updating it.
	 * @param pet the {@link Pet} to save
	 */
	@Query(function = "save_pet")
	Pet save(Pet pet);

}
