<template>
	<div id="app">
		<NavBar @add-client="addClient"></NavBar>
		<div class="container">
			<ClientList
				:clients="clients"
				@delete-client="deleteClient"
				@edit-client="editClient"
			></ClientList>
		</div>
	</div>
</template>

<script>
import ClientList from "./components/ClientList.vue";
import NavBar from "./components/NavBar.vue";

export default {
	components: {
		ClientList,
		NavBar,
	},
	data() {
		return {
			clients: [
				{
					id: 1,
					name: "Client 1",
					location: "Germany",
					status: 235,
				},
				{
					id: 2,
					name: "Client 2",
					location: "United States",
					status: 408,
				},
				{
					id: 3,
					name: "Client 3",
					location: "Spain",
					status: 83,
				},
				{
					id: 4,
					name: "Client 4",
					location: "Canada",
					status: 162,
				},
				{
					id: 5,
					name: "Client 5",
					location: "United Kingdom",
					status: 297,
				},
				{
					id: 6,
					name: "Client 6",
					location: "South Korea",
					status: 443,
				},
				{
					id: 7,
					name: "Client 7",
					location: "Saudi Arabia",
					status: 50,
				},
				{
					id: 8,
					name: "Client 8",
					location: "Mexico",
					status: 375,
				},
				{
					id: 9,
					name: "Client 9",
					location: "Brazil",
					status: 119,
				},
				{
					id: 10,
					name: "Client 10",
					location: "Russia",
					status: 482,
				},
			],
		};
	},
	methods: {
		deleteClient(id) {
			const index = this.clients.findIndex((obj) => obj.id === id);
			if (index !== -1) {
				this.clients.splice(index, 1);
			}
		},
		addClient(newClient) {
			this.clients.push(newClient);
		},
		editClient(editedClient) {
			let index = this.clients.findIndex(
				(client) => client.id === editedClient.id
			);
			this.clients.splice(index, 1, editedClient);
		},
	},
};
</script>
<style></style>
