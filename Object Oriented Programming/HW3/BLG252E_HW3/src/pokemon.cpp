/*
Abdullah Jafar Mansour Shamout
150200919
*/
#include "pokemon.h"

//constructor with initializer list that sets the attributes of the pokemon
Pokemon::Pokemon(const std::string &NAME, int hp, const int DAMAGE, const double POWERUP_CHANCE, const int RECHARGE): NAME{NAME}, hp{hp}, DAMAGE{DAMAGE}, POWERUP_CHANCE{POWERUP_CHANCE}, RECHARGE{RECHARGE} {};

void Pokemon::set_fainted(){
    if(hp <= 0){                                    //if the hp is less than or equal to 0 then the pokemon faints
        fainted = 1;
        hp = 0;
    }
    else{
        fainted = 0;                                //if the hp isnt less than or equal to 0 then the pokemon doesnt faint
    }
    return;
};

void Pokemon::set_own_terrain(const bool ON_TERRAIN){
    own_terrain = ON_TERRAIN;                       //setting the terrain according to the incoming information on whether its on its own terrain or not
    return;
};

void Pokemon::damage_taken(const int DAMAGE_TAKEN){
    hp -= DAMAGE_TAKEN;                             //take away the damage taken from the hp of the pokemon then set its fainted status
    set_fainted();                                  //calling  the set_fainted function to make sure whether the pokemon fainted yet or not as it might attack second, so to prevent it from attacking second if it fainted from the previous attack
    return;
};

void Pokemon::power_up(){
    if(powerup_cooldown == 0){                      //I check if there is no cooldown "I check if cooldown is 0"
        if(rand() % 10 <= POWERUP_CHANCE*10){       //since POWERUP_CHANCE is a fractional value per requested in the assignment, I multiply it by 10 to get an integer percentage between 0 and 9, then I compare it with a random value to modulus 10, if the value is within the POWERUP_CHANCE, Then the pokemon powers up
            powered_up = 1;                         //I set the pokemon to powered up
            powerup_cooldown = RECHARGE;            //I set a cooldown equal to the amount decided from the type of the pokemon
        }
        else{
            powered_up = 0;                         //if the random value isnt within the range then the pokemon doesnt power up
        }
    }
    else{
        powered_up = 0;
        powerup_cooldown--;                         // if the cooldown isnt 0 then a round will pass and the cooldown goes down by 1
    }
    return;
};
