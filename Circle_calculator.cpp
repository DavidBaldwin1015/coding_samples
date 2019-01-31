#include <iostream>
#include <cmath>
#include <string>
#include <iomanip>
#include <stdlib.h>
#include <fstream>
using namespace std;

int main(){
	//Variable deifnitions
	double center_x;
	double center_y;
	double radius;
	double P1x;
	double P1y;
	double Points_x [359];
	double Points_y [359];
	int count = 360;
	
	//Take values from user
	cout << "Circle Calculator v0.01\n\n";
	cout << "Please enter the center x coordinate: ";
	cin >> center_x;
	cout << "\nPlease enter the center y coordinate: ";
	cin >> center_y;
	cout << "Radius: ";
	cin >> radius;

	//iterate through 360 degrees of the circle
	while (count > 0){
		int Theta;
		Theta = 360-count;
		Points_y[Theta] = (center_y+(radius*sin(Theta)));
		Points_x[Theta] = (center_x+(radius*cos(Theta)));
		count = count - 1;
	}

	/*Check to make sure circle is true by taking random points and checking against x^2+y^2=r^2, commented out due to being unnecessary, but too nice to throw away
	int random1 = rand() % 359;
	int random2 = rand() % 359;
	cout << random1 << "\n";
	cout << random2 << "\n";
	if (center_y == 0 && center_x == 0){
		if (pow(Points_x[random1],2)+pow(Points_y[random1],2)==pow(radius,2) && pow(Points_x[random2],2)+pow(Points_y[random2],2)==pow(radius,2)){
		cout << "'Circle is true.\n";
		}
	}
	else {
		if (pow((center_x+Points_x[random1]),2)+pow((-center_y+Points_x[random1]),2)==pow(radius,2) && pow((-center_x+Points_x[random2]),2)+pow((-center_y+Points_x[random2]),2)==pow(radius,2)){
		cout << "'Circle is true.\n";
	}}*/

	//Output results
	ofstream output ("circle.csv");
	cout << "Angle" << setw(13) << "X-Coord" << setw(13) << "Y-coord" << endl;
	output << "X,"<<"Y"<<endl;
	for(int Angle = 0; Angle < 360; Angle++){
		cout << setw( 7 ) << Angle << setw(13) << Points_x[Angle] << setw(13) << Points_y[Angle] << endl;
		output << Points_x[Angle] << "," << Points_y[Angle] << endl;
	}

	output.close();
	return 0;
}