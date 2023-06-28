<template>
	<div id="app">
		<NavBar @add-client="addClient"></NavBar>
		<div class="container">
			<ClientList
				:clients="clients"
				@delete-client="removeClient"
				@edit-client="changeClient"
			></ClientList>
		</div>
	</div>
</template>

<script>
import ClientList from "./components/ClientList.vue";
import NavBar from "./components/NavBar.vue";
import {
	getAllClients,
	createClient,
	deleteClient,
	editClient,
} from "./services/ClientService";

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
		async removeClient(id) {
			await deleteClient(id);
			this.fetchAllClients();
		},
		async addClient(newClient) {
			const response = await createClient(newClient);
			this.fetchAllClients();
		},
		async changeClient(editedClient) {
			await editClient(editedClient);
			this.fetchAllClients();
		},
		async fetchAllClients() {
			const fetchedClients = await getAllClients();
			this.clients = fetchedClients;
		},
	},
};
</script>
<style></style>
