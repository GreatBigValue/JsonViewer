'use client'

import { usePathname } from 'next/navigation'
import { Navbar as NextUINavbar, NavbarBrand, NavbarContent, NavbarItem, Link, Button } from "@nextui-org/react"
import ThemeSwitcher from './ThemeSwitcher'

export default function Navbar() {
  const pathname = usePathname()

  return (
    <NextUINavbar isBordered>
      <NavbarBrand>
        <Link href="/" className="font-bold text-inherit">JSON VIEWER</Link>
      </NavbarBrand>

      <NavbarContent className="hidden sm:flex gap-4" justify="center">
        <NavbarItem isActive={pathname === '/'}>
          <Link color={pathname === '/' ? "primary" : "foreground"} href="/" aria-current="page">
            Parser
          </Link>
        </NavbarItem>
        <NavbarItem isActive={pathname === '/saved'}>
          <Link color={pathname === '/saved' ? "primary" : "foreground"} href="/saved">
            Saved Documents
          </Link>
        </NavbarItem>
      </NavbarContent>

      <NavbarContent justify="end">
        <NavbarItem>
          <ThemeSwitcher />
        </NavbarItem>
      </NavbarContent>
    </NextUINavbar>
  )
}
