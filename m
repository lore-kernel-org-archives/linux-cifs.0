From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 11/17] setcifsacl: clean up get_numcaces
Date: Sat,  3 Nov 2012 08:50:28 -0400
Message-ID: <1351947034-18876-12-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

No need to walk the string twice or to hand-roll our own version of
strchr(). Also, move the check for no argument out into main().

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 4d9787e..faf5405 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -701,22 +701,19 @@ parse_cmdline_aces_ret:
 	return NULL;
 }
 
+/* How many aces were provided on the command-line? Count the commas. */
 static unsigned int
-get_numcaces(const char *optarg)
+get_numcaces(const char *aces)
 {
 	int i, len;
-	unsigned int numcaces = 1;
+	unsigned int num = 1;
+	const char *current;
 
-	if (!optarg)
-		return 0;
-
-	len = strlen(optarg);
-	for (i = 0; i < len; ++i) {
-		if (*(optarg + i) == ',')
-			++numcaces;
-	}
+	current = aces;
+	while((current = strchr(current, ',')))
+		++num;
 
-	return numcaces;
+	return num;
 }
 
 static int
@@ -831,12 +828,13 @@ main(const int argc, char *const argv[])
 	}
 	filename = argv[3];
 
-	numcaces = get_numcaces(ace_list);
-	if (!numcaces) {
+	if (!ace_list) {
 		printf("%s: No valid ACEs specified\n", __func__);
 		return -1;
 	}
 
+	numcaces = get_numcaces(ace_list);
+
 	arrptr = parse_cmdline_aces(ace_list, numcaces);
 	if (!arrptr)
 		goto setcifsacl_numcaces_ret;
-- 
1.7.11.7
