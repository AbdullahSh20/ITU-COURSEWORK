/*
Abdullah Jafar Mansour Shamout
150200919
*/
#include "psychicPokemon.h"

//constructor that sets the PsychicPokemon by calling the Pokemon constructor
PsychicPokemon::PsychicPokemon(const std::string& NAME, int hp, const int DAMAGE): Pokemon::Pokemon{NAME,hp,DAMAGE,0.3,5}{}; //the 0.3 refers to the power up chance and the 5 refers to the recharge time for powerup

const int PsychicPokemon::attack(){         //a function to generate damage that is going to be dealt by the pokemon that round
    if(is_own_terrain()){                   //if the pokemon is on its own terrain it will deal twice the damage it usually does
        return (get_DAMAGE() * 2);
    }
    else{
        return get_DAMAGE();                //if it isnt, it will deal the normal amount of damage
    }
};