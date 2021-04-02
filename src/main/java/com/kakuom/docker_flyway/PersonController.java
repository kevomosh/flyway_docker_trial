package com.kakuom.docker_flyway;

import com.kakuom.docker_flyway.models.Person;
import com.kakuom.docker_flyway.services.PersonService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/person")
public class PersonController {
    private final PersonService personService;

    public PersonController(PersonService personService) {
        this.personService = personService;
    }

    @PostMapping("/create/{name}/{age}")
    public ResponseEntity<Person> create(
            @PathVariable String name,
            @PathVariable int age
    ){
        return ResponseEntity.ok(personService.createPerson(name, age));
    }

    @GetMapping()
    public ResponseEntity<List<Person>> all(){
        return ResponseEntity.ok(personService.allPeople());
    }
}
