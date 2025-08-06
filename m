Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCFE1A08BC
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501842; cv=none; b=l7HAjnbTO4mgJA7bI7/SG1u3NnMpK9BiPuDxCa+iay9JRqOEzG2/yt9Hlpqc2SvUh9d0YWtff3N/ygh4CVjPhQe9ejVZqOzuCf/EjrUwdpVwj1bQ6DTyAcF9NUduiz9Jdispqiu613XBfJSR+oXdtaElB7DoiVDcHfkptFfCwiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501842; c=relaxed/simple;
	bh=gYa8LizhpstxvjUfMiMlXywr8e5wqsNjbBQrEVlBMkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghND8R96l4V7FwxB38ByvrhAGf2aRlXcPuzB/8LE6LTCi6DBE/ZOBkf0x180/S0PzXyFfbA9yE88nEhg2l8cGhJFAfIZFR+eLj6yr3+KLlxy2wz6THuu442lic3XuV0uaUVLcdUC33Oi91zmFA8iBGEgn0L+Rz2Zsb8NNLTQ+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wC/rRQxm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wC/rRQxm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=BL0BxrnODPQelUrzJkaMgH/BYSzj8AR/nQ6xizT3AM0=; b=wC/rRQxmV6tMdnqLZWv5yfCsLE
	sD9tra5SceCGVR/uVUz0fxwqUVdHVa2XbMtaRA9gf8vJklGM6mjn5gBIR0oYZkqy/boEStZED0B30
	vKtCxDmEA+j3fMRpsMImxc+XbZbdLQbvvtbTpUUcmam4Sq3fH/CDw++oqaTupBCELaqjSfTMNlcYY
	Qdi3tM4qHOEPSoHZfqI2DZCTnjt8vkVI4QHO4kg3yQdnqALuECyeULHI5fFSCZHIdJOfUvpcNGDOb
	9/t5e04gQiImEgFKrpilXY80+Vbs4VIwC/lQ8L0tfBY3ASkjB9AS52l0WdFFRziHx/CnbBHuWvYzD
	84Kz2WaNc9ugM4oydbUrLbJv1dOoqujIK1hipuU7Sn/wqYacWK3h5L7P4p5+GAu9u20p2miapOX6l
	bjYWXnkl6Es1yZjjFJ7UYVnUk2/5VZUYF2Ttm5dsUaS4OVWXAHXOi7VIRcnxPXyJ6igtqQAKzmdBU
	3DTyb49oWNoWGr3EA5jNKh6H;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji4k-001Ogd-06;
	Wed, 06 Aug 2025 17:37:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Subject: [PATCH 09/18] smb: server: make use of common smbdirect.h
Date: Wed,  6 Aug 2025 19:35:55 +0200
Message-ID: <0ddd1afd130d3bb8a757d1d81e947dba16797d73.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/connection.c     |  4 ++--
 fs/smb/server/connection.h     | 10 ++++++----
 fs/smb/server/smb2pdu.c        | 11 ++++++-----
 fs/smb/server/smb2pdu.h        |  6 ------
 fs/smb/server/transport_rdma.c |  7 ++++---
 5 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 3f04a2977ba8..6bfb29e36fa2 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -243,7 +243,7 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 			 void *buf, unsigned int buflen,
-			 struct smb2_buffer_desc_v1 *desc,
+			 struct smbdirect_buffer_descriptor_v1 *desc,
 			 unsigned int desc_len)
 {
 	int ret = -EINVAL;
@@ -257,7 +257,7 @@ int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 
 int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
 			  void *buf, unsigned int buflen,
-			  struct smb2_buffer_desc_v1 *desc,
+			  struct smbdirect_buffer_descriptor_v1 *desc,
 			  unsigned int desc_len)
 {
 	int ret = -EINVAL;
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index dd3e0e3f7bf0..b18a518de508 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -19,6 +19,8 @@
 #include "smb_common.h"
 #include "ksmbd_work.h"
 
+struct smbdirect_buffer_descriptor_v1;
+
 #define KSMBD_SOCKET_BACKLOG		16
 
 enum {
@@ -127,11 +129,11 @@ struct ksmbd_transport_ops {
 		      unsigned int remote_key);
 	int (*rdma_read)(struct ksmbd_transport *t,
 			 void *buf, unsigned int len,
-			 struct smb2_buffer_desc_v1 *desc,
+			 struct smbdirect_buffer_descriptor_v1 *desc,
 			 unsigned int desc_len);
 	int (*rdma_write)(struct ksmbd_transport *t,
 			  void *buf, unsigned int len,
-			  struct smb2_buffer_desc_v1 *desc,
+			  struct smbdirect_buffer_descriptor_v1 *desc,
 			  unsigned int desc_len);
 	void (*free_transport)(struct ksmbd_transport *kt);
 };
@@ -157,11 +159,11 @@ bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 			 void *buf, unsigned int buflen,
-			 struct smb2_buffer_desc_v1 *desc,
+			 struct smbdirect_buffer_descriptor_v1 *desc,
 			 unsigned int desc_len);
 int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
 			  void *buf, unsigned int buflen,
