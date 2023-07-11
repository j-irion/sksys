<template>
	<div id="app">
		<NavBar @add-client="addClient"></NavBar>
		<ClientList
			:clients="clients"
			@delete-client="removeClient"
			@edit-client="changeClient"
		></ClientList>
	</div>
	<div
		class="modal fade"
		id="apiKeyModal"
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
						Client API key
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
					<div class="">
						<pre
							class="bg-light p-3 rounded mb-0"
							id="apiKeyDisplay"
						><code>{{ clientApiKey.key }}</code></pre>
						<div class="p-1">
							<span id="copyMessage" class="text-success"></span>
						</div>
						<div class="input-group-append">
							<button
								class="btn btn-primary"
								type="button"
								id="copyButton"
								@click="copyToClipboard"
							>
								Copy
							</button>
						</div>
					</div>
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
				</div>
			</div>
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
import "bootstrap/dist/css/bootstrap.css";
import { Modal } from "bootstrap";

export default {
	components: {
		ClientList,
		NavBar,
	},
	data() {
		return {
			clients: [],
			clientApiKey: "",
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
			const modal = new Modal(document.getElementById("apiKeyModal"));
			modal.show();
			this.clientApiKey = response;
		},
		async changeClient(editedClient) {
			await editClient(editedClient);
			this.fetchAllClients();
		},
		async fetchAllClients() {
			const fetchedClients = await getAllClients();
			this.clients = fetchedClients;
		},
		copyToClipboard() {
			var apiKeyText = document.getElementById("apiKeyDisplay").innerText;
			var tempInput = document.createElement("input");
			tempInput.value = apiKeyText;
			document.body.appendChild(tempInput);
			tempInput.select();
			navigator.clipboard.writeText(tempInput.value);
			document.body.removeChild(tempInput);
			let copyMessage = document.getElementById("copyMessage");
			copyMessage.innerText = "API key copied!";
		},
	},
};
</script>
<style>
#app {
	display: flex;
	flex-direction: column;
	height: 100vh;
}

.container {
	display: flex;
	flex-direction: column;
	height: 100vh;
	flex-grow: 1;
}
</style>
