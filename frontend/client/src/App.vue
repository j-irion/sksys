<template>
	<div class="input-group mb-3">
		<span class="input-group-text" id="inputGroup-sizing-default"
			>API Token</span
		>
		<input
			id="apiToken"
			class="form-control"
			aria-label="Sizing example input"
			aria-describedby="inputGroup-sizing-default"
		/>
	</div>
	<button btn-primary btn-lg @click="intervall">weiter</button>
</template>

<script>
export default {
	name: "App",
	data: () => ({
		count: 1,
	}),

	methods: {
		intervall(/* TODO: client token */) {
			setInterval(async () => {
				await this.res();
			}, 5000);
		},

		async res(/* TODO: client token */) {
			//let apiURL = "https://fakeapi.andreaspabst.com/api/todos"
			let apiURL = document.getElementById("apiToken").value;

			// TODO: Use fetch-API with POST method
			let response = await this.axios.get(apiURL);
			console.log(this.count, response);
			this.count++;
		},
	},
};
</script>

<style>
#app {
	font-family: Avenir, Helvetica, Arial, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	text-align: center;
	color: #2c3e50;
	margin-top: 60px;
}
</style>
