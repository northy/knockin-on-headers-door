module;

#define SECRET 42

export module Private;

namespace Private
{
    int secret_internal()
    {
        return SECRET;
    }

    export int secret()
    {
        return secret_internal();
    }
}
