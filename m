From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 08/15] cifscreds: make username parameter optional
Date: Fri,  6 Jan 2012 13:14:40 -0500
Message-ID: <1325873687-11229-9-git-send-email-jlayton@samba.org>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and use getopt_long to get it. If someone doesn't specify the username,
use getusername() to get it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   39 ++++++++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 79ab426..f45497a 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -27,8 +27,10 @@
 #include <string.h>
 #include <ctype.h>
 #include <keyutils.h>
+#include <getopt.h>
 #include "mount.h"
 #include "resolve_host.h"
+#include "util.h"
 
 #define THIS_PROGRAM_NAME "cifscreds"
 
@@ -49,8 +51,8 @@
 #define DEST_KEYRING KEY_SPEC_USER_KEYRING
 
 struct cmdarg {
-	char	*host;
-	char	*user;
+	char		*host;
+	char		*user;
 };
 
 struct command {
@@ -67,13 +69,18 @@ static int cifscreds_update(struct cmdarg *arg);
 const char *thisprogram;
 
 struct command commands[] = {
-	{ cifscreds_add,	"add",		"<host> <user>" },
-	{ cifscreds_clear,	"clear",	"<host> <user>" },
+	{ cifscreds_add,	"add",		"[-u username] <host>" },
+	{ cifscreds_clear,	"clear",	"[-u username] <host>" },
 	{ cifscreds_clearall,	"clearall",	"" },
-	{ cifscreds_update,	"update",	"<host> <user>" },
+	{ cifscreds_update,	"update",	"[-u username] <host>" },
 	{ NULL, "", NULL }
 };
 
+struct option longopts[] = {
+	{"username", 1, NULL, 'u'},
+	{NULL, 0, NULL, 0}
+};
+
 /* display usage information */
 static int
 usage(void)
@@ -499,12 +506,22 @@ int main(int argc, char **argv)
 	if (argc == 1)
 		return usage();
 
+	while((n = getopt_long(argc, argv, "u:", longopts, NULL)) != -1) {
+		switch (n) {
+		case 'u':
+			arg.user = optarg;
+			break;
+		default:
+			return usage();
+		}
+	}
+
 	/* find the best fit command */
 	best = NULL;
-	n = strnlen(argv[1], MAX_COMMAND_SIZE);
+	n = strnlen(argv[optind], MAX_COMMAND_SIZE);
 
 	for (cmd = commands; cmd->action; cmd++) {
-		if (memcmp(cmd->name, argv[1], n) != 0)
+		if (memcmp(cmd->name, argv[optind], n) != 0)
 			continue;
 
 		if (cmd->name[n] == 0) {
@@ -527,12 +544,12 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	/* first argument should be host */
+	/* second argument should be host */
 	if (argc >= 3)
-		arg.host = argv[2];
+		arg.host = argv[optind + 1];
 
-	if (argc >= 4)
-		arg.user = argv[3];
+	if (arg.user == NULL)
+		arg.user = getusername(getuid());
 
 	return best->action(&arg);
 }
-- 
1.7.7.4
