From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/7] cifs.idmap: add an options struct to handle long options
Date: Sat, 27 Oct 2012 07:20:18 -0400
Message-ID: <1351336822-16425-4-git-send-email-jlayton@samba.org>
References: <1351336822-16425-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351336822-16425-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...since the manpage advertises them.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index bfef58b..ea22300 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -44,6 +44,11 @@
 
 static const char *prog = "cifs.idmap";
 
+static const struct option long_options[] = {
+	{"version", 0, NULL, 'v'},
+	{NULL, 0, NULL, 0}
+};
+
 static void usage(void)
 {
 	fprintf(stderr, "Usage: %s key_serial\n", prog);
@@ -189,7 +194,7 @@ int main(const int argc, char *const argv[])
 
 	openlog(prog, 0, LOG_DAEMON);
 
-	while ((c = getopt_long(argc, argv, "v", NULL, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "v", long_options, NULL)) != -1) {
 		switch (c) {
 		case 'v':
 			printf("version: %s\n", VERSION);
-- 
1.7.11.7
