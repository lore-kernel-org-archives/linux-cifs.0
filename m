From: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Trivial comment fixes
Date: Wed, 10 Apr 2013 13:16:52 -0400
Message-ID: <1365614212-13433-1-git-send-email-scott.lovenberg@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Two trivial comment fixes.

Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 4548fc6..58b127a 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -975,7 +975,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 
 			fprintf(stderr, "bad option: gid=\"%s\"\n", value);
 			return EX_USAGE;
-		/* fmask fall through to file_mode */
+		/* fmask falls through to file_mode */
 		case OPT_FMASK:
 			fprintf(stderr,
 				"WARNING: CIFS mount option 'fmask' is\
@@ -1145,7 +1145,7 @@ nocopy:
 	if (got_cruid) {
 		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", cruid);
 
-		/* comma + "cruid=" + terminating NULL == 6 */
+		/* comma + "cruid=" + terminating NULL == 8 */
 		if (out_len + word_len + 8 > MAX_OPTIONS_LEN) {
 			fprintf(stderr, "Options string too long\n");
 			return EX_USAGE;
-- 
1.7.5.4
