import React from "react";
import 'bootstrap/dist/css/bootstrap.css';
import { Collapse, Nav, Navbar, NavbarBrand, NavLink } from 'reactstrap';
import { Link } from 'react-router-dom';

function AppNavbar() {
    return (
        <Navbar color="dark" dark expand="md">
            <NavbarBrand tag={Link} to="/">Home</NavbarBrand>
            <Collapse navbar>
                <Nav className="justify-content-end" style={{ width: "100%" }} navbar>
                    <NavLink href="/user">Users</NavLink>
                    <NavLink href="/vehicle">Vehicles</NavLink>
                    <NavLink href="/odometerLog">Odometer Logs</NavLink>
                </Nav>
            </Collapse>
        </Navbar>
    );
}

export default AppNavbar;