// const HOST = "http://localhost";
const HOST = "";

export async function getAllClients() {
	const response = await fetch(`${HOST}/api/admin/devices`);
	return await response.json();
}

export async function createClient(client) {
	const response = await fetch(`${HOST}/api/admin/devices`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(client),
	});
	return await response.json();
}

export async function editClient(client) {
	await fetch(`${HOST}/api/admin/devices/${client.id}`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(client),
	});
}

export async function deleteClient(id) {
	await fetch(`${HOST}/api/admin/devices/${id}`, {
		method: "DELETE",
	});
}

export async function getGrafanaURL() {
	const response = await fetch(`${HOST}/api/dashboard`);
	return await response.text();
}
