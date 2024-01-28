/*
Abdullah Jafar Mansour Shamout
150200919
*/
#pragma once
#include "pokemon.h"

class PsychicPokemon: public Pokemon{
    public:
        PsychicPokemon(const std::string& NAME, int hp, const int DAMAGE); //constructor that sets the main values for the class it inherits from, besides the parameters defined here I called the Pokemon constuctor using an initializor list to set basic values defined in this class like the power up chance and the recharge. This can be seen in the cpp file for this header file.
        const int attack(); //a function that makes a pokemon attack, generates certain amount of damage

    private:
        bool confuse_ability{}; //confuse ability is preset to 0 and is set to 1 when the pokemon powers up successfully
};