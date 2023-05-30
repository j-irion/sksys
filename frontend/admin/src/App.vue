<template>
	<div id="app">
		<NavBar @add-client="addClient"></NavBar>
		<div class="container" style="margin: 0; height: 100%">
			<div class="row" style="height: 100%">
				<div class="col-3" style="height: 100%">
					<ClientList
						:clients="clients"
						@delete-client="deleteClient"
					></ClientList>
				</div>
				<div class="col-9"></div>
			</div>
		</div>
	</div>
</template>

<script>
import ClientList from "./components/ClientList.vue";
import NavBar from "./components/Navbar.vue";

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
					status: "busy",
				},
				{
					id: 2,
					name: "Client 2",
					location: "United States",
					status: "available",
				},
				{
					id: 3,
					name: "Client 3",
					location: "Spain",
					status: "busy",
				},
				{
					id: 4,
					name: "Client 4",
					location: "Canada",
					status: "available",
				},
				{
					id: 5,
					name: "Client 5",
					location: "United Kingdom",
					status: "busy",
				},
				{
					id: 6,
					name: "Client 6",
					location: "South Korea",
					status: "available",
				},
				{
					id: 7,
					name: "Client 7",
					location: "Saudi Arabia",
					status: "busy",
				},
				{
					id: 8,
					name: "Client 8",
					location: "Mexico",
					status: "available",
				},
				{
					id: 9,
					name: "Client 9",
					location: "Brazil",
					status: "busy",
				},
				{
					id: 10,
					name: "Client 10",
					location: "Russia",
					status: "available",
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
	},
};
</script>
<style></style>
