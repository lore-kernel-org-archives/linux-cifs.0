From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: fix cifsidmap.h comment
Date: Wed,  2 Jan 2013 14:12:26 -0500
Message-ID: <1357153946-9300-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's actually OK to set this to BOTH.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifsidmap.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/cifsidmap.h b/cifsidmap.h
index e539719..656df86 100644
--- a/cifsidmap.h
+++ b/cifsidmap.h
@@ -45,10 +45,7 @@ struct cifs_sid {
 #define	CIFS_UXID_TYPE_GID	(2)	/* mapping is a GID */
 #define	CIFS_UXID_TYPE_BOTH	(3)	/* usable as UID or GID */
 
-/*
- * This struct represents both a uid or gid and its type. The type should
- * never be set to CIFSIDMAP_BOTH.
- */
+/* This struct represents a uid or gid and its type */
 struct cifs_uxid {
 	union {
 		uid_t uid;
-- 
1.7.11.7
