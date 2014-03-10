INSERT INTO `j_users` (`id`, `name`, `username`, `email`, `password`, `block`, `sendEmail`, `registerDate`, `lastvisitDate`, `activation`, `params`, `lastResetTime`, `resetCount`)
VALUES
	(951, 'Super User', 'admin', 'admin@example.com', '871b1a6d54b378b5547a945ea1a8bd18:3UgsAngDFq7D0FRmyiWey4qgV8n5PpEJ', 0, 1, '2013-07-24 09:07:43', '2014-01-07 11:18:12', '0', '{\"admin_style\":\"\",\"admin_language\":\"\",\"language\":\"\",\"editor\":\"\",\"helpsite\":\"\",\"timezone\":\"\"}', '0000-00-00 00:00:00', 0),
	(952, 'User', 'user', 'user@example.com', '931d334de664be1135bed97fd9bb7b62:ZzvicSTnh9dr1Ln36G3MgkC9WSa9J4PW', 0, 0, '2013-07-24 09:23:03', '0000-00-00 00:00:00', '', '{\"admin_style\":\"\",\"admin_language\":\"\",\"language\":\"\",\"editor\":\"\",\"helpsite\":\"\",\"timezone\":\"\"}', '0000-00-00 00:00:00', 0),
	(953, 'Manager', 'manager', 'manager@example.com', 'e0f025cc620a663e172c8b25911e5c4e:44wqdHQWhDPcrRg5koGsWJ9Zlhr9WC5x', 0, 0, '2013-07-24 10:53:59', '0000-00-00 00:00:00', '', '{\"admin_style\":\"\",\"admin_language\":\"\",\"language\":\"\",\"editor\":\"\",\"helpsite\":\"\",\"timezone\":\"\"}', '0000-00-00 00:00:00', 0);

INSERT INTO `j_user_usergroup_map` (`user_id`, `group_id`)
VALUES
	(951, 8),
	(952, 2),
	(953, 6);
