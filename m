Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659B91632C8
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155024; cv=none; b=UI0hj2QjjcwEDVCgwyEoGGTM8wOPixIEpR8frOMAeWnX74j8+f9e+OM6WOXTlx6nctd7gLEK/GT4Xtthobp9tUPLU92U6oggRWC3aNK5oYdUgyrhF8ACwTqBhSNkj87bExfasiDrc198J1QNHQJzUNAVv877E7FkZbdpySb1qlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155024; c=relaxed/simple;
	bh=wxigcE5KaK7kTgtqD7nRpCftf35pq0TbY2yc80G7Lms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDvF7aPPwwTxWc8DE1Dk5wgl4+LORyNc3mX6zH5LaDkJgTWQ/LgOkthdUrkPjVJqeg+0tO/CX/A3xnY/wu5wAsHeKVlZj1C73/K6/hGQ34gSiI40z+wHmd+hA06mTvhR6Xsd8PUxGU1YRfm96zLw+5mVJitWiCnPbVp2yXwNHUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ljawLQ/L; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ljawLQ/L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nJI0H4ilBK20OpQaG9Kglv2NydBNuQCIF+aIEOZ2Ct0=; b=ljawLQ/LjeQtADLGQElMy8FVi0
	FQ2ByoZbIhdlF6AwwZkcelDqOauU3+NwbZIKsb5LQ/heh1XKTLIeV3OaXd6cLVTVNK98elg76ELMW
	6Cukz+fWMdpxxQVp/cs/JHWTFL1KaUUwZTxRDgo5oUd9sqfYnfG17YTfcvmSHV/d+UG+EMAhjjc6r
	HdjWCZymCaQ3OCCN2z6BF0FKJN/v2Fj/OkB0dCvQSscv+NkjpKvBHxgdrUw2aIK9U7pMwnHIz76gW
	IVCygBlbtbxX1rWV0BfN+KmOAJvd7WOKEfyqsCiMpbIkRekoTk4Y8+Nsz0ecHvbHGZEi6CwoLW1fS
	Q0AZDweCfD1vGIFbnRdV1ILxKXPgLGQ+aEuamwLmVMaGstx+tnq0HPrRVe6JzzCRqrEesVIdFAIyV
	PC2SvU4fNoIBg8L/VBTCYxqvUpen5j5+BkSqyDhaB45Ya2usqm/PQOHrQShoxDA8MK/ExP4pgPSAp
	ueP50RYOe7W7Qe86uuRqAOc1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe8s-000kvo-2r;
	Mon, 25 Aug 2025 20:50:15 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 051/142] smb: client: add and use smbd_get_parameters()
Date: Mon, 25 Aug 2025 22:40:12 +0200
Message-ID: <124671bf9b9473af89bb6ec2bb7bf2e71032f2be.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In future struct smbdirect_socket_parameters will be the only
public structure for the smb layer. This prepares this...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smb2ops.c   | 8 ++++----
 fs/smb/client/smbdirect.c | 7 +++++++
 fs/smb/client/smbdirect.h | 2 ++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 94b1d7a395d5..87b6254e1e73 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -504,8 +504,8 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	wsize = min_t(unsigned int, wsize, server->max_write);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
-		struct smbdirect_socket_parameters *sp =
-			&server->smbd_conn->socket.parameters;
+		const struct smbdirect_socket_parameters *sp =
+			smbd_get_parameters(server->smbd_conn);
 
 		if (server->sign)
 			/*
@@ -555,8 +555,8 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	rsize = min_t(unsigned int, rsize, server->max_read);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
-		struct smbdirect_socket_parameters *sp =
-			&server->smbd_conn->socket.parameters;
+		const struct smbdirect_socket_parameters *sp =
+			smbd_get_parameters(server->smbd_conn);
 
 		if (server->sign)
 			/*
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 7a1ae4704ab0..be4e90755a6c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -13,6 +13,13 @@
 #include "cifsproto.h"
 #include "smb2proto.h"
 
+const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn)
+{
+	struct smbdirect_socket *sc = &conn->socket;
+
+	return &sc->parameters;
+}
+
 static struct smbdirect_recv_io *get_receive_buffer(
 		struct smbd_connection *info);
 static void put_receive_buffer(
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 455618e676f5..7773939db5f2 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -59,6 +59,8 @@ struct smbd_connection {
 struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
 
+const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn);
+
 /* Reconnect SMBDirect session */
 int smbd_reconnect(struct TCP_Server_Info *server);
 /* Destroy SMBDirect session */
-- 
2.43.0

