From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 06/16] cifscreds: eliminate domain parm from most commands
Date: Sun, 11 Dec 2011 11:34:13 -0500
Message-ID: <1323621263-14452-7-git-send-email-jlayton@samba.org>
References: <1323621263-14452-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323621263-14452-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Eventually we'll add this back in a different way. The domain and
address should be exclusive of one another. IOW, we want the kernel to
be able to find credentials for a specific address or for the domain of
which the server is a member.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   39 ++++++---------------------------------
 1 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 0292bec..a9181ef 100644
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
 
@@ -224,7 +224,7 @@ static int cifscreds_add(int argc, char *argv[])
 	char *pass;
 	int ret;
 
-	if (argc != 4 && argc != 5)
+	if (argc != 4)
 		usage();
 
 	ret = resolve_host(argv[2], addrstr);
@@ -244,15 +244,6 @@ static int cifscreds_add(int argc, char *argv[])
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
@@ -328,7 +319,7 @@ static int cifscreds_clear(int argc, char *argv[])
 	char *currentaddress, *nextaddress;
 	int ret, count = 0, errors = 0;
 
-	if (argc != 4 && argc != 5)
+	if (argc != 4)
 		usage();
 
 	ret = resolve_host(argv[2], addrstr);
@@ -348,15 +339,6 @@ static int cifscreds_clear(int argc, char *argv[])
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
@@ -445,7 +427,7 @@ static int cifscreds_update(int argc, char *argv[])
 	char *addrs[16];
 	int ret, id, count = 0;
 
-	if (argc != 4 && argc != 5)
+	if (argc != 4)
 		usage();
 
 	ret = resolve_host(argv[2], addrstr);
@@ -465,15 +447,6 @@ static int cifscreds_update(int argc, char *argv[])
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
-- 
1.7.7.3
