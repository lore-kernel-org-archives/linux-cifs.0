From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 07/17] cifsacl: header file cleanup
Date: Sat,  3 Nov 2012 08:50:24 -0400
Message-ID: <1351947034-18876-8-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Remove the unused ace_action enum, and express mask values by or'ing
what they represent. Add a comment about the endianness of these values
in the packed structs too.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifsacl.h | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/cifsacl.h b/cifsacl.h
index f9fdc8f..68fe0fd 100644
--- a/cifsacl.h
+++ b/cifsacl.h
@@ -83,7 +83,7 @@
 #define NO_PROPAGATE_INHERIT_FLAG 0x04	/* NP */
 #define INHERIT_ONLY_FLAG 0x08		/* IO */
 #define INHERITED_ACE_FLAG 0x10		/* I */
-#define VFLAGS 0x1f
+#define VFLAGS (OBJECT_INHERIT_FLAG|CONTAINER_INHERIT_FLAG|NO_PROPAGATE_INHERIT_FLAG|INHERIT_ONLY_FLAG|INHERITED_ACE_FLAG)
 
 #define ACCESS_ALLOWED	0		/* ALLOWED */
 #define ACCESS_DENIED	1		/* DENIED */
@@ -94,18 +94,17 @@
 #define COMPTYPE 0x2
 #define COMPFLAG 0x4
 #define COMPMASK 0x8
-#define COMPALL 0xf /* COMPSID | COMPTYPE | COMPFLAG | COMPMASK */
+#define COMPALL (COMPSID|COMPTYPE|COMPFLAG|COMPMASK)
 
-#define NUM_AUTHS (6)   /* number of authority fields */
-#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
-
-enum ace_action {
-	acedelete = 0,
-	acemodify,
-	aceadd,
-	aceset
-};
+#define NUM_AUTHS (6)			/* number of authority fields */
+#define SID_MAX_SUB_AUTHORITIES (15)	/* max number of sub authority fields */
 
+/*
+ * While not indicated here, the structs below represent on-the-wire data
+ * structures. Any multi-byte values are expected to be little-endian!
+ *
+ * FIXME: should we change these to use endianness annotations?
+ */
 struct cifs_ntsd {
 	uint16_t revision; /* revision level */
 	uint16_t type;
-- 
1.7.11.7
