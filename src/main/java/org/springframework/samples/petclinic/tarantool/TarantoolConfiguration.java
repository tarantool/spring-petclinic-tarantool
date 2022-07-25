package org.springframework.samples.petclinic.tarantool;

import io.tarantool.driver.api.TarantoolClient;
import io.tarantool.driver.api.TarantoolResult;
import io.tarantool.driver.api.TarantoolClientConfig;
import io.tarantool.driver.api.TarantoolServerAddress;
import io.tarantool.driver.api.TarantoolClusterAddressProvider;
import io.tarantool.driver.api.tuple.TarantoolTuple;
import io.tarantool.driver.auth.SimpleTarantoolCredentials;
import io.tarantool.driver.auth.TarantoolCredentials;
import io.tarantool.driver.core.ProxyTarantoolTupleClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.tarantool.config.AbstractTarantoolDataConfiguration;
import org.springframework.data.tarantool.repository.config.EnableTarantoolRepositories;
import org.springframework.samples.petclinic.owner.OwnerRepository;
import org.springframework.samples.petclinic.owner.PetRepository;
import org.springframework.samples.petclinic.owner.PetTypeRepository;
import org.springframework.samples.petclinic.vet.VetRepository;
import org.springframework.samples.petclinic.visit.VisitRepository;

@Configuration
@EnableTarantoolRepositories(basePackageClasses = { VetRepository.class, OwnerRepository.class, PetRepository.class,
		PetTypeRepository.class, VisitRepository.class })
public class TarantoolConfiguration extends AbstractTarantoolDataConfiguration {

	@Value("${tarantool.host}")
	protected String host;

	@Value("${tarantool.port}")
	protected int port;

	@Value("${tarantool.username}")
	protected String username;

	@Value("${tarantool.password}")
	protected String password;

	@Override
	protected void configureClientConfig(TarantoolClientConfig.Builder builder) {
		builder.withConnectTimeout(1000 * 5).withReadTimeout(1000 * 5).withRequestTimeout(1000 * 5);
	}

	@Override
	public TarantoolCredentials tarantoolCredentials() {
		return new SimpleTarantoolCredentials(username, password);
	}

	@Override
	protected TarantoolServerAddress tarantoolServerAddress() {
		return new TarantoolServerAddress(host, port);
	}

	@Override
	public TarantoolClient<TarantoolTuple, TarantoolResult<TarantoolTuple>> tarantoolClient(
			TarantoolClientConfig tarantoolClientConfig,
			TarantoolClusterAddressProvider tarantoolClusterAddressProvider) {
		return new ProxyTarantoolTupleClient(
				super.tarantoolClient(tarantoolClientConfig, tarantoolClusterAddressProvider));
	}

}
