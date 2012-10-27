From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/7] cifs.idmap: get rid of useless strcmp prior to idmapping
Date: Sat, 27 Oct 2012 07:20:17 -0400
Message-ID: <1351336822-16425-3-git-send-email-jlayton@samba.org>
References: <1351336822-16425-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351336822-16425-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The code copies off the key description and then ensures that it's
prefixed with "cifs.idmap". What's the point of that?

Presumably request-key would never have called this otherwise. There's
little harm in going ahead and doing the idmapping if this is called
with the wrong string.

Also, the error handling here is wrong. If the prefix doesn't match
the code will exit 0 without doing any mapping. Just remove it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index 80802d7..bfef58b 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -225,8 +225,7 @@ int main(const int argc, char *const argv[])
 
 	syslog(LOG_DEBUG, "key description: %s", buf);
 
-	if ((strncmp(buf, "cifs.idmap", sizeof("cifs.idmap") - 1) == 0))
-		rc = cifs_idmap(key, buf);
+	rc = cifs_idmap(key, buf);
 out:
 	return rc;
 }
-- 
1.7.11.7
