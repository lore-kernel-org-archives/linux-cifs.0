From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] KEYS: Authorise keyctl_set_timeout() on a key if we have
	its authorisation key
Date: Thu, 22 Jul 2010 18:32:51 +0100
Message-ID: <20100722173251.1512.29858.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Authorise a process to perform keyctl_set_timeout() on an uninstantiated key if
that process has the authorisation key for it.

This allows the instantiator to set the timeout on a key it is instantiating -
provided it does it before instantiating the key.

For instance, the test upcall script provided with the keyutils package could
be modified to set the expiry to an hour hence before instantiating the key:

	[/usr/share/keyutils/request-key-debug.sh]
	 if [ "$3" != "neg" ]
	 then
	+    keyctl timeout $1 3600
	     keyctl instantiate $1 "Debug $3" $4 || exit 1
	 else

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 security/keys/keyctl.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 6261745..639226a 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1091,7 +1091,7 @@ error:
 long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 {
 	struct timespec now;
-	struct key *key;
+	struct key *key, *instkey;
 	key_ref_t key_ref;
 	time_t expiry;
 	long ret;
@@ -1099,10 +1099,25 @@ long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 	key_ref = lookup_user_key(id, KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL,
 				  KEY_SETATTR);
 	if (IS_ERR(key_ref)) {
+		/* setting the timeout on a key under construction is permitted
+		 * if we have the authorisation token handy */
+		if (PTR_ERR(key_ref) == -EACCES) {
+			instkey = key_get_instantiation_authkey(id);
+			if (!IS_ERR(instkey)) {
+				key_put(instkey);
+				key_ref = lookup_user_key(id,
+							  KEY_LOOKUP_PARTIAL,
+							  0);
+				if (!IS_ERR(key_ref))
+					goto okay;
+			}
+		}
+
 		ret = PTR_ERR(key_ref);
 		goto error;
 	}
 
+okay:
 	key = key_ref_to_ptr(key_ref);
 
 	/* make the changes with the locks held to prevent races */
