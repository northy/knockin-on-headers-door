module;

#include <string_view>

export module lib;

namespace detail
{
    void logOperation(const std::string_view operation);
}

export namespace lib
{
    template<typename T>
    struct Point
    {
        T x;
        T y;
    };

    template<typename T>
    Point<T> add(const Point<T>& a, const Point<T>& b)
    {
        detail::logOperation("add");
        return { .x = a.x + b.x, .y = a.y + b.y};
    }
}
