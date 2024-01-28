/*
Abdullah Jafar Mansour Shamout
150200919
*/
#pragma once
#include "pokemon.h"

class ElectricPokemon: public Pokemon{
    public:
        ElectricPokemon(const std::string& NAME, int hp, const int DAMAGE); //constructor that sets the main values for the class it inherits from, besides the parameters defined here I called the Pokemon constuctor using an initializor list to set basic values defined in this class like the power up chance and the recharge. This can be seen in the cpp file for this header file.
        const bool is_confused() const { return confused; }; //a function that checks if the pokemon is confused
        void set_confused(const bool STATUS); //a function that sets the confused state of the Electric pokemon
        void set_confusion_cooldown(); //a function that sets the confustion cooldown to 3 rounds if the pokemon got confused
        const int attack(); // a function that makes a pokemon attack, generates certain amount of damage

    private:
        int confusion_cooldown{}; //a cooldown for when the pokemon is confused, initialized as 0 as the pokemon isnt normally confused
        bool confused{}; // electric pokemons are prone to confusion, initialized to 0 as normally they arent
};