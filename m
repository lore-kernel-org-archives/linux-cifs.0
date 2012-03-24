From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: add support for -s option
Date: Sat, 24 Mar 2012 08:26:59 -0400
Message-ID: <1332592019-8080-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

autofs generally calls mount helpers with '-s'. Handle that the same
way we do for NFS -- append ",sloppy" option to the mount options.

The kernel can look for that option to decide whether to ignore
unknown mount options, warn, or error out.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 824cd3a..c0aea35 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1438,6 +1438,7 @@ static struct option longopts[] = {
 	{"pass", 1, NULL, 'p'},
 	{"credentials", 1, NULL, 'c'},
 	{"port", 1, NULL, 'P'},
+	{"sloppy", 0, NULL, 's'},
 	{NULL, 0, NULL, 0}
 };
 
@@ -1863,6 +1864,7 @@ int main(int argc, char **argv)
 	char *currentaddress, *nextaddress;
 	int rc = 0;
 	int already_uppercased = 0;
+	int sloppy = 0;
 	size_t options_size = MAX_OPTIONS_LEN;
 	struct parsed_mount_info *parsed_info = NULL;
 	pid_t pid;
@@ -1900,7 +1902,7 @@ int main(int argc, char **argv)
 	}
 
 	/* add sharename in opts string as unc= parm */
-	while ((c = getopt_long(argc, argv, "?fhno:rvVw",
+	while ((c = getopt_long(argc, argv, "?fhno:rsvVw",
 				longopts, NULL)) != -1) {
 		switch (c) {
 		case '?':
@@ -1932,6 +1934,9 @@ int main(int argc, char **argv)
 		case 'f':
 			++parsed_info->fakemnt;
 			break;
+		case 's':
+			++sloppy;
+			break;
 		default:
 			fprintf(stderr, "unknown command-line option: %c\n", c);
 			rc = mount_usage(stderr);
@@ -2037,6 +2042,9 @@ mount_retry:
 		strlcat(options, parsed_info->prefix, options_size);
 	}
 
+	if (sloppy)
+		strlcat(options, ",sloppy", options_size);
+
 	if (parsed_info->verboseflag)
 		fprintf(stderr, "%s kernel mount options: %s",
 			thisprogram, options);
-- 
1.7.7.6
