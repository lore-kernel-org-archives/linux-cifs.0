From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 10/16] cifscreds: move option parsing into main()
Date: Sun, 11 Dec 2011 11:34:17 -0500
Message-ID: <1323621263-14452-11-git-send-email-jlayton@samba.org>
References: <1323621263-14452-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323621263-14452-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Having to parse options in every command routine is cumbersome and
restrictive. Declare a struct to hold arguments, and then have the
functions take that struct as an argument.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   76 ++++++++++++++++++++++++++++++++++------------------------
 1 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 3ed15f2..79ab426 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -48,16 +48,21 @@
 /* destination keyring */
 #define DEST_KEYRING KEY_SPEC_USER_KEYRING
 
+struct cmdarg {
+	char	*host;
+	char	*user;
+};
+
 struct command {
-	int (*action)(int argc, char *argv[]);
+	int (*action)(struct cmdarg *arg);
 	const char	name[MAX_COMMAND_SIZE];
 	const char	*format;
 };
 
-static int cifscreds_add(int argc, char *argv[]);
-static int cifscreds_clear(int argc, char *argv[]);
-static int cifscreds_clearall(int argc, char *argv[]);
-static int cifscreds_update(int argc, char *argv[]);
+static int cifscreds_add(struct cmdarg *arg);
+static int cifscreds_clear(struct cmdarg *arg);
+static int cifscreds_clearall(struct cmdarg *arg);
+static int cifscreds_update(struct cmdarg *arg);
 
 const char *thisprogram;
 
@@ -210,21 +215,21 @@ key_add(const char *addr, const char *user, const char *pass)
 }
 
 /* add command handler */
-static int cifscreds_add(int argc, char *argv[])
+static int cifscreds_add(struct cmdarg *arg)
 {
 	char addrstr[MAX_ADDR_LIST_LEN];
 	char *currentaddress, *nextaddress;
 	char *pass;
 	int ret;
 
-	if (argc != 4)
+	if (arg->host == NULL || arg->user == NULL)
 		return usage();
 
-	ret = resolve_host(argv[2], addrstr);
+	ret = resolve_host(arg->host, addrstr);
 	switch (ret) {
 	case EX_USAGE:
 		fprintf(stderr, "error: Could not resolve address "
-			"for %s\n", argv[2]);
+			"for %s\n", arg->host);
 		return EXIT_FAILURE;
 
 	case EX_SYSERR:
@@ -232,7 +237,7 @@ static int cifscreds_add(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	if (strpbrk(argv[3], USER_DISALLOWED_CHARS)) {
+	if (strpbrk(arg->user, USER_DISALLOWED_CHARS)) {
 		fprintf(stderr, "error: Incorrect username\n");
 		return EXIT_FAILURE;
 	}
@@ -246,7 +251,7 @@ static int cifscreds_add(int argc, char *argv[])
 	while (currentaddress) {
 		if (key_search(currentaddress) > 0) {
 			printf("You already have stashed credentials "
-				"for %s (%s)\n", currentaddress, argv[2]);
+				"for %s (%s)\n", currentaddress, arg->host);
 			printf("If you want to update them use:\n");
 			printf("\t%s update\n", thisprogram);
 
@@ -274,7 +279,7 @@ static int cifscreds_add(int argc, char *argv[])
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_add(currentaddress, argv[3], pass);
+		key_serial_t key = key_add(currentaddress, arg->user, pass);
 		if (key <= 0) {
 			fprintf(stderr, "error: Add credential key for %s\n",
 				currentaddress);
@@ -289,7 +294,7 @@ static int cifscreds_add(int argc, char *argv[])
 				if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
 					fprintf(stderr, "error: Deleting key from "
 						"keyring for %s (%s)\n",
-						currentaddress, argv[2]);
+						currentaddress, arg->host);
 				}
 			}
 		}
@@ -306,20 +311,20 @@ static int cifscreds_add(int argc, char *argv[])
 }
 
 /* clear command handler */
