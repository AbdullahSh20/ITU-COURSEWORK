/* @Author
 * Student Name:  Abdullah Jafar Mansour Shamout
 * Student ID : 150200919
 */
#include <iostream>
#include "student.h"
/* Here I created the university class as requested in the homework with the required initial values. However, the University class has certain attributes
 without initialization, this makes those values random as requested in the homework, so there is no need to use a random function to generate junk values.
*/
class University{
    public:
        //Here I created a single constructor with a default value of "" for the country attribute instead of making another constructor to satisfy all the calls done in main
        // since nothing needs to run when the University objects go out of scope, eg. no print statements needed. I didnt write my own destructor as its not needed
        University(std::string ,float ,float ,float ,float ,std::string = ""); 

        // getter methods: they return the attribute requested, I only implemented the needed getter methods according to main.cpp
        // since getters only get values they must not change values I made them into const methods
        std::string get_name() const;
        float get_GPA() const;
        float get_GRE() const;
        float get_TOEFL() const;
        float get_bias() const;

        // setter methods: they set the value for the attribute requested, I used them in my constructor
        void set_name(std::string);
        void set_GPA(float);
        void set_GRE(float);
        void set_TOEFL(float);
        void set_bias(float);
        void set_country(std::string);

        // this method evaluates whether the student will be accepted according to that university's measurements or not
        // I took input as a constant refrence because there are student objects created as a constant
        void evaluate_student(const Student&);
    private:
        //Here I created the required attributes and gave them their requested initial values, if no initaial value is specified that means the value generated would be random
        std::string name{""};
        float GPA;
        float GRE;
        float TOEFL;
        float bias;
        std::string country{""};
};
