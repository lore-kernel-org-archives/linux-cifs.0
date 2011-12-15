From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 06/12] cifscreds: make usage use "return" and have callers return
Date: Thu, 15 Dec 2011 13:12:10 -0500
Message-ID: <1323972736-15804-7-git-send-email-jlayton@samba.org>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323972736-15804-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...banish the use of exit(), which may be helpful in the future in
the event that we eventually move some of this code into a library.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index b6c1fb6..3ed15f2 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -70,7 +70,8 @@ struct command commands[] = {
 };
 
 /* display usage information */
-static void usage(void)
+static int
+usage(void)
 {
 	struct command *cmd;
 
@@ -80,7 +81,7 @@ static void usage(void)
 			cmd->name, cmd->format);
 	fprintf(stderr, "\n");
 
-	exit(EXIT_FAILURE);
+	return EXIT_FAILURE;
 }
 
 /* search a specific key in keyring */
@@ -217,7 +218,7 @@ static int cifscreds_add(int argc, char *argv[])
 	int ret;
 
 	if (argc != 4)
-		usage();
+		return usage();
 
 	ret = resolve_host(argv[2], addrstr);
 	switch (ret) {
@@ -312,7 +313,7 @@ static int cifscreds_clear(int argc, char *argv[])
 	int ret, count = 0, errors = 0;
 
 	if (argc != 4)
-		usage();
+		return usage();
 
 	ret = resolve_host(argv[2], addrstr);
 	switch (ret) {
@@ -380,7 +381,7 @@ static int cifscreds_clearall(int argc, char *argv[] __attribute__ ((unused)))
 	int count = 0, errors = 0;
 
 	if (argc != 2)
-		usage();
+		return usage();
 
 	/*
 	 * search for all program's credentials stashed in session keyring
@@ -420,7 +421,7 @@ static int cifscreds_update(int argc, char *argv[])
 	int ret, id, count = 0;
 
 	if (argc != 4)
-		usage();
+		return usage();
 
 	ret = resolve_host(argv[2], addrstr);
 	switch (ret) {
@@ -491,7 +492,7 @@ int main(int argc, char **argv)
 		thisprogram = THIS_PROGRAM_NAME;
 
 	if (argc == 1)
-		usage();
+		return usage();
 
 	/* find the best fit command */
 	best = NULL;
@@ -510,7 +511,7 @@ int main(int argc, char **argv)
 		/* partial match */
 		if (best) {
 			fprintf(stderr, "Ambiguous command\n");
-			exit(EXIT_FAILURE);
+			return EXIT_FAILURE;
 		}
 
 		best = cmd;
@@ -518,8 +519,8 @@ int main(int argc, char **argv)
 
 	if (!best) {
 		fprintf(stderr, "Unknown command\n");
-		exit(EXIT_FAILURE);
+		return EXIT_FAILURE;
 	}
 
-	exit(best->action(argc, argv));
+	return best->action(argc, argv);
 }
-- 
1.7.1
