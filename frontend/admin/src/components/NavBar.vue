<template>
	<nav class="navbar bg-dark p-3">
		<div class="container-fluid">
			<div class="navbar-brand text-white fw-bold">Admin Dashboard</div>
			<form class="d-flex justify-content-center align-items-center">
				<input
					type="text"
					class="form-control me-2"
					placeholder="Name"
					v-model="newClient.name"
					required
				/>
				<input
					type="text"
					class="form-control me-2"
					placeholder="Location"
					v-model="newClient.location"
					required
				/>
				<input
					type="text"
					class="form-control me-2"
					placeholder="Status"
					v-model="newClient.status"
					required
				/>
				<button
					class="btn btn-light"
					id="btn-add-client"
					@click.prevent="addClient"
				>
					Add Client
				</button>
			</form>
		</div>
	</nav>
</template>
<script>
export default {
	data() {
		return {
			newClient: {
				name: "",
				location: "",
				status: "",
			},
		};
	},
	methods: {
		addClient() {
			if (
				this.newClient.name === "" ||
				this.newClient.location === "" ||
				this.newClient.status === ""
			)
				return;
			console.log(this.newClient);
			this.$emit("add-client", this.newClient);
			this.newClient = {
				name: "",
				location: "",
				status: "",
			};
		},
	},
};
</script>
<style>
#btn-add-client {
	white-space: nowrap;
}
</style>
