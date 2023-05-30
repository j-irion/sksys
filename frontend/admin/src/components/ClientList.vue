<template>
	<div class="overflow-scroll" style="height: 100%;">
		<div v-for="client in clients" class="card mt-2 mb-2">
			<div class="card-body">
				<h5 class="card-title">{{ client.name }}</h5>
				<p class="card-text">
					<div><b>Location:</b> {{ client.location }}</div>
					<div><b>Status:</b> {{ client.status }}</div>
				</p>
				<button class="btn btn-primary" @click="$emit('delete-client', client.id)">Remove</button>
			</div>
		</div>
	</div>
</template>
<script>
export default {
	props: {
		clients: {
			type: Array,
			require: true,
		},
	},
};
</script>
