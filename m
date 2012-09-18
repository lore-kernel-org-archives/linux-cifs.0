From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix return value in cifsConvertToUTF16
Date: Tue, 18 Sep 2012 14:21:01 -0400
Message-ID: <1347992461-20670-1-git-send-email-jlayton@redhat.com>
Cc: baldvin.kovacs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nico.lefebvre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This function returns the wrong value, which causes the callers to get
the length of the resulting pathname wrong when it contains non-ASCII
characters.

This seems to fix https://bugzilla.samba.org/show_bug.cgi?id=6767

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reported-by: Baldvin Kovacs <baldvin.kovacs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-and-Tested-by: Nicolas Lefebvre <nico.lefebvre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 7dab9c0..53cf2aa 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -328,7 +328,7 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 	}
 
 ctoUTF16_out:
-	return i;
+	return j;
 }
 
 #ifdef CONFIG_CIFS_SMB2
-- 
1.7.11.4
