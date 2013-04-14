From: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mount.cifs: Add support for parsing IPv6 addresses enclosed in brackets.
Date: Sun, 14 Apr 2013 14:19:18 -0400
Message-ID: <1365963558-20082-1-git-send-email-scott.lovenberg@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The standard for formatting IPv6 addresses is to enclose them in brackets.
This patch allows the mount helper to parse IPv6 addresses that are enclosed in brackets.
There is a slight change of behavior in this patch; specifying the --ip option without
supplying an address now exits the mount helper rather than just ignoring and continuing.

Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 AUTHORS      |    1 +
 mount.cifs.c |   63 ++++++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/AUTHORS b/AUTHORS
index 2807079..081c2fe 100644
--- a/AUTHORS
+++ b/AUTHORS
@@ -5,5 +5,6 @@ Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
 Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 
 ...and others.
diff --git a/mount.cifs.c b/mount.cifs.c
index 3b2b89e..276f50d 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -751,6 +751,48 @@ static int parse_opt_token(const char *token)
 	return OPT_ERROR;
 }
 
+/* 
+  Extract an ipv4 or ipv6 address and put it into parsed_info. 
+  Returns 0 on success.
+*/
+static int parse_ip(char *value, struct parsed_mount_info *parsed_info)
+{
+	char *closingBracket = NULL;
+
+	if (!value || !*value) {
+		fprintf(stderr, "target ip address argument missing\n");
+		return OPT_ERROR;
+	}
+
+	/* check for ipv6 in brackets */
+	if (value[0] == '[') {
+		value++;
+		/* temporarily null the closing bracket */
+		closingBracket = strchr(value, ']');
+		if (closingBracket)
+			*closingBracket = '\0';
+	}
+
+	/* check length of address*/
+	if (strnlen(value, MAX_ADDRESS_LEN + 1) > MAX_ADDRESS_LEN) {
+		fprintf(stderr, "ip address too long\n");
+		if (closingBracket)
+			*closingBracket = ']';
+		return EX_USAGE;
+	}
+
+	/* all test pass, copy it */
+	strcpy(parsed_info->addrlist, value);
+	if (parsed_info->verboseflag)
+		fprintf(stderr, "ip address %s override specified\n", value);
+
+	/* put back closing bracket */
+	if (closingBracket)
+		*closingBracket = ']';
+
+	return 0;
+}
+
 static int
 parse_options(const char *data, struct parsed_mount_info *parsed_info)
 {
@@ -861,23 +903,10 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			break;
 
 		case OPT_IP:
-			if (!value || !*value) {
-				fprintf(stderr,
-					"target ip address argument missing\n");
-			} else if (strnlen(value, MAX_ADDRESS_LEN) <=
-				MAX_ADDRESS_LEN) {
-				strcpy(parsed_info->addrlist, value);
-				if (parsed_info->verboseflag)
-					fprintf(stderr,
-						"ip address %s override specified\n",
-						value);
-				goto nocopy;
-			} else {
-				fprintf(stderr, "ip address too long\n");
-				return EX_USAGE;
-
-			}
-			break;
+			rc = parse_ip(value, parsed_info);
+			if (rc)
+				return rc;			
+			goto nocopy;
 
 		/* unc || target || path */
 		case OPT_UNC:
-- 
1.7.10.4
