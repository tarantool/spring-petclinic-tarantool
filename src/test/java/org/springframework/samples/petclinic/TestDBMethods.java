package org.springframework.samples.petclinic;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.testcontainers.containers.TarantoolCartridgeContainer;
import org.springframework.samples.petclinic.owner.Owner;
import org.springframework.samples.petclinic.owner.OwnerRepository;
import org.springframework.samples.petclinic.owner.Pet;
import org.springframework.samples.petclinic.owner.PetRepository;
import org.springframework.samples.petclinic.owner.PetType;
import org.springframework.samples.petclinic.owner.PetTypeRepository;
import org.springframework.samples.petclinic.vet.Specialty;
import org.springframework.samples.petclinic.vet.Vet;
import org.springframework.samples.petclinic.vet.VetRepository;
import org.springframework.samples.petclinic.visit.Visit;
import org.springframework.samples.petclinic.visit.VisitRepository;
import org.testcontainers.containers.TarantoolCartridgeContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.shaded.org.apache.commons.lang.StringUtils;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
@Testcontainers
public class TestDBMethods {
    @Autowired
    private VetRepository vets;
    @Autowired
    private OwnerRepository owners;
    @Autowired
    PetTypeRepository petTypes;
    @Autowired
    PetRepository pets;
    @Autowired
    VisitRepository visits;

    @Container
    private static final TarantoolCartridgeContainer container =
        // Pass the classpath-relative paths of the instances configuration and topology script files
        new TarantoolCartridgeContainer("cartridge/instances.yml", "cartridge/topology.lua")
            // Point out the classpath-relative directory where the application files reside
            .withDirectoryBinding("cartridge")
            .withRouterHost("localhost") // Optional, "localhost" is default
            .withRouterPort(3301) // Binary port, optional, 3301 is default
            .withAPIPort(8081) // Cartridge HTTP API port, optional, 8081 is default
            .withRouterUsername("admin") // Specify the actual username, default is "admin"
            .withRouterPassword("secret-cluster-cookie")
            .withUseFixedPorts(true)
            .withReuse(true); // allows to reuse the container build once for faster testing

    @BeforeAll
    public static void startCluster() throws Exception {
        container.start();
        container.executeCommand("return require('migrator').up()").get();
        container.executeCommand("require('data')").get();
    }

    protected UUID genSimpleUuid(String nString) {
        String forChars = StringUtils.repeat(nString, 4) + "-";
        return UUID.fromString(StringUtils.repeat(nString, 8) + "-" + StringUtils.repeat(forChars, 3)
            + StringUtils.repeat(nString, 12));
    }

    protected UUID genSimpleUuid(int n) {
        String nString = String.valueOf(n);
        return genSimpleUuid(nString);
    }

