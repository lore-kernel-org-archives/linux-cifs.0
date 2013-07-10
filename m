From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/8] CIFS: Simplify SMB2 create context handling
Date: Wed, 10 Jul 2013 13:59:56 +0400
Message-ID: <1373450401-4135-5-git-send-email-pshilovsky@samba.org>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to make it easier to add other create context further.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2pdu.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9a35dcd..e65ccdb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -878,6 +878,29 @@ parse_lease_state(struct smb2_create_rsp *rsp)
 	return smb2_map_lease_to_oplock(lc->lcontext.LeaseState);
 }
 
+static int
+add_lease_context(struct kvec *iov, unsigned int *num_iovec, __u8 *oplock)
+{
+	struct smb2_create_req *req = iov[0].iov_base;
+	unsigned int num = *num_iovec;
+
+	iov[num].iov_base = create_lease_buf(oplock+1, *oplock);
+	if (iov[num].iov_base == NULL)
+		return -ENOMEM;
+	iov[num].iov_len = sizeof(struct create_lease);
+	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
+	if (!req->CreateContextsOffset)
+		req->CreateContextsOffset = cpu_to_le32(
+				sizeof(struct smb2_create_req) - 4 +
+				iov[num - 1].iov_len);
+	req->CreateContextsLength = cpu_to_le32(
+				le32_to_cpu(req->CreateContextsLength) +
+				sizeof(struct create_lease));
+	inc_rfc1001_len(&req->hdr, sizeof(struct create_lease));
+	*num_iovec = num + 1;
+	return 0;
+}
+
 int
 SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	  u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
@@ -956,21 +979,12 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	    *oplock == SMB2_OPLOCK_LEVEL_NONE)
 		req->RequestedOplockLevel = *oplock;
 	else {
-		iov[num_iovecs].iov_base = create_lease_buf(oplock+1, *oplock);
-		if (iov[num_iovecs].iov_base == NULL) {
+		rc = add_lease_context(iov, &num_iovecs, oplock);
+		if (rc) {
 			cifs_small_buf_release(req);
 			kfree(copy_path);
-			return -ENOMEM;
+			return rc;
 		}
-		iov[num_iovecs].iov_len = sizeof(struct create_lease);
-		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
-		req->CreateContextsOffset = cpu_to_le32(
-			sizeof(struct smb2_create_req) - 4 +
-			iov[num_iovecs-1].iov_len);
-		req->CreateContextsLength = cpu_to_le32(
-			sizeof(struct create_lease));
-		inc_rfc1001_len(&req->hdr, sizeof(struct create_lease));
-		num_iovecs++;
 	}
 
 	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
-- 
1.7.10.4
