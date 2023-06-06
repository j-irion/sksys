<template>
	<table class="table table-hover">
		<thead>
			<tr>
				<th scope="col">Name</th>
				<th scope="col">Location</th>
				<th scope="col">Status</th>
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
				<td>{{ client.status }} kWh</td>
				<td><button class="btn btn-primary">Edit</button></td>
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
