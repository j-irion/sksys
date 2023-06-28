const HOST = "http://localhost:8000";

export async function getAllClients() {
	const response = await fetch(`${HOST}/api/admin/devices`);
	return response.json();
}

export async function createClient(client) {
	const response = await fetch("/admin/device", {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(client),
	});
	return await response.json();
}

export async function editClient(client) {
	const response = await fetch(`/admin/device/${client.id}`, {
		method: "PUT",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(client),
	});
	return await response.json();
}

export async function deleteClient(client) {
	const response = await fetch(`/admin/device/${client.id}`, {
		method: "DELETE",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(client),
	});
	return await response.json();
}
