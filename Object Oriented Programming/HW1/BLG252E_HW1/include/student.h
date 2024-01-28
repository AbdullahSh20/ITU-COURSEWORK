/* @Author
 * Student Name:  Abdullah Jafar Mansour Shamout
 * Student ID : 150200919
 */
#include <iostream>

/* Here I created the classes as requested in the homework with the required initial values. However, the University class has certain attributes
 without initialization, this makes those values random as requested in the homework, so there is no need to use a random function to generate junk values.
*/

class Student{                                  
    public:
        // constructors and destructors
        Student(std::string ,float ,int ,int); //constructor to initialize attributes, and print logins
        Student(const Student&); //copy constructor, made because in main there was a student made as a copy of another const student
        ~Student(); //destructor used to logout students when they go out of scope

        // getter methods: they return the attribute requested, they are const because they shouldnt change the values
        std::string get_name() const;
        float get_GPA() const;
        int get_GRE() const;
        int get_TOEFL() const;
        int get_app() const; // this getter gets the application value

        // setter methods: they set the value for the attribute requested
        void set_name(std::string);
        void set_GPA(float);
        void set_GRE(int);
        void set_TOEFL(int);

        // extra methods
        void inc_app() const; // this method is short for increment application. It is called when a university evaluates a student. it increments the No_of_applications by 1
    private:
        std::string name{""};
        float GPA{0};
        int GRE{0};
        int TOEFL{0};
        mutable int No_of_applications{0};  //since some objects are constant and we need to edit no. of applications i made it as a mutable
};
