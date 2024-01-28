/*
Abdullah Jafar Mansour Shamout
150200919
*/
#pragma once
#include "electricPokemon.h"
#include "psychicPokemon.h"

class Arena{
    public:
        ~Arena();               //Destructor to free the pointers to pokemon if they had memory allocated for them
        void addPokemon(const char TYPE, const std::string NAME, int hp,const int DAMAGE); //creates a pokemon and sets it for the pointer
        void spawnTerrain(); //a function to generate a terrain per round
        void restartTerrain();  //a function that restarts the terrain despite of any circumstance(doesnt care about the cooldown)
        void simulateBattle(); //used to simulate the battle between pokemons till one faints
        void printRoundStats(const int ROUND, const int HEADS) const; //a function that prints the stats of that round
        void printMatchResults()const;   //a function that prints the match results when a pokemon faints
        const std::string& get_terrain() const{ return terrain; };   //a function that returns the type of terrain the arena is on

    private:
        std::string terrain{}; //Psychic, Electric, and None. can change during battle, must be reset at the start
        int terrain_cooldown{}; //terrain cooldown integer that is set according to the spawned terrain
        ElectricPokemon *Electric{nullptr}; //Electric pokemon pointer that holds the fighting pokemon slot in the arena
        PsychicPokemon *Psychic{nullptr};   //Psychic pokemon pointer that holds the fighting pokemon slot in the arena
};