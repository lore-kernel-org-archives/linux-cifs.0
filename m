From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: after upcalling for krb5 creds, invalidate key rather than revoking it
Date: Fri, 15 Jun 2012 08:53:41 -0400
Message-ID: <1339764822-24528-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Calling key_revoke here isn't ideal as further requests for the key will
end up returning -EKEYREVOKED until it gets purged from the cache. What we
really intend here is to force a new upcall on the next request_key.

Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 551d0c2..b421978 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -938,7 +938,7 @@ ssetup_ntlmssp_authenticate:
 
 ssetup_exit:
 	if (spnego_key) {
-		key_revoke(spnego_key);
+		key_invalidate(spnego_key);
 		key_put(spnego_key);
 	}
 	kfree(str_area);
-- 
1.7.7.6
