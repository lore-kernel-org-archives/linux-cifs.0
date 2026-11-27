Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782606;
	b=KxruyS+/3cewasEL/RDFbTFawbJaL6FNp7PONhMvpmdgcTNyHLiACnnj8z6FoMEleX9r
	 WcyZqBEitEZ2i2D3dKJTRG+xgImDyUKucf0kaik2bhMYvxa4x1ECiqZYnjkBH32gFM5Qj
	 q3usnRhctxnzZeezekI9jAG6fuL2AQAgkQnignYVfE7OJLZbCG+0VXAC06PWTIaH0aRST
	 +1oGIdPIp4loyDDMN4XzLLi28+ujfEBl9ywTu6BChGkIOWb/4TwEV+xLLF53+gX5H/HlF
	 WEHfHMp5kGEl+Z5zL3Mrqh4cPF0DlFi+Odq9GdM+4GO71FmrvAc/NIGJQ3Fv2cjmd2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782606;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5en4e/o/0hc+EGVlVl9VhUUYZ2s3TiFRZr0sO82VfS4=;
	b=PdFPGjrLqKZ9YliAtfQOJ7bCDZ9AutqrjeEEUQPqG78p23tmnXnqMSGtZ2Mg5J2LM2X9
	 QOFllTckL9zNC1tEs5ZtLyayXEToupILniJ04RBaQQOpUejllTAv0pOL4FfT40Wd5BQHB
	 BFpHwhXChuBFLxEx+SXBCMlGtTKGIEfaGs641vmuc3itcFDagw8GGWNCmsHd3xHkOLzrM
	 ndb5tteaOUleooYipmTrmB1s+uDecw5zj5AGDn98QU+ImlHAkgPCHNhykMmJOxfGTfxcZ
	 yfi/bdb1dXFJCrM7oWnsYKAu8XlV6FmZw1UNvdh7Zgfgk8Bi1KmhcyY2ohnzTTlxhBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=wG7b9oBO;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F78A606A31F;
	Fri, 27 Nov 2026 12:30:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F78A606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=wG7b9oBO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=5en4e/o/0hc+EGVlVl9VhUUYZ2s3TiFRZr0sO82VfS4=; b=wG7b9oBO8AvhIMKskxSvY2Fg18
	gN42ZJ/Ruauq0gOz11ADa+xz+PbqlRX3bXhrWctSYjIt0haVRzTpcsX5NhNKov+TUGZ5yOm9fIi3M
	yZWRJmj1zZXrb+J9dPG/xGtDOkXwIEvSon9QpfZHBZlEGTtC5uHPVyJwecXYc0KsWSlQqAiEq99sU
	PphWORmFBA2XW9SsqhadeRMF2DOLjCzV+ol33OaA0cXdcySDnIpQltwc8oFVz8fipiizxf8qD+Cie
	/YOjG3smtOnQnnTubsXxZ41wENqWWqCxOzg2vnueIylV/faaDgSlH/Gjwir74owpH2E2fOj0Rahn9
	r0HQMLBHwlQuGq3eBM5/PpJY3ocZXD4pQ39yoZUKBv54LAYY1o4jehtFuhsCxkLyu5AEMdctEPxWO
	zkwJ88i8zl5PEDFxIAqezj7NF8d8nZc+Cojh287JIiIGI+eDFYQIqQcjF3/qOdqkE0vCkqmK+zgFj
	oMYVid6VevCuHd4PpwtHIR+C;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv5U-00000001Ldg-10rY;
	Fri, 27 Nov 2026 12:30:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH 07/10] smb: smbdirect: use separate cqes for MR registration and invalidation
Date: Fri, 27 Nov 2026 13:29:04 +0100
Message-ID: <8b1ab08e82c1177b44c3966e390a20733172366d.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smbdirect_connection_register_mr_io() posts a signaled IB_WR_REG_MR
with mr->cqe.done = smbdirect_connection_mr_io_register_done, and
smbdirect_connection_deregister_mr_io() reused the same mr->cqe for
IB_WR_LOCAL_INV, overwriting cqe.done with
smbdirect_connection_mr_io_local_inv_done.

