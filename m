Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA0929B239
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155749; cv=none; b=Yp0X3aN155/LSK46OQaa2JHASBuMONB+SLnc6PJT129nIDMzqH4fVXYVevZ2n23Wri4KrHh5Zyg0yC5vw5hpXHzV223IU6y7MdRvjbdoKUSnmu3V8pBtVOTaMgULbDNfUeLAqJHyVVYcBbZXySTJO4CiZGzXacMkuFrOzP2uhl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155749; c=relaxed/simple;
	bh=D6wXzkg4S+CyJG07DXkTwU0Zx2SpXc/qoN3lD4wcM+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1YGth6guHav8VLEiCzlGsiRuRysz6auEk/TDLQDhEELob7g++Uf+RZovcMzTBvU6De3mSssjElYUWS0yNMAPX6YxOFITPP42iIvsueczosv86iQ/NGR68e9dMrzqjVbMK8yp8k2jPqRLiV+BJRWL7pErz4aca1jfCATNBulRgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xhoHXX5C; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xhoHXX5C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=EHCJGSztatIzvewE30sb0Aqd1xrRp5FNsdWHZU/dZPA=; b=xhoHXX5C4o3q/fkPwkqX1mj8Up
	YZ1zzx8gBTS5FqAqHcITFvp7hur2n3R/nStjUl0aZFwd2y5Z/AC8u+jVCIPa7MmVpsEhKh9v8UYPL
	icGzz9Xf42duCbTJLEmnblLsOWg0MOpNz7B8KjttvKu+gbRj8pqCSbjVchVQ8IqgZmc/obMcmcfys
	blqV8S7hEkQfTfsE28zbRsQ2RO9CdwckHCT2GA4RPG4vDfLmW3zpcZ2AG6sd5KYRd1bbAsobIMRRJ
	1736SdZZ/ZYRGwSPYdwRAxt63NOmttVMPICCCoqAq2mdgIsEnj6epnA+cgkoT+ceWZz2S2oA4QTb3
	owX2yXwVzko2W98gDb+RiU7bhu89YmyyGdxTCA3a5okMzVOD/f6zw3LYzu4YFK/RDxA2yfs01HJPW
	RBt7jnGSVunw/0/uf4H5kndex3dFQ6FVonnTfnM4Vbjiw0Fg4aBTrdDe4T/hInGXNvRsI+uRE1kC0
	5uixUyrC0eqaPIQSFJiv3O0l;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeKf-000nLS-0e;
	Mon, 25 Aug 2025 21:02:25 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 124/142] smb: server: pass struct smbdirect_socket to smb_direct_post_recv()
Date: Mon, 25 Aug 2025 22:41:25 +0200
Message-ID: <72569a316bb1cbc21a80ff48accda6eb9f27a380.1756139607.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 2650c6c5e1af..21271c8a9573 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -620,10 +620,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	smb_direct_disconnect_rdma_connection(sc);
 }
 
-static int smb_direct_post_recv(struct smb_direct_transport *t,
+static int smb_direct_post_recv(struct smbdirect_socket *sc,
 				struct smbdirect_recv_io *recvmsg)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_recv_wr wr;
 	int ret;
@@ -780,8 +779,6 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
-	struct smb_direct_transport *t =
-		container_of(sc, struct smb_direct_transport, socket);
 	struct smbdirect_recv_io *recvmsg;
 	int credits = 0;
 	int ret;
@@ -794,7 +791,7 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 			recvmsg->first_segment = false;
 
-			ret = smb_direct_post_recv(t, recvmsg);
+			ret = smb_direct_post_recv(sc, recvmsg);
 			if (ret) {
 				pr_err("Can't post recv: %d\n", ret);
 				put_recvmsg(sc, recvmsg);
@@ -1722,7 +1719,7 @@ static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 	if (!recvmsg)
 		return -ENOMEM;
 
-	ret = smb_direct_post_recv(t, recvmsg);
+	ret = smb_direct_post_recv(sc, recvmsg);
 	if (ret) {
 		pr_err("Can't post recv: %d\n", ret);
 		goto out_err;
-- 
2.43.0

