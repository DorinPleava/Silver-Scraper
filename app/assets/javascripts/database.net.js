require('jquery')

import $ from 'jquery'

import 'datatables.net';

$(document).ready(function () {
	$('#example').DataTable({
		"pageLength": 50,
		"paging": true,
		"ordering": true,
		"info": false,
	    initComplete: function () {
			this.api().columns().every(function () {
				var column = this;
				var select = $('<select><option value=""></option></select>')
					.appendTo($(column.footer()).empty())
					.on('change', function () {
						var val = $.fn.dataTable.util.escapeRegex(
							$(this).val()
						);

						column
							.search(val ? '^' + val + '$' : '', true, false)
							.draw();
					});

				column.data().unique().sort().each(function (d, j) {
					select.append('<option value="' + d + '">' + d + '</option>')
				});
			});
		}
	});
});