-			  struct smb2_buffer_desc_v1 *desc,
+			  struct smbdirect_buffer_descriptor_v1 *desc,
 			  unsigned int desc_len);
 void ksmbd_conn_enqueue_request(struct ksmbd_work *work);
 void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6fc6ad63d004..e5699c4ee2e9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -23,6 +23,7 @@
 #include "asn1.h"
 #include "connection.h"
 #include "transport_ipc.h"
+#include "../common/smbdirect/smbdirect.h"
 #include "transport_rdma.h"
 #include "vfs.h"
 #include "vfs_cache.h"
@@ -6662,7 +6663,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 }
 
 static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
-					struct smb2_buffer_desc_v1 *desc,
+					struct smbdirect_buffer_descriptor_v1 *desc,
 					__le32 Channel,
 					__le16 ChannelInfoLength)
 {
@@ -6698,7 +6699,7 @@ static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
 	int err;
 
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
-				    (struct smb2_buffer_desc_v1 *)
+				    (struct smbdirect_buffer_descriptor_v1 *)
 				    ((char *)req + le16_to_cpu(req->ReadChannelInfoOffset)),
 				    le16_to_cpu(req->ReadChannelInfoLength));
 	if (err)
@@ -6769,7 +6770,7 @@ int smb2_read(struct ksmbd_work *work)
 			goto out;
 		}
 		err = smb2_set_remote_key_for_rdma(work,
-						   (struct smb2_buffer_desc_v1 *)
+						   (struct smbdirect_buffer_descriptor_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->ReadChannelInfoLength);
@@ -6964,7 +6965,7 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 		return -ENOMEM;
 
 	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length,
-				   (struct smb2_buffer_desc_v1 *)
+				   (struct smbdirect_buffer_descriptor_v1 *)
 				   ((char *)req + le16_to_cpu(req->WriteChannelInfoOffset)),
 				   le16_to_cpu(req->WriteChannelInfoLength));
 	if (ret < 0) {
@@ -7029,7 +7030,7 @@ int smb2_write(struct ksmbd_work *work)
 			goto out;
 		}
 		err = smb2_set_remote_key_for_rdma(work,
-						   (struct smb2_buffer_desc_v1 *)
+						   (struct smbdirect_buffer_descriptor_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->WriteChannelInfoLength);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 16ae8a10490b..5163d5241b90 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -136,12 +136,6 @@ struct create_posix_rsp {
 	u8 SidBuffer[44];
 } __packed;
 
-struct smb2_buffer_desc_v1 {
-	__le64 offset;
-	__le32 token;
-	__le32 length;
-} __packed;
-
 #define SMB2_0_IOCTL_IS_FSCTL 0x00000001
 
 struct smb_sockaddr_in {
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 275199fef4e5..584f89b88c71 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -23,6 +23,7 @@
 #include "connection.h"
 #include "smb_common.h"
 #include "../common/smb2status.h"
+#include "../common/smbdirect/smbdirect.h"
 #include "../common/smbdirect/smbdirect_pdu.h"
 #include "transport_rdma.h"
 
@@ -1335,7 +1336,7 @@ static void write_done(struct ib_cq *cq, struct ib_wc *wc)
 
 static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 				void *buf, int buf_len,
-				struct smb2_buffer_desc_v1 *desc,
+				struct smbdirect_buffer_descriptor_v1 *desc,
 				unsigned int desc_len,
 				bool is_read)
 {
@@ -1465,7 +1466,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 static int smb_direct_rdma_write(struct ksmbd_transport *t,
 				 void *buf, unsigned int buflen,
-				 struct smb2_buffer_desc_v1 *desc,
+				 struct smbdirect_buffer_descriptor_v1 *desc,
 				 unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
@@ -1474,7 +1475,7 @@ static int smb_direct_rdma_write(struct ksmbd_transport *t,
 
 static int smb_direct_rdma_read(struct ksmbd_transport *t,
 				void *buf, unsigned int buflen,
-				struct smb2_buffer_desc_v1 *desc,
+				struct smbdirect_buffer_descriptor_v1 *desc,
 				unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
-- 
2.43.0

