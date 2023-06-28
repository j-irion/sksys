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
								list="locationOptions"
								required
							/>
							<datalist id="locationOptions"></datalist>
						</div>
						<div class="mb-3">
							<label for="clientDescription" class="form-label"
								>Description</label
							>
							<div class="input-group">
								<textarea
									id="clientDescription"
									class="form-control"
									v-model="newClient.description"
								></textarea>
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
	emits: ["add-client"],
	data() {
		return {
			newClient: {
				name: "",
				description: "",
				location: "",
			},
			locationData: {},
		};
	},
	mounted() {
		this.fetchLocationData();
	},
	methods: {
		fetchLocationData() {
			fetch("https://api.electricitymap.org/v3/zones")
				.then((response) => response.json())
				.then((data) => {
					this.locationData = data;
					this.populateLocationOptions();
				})
				.catch((error) => {
					console.error("Error fetching location data:", error);
				});
		},
		populateLocationOptions() {
			const locationOptions = document.getElementById("locationOptions");
			for (const locationKey in this.locationData) {
				const location = this.locationData[locationKey];
				const option = document.createElement("option");
				option.value = locationKey;
				option.text =
					location.countryName === undefined
						? location.zoneName
						: `${location.countryName} - ${location.zoneName}`;
				locationOptions.appendChild(option);
			}
		},
		addClient() {
			if (
				this.newClient.name === "" ||
				this.newClient.location === "" ||
				this.newClient.description === "" ||
				!Object.keys(this.locationData).includes(
					this.newClient.location
				)
			)
				return;
			this.$emit("add-client", this.newClient);
			this.newClient = {
				name: "",
				description: "",
				location: "",
			};
		},
		clearModal() {
			this.newClient = {
				name: "",
				description: "",
				location: "",
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
