From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: implement the "nofail" option
Date: Mon,  8 Oct 2012 06:47:04 -0400
Message-ID: <1349693224-17065-1-git-send-email-jlayton@samba.org>
Cc: PTrenholme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The mount(8) manpage lists this as a fs-independent option:

    nofail: Do not report errors for this device if it does not exist.

Implement that in mount.cifs by not returning an error if we were unable
to find a suitable address for the mount attempt.

Reported-by: Peter Trenholme <PTrenholme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 7ee859b..756fce2 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -159,6 +159,7 @@
 #define OPT_CRUID      29
 #define OPT_BKUPUID    30
 #define OPT_BKUPGID    31
+#define OPT_NOFAIL     32
 
 #define MNT_TMP_FILE "/.mtab.cifs.XXXXXX"
 
@@ -178,6 +179,7 @@ struct parsed_mount_info {
 	unsigned int fakemnt:1;
 	unsigned int nomtab:1;
 	unsigned int verboseflag:1;
+	unsigned int nofail:1;
 };
 
 const char *thisprogram;
@@ -805,6 +807,8 @@ static int parse_opt_token(const char *token)
 		return OPT_BKUPUID;
 	if (strncmp(token, "backupgid", 9) == 0)
 		return OPT_BKUPGID;
+	if (strncmp(token, "nofail", 6) == 0)
+		return OPT_NOFAIL;
 
 	return OPT_ERROR;
 }
@@ -1177,6 +1181,9 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 
 			bkupgid = gr->gr_gid;
 			goto nocopy;
+		case OPT_NOFAIL:
+			parsed_info->nofail = 1;
+			goto nocopy;
 		}
 
 		/* check size before copying option to buffer */
@@ -2119,7 +2126,7 @@ int main(int argc, char **argv)
 mount_retry:
 	if (!currentaddress) {
 		fprintf(stderr, "Unable to find suitable address.\n");
-		rc = EX_FAIL;
+		rc = parsed_info->nofail ? 0 : EX_FAIL;
 		goto mount_exit;
 	}
 	strlcpy(options, "ip=", options_size);
-- 
1.7.11.4
