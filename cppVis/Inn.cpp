#include <iostream>
#include <string>
#include <vector>


int main()
{
	std::string result1;
	std::string result2;
	std::getline(std::cin,result1);
	std::getline(std::cin,result2);
	if (result1 == "Out")
	{
		printf("Yessir\n");
	}
	std::cout << result1 << std::endl;
	std::cout << "\n";
	std::cout << result2 << std::endl;
	return 0;
}
