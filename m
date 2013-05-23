From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: allow sec=none mounts to work against servers that don't support extended security
Date: Wed, 22 May 2013 20:48:00 -0400
Message-ID: <1369270080-16005-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In the case of sec=none, we're not sending a username or password, so
there's little benefit to mandating NTLMSSP auth. Allow it to use
unencapsulated auth in that case.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 99eeaa1..0a7fdc3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1061,6 +1061,7 @@ static int cifs_parse_security_flavors(char *value,
 #endif
 	case Opt_sec_none:
 		vol->nullauth = 1;
+		vol->secFlg |= CIFSSEC_MAY_NTLM;
 		break;
 	default:
 		cifs_dbg(VFS, "bad security option: %s\n", value);
-- 
1.8.1.4
