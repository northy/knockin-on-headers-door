#include "UserFacing.h"

#include <print>

int main()
{
    UserFacing userFacing{};
    std::println("{}", userFacing.getNumber());
}
