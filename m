From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 11/15] cifscreds: use the session keyring
Date: Fri,  6 Jan 2012 13:14:43 -0500
Message-ID: <1325873687-11229-12-git-send-email-jlayton@samba.org>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This seems like a reasonable change, but I'm willing to listen to
arguments to the contrary...

cifscreds currently hangs the keys off of the uid keyring. It seems
more appropriate though that we require that each session have its
own set. This might be particularly important in a containerized
situation. If a user authenticates in one container, then we probably
don't want to allow a user in another to "borrow" those creds.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index cbd431e..6079b38 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -51,7 +51,7 @@
 #define DOMAIN_DISALLOWED_CHARS "\\/:*?\"<>|"
 
 /* destination keyring */
-#define DEST_KEYRING KEY_SPEC_USER_KEYRING
+#define DEST_KEYRING KEY_SPEC_SESSION_KEYRING
 
 struct cmdarg {
 	char		*host;
-- 
1.7.7.4