If the deregistration happens before the REG_MR completion was
polled, that completion already ran local_inv_done(): it set the mr
to SMBDIRECT_MR_INVALIDATED and completed invalidate_done too early,
so the mr went back to SMBDIRECT_MR_READY (and ready.count++) while
the LOCAL_INV was still outstanding. Its real completion later set the
already reused mr to SMBDIRECT_MR_INVALIDATED again, leaving
ready.count counting mrs that are no longer READY, which can make
smbdirect_connection_get_mr_io() spin forever.

Rename mr->cqe to mr->reg_cqe and add a separate mr->inv_cqe for the
LOCAL_INV.

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/mr.c     | 12 ++++++------
 fs/smb/smbdirect/socket.h |  9 ++++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 54c53d0b2d64..70fc4a2fc7a8 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -237,7 +237,7 @@ smbdirect_connection_get_mr_io(struct smbdirect_socket *sc)
 static void smbdirect_connection_mr_io_register_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_mr_io *mr =
-		container_of(wc->wr_cqe, struct smbdirect_mr_io, cqe);
+		container_of(wc->wr_cqe, struct smbdirect_mr_io, reg_cqe);
 	struct smbdirect_socket *sc = mr->socket;
 
 	if (wc->status != IB_WC_SUCCESS) {
@@ -251,7 +251,7 @@ static void smbdirect_connection_mr_io_register_done(struct ib_cq *cq, struct ib
 static void smbdirect_connection_mr_io_local_inv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_mr_io *mr =
-		container_of(wc->wr_cqe, struct smbdirect_mr_io, cqe);
+		container_of(wc->wr_cqe, struct smbdirect_mr_io, inv_cqe);
 	struct smbdirect_socket *sc = mr->socket;
 
 	mr->state = SMBDIRECT_MR_INVALIDATED;
@@ -378,8 +378,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
 	reg_wr = &mr->wr;
 	reg_wr->wr.opcode = IB_WR_REG_MR;
-	mr->cqe.done = smbdirect_connection_mr_io_register_done;
-	reg_wr->wr.wr_cqe = &mr->cqe;
+	mr->reg_cqe.done = smbdirect_connection_mr_io_register_done;
+	reg_wr->wr.wr_cqe = &mr->reg_cqe;
 	reg_wr->wr.num_sge = 0;
 	reg_wr->wr.send_flags = IB_SEND_SIGNALED;
 	reg_wr->mr = mr->mr;
@@ -499,8 +499,8 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 
 		/* Need to finish local invalidation before returning */
 		wr->opcode = IB_WR_LOCAL_INV;
-		mr->cqe.done = smbdirect_connection_mr_io_local_inv_done;
-		wr->wr_cqe = &mr->cqe;
+		mr->inv_cqe.done = smbdirect_connection_mr_io_local_inv_done;
+		wr->wr_cqe = &mr->inv_cqe;
 		wr->num_sge = 0;
 		wr->ex.invalidate_rkey = mr->mr->rkey;
 		wr->send_flags = IB_SEND_SIGNALED;
diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
index 4dcbd9c86aaf..1fc4aebcdda5 100644
--- a/fs/smb/smbdirect/socket.h
+++ b/fs/smb/smbdirect/socket.h
@@ -826,7 +826,14 @@ enum smbdirect_mr_state {
 
 struct smbdirect_mr_io {
 	struct smbdirect_socket *socket;
-	struct ib_cqe cqe;
+	/*
+	 * Separate completion entries for IB_WR_REG_MR and IB_WR_LOCAL_INV:
+	 * smbdirect_connection_deregister_mr_io() can post the LOCAL_INV
+	 * before the REG_MR completion was polled, and with a shared entry
+	 * that completion would then already run the LOCAL_INV handler.
+	 */
+	struct ib_cqe reg_cqe;
+	struct ib_cqe inv_cqe;
 
 	/*
 	 * We can have up to two references:
-- 
2.43.0