    protected LocalDate fromStringToTimestamp(String string) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return LocalDate.parse(string, formatter);
    }

    protected void compairSpecialties(Specialty firstSpecialty, Specialty secondSpecialty) {
        assertEquals(firstSpecialty.getId(), secondSpecialty.getId());
        assertEquals(firstSpecialty.getName(), secondSpecialty.getName());
    }

    protected void compairVets(Vet firstVet, Vet secondVet) {
        assertEquals(firstVet.getId(), secondVet.getId());
        assertEquals(firstVet.getFirstName(), secondVet.getFirstName());
        assertEquals(firstVet.getLastName(), secondVet.getLastName());
    }

    private void comparePetTypes(PetType firstType, PetType secondType) {
        assertEquals(firstType.getName(), secondType.getName());
        assertEquals(firstType.getId(), secondType.getId());
    }

    private void comparePets(Pet firstPet, Pet secondPet) {
        assertEquals(firstPet.getName(), secondPet.getName());
        assertEquals(firstPet.getId(), secondPet.getId());
        assertEquals(firstPet.getBirthDate(), secondPet.getBirthDate());
        assertEquals(firstPet.getBirthDate(), secondPet.getBirthDate());

        comparePetTypes(firstPet.getType(), secondPet.getType());
    }

    protected void compairVisits(Visit firstVisit, Visit secondVisit) {
        assertEquals(firstVisit.getId(), secondVisit.getId());
        assertEquals(firstVisit.getPetId(), secondVisit.getPetId());
        assertEquals(firstVisit.getDate(), secondVisit.getDate());
        assertEquals(firstVisit.getDescription(), secondVisit.getDescription());
    }

    private void compareOwners(Owner firstOwner, Owner secondOwner) {
        assertEquals(firstOwner.getFirstName(), secondOwner.getFirstName());
        assertEquals(firstOwner.getLastName(), secondOwner.getLastName());
        assertEquals(firstOwner.getId(), secondOwner.getId());
        assertEquals(firstOwner.getAddress(), secondOwner.getAddress());
        assertEquals(firstOwner.getCity(), secondOwner.getCity());
        assertEquals(firstOwner.getTelephone(), secondOwner.getTelephone());
    }

    @Test
    void testVets() {
        List<Vet> vetsArray = (List<Vet>) vets.findAll();
        Map<UUID, Vet> vetsMap = vetsArray.stream().collect(Collectors.toMap(Vet::getId, Function.identity()));
        assertEquals(6, vetsMap.size());

        Specialty surgery = new Specialty(genSimpleUuid(2), "surgery");
        Specialty dentistry = new Specialty(genSimpleUuid(3), "dentistry");

        Vet linda = new Vet(genSimpleUuid(3), "Linda", "Douglas");

        Vet lindaFromTarantool = vetsMap.get(genSimpleUuid(3));
        compairVets(linda, lindaFromTarantool);

        vetsArray = (List<Vet>) vets.getVetsWithSpecialties();
        vetsMap = vetsArray.stream().collect(Collectors.toMap(Vet::getId, Function.identity()));
        assertEquals(6, vetsMap.size());

        lindaFromTarantool = vetsMap.get(genSimpleUuid(3));
        compairVets(linda, lindaFromTarantool);

        List<Specialty> lindaSpecialties = lindaFromTarantool.getSpecialties();
        assertEquals(2, lindaSpecialties.size());

        if (lindaSpecialties.get(0).getName().equals("surgery")) {
            compairSpecialties(surgery, lindaSpecialties.get(0));
            compairSpecialties(dentistry, lindaSpecialties.get(1));
        } else {
            compairSpecialties(surgery, lindaSpecialties.get(1));
            compairSpecialties(dentistry, lindaSpecialties.get(0));
        }
    }

    @Test
    void testPets() {
        PetType cat = new PetType(genSimpleUuid(1), "cat");

        Pet leo = new Pet(genSimpleUuid(1), "Leo", fromStringToTimestamp("2010-09-07"), cat);

        Pet leoFromTarantool = pets.findPetById(leo.getId());

        comparePets(leo, leoFromTarantool);
    }

    @Test
    void testVisits() {
        Visit firstVisit = new Visit(
            genSimpleUuid(1),
            genSimpleUuid(7),
            fromStringToTimestamp("2013-01-01"),
            "rabies shot"
        );
        Visit secondVisit = new Visit(
            genSimpleUuid(4),
            genSimpleUuid(7),
            fromStringToTimestamp("2013-01-04"),
            "spayed"
        );

        List<Visit> visitsArray = (List<Visit>) visits.findAll();
        assertEquals(4, visitsArray.size());

        List<Visit> samanthaVisits = visits.findByPetId(firstVisit.getPetId());
        assertEquals(2, samanthaVisits.size());

        compairVisits(firstVisit, samanthaVisits.get(0));
        compairVisits(secondVisit, samanthaVisits.get(1));
    }

    @Test
    void testOwners() {
        List<Owner> ownersArray = (List<Owner>) owners.findAll();
        assertEquals(10, ownersArray.size());

        Owner betty = new Owner(
            genSimpleUuid(2),
            "Betty",
            "Davis",
            "638 Cardinal Ave.",
            "Sun Prairie",
            "6085551749"
        );
        Owner harold = new Owner(
            genSimpleUuid(4),
            "Harold",
            "Davis",
            "563 Friendly St.",
            "Windsor",
            "6085553198"
        );

        Owner bettyFromTarantool = owners.findOwnerById(betty.getId());
        compareOwners(betty, bettyFromTarantool);

        List<Owner> davises = (List<Owner>) owners.findByLastName(betty.getLastName());
        assertEquals(2, davises.size());
        Owner haroldFromTarantool;

        if (davises.get(0).getFirstName().equals("Betty")) {
            bettyFromTarantool = davises.get(0);
            haroldFromTarantool = davises.get(1);
        } else {
            bettyFromTarantool = davises.get(1);
            haroldFromTarantool = davises.get(0);
        }

        compareOwners(betty, davises.get(0));
        compareOwners(harold, davises.get(1));

        Owner george = new Owner(
            UUID.randomUUID(),
            "George",
            "Franklin",
            "110 W. Liberty St.",
            "Madison",
            "6085551023"
        );
        owners.save(george);

        ownersArray = (List<Owner>) owners.findAll();
        assertEquals(11, ownersArray.size());
    }
}
