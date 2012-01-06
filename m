From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 03/15] cifscreds: eliminate domain parm from most functions
Date: Fri,  6 Jan 2012 13:14:35 -0500
Message-ID: <1325873687-11229-4-git-send-email-jlayton@samba.org>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Eventually we'll add this back in a different way. The domain and
address should be exclusive of one another. IOW, we want the kernel to
be able to find credentials for a specific address or for the domain of
which the server is a member.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   85 ++++++++++++----------------------------------------------
 1 files changed, 18 insertions(+), 67 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index d771056..a9181ef 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -62,10 +62,10 @@ static int cifscreds_update(int argc, char *argv[]);
 const char *thisprogram;
 
 struct command commands[] = {
-	{ cifscreds_add,	"add",		"<host> <user> [domain]" },
-	{ cifscreds_clear,	"clear",	"<host> <user> [domain]" },
+	{ cifscreds_add,	"add",		"<host> <user>" },
+	{ cifscreds_clear,	"clear",	"<host> <user>" },
 	{ cifscreds_clearall,	"clearall",	"" },
-	{ cifscreds_update,	"update",	"<host> <user> [domain]" },
+	{ cifscreds_update,	"update",	"<host> <user>" },
 	{ NULL, "", NULL }
 };
 
@@ -85,41 +85,28 @@ static void usage(void)
 
 /* create key's description string from given credentials */
 static char *
-create_description(const char *addr, const char *user,
-		   const char *domain, char *desc)
+create_description(const char *addr, const char *user, char *desc)
 {
 	char *str_end;
 	int str_len;
 
 	sprintf(desc, "%s:%s:%s:", THIS_PROGRAM_NAME, addr, user);
 
-	if (domain != NULL) {
-		str_end = desc + strnlen(desc, INET6_ADDRSTRLEN + \
-					+ MAX_USERNAME_SIZE + \
-					+ sizeof(THIS_PROGRAM_NAME) + 3);
-		str_len = strnlen(domain, MAX_DOMAIN_SIZE);
-		while (str_len--) {
-			*str_end = tolower(*domain++);
-			str_end++;
-		}
-		*str_end = '\0';
-	}
-
 	return desc;
 }
 
 /* search a specific key in keyring */
 static key_serial_t
-key_search(const char *addr, const char *user, const char *domain)
+key_search(const char *addr, const char *user)
 {
-	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + MAX_DOMAIN_SIZE + \
+	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + \
 		+ sizeof(THIS_PROGRAM_NAME) + 3];
 	key_serial_t key, *pk;
 	void *keylist;
 	char *buffer;
 	int count, dpos, n, ret;
 
-	create_description(addr, user, domain, desc);
+	create_description(addr, user, desc);
 
 	/* read the key payload data */
 	count = keyctl_read_alloc(DEST_KEYRING, &keylist);
@@ -219,13 +206,11 @@ key_search_all_out:
 
 /* add or update a specific key to keyring */
 static key_serial_t
-key_add(const char *addr, const char *user,
-	const char *domain, const char *pass)
+key_add(const char *addr, const char *user, const char *pass)
 {
-	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + MAX_DOMAIN_SIZE + \
-		+ sizeof(THIS_PROGRAM_NAME) + 3];
+	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + sizeof(THIS_PROGRAM_NAME) + 3];
 
-	create_description(addr, user, domain, desc);
+	create_description(addr, user, desc);
 
 	return add_key("user", desc, pass, strnlen(pass, MOUNT_PASSWD_SIZE) + 1,
 		DEST_KEYRING);
@@ -239,7 +224,7 @@ static int cifscreds_add(int argc, char *argv[])
 	char *pass;
 	int ret;
 
-	if (argc != 4 && argc != 5)
+	if (argc != 4)
 		usage();
 
 	ret = resolve_host(argv[2], addrstr);
