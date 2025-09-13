module;

#include <print>

module lib;

void detail::logOperation(const std::string_view operation)
{
    std::println("Lib performing operation: {}", operation);
}
