export module UserFacing;

import std;
import Private;

struct UserFacingImpl
{
    const int number = Private::secret();
};

export class UserFacing
{
public:
    UserFacing()
        : m_pimpl(std::make_shared<UserFacingImpl>())
    {}

    int getNumber() const
    {
        return m_pimpl->number;
    }

private:
    std::shared_ptr<UserFacingImpl> m_pimpl;
};