@@ -259,15 +244,6 @@ static int cifscreds_add(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	if (argc == 5) {
-		if (strspn(argv[4], DOMAIN_ALLOWED_CHARS) !=
-			strnlen(argv[4], MAX_DOMAIN_SIZE)
-		) {
-			fprintf(stderr, "error: Incorrect domain name\n");
-			return EXIT_FAILURE;
-		}
-	}
-
 	/* search for same credentials stashed for current host */
 	currentaddress = addrstr;
 	nextaddress = strchr(currentaddress, ',');
@@ -275,9 +251,7 @@ static int cifscreds_add(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		if (key_search(currentaddress, argv[3],
-			argc == 5 ? argv[4] : NULL) > 0
-		) {
+		if (key_search(currentaddress, argv[3]) > 0) {
 			printf("You already have stashed credentials "
 				"for %s (%s)\n", currentaddress, argv[2]);
 			printf("If you want to update them use:\n");
@@ -307,8 +281,7 @@ static int cifscreds_add(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_add(currentaddress, argv[3],
-					   argc == 5 ? argv[4] : NULL, pass);
+		key_serial_t key = key_add(currentaddress, argv[3], pass);
 		if (key <= 0) {
 			fprintf(stderr, "error: Add credential key for %s\n",
 				currentaddress);
@@ -346,7 +319,7 @@ static int cifscreds_clear(int argc, char *argv[])
 	char *currentaddress, *nextaddress;
 	int ret, count = 0, errors = 0;
 
-	if (argc != 4 && argc != 5)
+	if (argc != 4)
 		usage();
 
 	ret = resolve_host(argv[2], addrstr);
@@ -366,15 +339,6 @@ static int cifscreds_clear(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	if (argc == 5) {
-		if (strspn(argv[4], DOMAIN_ALLOWED_CHARS) !=
-			strnlen(argv[4], MAX_DOMAIN_SIZE)
-		) {
-			fprintf(stderr, "error: Incorrect domain name\n");
-			return EXIT_FAILURE;
-		}
-	}
-
 	/*
 	 * search for same credentials stashed for current host
 	 * and unlink them from session keyring
@@ -385,8 +349,7 @@ static int cifscreds_clear(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_search(currentaddress, argv[3],
-						argc == 5 ? argv[4] : NULL);
+		key_serial_t key = key_search(currentaddress, argv[3]);
 		if (key > 0) {
 			if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
 				fprintf(stderr, "error: Removing key from "
@@ -464,7 +427,7 @@ static int cifscreds_update(int argc, char *argv[])
 	char *addrs[16];
 	int ret, id, count = 0;
 
-	if (argc != 4 && argc != 5)
+	if (argc != 4)
 		usage();
 
 	ret = resolve_host(argv[2], addrstr);
@@ -484,15 +447,6 @@ static int cifscreds_update(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	if (argc == 5) {
-		if (strspn(argv[4], DOMAIN_ALLOWED_CHARS) !=
-			strnlen(argv[4], MAX_DOMAIN_SIZE)
-		) {
-			fprintf(stderr, "error: Incorrect domain name\n");
-			return EXIT_FAILURE;
-		}
-	}
-
 	/* search for necessary credentials stashed in session keyring */
 	currentaddress = addrstr;
 	nextaddress = strchr(currentaddress, ',');
@@ -500,9 +454,7 @@ static int cifscreds_update(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		if (key_search(currentaddress, argv[3],
-			argc == 5 ? argv[4] : NULL) > 0
-		) {
+		if (key_search(currentaddress, argv[3]) > 0) {
 			addrs[count] = currentaddress;
 			count++;
 		}
@@ -528,8 +480,7 @@ static int cifscreds_update(int argc, char *argv[])
 	pass = getpass("Password: ");
 
 	for (id = 0; id < count; id++) {
-		key_serial_t key = key_add(addrs[id], argv[3],
-					argc == 5 ? argv[4] : NULL, pass);
+		key_serial_t key = key_add(addrs[id], argv[3], pass);
 		if (key <= 0)
 			fprintf(stderr, "error: Update credential key "
 				"for %s\n", addrs[id]);
-- 
1.7.7.4
