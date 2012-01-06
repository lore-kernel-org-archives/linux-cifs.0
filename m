From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 09/15] cifscreds: add --domain flag
Date: Fri,  6 Jan 2012 13:14:41 -0500
Message-ID: <1325873687-11229-10-git-send-email-jlayton@samba.org>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...to indicate that the first argument is not a hostname but an
NT domain name. If it's set, then treat the argument as a
string literal.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   64 ++++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index f45497a..279517a 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -53,6 +53,7 @@
 struct cmdarg {
 	char		*host;
 	char		*user;
+	char		keytype;
 };
 
 struct command {
@@ -69,15 +70,16 @@ static int cifscreds_update(struct cmdarg *arg);
 const char *thisprogram;
 
 struct command commands[] = {
-	{ cifscreds_add,	"add",		"[-u username] <host>" },
-	{ cifscreds_clear,	"clear",	"[-u username] <host>" },
+	{ cifscreds_add,	"add",		"[-u username] [-d] <host|domain>" },
+	{ cifscreds_clear,	"clear",	"[-u username] [-d] <host|domain>" },
 	{ cifscreds_clearall,	"clearall",	"" },
-	{ cifscreds_update,	"update",	"[-u username] <host>" },
+	{ cifscreds_update,	"update",	"[-u username] [-d] <host|domain>" },
 	{ NULL, "", NULL }
 };
 
 struct option longopts[] = {
 	{"username", 1, NULL, 'u'},
+	{"domain", 0, NULL, 'd' },
 	{NULL, 0, NULL, 0}
 };
 
@@ -98,7 +100,7 @@ usage(void)
 
 /* search a specific key in keyring */
 static key_serial_t
-key_search(const char *addr)
+key_search(const char *addr, char keytype)
 {
 	char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME) + 4];
 	key_serial_t key, *pk;
@@ -106,7 +108,7 @@ key_search(const char *addr)
 	char *buffer;
 	int count, dpos, n, ret;
 
-	sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, addr);
+	sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME, keytype, addr);
 
 	/* read the key payload data */
 	count = keyctl_read_alloc(DEST_KEYRING, &keylist);
@@ -206,14 +208,14 @@ key_search_all_out:
 
 /* add or update a specific key to keyring */
 static key_serial_t
-key_add(const char *addr, const char *user, const char *pass)
+key_add(const char *addr, const char *user, const char *pass, char keytype)
 {
 	int len;
 	char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME) + 4];
 	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
 
 	/* set key description */
-	sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, addr);
+	sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME, keytype, addr);
 
 	/* set payload contents */
 	len = sprintf(val, "%s:%s", user, pass);
@@ -227,12 +229,16 @@ static int cifscreds_add(struct cmdarg *arg)
 	char addrstr[MAX_ADDR_LIST_LEN];
 	char *currentaddress, *nextaddress;
 	char *pass;
-	int ret;
+	int ret = 0;
 
 	if (arg->host == NULL || arg->user == NULL)
 		return usage();
 
