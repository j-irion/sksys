<template>
	<div class="container">
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

		<div class="input-group mb-3">
			<label for="metric">Stromeinheit:</label>

			<input
				type="number"
				id="metric"
				name="metric"
				class="form-control"
				min="1"
				max="1000000"
			/>
		</div>

		<button btn-primary btn-lg @click="intervall">weiter</button>
	</div>
</template>

<script>
/*
export default {
	name: "App",
	data: () => ({
		count: 1,
	}),
	

	methods: {
		intervall( TODO: client token ) {
			setInterval(async () => {
				await this.res();
			}, 5000);
		},

		async res( TODO: client token ) {
			let apiURL = document.getElementById("apiToken").value;

			const url = ;

			let data = {
  			
			}

			var request = new Request(url, {
			method: 'POST',
			body: data,
			headers: new Headers()
			});

			fetch(request)
			.then(function() {
    // Handle response we get from the API
})

			console.log(this.count, response);
			this.count++;
		},
	},
};
*/
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
