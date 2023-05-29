import React, { useEffect, useState } from "react";
import { useNavigate, useParams, Link } from "react-router-dom";
import { Button, Container, Form, FormGroup, Input, Label } from 'reactstrap';

function EditUser() {
    const initialUserState = {
        name: "",
        surname: "",
        phone: "",
        mail: "",
        address: "",
        deviceId: ""
    };

    const [user, setUser] = useState(initialUserState);
    const navigate = useNavigate();
    const { id } = useParams();

    useEffect(
        () => {
            if (id !== undefined) {
                fetch(`/user/${id}`).then(response => response.json()).then(data => setUser(data));
            }
        }, [id, setUser, user]
    );

    const handleChange = (event) => {
        const { name, value } = event.target

        setUser({ ...user, [name]: value })
    }

    const handleSubmit = async (event) => {
        event.preventDefault();

        await fetch('/user' + (user.id ? '/' + user.id : ''), {
            method: (user.id) ? 'PUT' : 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(user)
        });
        setUser(initialUserState);
        navigate('/user');
    }

    const title = <h2>{user.id ? 'Edit User' : 'Create a New User'}</h2>;

    return (
        <div>
            <Container>
                {title}
                <Form onSubmit={handleSubmit}>
                    <FormGroup>
                        <Label for="name">Name</Label>
                        <Input type="text" name="name" id="name" value={user.name || ''}
                            onChange={handleChange} autoComplete="name" />
                    </FormGroup>
                    <FormGroup>
                        <Label for="surname">Surname</Label>
                        <Input type="text" name="surname" id="surname" value={user.surname || ''}
                            onChange={handleChange} autoComplete="surname" />
                    </FormGroup>
                    <FormGroup>
                        <Label for="phone">Phone</Label>
                        <Input type="text" name="phone" id="phone" value={user.phone || ''}
                            onChange={handleChange} autoComplete="phone" />
                    </FormGroup>
                    <FormGroup>
                        <Label for="mail">Email</Label>
                        <Input type="text" name="mail" id="mail" value={user.mail || ''}
                            onChange={handleChange} autoComplete="email" />
                    </FormGroup>
                    <FormGroup>
                        <Label for="address">Address</Label>
                        <Input type="text" name="address" id="address" value={user.address || ''}
                            onChange={handleChange} autoComplete="address" />
                    </FormGroup>
                    <FormGroup>
                        <Label for="deviceId">Device ID</Label>
                        <Input type="text" name="deviceId" id="deviceId" value={user.deviceId || ''}
                            onChange={handleChange} autoComplete="deviceId" />
                    </FormGroup>
                    <FormGroup>
                        <Button color="primary" type="submit">Save</Button>{' '}
                        <Button color="secondary" tag={Link} to="/user">Cancel</Button>
                    </FormGroup>
                </Form>
            </Container>
            <footer>Copyright © 2023 Rock of MAM</footer>
        </div>
    );
}

export default EditUser;