-	ret = resolve_host(arg->host, addrstr);
+	if (arg->keytype == 'd')
+		strlcpy(addrstr, arg->host, MAX_ADDR_LIST_LEN);
+	else
+		ret = resolve_host(arg->host, addrstr);
+
 	switch (ret) {
 	case EX_USAGE:
 		fprintf(stderr, "error: Could not resolve address "
@@ -256,7 +262,7 @@ static int cifscreds_add(struct cmdarg *arg)
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		if (key_search(currentaddress) > 0) {
+		if (key_search(currentaddress, arg->keytype) > 0) {
 			printf("You already have stashed credentials "
 				"for %s (%s)\n", currentaddress, arg->host);
 			printf("If you want to update them use:\n");
@@ -286,7 +292,7 @@ static int cifscreds_add(struct cmdarg *arg)
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_add(currentaddress, arg->user, pass);
+		key_serial_t key = key_add(currentaddress, arg->user, pass, arg->keytype);
 		if (key <= 0) {
 			fprintf(stderr, "error: Add credential key for %s\n",
 				currentaddress);
@@ -322,12 +328,16 @@ static int cifscreds_clear(struct cmdarg *arg)
 {
 	char addrstr[MAX_ADDR_LIST_LEN];
 	char *currentaddress, *nextaddress;
-	int ret, count = 0, errors = 0;
+	int ret = 0, count = 0, errors = 0;
 
 	if (arg->host == NULL || arg->user == NULL)
 		return usage();
 
-	ret = resolve_host(arg->host, addrstr);
+	if (arg->keytype == 'd')
+		strlcpy(addrstr, arg->host, MAX_ADDR_LIST_LEN);
+	else
+		ret = resolve_host(arg->host, addrstr);
+
 	switch (ret) {
 	case EX_USAGE:
 		fprintf(stderr, "error: Could not resolve address "
@@ -354,7 +364,7 @@ static int cifscreds_clear(struct cmdarg *arg)
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_search(currentaddress);
+		key_serial_t key = key_search(currentaddress, arg->keytype);
 		if (key > 0) {
 			if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
 				fprintf(stderr, "error: Removing key from "
@@ -427,12 +437,16 @@ static int cifscreds_update(struct cmdarg *arg)
 	char addrstr[MAX_ADDR_LIST_LEN];
 	char *currentaddress, *nextaddress, *pass;
 	char *addrs[16];
-	int ret, id, count = 0;
+	int ret = 0, id, count = 0;
 
 	if (arg->host == NULL || arg->user == NULL)
 		return usage();
 
-	ret = resolve_host(arg->host, addrstr);
+	if (arg->keytype == 'd')
+		strlcpy(addrstr, arg->host, MAX_ADDR_LIST_LEN);
+	else
+		ret = resolve_host(arg->host, addrstr);
+
 	switch (ret) {
 	case EX_USAGE:
 		fprintf(stderr, "error: Could not resolve address "
@@ -456,7 +470,7 @@ static int cifscreds_update(struct cmdarg *arg)
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		if (key_search(currentaddress) > 0) {
+		if (key_search(currentaddress, arg->keytype) > 0) {
 			addrs[count] = currentaddress;
 			count++;
 		}
@@ -482,7 +496,7 @@ static int cifscreds_update(struct cmdarg *arg)
 	pass = getpass("Password: ");
 
 	for (id = 0; id < count; id++) {
-		key_serial_t key = key_add(addrs[id], arg->user, pass);
+		key_serial_t key = key_add(addrs[id], arg->user, pass, arg->keytype);
 		if (key <= 0)
 			fprintf(stderr, "error: Update credential key "
 				"for %s\n", addrs[id]);
@@ -498,6 +512,7 @@ int main(int argc, char **argv)
 	int n;
 
 	memset(&arg, 0, sizeof(arg));
+	arg.keytype = 'a';
 
 	thisprogram = (char *)basename(argv[0]);
 	if (thisprogram == NULL)
@@ -506,8 +521,11 @@ int main(int argc, char **argv)
 	if (argc == 1)
 		return usage();
 
-	while((n = getopt_long(argc, argv, "u:", longopts, NULL)) != -1) {
+	while((n = getopt_long(argc, argv, "du:", longopts, NULL)) != -1) {
 		switch (n) {
+		case 'd':
+			arg.keytype = (char) n;
+			break;
 		case 'u':
 			arg.user = optarg;
 			break;
@@ -544,10 +562,16 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	/* second argument should be host */
+	/* second argument should be host or domain */
 	if (argc >= 3)
 		arg.host = argv[optind + 1];
 
+	if (arg.host && arg.keytype == 'd' &&
+	    strspn(arg.host, DOMAIN_ALLOWED_CHARS) != strnlen(arg.host, MAX_DOMAIN_SIZE)) {
+		fprintf(stderr, "error: Domain name contains invalid characters\n");
+		return EXIT_FAILURE;
+	}
+
 	if (arg.user == NULL)
 		arg.user = getusername(getuid());
 
-- 
1.7.7.4
