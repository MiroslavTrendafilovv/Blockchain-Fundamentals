// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;


contract Structs {

    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;

    mapping(address => Car[]) public carsByOwner;

    function examples() external{

        Car memory toyota = Car("Toyota", 1990, msg.sender);
        Car memory lambo = Car({model: "Lambo", year: 2000, owner: msg.sender});
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2010;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        cars.push(Car("Ferrari", 2020, msg.sender));

        Car storage _car = cars[0];

        _car.model = "Opel";

        delete _car.owner;

        delete cars[1];




    }

    


}