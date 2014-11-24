From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] Convert MessageID in smb2_hdr to LE
Date: Mon, 24 Nov 2014 15:53:58 +0000
Message-ID: <1416844438-22012-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We have encountered failures when When testing smb2 mounts on ppc64
machines when using both Samba as well as Windows 2012.

On poking around, the problem was determined to be caused by the
high endian MessageID passed in the header for smb2. On checking the
corresponding MID for smb1 is converted to LE before being sent on the
wire.

We have tested this using the RHEL 7 kernel where the patch fixes the
issue.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h | 6 +++---
 fs/cifs/smb2pdu.h  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 02a33e5..41ec69d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -661,16 +661,16 @@ set_credits(struct TCP_Server_Info *server, const int val)
 	server->ops->set_credits(server, val);
 }
 
-static inline __u64
+static inline __le64
 get_next_mid64(struct TCP_Server_Info *server)
 {
-	return server->ops->get_next_mid(server);
+	return cpu_to_le64(server->ops->get_next_mid(server));
 }
 
 static inline __le16
 get_next_mid(struct TCP_Server_Info *server)
 {
-	__u16 mid = get_next_mid64(server);
+	__u16 mid = server->ops->get_next_mid(server);
 	/*
 	 * The value in the SMB header should be little endian for easy
 	 * on-the-wire decoding.
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index e3188ab..2d4914e 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -110,7 +110,7 @@ struct smb2_hdr {
 	__le16 CreditRequest;  /* CreditResponse */
 	__le32 Flags;
 	__le32 NextCommand;
-	__u64  MessageId;	/* opaque - so can stay little endian */
+	__le64 MessageId;
 	__le32 ProcessId;
 	__u32  TreeId;		/* opaque - so do not make little endian */
 	__u64  SessionId;	/* opaque - so do not make little endian */
-- 
1.9.3
