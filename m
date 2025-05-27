Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BEB27E7E1
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 16:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362475; cv=none; b=L/EFnIvFXlkusOjZio3hMsbuVbrVA9AXPbLAIfkv/dxeXcQaFGDMqzmK95Sim9ZWssn6LesEpYE8RL4OL/BiA7TJzK+7zecZpBsMbKnYjRXklWnK5gmDBFnhlgnek/UcRYsOS04pgUIRyszSorAYcE0nJOijXP+fNvsnMQ+CD9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362475; c=relaxed/simple;
	bh=szCZUu+zz1PhCc+LBZDP0gyAjxyfhXsgUnLPvBK22xU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fyrcrZZxE4yNaoZus4X/M2FKHcwljAVCprRcXzS6Lshum4h/ZNsMUlGK2UZQrFDEOde6m14VJHIKJx/MTuy7u9f6B00wE+4hnqITjPr+8mwidz9JStpLVlaHSzdek0tXFAF3SPjsZB1QmChOyRbMcjjqyCaAdT+zRsv0lhHGBoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VF7Pfwxk; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VF7Pfwxk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=iztxBZ9OXHHl2Xv4xbOjU6tQM8zWvrNP2iWxZbG4q0o=; b=VF7PfwxknLYorI3feldCbVD7S+
	sl+YxhEsejlsLrbGJ2y5S54SW5VfM4EBh2engarzBCI2rjpzm5zbmRPmNA1gb5+VZZ4KjsIkRpjdK
	DssoeYMCuPIpXOSk4G+q1C1+hVYB6uNFXjhZLX2b2io7K7CeX+KNQEQ2zJlp3guyAKTLFQmd3wtL3
	lKauKGYxTchxHBU04qYTTWbYvQuRYgTjKxhNWRgRfqJr4it8J480bw5ZtqIb17hKte1MOtOSzZq2i
	H9qMc33q4xYXLQXtSzTF3YU/I48n5qCPaDdxyOYXKPZ6ayJiBqSVBEd9ll+nWKMxvM8I2ViLuxjqo
	NEl7sCjMWi7wQzc3Bgh2A2ym+FdtkQfllBTMSWRXawQ4zBzsGSoxvD/fHn2sLt8ew91wBzs669Uai
	lAfkcoA+4Gb3KiwLMSKP19E1MR5qnN7gfcWTJCm2BwSVp8/hNH+9wxGrxHPdxvexrdEc1cKtkEmz1
	x7lcBG7pT2WngI66+nUS342F;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uJwwh-007VqK-0Q;
	Tue, 27 May 2025 16:14:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH 5/5] smb: server: make use of common smb_direct_buffer_descriptor_v1
Date: Tue, 27 May 2025 18:13:02 +0200
Message-Id: <59bd3b193af3897478c9c8c5158e04c29705278a.1748362221.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748362221.git.metze@samba.org>
References: <cover.1748362221.git.metze@samba.org>
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
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/connection.c     |  4 ++--
 fs/smb/server/connection.h     |  8 ++++----
 fs/smb/server/smb2pdu.c        | 10 +++++-----
 fs/smb/server/smb2pdu.h        |  8 ++------
 fs/smb/server/transport_rdma.c |  6 +++---
 fs/smb/server/transport_rdma.h |  2 --
 6 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 83764c230e9d..0f576edda6c1 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -243,7 +243,7 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 			 void *buf, unsigned int buflen,
-			 struct smb2_buffer_desc_v1 *desc,
+			 struct smb_direct_buffer_descriptor_v1 *desc,
 			 unsigned int desc_len)
 {
 	int ret = -EINVAL;
@@ -257,7 +257,7 @@ int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 
 int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
 			  void *buf, unsigned int buflen,
-			  struct smb2_buffer_desc_v1 *desc,
+			  struct smb_direct_buffer_descriptor_v1 *desc,
 			  unsigned int desc_len)
 {
 	int ret = -EINVAL;
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 14620e147dda..f6f1952f796b 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -126,11 +126,11 @@ struct ksmbd_transport_ops {
 		      unsigned int remote_key);
 	int (*rdma_read)(struct ksmbd_transport *t,
 			 void *buf, unsigned int len,
-			 struct smb2_buffer_desc_v1 *desc,
+			 struct smb_direct_buffer_descriptor_v1 *desc,
 			 unsigned int desc_len);
 	int (*rdma_write)(struct ksmbd_transport *t,
 			  void *buf, unsigned int len,
-			  struct smb2_buffer_desc_v1 *desc,
+			  struct smb_direct_buffer_descriptor_v1 *desc,
 			  unsigned int desc_len);
 };
 