-static int cifscreds_clear(int argc, char *argv[])
+static int cifscreds_clear(struct cmdarg *arg)
 {
 	char addrstr[MAX_ADDR_LIST_LEN];
 	char *currentaddress, *nextaddress;
 	int ret, count = 0, errors = 0;
 
-	if (argc != 4)
+	if (arg->host == NULL || arg->user == NULL)
 		return usage();
 
-	ret = resolve_host(argv[2], addrstr);
+	ret = resolve_host(arg->host, addrstr);
 	switch (ret) {
 	case EX_USAGE:
 		fprintf(stderr, "error: Could not resolve address "
-			"for %s\n", argv[2]);
+			"for %s\n", arg->host);
 		return EXIT_FAILURE;
 
 	case EX_SYSERR:
@@ -327,7 +332,7 @@ static int cifscreds_clear(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	if (strpbrk(argv[3], USER_DISALLOWED_CHARS)) {
+	if (strpbrk(arg->user, USER_DISALLOWED_CHARS)) {
 		fprintf(stderr, "error: Incorrect username\n");
 		return EXIT_FAILURE;
 	}
@@ -347,7 +352,7 @@ static int cifscreds_clear(int argc, char *argv[])
 			if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
 				fprintf(stderr, "error: Removing key from "
 					"keyring for %s (%s)\n",
-					currentaddress, argv[2]);
+					currentaddress, arg->host);
 				errors++;
 			} else {
 				count++;
@@ -364,7 +369,7 @@ static int cifscreds_clear(int argc, char *argv[])
 
 	if (!count && !errors) {
 		printf("You have no same stashed credentials "
-			" for %s\n", argv[2]);
+			" for %s\n", arg->host);
 		printf("If you want to add them use:\n");
 		printf("\t%s add\n", thisprogram);
 
@@ -375,14 +380,11 @@ static int cifscreds_clear(int argc, char *argv[])
 }
 
 /* clearall command handler */
-static int cifscreds_clearall(int argc, char *argv[] __attribute__ ((unused)))
+static int cifscreds_clearall(struct cmdarg *arg __attribute__ ((unused)))
 {
 	key_serial_t key;
 	int count = 0, errors = 0;
 
-	if (argc != 2)
-		return usage();
-
 	/*
 	 * search for all program's credentials stashed in session keyring
 	 * and then unlink them
@@ -413,21 +415,21 @@ static int cifscreds_clearall(int argc, char *argv[] __attribute__ ((unused)))
 }
 
 /* update command handler */
-static int cifscreds_update(int argc, char *argv[])
+static int cifscreds_update(struct cmdarg *arg)
 {
 	char addrstr[MAX_ADDR_LIST_LEN];
 	char *currentaddress, *nextaddress, *pass;
 	char *addrs[16];
 	int ret, id, count = 0;
 
-	if (argc != 4)
+	if (arg->host == NULL || arg->user == NULL)
 		return usage();
 
-	ret = resolve_host(argv[2], addrstr);
+	ret = resolve_host(arg->host, addrstr);
 	switch (ret) {
 	case EX_USAGE:
 		fprintf(stderr, "error: Could not resolve address "
-			"for %s\n", argv[2]);
+			"for %s\n", arg->host);
 		return EXIT_FAILURE;
 
 	case EX_SYSERR:
@@ -435,7 +437,7 @@ static int cifscreds_update(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	if (strpbrk(argv[3], USER_DISALLOWED_CHARS)) {
+	if (strpbrk(arg->user, USER_DISALLOWED_CHARS)) {
 		fprintf(stderr, "error: Incorrect username\n");
 		return EXIT_FAILURE;
 	}
@@ -462,7 +464,7 @@ static int cifscreds_update(int argc, char *argv[])
 
 	if (!count) {
 		printf("You have no same stashed credentials "
-			"for %s\n", argv[2]);
+			"for %s\n", arg->host);
 		printf("If you want to add them use:\n");
 		printf("\t%s add\n", thisprogram);
 
@@ -473,7 +475,7 @@ static int cifscreds_update(int argc, char *argv[])
 	pass = getpass("Password: ");
 
 	for (id = 0; id < count; id++) {
-		key_serial_t key = key_add(addrs[id], argv[3], pass);
+		key_serial_t key = key_add(addrs[id], arg->user, pass);
 		if (key <= 0)
 			fprintf(stderr, "error: Update credential key "
 				"for %s\n", addrs[id]);
@@ -485,8 +487,11 @@ static int cifscreds_update(int argc, char *argv[])
 int main(int argc, char **argv)
 {
 	struct command *cmd, *best;
+	struct cmdarg arg;
 	int n;
 
+	memset(&arg, 0, sizeof(arg));
+
 	thisprogram = (char *)basename(argv[0]);
 	if (thisprogram == NULL)
 		thisprogram = THIS_PROGRAM_NAME;
@@ -522,5 +527,12 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	return best->action(argc, argv);
+	/* first argument should be host */
+	if (argc >= 3)
+		arg.host = argv[2];
+
+	if (argc >= 4)
+		arg.user = argv[3];
+
+	return best->action(&arg);
 }
-- 
1.7.7.3
