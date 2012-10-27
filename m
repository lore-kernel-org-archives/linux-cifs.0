From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/7] cifs.idmap: make sure cifsacl structs are packed
Date: Sat, 27 Oct 2012 07:20:16 -0400
Message-ID: <1351336822-16425-2-git-send-email-jlayton@samba.org>
References: <1351336822-16425-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351336822-16425-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The kernel equivalent definitions are defined with
__attribute__((packed)), and the code seems to assume the userspace and
kernel ones will be properly aligned. Fix the userspace definitions in a
similar fashion.

Given the way these structs are, there is probably not any padding
between fields on most arches, but it's best to be safe here.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifsacl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/cifsacl.h b/cifsacl.h
index 4ea7fd4..101881b 100644
--- a/cifsacl.h
+++ b/cifsacl.h
@@ -110,20 +110,20 @@ struct cifs_ntsd {
 	uint32_t gsidoffset;
 	uint32_t sacloffset;
 	uint32_t dacloffset;
-};
+} __attribute__((packed));
 
 struct cifs_sid {
 	uint8_t revision; /* revision level */
 	uint8_t num_subauth;
 	uint8_t authority[6];
 	uint32_t sub_auth[5]; /* sub_auth[num_subauth] */
-};
+} __attribute__((packed));
 
 struct cifs_ctrl_acl {
 	uint16_t revision; /* revision level */
 	uint16_t size;
 	uint32_t num_aces;
-};
+} __attribute__((packed));
 
 struct cifs_ace {
 	uint8_t type;
@@ -131,6 +131,6 @@ struct cifs_ace {
 	uint16_t size;
 	uint32_t access_req;
 	struct cifs_sid sid; /* ie UUID of user or group who gets these perms */
-};
+} __attribute__((packed));
 
 #endif /* CIFSACL_H */
-- 
1.7.11.7
