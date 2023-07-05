<template>
	<div class="container">
		<div class="input-group mb-3">
			<span
				style="font-size: 19px"
				class="input-group-text"
				id="inputGroup-sizing-default"
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
			<label style="font-size: 15px" class="input-group-text" for="metric"
				>Stromeinheit:</label
			>

			<input
				type="number"
				id="metric"
				name="metric"
				class="form-control"
				min="1"
				max="1000000"
			/>
		</div>
		<div>
			<p>Sekunden bis zum nächsten Post: {{ timerCount }}</p>
		</div>
	</div>
</template>

<script>
export default {
	name: "App",
	data() {
		return {
			timerCount: 5,
		};
	},

	watch: {
		timerCount: {
			handler(value) {
				if (value > -1) {
					setTimeout(() => {
						this.timerCount--;
					}, 1000);
				}
				if (value == -1) {
					this.timerCount = 5;
					this.res();
				}
			},
			immediate: true,
		},
	},

	methods: {
		async res() {
			const apiToken = document.getElementById("apiToken").value;
			if (apiToken === "") {
				return;
			}
			const power = parseFloat(document.getElementById("metric").value);
			console.log(power);
			if (!isFinite(power)) {
				return;
			}
			let data = {
				timestamp: Math.floor(Date.now() / 1000),
				used_power: power,
				authtoken: apiToken,
			};
			const response = await fetch("/api/submit", {
				// TODO: remove http://localhost:8000
				method: "POST",
				body: JSON.stringify(data),
				headers: {
					"Content-Type": "application/json",
				},
			});
			// Check status codea
			console.log(await response.text());
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
