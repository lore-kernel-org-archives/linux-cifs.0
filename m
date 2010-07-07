From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] KEYS: Authorise keyctl_set_timeout() on a key if we have
	its authorisation key
Date: Wed, 07 Jul 2010 10:14:06 +0100
Message-ID: <20100707091406.16573.40070.stgit@warthog.procyon.org.uk>
References: <20100707091400.16573.2817.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100707091400.16573.2817.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

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

Signed-off-by: David Howells <dhowells@redhat.com>
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