@@ -155,11 +155,11 @@ bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 			 void *buf, unsigned int buflen,
-			 struct smb2_buffer_desc_v1 *desc,
+			 struct smb_direct_buffer_descriptor_v1 *desc,
 			 unsigned int desc_len);
 int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
 			  void *buf, unsigned int buflen,
-			  struct smb2_buffer_desc_v1 *desc,
+			  struct smb_direct_buffer_descriptor_v1 *desc,
 			  unsigned int desc_len);
 void ksmbd_conn_enqueue_request(struct ksmbd_work *work);
 void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8d414239b3fe..9428f9e08a93 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6617,7 +6617,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 }
 
 static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
-					struct smb2_buffer_desc_v1 *desc,
+					struct smb_direct_buffer_descriptor_v1 *desc,
 					__le32 Channel,
 					__le16 ChannelInfoLength)
 {
@@ -6653,7 +6653,7 @@ static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
 	int err;
 
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
-				    (struct smb2_buffer_desc_v1 *)
+				    (struct smb_direct_buffer_descriptor_v1 *)
 				    ((char *)req + le16_to_cpu(req->ReadChannelInfoOffset)),
 				    le16_to_cpu(req->ReadChannelInfoLength));
 	if (err)
@@ -6724,7 +6724,7 @@ int smb2_read(struct ksmbd_work *work)
 			goto out;
 		}
 		err = smb2_set_remote_key_for_rdma(work,
-						   (struct smb2_buffer_desc_v1 *)
+						   (struct smb_direct_buffer_descriptor_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->ReadChannelInfoLength);
@@ -6919,7 +6919,7 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 		return -ENOMEM;
 
 	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length,
-				   (struct smb2_buffer_desc_v1 *)
+				   (struct smb_direct_buffer_descriptor_v1 *)
 				   ((char *)req + le16_to_cpu(req->WriteChannelInfoOffset)),
 				   le16_to_cpu(req->WriteChannelInfoLength));
 	if (ret < 0) {
@@ -6984,7 +6984,7 @@ int smb2_write(struct ksmbd_work *work)
 			goto out;
 		}
 		err = smb2_set_remote_key_for_rdma(work,
-						   (struct smb2_buffer_desc_v1 *)
+						   (struct smb_direct_buffer_descriptor_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->WriteChannelInfoLength);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 17a0b18a8406..be79eeef540b 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -10,6 +10,8 @@
 #include "ntlmssp.h"
 #include "smbacl.h"
 
+#include "../common/smb_direct/smb_direct.h"
+
 /*Create Action Flags*/
 #define FILE_SUPERSEDED                0x00000000
 #define FILE_OPENED            0x00000001
@@ -133,12 +135,6 @@ struct create_posix_rsp {
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
index 4998df04ab95..642d419d9a52 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1354,7 +1354,7 @@ static void write_done(struct ib_cq *cq, struct ib_wc *wc)
 
 static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 				void *buf, int buf_len,
-				struct smb2_buffer_desc_v1 *desc,
+				struct smb_direct_buffer_descriptor_v1 *desc,
 				unsigned int desc_len,
 				bool is_read)
 {
@@ -1484,7 +1484,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 static int smb_direct_rdma_write(struct ksmbd_transport *t,
 				 void *buf, unsigned int buflen,
-				 struct smb2_buffer_desc_v1 *desc,
+				 struct smb_direct_buffer_descriptor_v1 *desc,
 				 unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
@@ -1493,7 +1493,7 @@ static int smb_direct_rdma_write(struct ksmbd_transport *t,
 
 static int smb_direct_rdma_read(struct ksmbd_transport *t,
 				void *buf, unsigned int buflen,
-				struct smb2_buffer_desc_v1 *desc,
+				struct smb_direct_buffer_descriptor_v1 *desc,
 				unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index 71909b6d8021..0fb692c40e21 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -7,8 +7,6 @@
 #ifndef __KSMBD_TRANSPORT_RDMA_H__
 #define __KSMBD_TRANSPORT_RDMA_H__
 
-#include "../common/smb_direct/smb_direct.h"
-
 #define SMBD_DEFAULT_IOSIZE (8 * 1024 * 1024)
 #define SMBD_MIN_IOSIZE (512 * 1024)
 #define SMBD_MAX_IOSIZE (16 * 1024 * 1024)
-- 
2.34.1

