<template>
	<nav class="navbar bg-dark p-3">
		<div class="container-fluid">
			<div class="navbar-brand text-white fw-bold">Admin Dashboard</div>
			<button
				class="btn btn-light"
				id="btn-add-client"
				data-bs-toggle="modal"
				data-bs-target="#exampleModal"
			>
				Add Client
			</button>
		</div>
	</nav>

	<div
		class="modal fade"
		id="exampleModal"
		data-bs-backdrop="static"
		data-bs-keyboard="false"
		tabindex="-1"
		aria-labelledby="exampleModalLabel"
		aria-hidden="true"
	>
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="exampleModalLabel">
						New Client
					</h1>
					<button
						type="button"
						class="btn-close"
						data-bs-dismiss="modal"
						@click="clearModal"
						aria-label="Close"
					></button>
				</div>
				<div class="modal-body">
					<form>
						<div class="mb-3">
							<label for="clientName" class="form-label"
								>Name</label
							>
							<input
								id="clientName"
								type="text"
								class="form-control"
								v-model="newClient.name"
								required
							/>
						</div>
						<div class="mb-3">
							<label for="clientLocation" class="form-label"
								>Location</label
							>
							<input
								id="clientLocation"
								type="text"
								class="form-control"
								v-model="newClient.location"
								required
							/>
						</div>
						<div class="mb-3">
							<label for="clientStatus" class="form-label"
								>Status</label
							>
							<div class="input-group">
								<input
									id="clientStatus"
									type="number"
									class="form-control"
									v-model="newClient.status"
									required
								/>
								<span class="input-group-text">kWh</span>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button
						type="button"
						class="btn btn-secondary"
						data-bs-dismiss="modal"
						@click="clearModal"
					>
						Close
					</button>
					<button
						type="button"
						class="btn btn-primary"
						@click="addClient"
						data-bs-dismiss="modal"
					>
						Create Client
					</button>
				</div>
			</div>
		</div>
	</div>
</template>
<script>
export default {
	data() {
		return {
			newClient: {
				name: "",
				location: "",
				status: 0,
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
				status: 0,
			};
		},
		clearModal() {
			this.newClient = {
				name: "",
				location: "",
				status: 0,
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
