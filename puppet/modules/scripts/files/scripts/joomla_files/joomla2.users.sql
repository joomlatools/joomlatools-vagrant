INSERT INTO `j_users` (`id`, `name`, `username`, `email`, `password`, `usertype`, `block`, `sendEmail`, `registerDate`, `lastvisitDate`, `activation`, `params`, `lastResetTime`, `resetCount`)
VALUES
	(970, 'Super User', 'admin', 'admin@example.com', 'e8d876703ae04a3fe6c4868ff296fb9f:99SknoS4CFHGWhkOtk8cNTIDXR0bSUvN', 'deprecated', 0, 1, '2013-07-24 11:23:33', '2013-07-26 13:40:55', '0', '', '0000-00-00 00:00:00', 0),
	(971, 'User', 'user', 'user@example.com', '92b46d92fc58eb86e92a8c796febeb34:fXySsDEWvyiIg0ifkftgTkrXzmviMvC3', '', 0, 0, '2013-07-24 11:28:07', '0000-00-00 00:00:00', '', '{\"admin_style\":\"\",\"admin_language\":\"\",\"language\":\"\",\"editor\":\"\",\"helpsite\":\"\",\"timezone\":\"\"}', '0000-00-00 00:00:00', 0),
	(972, 'Manager', 'manager', 'manager@example.com', '770b271ae81867018860e471d51781c9:8CqzT83QhW5AJACYBqDqoHJJE21l8r8Y', '', 0, 0, '2013-07-24 11:28:20', '0000-00-00 00:00:00', '', '{\"admin_style\":\"\",\"admin_language\":\"\",\"language\":\"\",\"editor\":\"\",\"helpsite\":\"\",\"timezone\":\"\"}', '0000-00-00 00:00:00', 0);

INSERT INTO `j_user_usergroup_map` (`user_id`, `group_id`)
VALUES
	(970, 8),
	(971, 2),
	(972, 6);
