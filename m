Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174BD32D0C3
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094221; cv=none; b=ZaHPRh98xbUVj7yF1+dHCTHO1RowA8cpGKnYLZv3tX11acUJhN/UXLYsvdnhs4tPHekF1s5PYR0SsotP3LFPPmaVoa+FBPo7u0pIcff2DhDn9Lnf3uXmnOc4HHppcnfiN67eMRhJw0kisGnj2bD5AX9icRwKIe3chDA3En+2pQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094221; c=relaxed/simple;
	bh=qaszI1xWft/1TpjBot66ZAGf71Ls4TbLt3HcUb0eCzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sU0RXoedrHtPD11VKztfuzcK2Ldd7RhKliKXWssRxqHKyfjcxNpczSy+V83iJBGp2hjQx9bMAlF7PuM/4S6amof9Q8tSvMziq2nOYfcrOCcNFFhvofkuesRzFkbanU/MyDBV6wN0Reb8xDv719hhivjioeHzfuJBNaGY+xklgOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=lZSXwKYa; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="lZSXwKYa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=MP5KVFJ+WAUDu8ay9oEpG62uSdtjgnSYuMNJWqRhG2I=; b=lZSXwKYaWf9ZyQa4aIiEl0sX/L
	vRGNQHd61M+v4omxLYUvlzVKWgf99gKAC0gV16QWirATJx/Bf/a1IluTNfmv22ck4TiNsqG69hNYq
	MJY3PwGTFO3DR9Bb1ZGDXCgR59pP9eHdsshRzVKQZ69f1Bz4wJjOb6kuHH2Xy6guGZKMEr8O3J/s+
	JLFs+V+mYhSUTFFZL3oTwDlXUotTOJhFgkTkYVkP6H/9LOIFBAbN+GVbOvxWS+KIYSxYdjQAg0erF
	OZj4GPWTCfi8ta9wYoFpVwdOs0P6AXnOkpx4qe83eZq9uvwC1bc2kFW6/rHYP4pmiUmfXr8xKsl1h
	etTHHfJDyGW8aIPT0H3JvnLhy7ubEmema5SfZyxRv2+OqdYUNe+Y05iRUypMuNKvEjZxCV0wXew4c
	ThxsEWvH4AKqGfzhfn01+lZ4QLPk06t5aXHFT+RuD2Qwk0fc396ygUUNLyayE+qmcrJ0aY5+BaLaw
	hdm2VhTnyW5z9vqUdGPEmchM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxRe-00Fdww-3A;
	Tue, 25 Nov 2025 18:07:19 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 084/145] smb: client: let smbd_post_send() make use of request->wr
Date: Tue, 25 Nov 2025 18:55:30 +0100
Message-ID: <2d427d59556804d80ef93fbbf71b2be80f6abbe4.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need a stack variable in addition.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 5f0d0271083b..5b234f44e1b1 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -787,7 +787,6 @@ static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
 {
-	struct ib_send_wr send_wr;
 	int rc, i;
 
 	for (i = 0; i < request->num_sge; i++) {
@@ -803,14 +802,14 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 
 	request->cqe.done = smbdirect_connection_send_io_done;
 
-	send_wr.next = NULL;
-	send_wr.wr_cqe = &request->cqe;
-	send_wr.sg_list = request->sge;
-	send_wr.num_sge = request->num_sge;
-	send_wr.opcode = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
+	request->wr.next = NULL;
+	request->wr.wr_cqe = &request->cqe;
+	request->wr.sg_list = request->sge;
+	request->wr.num_sge = request->num_sge;
+	request->wr.opcode = IB_WR_SEND;
+	request->wr.send_flags = IB_SEND_SIGNALED;
 
-	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
+	rc = ib_post_send(sc->ib.qp, &request->wr, NULL);
 	if (rc) {
 		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
 		smbdirect_socket_schedule_cleanup(sc, rc);
-- 
2.43.0

