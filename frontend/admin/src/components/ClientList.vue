<template>
	<div class="container">
		<div class="row">
			<div class="col-4">
				<table class="table table-hover">
					<thead>
						<tr>
							<th scope="col">Name</th>
							<th scope="col">Location</th>
							<th scope="col">Description</th>
							<th scope="col"></th>
							<th scope="col"></th>
						</tr>
					</thead>
					<tbody class="table-group-divider">
						<tr v-for="client in clients">
							<td>
								<h5>{{ client.name }}</h5>
							</td>
							<td>{{ client.location }}</td>
							<td>{{ client.description }}</td>
							<td>
								<button
									class="btn btn-primary"
									data-bs-toggle="modal"
									data-bs-target="#editModal"
									@click="clientBeingEdited = client"
								>
									Edit
								</button>
							</td>
							<td>
								<button
									class="btn btn-danger ms-2"
									@click="$emit('delete-client', client.id)"
								>
									Remove
								</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="col-8">
				<div class="row">
					<iframe
						:src="`${grafanaURL}&panelId=3`"
						frameborder="0"
					></iframe>
				</div>
				<div class="row">
					<iframe
						:src="`${grafanaURL}&panelId=1`"
						frameborder="0"
					></iframe>
				</div>
			</div>
		</div>
	</div>

	<div
		class="modal fade"
		id="editModal"
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
						Edit Client
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
								v-model="clientBeingEdited.name"
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
								v-model="clientBeingEdited.location"
								required
							/>
						</div>
						<div class="mb-3">
							<label for="clientStatus" class="form-label"
								>Description</label
							>
							<div class="input-group">
								<textarea
									id="clientStatus"
									class="form-control"
									v-model="clientBeingEdited.description"
									required
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
						@click="editClient"
						data-bs-dismiss="modal"
					>
						Save Changes
					</button>
				</div>
			</div>
		</div>
	</div>
</template>
<script>
import { getGrafanaURL } from "../services/ClientService";

export default {
	emits: ["edit-client", "delete-client"],
	props: {
		clients: {
			type: Array,
			require: true,
		},
	},
	data() {
		return {
			clientBeingEdited: {
				id: 0,
				name: "",
				description: "",
				location: "",
			},
			clientDashboardShownId:
				this.clients.length > 0 ? clients[0].id : null,
			grafanaURL: "",
		};
	},
	created() {
		this.createGrafanaIFrame();
	},
	methods: {
		clearModal() {
			this.clientBeingEdited = {
				id: null,
				name: "",
				description: "",
				location: "",
			};
		},
		editClient() {
			if (
				this.clientBeingEdited.name === "" ||
				this.clientBeingEdited.location === "" ||
				this.clientBeingEdited.description === ""
			)
				return;
			console.log(this.clientBeingEdited);
			this.$emit("edit-client", this.clientBeingEdited);
			this.clearModal();
		},
		async createGrafanaIFrame(id) {
			const grafanaURL = await getGrafanaURL();
			this.grafanaURL = `${grafanaURL}`;
		},
	},
};
</script>
<style scoped>
.container {
	display: flex;
	flex-direction: column;
	flex-grow: 1;
	margin: 0;
	max-width: none;
}
.row {
	flex-grow: 1;
}

.col-4 {
	overflow-y: scroll;
}
.col-8 {
	display: flex;
	flex-direction: column;
}

iframe {
	flex-grow: 1;
	width: 100%;
	height: 100%;
}
</style>
