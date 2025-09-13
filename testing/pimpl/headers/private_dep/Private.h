#pragma once

#define SECRET 42

namespace Private
{
    inline int secret_internal()
    {
        return SECRET;
    }

    inline int secret()
    {
        return secret_internal();
    }
}
