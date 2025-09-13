module UserFacing;

import Private;

struct UserFacingImpl
{
    const int number = Private::secret();
};

UserFacing::UserFacing()
    : m_pimpl(std::make_shared<UserFacingImpl>())
{}

int UserFacing::getNumber() const
{
    return m_pimpl->number;
}
