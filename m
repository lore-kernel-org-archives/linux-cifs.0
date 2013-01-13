From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: set parsed_info->got_user when a cred file supplies a username
Date: Sun, 13 Jan 2013 05:53:31 -0500
Message-ID: <1358074411-29601-1-git-send-email-jlayton@samba.org>
Cc: grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit 85d18a1ed introduced a regression when using a credentials file.
It set the username in the parsed mount info properly, but didn't set
the "got_user" flag in it.

Also, fix an incorrect strlcpy length specifier in open_cred_file.

Reported-by: "Mantas M." <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index c7c3055..40b77e9 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -581,7 +581,8 @@ static int open_cred_file(char *file_name,
 		switch (parse_cred_line(line_buf + i, &temp_val)) {
 		case CRED_USER:
 			strlcpy(parsed_info->username, temp_val,
-				sizeof(parsed_info->domain));
+				sizeof(parsed_info->username));
+			parsed_info->got_user = 1;
 			break;
 		case CRED_PASS:
 			i = set_password(parsed_info, temp_val);
-- 
1.7.11.7
