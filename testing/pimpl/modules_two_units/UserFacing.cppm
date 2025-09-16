export module UserFacing;

import std;

struct UserFacingImpl;

export class UserFacing
{
public:
    UserFacing();

    int getNumber() const;

private:
    std::shared_ptr<UserFacingImpl> m_pimpl;
};
