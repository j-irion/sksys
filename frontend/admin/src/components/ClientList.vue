<template>
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
		};
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
	},
};
</script>
