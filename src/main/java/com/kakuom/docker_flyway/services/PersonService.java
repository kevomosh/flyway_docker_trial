package com.kakuom.docker_flyway.services;

import com.kakuom.docker_flyway.PersonRepository;
import com.kakuom.docker_flyway.models.Person;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PersonService {
    private final PersonRepository personRepository;

    public PersonService(PersonRepository personRepository) {
        this.personRepository = personRepository;
    }

    public Person createPerson(String name, int age) {
        var person = new Person(name, age);
        personRepository.save(person);
        return person;
    }

    public List<Person> allPeople(){
        return personRepository.findAll();
    }
}
