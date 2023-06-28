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
import { getAllClients, createClient } from "./services/ClientService";

export default {
	components: {
		ClientList,
		NavBar,
	},
	data() {
		return {
			clients: [],
		};
	},
	created() {
		this.fetchAllClients();
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
		fetchAllClients() {
			let test = getAllClients();
			console.log(test);
		},
	},
};
</script>
<style></style>
