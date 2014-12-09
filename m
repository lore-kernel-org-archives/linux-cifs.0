From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3] Convert MessageID in smb2_hdr to LE
Date: Tue,  9 Dec 2014 17:37:00 +0000
Message-ID: <1418146620-11888-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

We have tested this patch successfully on a ppc64 machine.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h      |  6 +++---
 fs/cifs/smb2misc.c      | 12 +++++++-----
 fs/cifs/smb2ops.c       |  3 ++-
 fs/cifs/smb2pdu.h       |  2 +-
 fs/cifs/smb2transport.c |  2 +-
 5 files changed, 14 insertions(+), 11 deletions(-)

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
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 1a08a34..6e01933 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -32,12 +32,14 @@
 static int
 check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
 {
+	__u64 wire_mid = le64_to_cpu(hdr->MessageId);
+
 	/*
 	 * Make sure that this really is an SMB, that it is a response,
 	 * and that the message ids match.
 	 */
 	if ((*(__le32 *)hdr->ProtocolId == SMB2_PROTO_NUMBER) &&
-	    (mid == hdr->MessageId)) {
+	    (mid == wire_mid)) {
 		if (hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
 			return 0;
 		else {
@@ -51,11 +53,11 @@ check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
 		if (*(__le32 *)hdr->ProtocolId != SMB2_PROTO_NUMBER)
 			cifs_dbg(VFS, "Bad protocol string signature header %x\n",
 				 *(unsigned int *) hdr->ProtocolId);
-		if (mid != hdr->MessageId)
+		if (mid != wire_mid)
 			cifs_dbg(VFS, "Mids do not match: %llu and %llu\n",
-				 mid, hdr->MessageId);
+				 mid, wire_mid);
 	}
-	cifs_dbg(VFS, "Bad SMB detected. The Mid=%llu\n", hdr->MessageId);
+	cifs_dbg(VFS, "Bad SMB detected. The Mid=%llu\n", wire_mid);
 	return 1;
 }
 
@@ -95,7 +97,7 @@ smb2_check_message(char *buf, unsigned int length)
 {
 	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
 	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
-	__u64 mid = hdr->MessageId;
+	__u64 mid = le64_to_cpu(hdr->MessageId);
 	__u32 len = get_rfc1002_length(buf);
 	__u32 clc_len;  /* calculated length */
 	int command;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c5f521b..9e7c86c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -176,10 +176,11 @@ smb2_find_mid(struct TCP_Server_Info *server, char *buf)
 {
 	struct mid_q_entry *mid;
 	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
+	__u64 wire_mid = le64_to_cpu(hdr->MessageId);
 
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
-		if ((mid->mid == hdr->MessageId) &&
+		if ((mid->mid == wire_mid) &&
 		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
 		    (mid->command == hdr->Command)) {
 			spin_unlock(&GlobalMid_Lock);
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
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 5111e72..d4c5b6f 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -490,7 +490,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 		return temp;
 	else {
 		memset(temp, 0, sizeof(struct mid_q_entry));
-		temp->mid = smb_buffer->MessageId;	/* always LE */
+		temp->mid = le64_to_cpu(smb_buffer->MessageId);
 		temp->pid = current->pid;
 		temp->command = smb_buffer->Command;	/* Always LE */
 		temp->when_alloc = jiffies;
-- 
2.1.0
