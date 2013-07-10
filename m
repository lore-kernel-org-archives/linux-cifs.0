From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 5/8] CIFS: Request durable open for SMB2 opens
Date: Wed, 10 Jul 2013 13:59:57 +0400
Message-ID: <1373450401-4135-6-git-send-email-pshilovsky@samba.org>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by passing durable context together with a handle caching lease or
batch oplock.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2file.c |    2 +-
 fs/cifs/smb2pdu.c  |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.h  |    6 +++++
 3 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 46a4299..150a9b1 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -81,7 +81,7 @@ smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	}
 
 	desired_access |= FILE_READ_ATTRIBUTES;
-	*smb2_oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	*smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
 	if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
 		memcpy(smb2_oplock + 1, fid->lease_key, SMB2_LEASE_KEY_SIZE);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e65ccdb..140a613 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -847,6 +847,28 @@ create_lease_buf(u8 *lease_key, u8 oplock)
 	return buf;
 }
 
+static struct create_durable *
+create_durable_buf(void)
+{
+	struct create_durable *buf;
+
+	buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->ccontext.DataOffset = cpu_to_le16(offsetof
+					(struct create_durable, Reserved));
+	buf->ccontext.DataLength = cpu_to_le32(16);
+	buf->ccontext.NameOffset = cpu_to_le16(offsetof
+				(struct create_durable, Name));
+	buf->ccontext.NameLength = cpu_to_le16(4);
+	buf->Name[0] = 'D';
+	buf->Name[1] = 'H';
+	buf->Name[2] = 'n';
+	buf->Name[3] = 'Q';
+	return buf;
+}
+
 static __u8
 parse_lease_state(struct smb2_create_rsp *rsp)
 {
@@ -901,6 +923,28 @@ add_lease_context(struct kvec *iov, unsigned int *num_iovec, __u8 *oplock)
 	return 0;
 }
 
+static int
+add_durable_context(struct kvec *iov, unsigned int *num_iovec)
+{
+	struct smb2_create_req *req = iov[0].iov_base;
+	unsigned int num = *num_iovec;
+
+	iov[num].iov_base = create_durable_buf();
+	if (iov[num].iov_base == NULL)
+		return -ENOMEM;
+	iov[num].iov_len = sizeof(struct create_durable);
+	if (!req->CreateContextsOffset)
+		req->CreateContextsOffset =
+			cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
+								iov[1].iov_len);
+	req->CreateContextsLength =
+			cpu_to_le32(le32_to_cpu(req->CreateContextsLength) +
+						sizeof(struct create_durable));
+	inc_rfc1001_len(&req->hdr, sizeof(struct create_durable));
+	*num_iovec = num + 1;
+	return 0;
+}
+
 int
 SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	  u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
@@ -911,7 +955,7 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	struct smb2_create_rsp *rsp;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses = tcon->ses;
-	struct kvec iov[3];
+	struct kvec iov[4];
 	int resp_buftype;
 	int uni_path_len;
 	__le16 *copy_path = NULL;
@@ -987,6 +1031,22 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		}
 	}
 
+	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
+		/* need to set Next field of lease context if we request it */
+		if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING) {
+			struct create_context *ccontext =
+			    (struct create_context *)iov[num_iovecs-1].iov_base;
+			ccontext->Next = sizeof(struct create_lease);
+		}
+		rc = add_durable_context(iov, &num_iovecs);
+		if (rc) {
+			cifs_small_buf_release(req);
+			kfree(copy_path);
+			kfree(iov[num_iovecs-1].iov_base);
+			return rc;
+		}
+	}
+
 	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
 	rsp = (struct smb2_create_rsp *)iov[0].iov_base;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 8b1025f..3e30f0a 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -485,6 +485,12 @@ struct create_lease {
 	struct lease_context lcontext;
 } __packed;
 
+struct create_durable {
+	struct create_context ccontext;
+	__u8   Name[8];
+	__u8   Reserved[16];
+} __packed;
+
 /* this goes in the ioctl buffer when doing a copychunk request */
 struct copychunk_ioctl {
 	char SourceKey[24];
-- 
1.7.10.4
