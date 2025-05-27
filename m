Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B0B2798F0
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362467; cv=none; b=lk3y752rFWfnhHnm8kNdhyMfdSyBd0EwN4jKSCxglbDyiwkXZF+MsqWdd4MxpAyCSHniqc6Tqmg43aCSdZCg0Z0ThxZzRvRgqdTLGNC94VM6Eg6GPg4lOORIYcwQg4F2fgTJUYwTDeCTUVj1/WmN65BNMok1dv91ySqnZOF6v+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362467; c=relaxed/simple;
	bh=CYzxDhNoZ/9eiCj6Sx2h3pMAAnRuz+sUHPPosSbGXW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p36Jzr+HVP1K7VXpMbnbmiaRdQ/2QSs+fNy6ArO0ZlIkDs1FjdGN8LYzdEn74pwH5g4ssxdA/HHzD8Fp/TJAeB+sUtF0JrYDtNPhxK12lyx9HWZ+VcW+ngO0F0rGs9moouO0Au/iRJDb4NDevozRgduqM7kcouwqf2bbdn5MoNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=DzmMKPa/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DzmMKPa/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=R/0f3Sv1x7JOL/iypUZpNmP27h7PYl2XgsP5zY1Sd8o=; b=DzmMKPa/xungUTFR9OEGgZ7hw+
	I1x4AbepWheUXGe4avz9Jym5pgVnSu18U4VKUw+++mou6pYWZ5gBzrvQHuLyzkVCBAA2ed28tWaiL
	vfnO7JQSnI290CHTZLy1lPiF7d/WXn8UPVm4Df8tfC7PeBa4lc6d/2xXFj596A37aFMc25vhPKdqr
	Lm5t5gq99ctrvVuSxRGWoc2DVwYMwexKf5hEZYPwMTZCrH7vDAonsdhfnbuBv5ZWq/8SnqxK3lUQH
	O9s6IEyUeuVIyoqt0mTGFTsMtHBllD4kCVahizDATRy4R3/iFyVFUf8goFqsML80TkuKDYvxAfroE
	T77cTatD0gUOl57EgXvrfcC4raSZEWGPSiWb/O/vIKRJ6EDtsQO7I+WJtWDVDNDh0k31AWvMFxHBp
	Pp8H+KmzJElOC0Id6RoRJVZsgHhEp3cQdJzULEBhDP2rN2Q/N7hcQcesEQ/JtSfD/AC2qbAbJyOOn
	tAaA7cN5Sw8X2Xu+KYku+2B+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uJwwY-007Vnt-1X;
	Tue, 27 May 2025 16:14:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH 4/5] smb: client: make use of common smb_direct_buffer_descriptor_v1
Date: Tue, 27 May 2025 18:13:01 +0200
Message-Id: <06ddf2c44a6f7917044d50b81f5b1a727fbe29ed.1748362221.git.metze@samba.org>
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
 fs/smb/client/smb2pdu.c   | 16 ++++++++--------
 fs/smb/client/smbdirect.h |  7 -------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 701a138b82c8..09b9bb1afd01 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4442,10 +4442,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a RDMA write, fill in and append
-	 * smbd_buffer_descriptor_v1 to the end of read request
+	 * smb_direct_buffer_descriptor_v1 to the end of read request
 	 */
 	if (rdata && smb3_use_rdma_offload(io_parms)) {
-		struct smbd_buffer_descriptor_v1 *v1;
+		struct smb_direct_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
 		rdata->mr = smbd_register_mr(server->smbd_conn, &rdata->subreq.io_iter,
@@ -4459,8 +4459,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		req->ReadChannelInfoOffset =
 			cpu_to_le16(offsetof(struct smb2_read_req, Buffer));
 		req->ReadChannelInfoLength =
-			cpu_to_le16(sizeof(struct smbd_buffer_descriptor_v1));
-		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
+			cpu_to_le16(sizeof(struct smb_direct_buffer_descriptor_v1));
+		v1 = (struct smb_direct_buffer_descriptor_v1 *) &req->Buffer[0];
 		v1->offset = cpu_to_le64(rdata->mr->mr->iova);
 		v1->token = cpu_to_le32(rdata->mr->mr->rkey);
 		v1->length = cpu_to_le32(rdata->mr->mr->length);
@@ -4968,10 +4968,10 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a server RDMA read, fill in and append
-	 * smbd_buffer_descriptor_v1 to the end of write request
+	 * smb_direct_buffer_descriptor_v1 to the end of write request
 	 */
 	if (smb3_use_rdma_offload(io_parms)) {
-		struct smbd_buffer_descriptor_v1 *v1;
+		struct smb_direct_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
 		wdata->mr = smbd_register_mr(server->smbd_conn, &wdata->subreq.io_iter,
@@ -4990,8 +4990,8 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		req->WriteChannelInfoOffset =
 			cpu_to_le16(offsetof(struct smb2_write_req, Buffer));
 		req->WriteChannelInfoLength =
-			cpu_to_le16(sizeof(struct smbd_buffer_descriptor_v1));
-		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
+			cpu_to_le16(sizeof(struct smb_direct_buffer_descriptor_v1));
+		v1 = (struct smb_direct_buffer_descriptor_v1 *) &req->Buffer[0];
 		v1->offset = cpu_to_le64(wdata->mr->mr->iova);
 		v1->token = cpu_to_le32(wdata->mr->mr->rkey);
 		v1->length = cpu_to_le32(wdata->mr->mr->length);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 9c5b78a33311..a6ed8910e864 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -179,13 +179,6 @@ enum smbd_message_type {
 	SMBD_TRANSFER_DATA,
 };
 
-/* The packet fields for a registered RDMA buffer */
-struct smbd_buffer_descriptor_v1 {
-	__le64 offset;
-	__le32 token;
-	__le32 length;
-} __packed;
-
 /* Maximum number of SGEs used by smbdirect.c in any send work request */
 #define SMBDIRECT_MAX_SEND_SGE	6
 
-- 
2.34.1

