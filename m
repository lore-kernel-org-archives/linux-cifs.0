Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783349;
	b=clEMH/+VYmMiRiMD1suJjmX26cdfhQh7eieOPgo5bQXnf5BBjmxGdTMHI+OdLk/7laqE
	 PGmfsxIdylfEXqex/nI3LuM2txNqH5JvROJcdvoiWSrO9Nr1aVxj9jQEGuFCFShBtaA8M
	 aRg7U0kZoerbzMjnTfaXY04HHA/EVSUaiIyKUb3Hrj85zph7xSsQ4IuAXEC9GEQCnQC9B
	 sYRBmJyE+rwSymFQUKk++AiBCy/cWNBscMqiZyANMu2BNZa6iDf8qTaf7B3Wc3MH+x6Lq
	 Nmn2toNArDUMqXNWPF5haVtoZ9kZ9pkNZ31WtUCDopH4pOg5US/EKLzROp4fuokT8YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783349;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DllCm78UR4smLJtSXvYoufx+xvOVjnPpTOX3LsucdeQ=;
	b=T1wXeLu2uhYg89HkJJ8XE2es35x3cWToaPjhB7SEDFglVVQE1w2fKt3g4kLDUR98a+zr
	 s4/dIdat6b9UMroehnnEvMsGRK3TyIwMpyodKNLVo6AINcsibCmohSOAWQCJ3VBh/YtgX
	 Jse7NHvUCRQMK48xG10KAsxknP6lS19X3wBuDy9zWl523fpUsuWaBp7+IScj7GJSnuJrG
	 +SrQvgmpwk2G5d0kMVWJKnFY05TAusSkanxf80tBK2Zyp8z4AvFx9TBzMFhx1w6zBcEjB
	 zMXFphs7N+d2FCe9rGUtTJi3QDh6cxuaahOofj/weEJBFPBIwjqbhqgPPsFNSDtZkiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=TZyP4NTb;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94580606A31F;
	Fri, 27 Nov 2026 12:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94580606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=TZyP4NTb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=DllCm78UR4smLJtSXvYoufx+xvOVjnPpTOX3LsucdeQ=; b=TZyP4NTbyEHfOMjr0GQDd4Y9r6
	CRBKcd6EKEjlaWAi7Tku4aiUrMJokb81mTrm8eutX69SoRnOzfLZkb6TVR70EB//n1oA/p+P1LTqe
	Qp+f0Bo343ZsEshogwMEdNK4iTxTkERi72b4KFS0xY2EsjgEDCeFccdSBCe+NcckPpnUOMmGp9xCs
	H/LdRffyKuotQX/kQrKlF8qfqt+k11g0tbIInLymrfK9EJZThZHP+8Ye/cdExDbTOxzc69mmzXXE7
	3dN6SJvGETDeohqhZAZI4oLEvYrXFlTUJaBoEHqd0kK8VyUAXDCqp2COoO2of/yGuezokc0aiLCJd
	lvqY+BwpWMG5mhqN7ZKFnFN2yE0/LJ62pPtDEp0RQqHnXXk3XEEyHsLk9vzYqduuiTHaZNHL4b57g
	dGY14aCuG6TY2qBZ4K7s2/iAL97NE3AYRS//u1t4Sw9EvW+5olLR0p6Q5ie+WC2w9dzXPPsUrN9Nz
	pu8MQZ/QEbdQb7/n909OqjYr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvHV-00000001MAX-0hGW;
	Fri, 27 Nov 2026 12:42:25 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 5/8] smb: client: pass server to smbd_register_mr()
Date: Fri, 27 Nov 2026 13:41:38 +0100
Message-ID: <0f69fd9fcc0298f380b7fd6bbe35939a459ba3c1.1795782695.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795782695.git.metze@samba.org>
References: <cover.1795782695.git.metze@samba.org>
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

This is a mechanical change of the prototype of smbd_register_mr()
to take a struct TCP_Server_Info *server instead of a
struct smbd_connection *, deriving server->smbd_conn inside the
function, with no change in behaviour. A following change uses this to
take a reference on server->smbd_conn's socket under server->srv_lock.

Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smb2pdu.c   | 4 ++--
 fs/smb/client/smbdirect.c | 3 ++-
 fs/smb/client/smbdirect.h | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7b7d25364e20..d56e84770615 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4721,7 +4721,7 @@ int smb2_new_read_req(void **buf, unsigned int *total_len,
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
-		rdata->mr = smbd_register_mr(server->smbd_conn, &rdata->subreq.io_iter,
+		rdata->mr = smbd_register_mr(server, &rdata->subreq.io_iter,
 					     true, need_invalidate);
 		if (!rdata->mr) {
 			rc = -EAGAIN;
@@ -5362,7 +5362,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
-		wdata->mr = smbd_register_mr(server->smbd_conn, &wdata->subreq.io_iter,
+		wdata->mr = smbd_register_mr(server, &wdata->subreq.io_iter,
 					     false, need_invalidate);
 		if (!wdata->mr) {
 			rc = -EAGAIN;
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b00224a1d411..9fe92db606ad 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -545,10 +545,11 @@ int smbd_send(struct TCP_Server_Info *server,
  * need_invalidate: true if this MR needs to be locally invalidated after I/O
  * return value: the MR registered, NULL if failed.
  */
-struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
+struct smbdirect_mr_io *smbd_register_mr(struct TCP_Server_Info *server,
 				 struct iov_iter *iter,
 				 bool writing, bool need_invalidate)
 {
+	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc = info->socket;
 
 	if (!smbdirect_connection_is_connected(sc))
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 81fd6b849ade..7d99797de6fa 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -47,7 +47,7 @@ int smbd_send(struct TCP_Server_Info *server,
 
 /* Interfaces to register and deregister MR for RDMA read/write */
 struct smbdirect_mr_io *smbd_register_mr(
-	struct smbd_connection *info, struct iov_iter *iter,
+	struct TCP_Server_Info *server, struct iov_iter *iter,
 	bool writing, bool need_invalidate);
 void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 				    struct smbdirect_buffer_descriptor_v1 *v1);
-- 
2.43.0

