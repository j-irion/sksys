<template>
	<div id="app">
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

export default {
	components: {
		ClientList,
	},
	data() {
		return {
			clients: [
				{
					id: 1,
					name: "Peter Pan",
					location: "Germany",
					status: "busy",
				},
				{
					id: 2,
					name: "Alice Smith",
					location: "United States",
					status: "available",
				},
				{
					id: 3,
					name: "Juan Rodriguez",
					location: "Spain",
					status: "busy",
				},
				{
					id: 4,
					name: "Emily Chen",
					location: "Canada",
					status: "available",
				},
				{
					id: 5,
					name: "John Johnson",
					location: "United Kingdom",
					status: "busy",
				},
				{
					id: 6,
					name: "Sophia Lee",
					location: "South Korea",
					status: "available",
				},
				{
					id: 7,
					name: "Mohammed Ali",
					location: "Saudi Arabia",
					status: "busy",
				},
				{
					id: 8,
					name: "Maria Lopez",
					location: "Mexico",
					status: "available",
				},
				{
					id: 9,
					name: "Alexandre Silva",
					location: "Brazil",
					status: "busy",
				},
				{
					id: 10,
					name: "Elena Petrova",
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
	},
};
</script>
<style></style>
