import React, { useEffect, useState } from "react";
import { useNavigate, useParams, Link } from "react-router-dom";
import { Button, ButtonGroup, Container, Form, FormGroup, Input, Label } from 'reactstrap';

function EditVehicle() {
    const [vehicleType, setVehicleType] = useState("Car");
    const defaultButtonColor = "#6c757d";
    const activeButtonColor = "#0d6efd";

    const initialVehicleState = {
        vehicleType: "Car",
        brand: "",
        model: "",
        purchaseYear: 2023,
        userId: 0
    };

    const [vehicle, setVehicle] = useState(initialVehicleState);
    const navigate = useNavigate();
    const { id } = useParams();
    const [isExecuted, setIsExecuted] = useState(false);

    useEffect(
        () => {
            if (id !== undefined) {
                fetch(`/vehicle/${id}`).then(response => response.json()).then(data => setVehicle(data));
            }

            if (isExecuted !== true) {
                if (vehicle.vehicleType === "Car") {
                    setVehicleType(0);
                } else if (vehicle.vehicleType === "Bus") {
                    setVehicleType(1);
                } else if (vehicle.vehicleType === "Van") {
                    setVehicleType(2);
                } else if (vehicle.vehicleType === "Truck") {
                    setVehicleType(3);
                } else if (vehicle.vehicleType === "Motorcycle") {
                    setVehicleType(4);
                }

                setIsExecuted(true);
            }
        }, [id, setVehicle, setVehicleType, vehicle, isExecuted]
    );

    useEffect(
        () => {
            setIsExecuted(false);
        }, []
    );

    const handleChange = (event) => {
        const { brand, value } = event.target

        setVehicle({ ...vehicle, [brand]: value })
    }

    const handleSubmit = async (event) => {
        event.preventDefault();
        vehicle.vehicleType = vehicleType;

        await fetch('/vehicle' + (vehicle.id ? '/' + vehicle.id : ''), {
            method: (vehicle.id) ? 'PUT' : 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(vehicle)
        });
        setVehicle(initialVehicleState);
        navigate('/vehicle');
    }

    const handleClick = async (event) => {
        event.preventDefault();
        for (let index = 0; index < 5; index++) {
            document.getElementById("vehicleType" + index).style.background = defaultButtonColor;
        }

        document.getElementById("vehicleType" + event.target.value).style.background = activeButtonColor;

        if (event.target.value === "0") {
            setVehicleType("Car");
        } else if (event.target.value === "1") {
            setVehicleType("Bus");
        } else if (event.target.value === "2") {
            setVehicleType("Van");
        } else if (event.target.value === "3") {
            setVehicleType("Truck");
        } else if (event.target.value === "4") {
            setVehicleType("Motorcycle");
        }
    }

    const title = <h2>{vehicle.id ? 'Edit Vehicle' : 'Create a New Vehicle'}</h2>;

    return (
        <div>
            <Container>
                {title}
                <Form onSubmit={handleSubmit}>
                    <FormGroup>
                        <Label for="vehicleType">Vehicle Type</Label>
                        <ButtonGroup onClick={handleClick}>
                            {vehicleType === 0 ? <Button id="vehicleType0" Style={"background-color: #0d6efd"} value={"0"}>Car</Button> : <Button id="vehicleType0" value={"0"}>Car</Button>}
                            {vehicleType === 1 ? <Button id="vehicleType1" Style={"background-color: #0d6efd"} value={"1"}>Bus</Button> : <Button id="vehicleType1" value={"1"}>Bus</Button>}
                            {vehicleType === 2 ? <Button id="vehicleType2" Style={"background-color: #0d6efd"} value={"2"}>Van</Button> : <Button id="vehicleType2" value={"2"}>Van</Button>}
                            {vehicleType === 3 ? <Button id="vehicleType3" Style={"background-color: #0d6efd"} value={"3"}>Truck</Button> : <Button id="vehicleType3" value={"3"}>Truck</Button>}
                            {vehicleType === 4 ? <Button id="vehicleType4" Style={"background-color: #0d6efd"} value={"4"}>Motorcycle</Button> : <Button id="vehicleType4" value={"4"}>Motorcycle</Button>}
                        </ButtonGroup>
                    </FormGroup>
                    <FormGroup>
                        <Label for="brand">Brand</Label>
                        <Input type="text" name="brand" id="namebrand" value={vehicle.brand || ''}
                            onChange={handleChange} autoComplete="brand" />
                    </FormGroup>
                    <FormGroup>
                        <Label for="model">Model</Label>
                        <Input type="text" name="model" id="model" value={vehicle.model || ''}
                            onChange={handleChange} autoComplete="model" />
                    </FormGroup>
                    <FormGroup>
                        <Label for="purchaseYear">Purchase Year</Label>
                        <Input type="text" name="purchaseYear" id="purchaseYear" value={vehicle.purchaseYear || ''}
                            onChange={handleChange} autoComplete="purchaseYear" />
                    </FormGroup>
                    <FormGroup>
                        <Button color="primary" type="submit">Save</Button>{' '}
                        <Button color="secondary" tag={Link} to="/vehicle">Cancel</Button>
                    </FormGroup>
                </Form>
            </Container>
        </div>
    );
}

export default EditVehicle;