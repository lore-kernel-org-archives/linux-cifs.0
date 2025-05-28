Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F9628C854
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448170; cv=none; b=BgMHLcrL5LA+i1Caty3NLapSLUnQuohJgepwQwnGKVxQLX+GiC47mImvtS51GaiPrTku+qVV6qY/3xEfLS/SZCgeqisSWtnKDfMYz1TjYtZe3zodapx++nU5R6JyWSd1B5zZ1scvUkJ23XomWCFXWIukAFjzXqkcJ4H7jA552IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448170; c=relaxed/simple;
	bh=Jre9rUxF52yrVG2k3GajFND2+KloDJHSOZFiOV9Q/80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dTS9uG8tzwwR0UxgKzbws0T2Oda6oEPlWVypOm40oklM2wk/aE9DQUivVbyhj5Uaz/kS7OLgE3pAanHJFq2f8RoR+Qpn+tFJlaB6LnBb2ncJx6+JA+fldhHvy0VceAVEfBBRvEsaenA0SD2tBxCu0j+lccxN+03zyCZK7lHF/lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dHInQV75; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dHInQV75"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=4ooRWdjNozhLp5m5+ekeKM5KHHFY+pUa4ke1MjKgp9I=; b=dHInQV75XsrK5BbCaFq1Lmq4J6
	vZ0/VAA2qXCHfodRuuMFwbhm/fYb6/4Lp3LEHaUU+6eKf95/5BhPWnSPiQX8X/IS2ahjxCWhpYutF
	RWBrQVYlKTTJTjSo+TBZ9e7rAXDzaOaArFkpBa50QXNcGAq5J7rA7b9o4UoekJGdgwH/hLo6e+gD5
	oES/vM4M4qfDrEiuM+qufpwVh5N9lX4K3fuMGrzZcWtqQVDM5kYJTEgYObxUNAaxIw8qexmgESsoO
	1I7waW1G9EuH2V6kb14HCUhUUpjXSsvp6XG9fD1LpXIK86GLtMSgAzgMmapBueUTKmm1wFj/Wh2V4
	zL7nLSaZJjC6A+RR8bbj9h82T5gDFGWHuuD+U53ZaxXTnEj2WpWJdF4EzRV+0tZIDxg6xEUbcVV3P
	yNemMquIRtWuJB75xegbbPRnrHEMNyN1grjnVrmGlbVzE6wDh2K9AH+K+HtjZ7hFl9o9tAGi+0McA
	/1+wKt30GqHS3d8by4jYI1YE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJEq-007hLy-0p;
	Wed, 28 May 2025 16:02:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH v2 06/12] smb: server: make use of common smbdirect.h
Date: Wed, 28 May 2025 18:01:35 +0200
Message-Id: <ecbcf78d7b5817e6bf421c917c7b5b20ed3c27fe.1748446473.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748446473.git.metze@samba.org>
References: <cover.1748446473.git.metze@samba.org>
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
index 83764c230e9d..2e7515e57117 100644
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
index 14620e147dda..3821f0f53d3d 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -19,6 +19,8 @@
 #include "smb_common.h"
 #include "ksmbd_work.h"
 
+struct smbdirect_buffer_descriptor_v1;
+
 #define KSMBD_SOCKET_BACKLOG		16
 
 enum {
@@ -126,11 +128,11 @@ struct ksmbd_transport_ops {
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
 };
 
@@ -155,11 +157,11 @@ bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
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
index 8d414239b3fe..7ddc69fe6320 100644
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
@@ -6617,7 +6618,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 }
 
 static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
-					struct smb2_buffer_desc_v1 *desc,
+					struct smbdirect_buffer_descriptor_v1 *desc,
 					__le32 Channel,
 					__le16 ChannelInfoLength)
 {
@@ -6653,7 +6654,7 @@ static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
 	int err;
 
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
-				    (struct smb2_buffer_desc_v1 *)
+				    (struct smbdirect_buffer_descriptor_v1 *)
 				    ((char *)req + le16_to_cpu(req->ReadChannelInfoOffset)),
 				    le16_to_cpu(req->ReadChannelInfoLength));
 	if (err)
@@ -6724,7 +6725,7 @@ int smb2_read(struct ksmbd_work *work)
 			goto out;
 		}
 		err = smb2_set_remote_key_for_rdma(work,
-						   (struct smb2_buffer_desc_v1 *)
+						   (struct smbdirect_buffer_descriptor_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->ReadChannelInfoLength);
@@ -6919,7 +6920,7 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 		return -ENOMEM;
 
 	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length,
-				   (struct smb2_buffer_desc_v1 *)
+				   (struct smbdirect_buffer_descriptor_v1 *)
 				   ((char *)req + le16_to_cpu(req->WriteChannelInfoOffset)),
 				   le16_to_cpu(req->WriteChannelInfoLength));
 	if (ret < 0) {
@@ -6984,7 +6985,7 @@ int smb2_write(struct ksmbd_work *work)
 			goto out;
 		}
 		err = smb2_set_remote_key_for_rdma(work,
-						   (struct smb2_buffer_desc_v1 *)
+						   (struct smbdirect_buffer_descriptor_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->WriteChannelInfoLength);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 17a0b18a8406..1b940cedb22f 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -133,12 +133,6 @@ struct create_posix_rsp {
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
index 55fda2585583..99ceef3d83ba 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -23,6 +23,7 @@
 #include "connection.h"
 #include "smb_common.h"
 #include "../common/smb2status.h"
+#include "../common/smbdirect/smbdirect.h"
 #include "../common/smbdirect/smbdirect_pdu.h"
 #include "transport_rdma.h"
 
@@ -1355,7 +1356,7 @@ static void write_done(struct ib_cq *cq, struct ib_wc *wc)
 
 static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 				void *buf, int buf_len,
-				struct smb2_buffer_desc_v1 *desc,
+				struct smbdirect_buffer_descriptor_v1 *desc,
 				unsigned int desc_len,
 				bool is_read)
 {
@@ -1485,7 +1486,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 static int smb_direct_rdma_write(struct ksmbd_transport *t,
 				 void *buf, unsigned int buflen,
-				 struct smb2_buffer_desc_v1 *desc,
+				 struct smbdirect_buffer_descriptor_v1 *desc,
 				 unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
@@ -1494,7 +1495,7 @@ static int smb_direct_rdma_write(struct ksmbd_transport *t,
 
 static int smb_direct_rdma_read(struct ksmbd_transport *t,
 				void *buf, unsigned int buflen,
-				struct smb2_buffer_desc_v1 *desc,
+				struct smbdirect_buffer_descriptor_v1 *desc,
 				unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
-- 
2.34.1

