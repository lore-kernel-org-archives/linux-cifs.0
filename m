Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4B2143C61
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155208; cv=none; b=sqLCpyLCw2NBV+jaGrKY/++RsZmEAxFaM7JBPVO3d5B5V83ZDk/7JpJfp5GHwoOapsp17pyOBEa4CgvLyuhM7zyvXnNldKPK8v37qPDSKBvu6+c8phppKlkCvdAs3FBaHHBbEI5K0kAmmZVcLjl5rEg4IspkDCSXdRcHfEPBJTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155208; c=relaxed/simple;
	bh=mwgGc5/wceAPxptdTfrNauOQVrg8k817EvCDEc7jxO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xqn4UczrztZDCQzvlu/Pf2bDR1LuDFJlUKae0qPovd4z7rGhUhlMMh/fL+8U1klApDCKXpY7aBjrXTZBggHCLPKrd4kUiW07crapMx4chY8VldUz5r8Fbp5igCN0os+AXGLhnQW6DaFaxYSBWImeYwn9ZPFC1Umiu3KPtoAAOGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tuLyOb1P; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tuLyOb1P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Mus8rDhtUh6j0CSQUCRAhqKGMFi3SLIzv2BweDqk/Y4=; b=tuLyOb1P0wVEGHpkig0uCBmf3g
	hsVPDQE8S0sGaY2tgIN/9b0IiGQj5YHUJZq8y147LsC2W6bGIbsUFx6mD6ldj5HkLI+87VAMJCRop
	xaAedWWyG/4VtDYH7g7DqXf6encUnEGjT+1SpHh8mOY8z3m/ckrUoJxkoFKizywXUpAgqdSpAeKRj
	QvstxA2RfhaGgoTwV67DSKQ08dGrbE2TlliHedK2zSgsEp/ve9wXJfZs1zgX30H8Q8m+AHxMgFLiL
	ZXBiVrc3SCGVn/9SKXbBTk1zl/tF05UNf+E3/KTl2msRdoDjg7e+ojwg+3MLP4IyclsVj7vPbZUOA
	0SkhXT2oW1ifIj4/TyuQWWkqvz4HPR0qayW69hUHMINLYhLsSaDa9fgxzFSshG/nZrbfSxpzAZZo7
	23a8bJd29d3TjCWbSLyWRBdBJwMKrdYdocY/LFOUGKZZEMcRvQKJHevGTelkin4F5iwXanOAp9lOQ
	MLSLwT4+/DWjkR5BBLG6d6Kf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeBt-000lWb-25;
	Mon, 25 Aug 2025 20:53:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 069/142] smb: client: pass struct smbdirect_socket to smbd_qp_async_error_upcall()
Date: Mon, 25 Aug 2025 22:40:30 +0200
Message-ID: <6b2dbc6502b3a2804a5487043996341ecbde489d.1756139607.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 8ef4d8319833..660edf02afee 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -359,11 +359,10 @@ static int smbd_conn_upcall(
 static void
 smbd_qp_async_error_upcall(struct ib_event *event, void *context)
 {
-	struct smbd_connection *info = context;
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc = context;
 
-	log_rdma_event(ERR, "%s on device %s info %p\n",
-		ib_event_msg(event->event), event->device->name, info);
+	log_rdma_event(ERR, "%s on device %s socket %p\n",
+		ib_event_msg(event->event), event->device->name, sc);
 
 	switch (event->event) {
 	case IB_EVENT_CQ_ERR:
@@ -1715,7 +1714,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	sc->ib.send_cq =
-		ib_alloc_cq_any(sc->ib.dev, info,
+		ib_alloc_cq_any(sc->ib.dev, sc,
 				sp->send_credit_target, IB_POLL_SOFTIRQ);
 	if (IS_ERR(sc->ib.send_cq)) {
 		sc->ib.send_cq = NULL;
@@ -1723,7 +1722,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	sc->ib.recv_cq =
-		ib_alloc_cq_any(sc->ib.dev, info,
+		ib_alloc_cq_any(sc->ib.dev, sc,
 				sp->recv_credit_max, IB_POLL_SOFTIRQ);
 	if (IS_ERR(sc->ib.recv_cq)) {
 		sc->ib.recv_cq = NULL;
@@ -1732,7 +1731,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	memset(&qp_attr, 0, sizeof(qp_attr));
 	qp_attr.event_handler = smbd_qp_async_error_upcall;
-	qp_attr.qp_context = info;
+	qp_attr.qp_context = sc;
 	qp_attr.cap.max_send_wr = sp->send_credit_target;
 	qp_attr.cap.max_recv_wr = sp->recv_credit_max;
 	qp_attr.cap.max_send_sge = SMBDIRECT_SEND_IO_MAX_SGE;
-- 
2.43.0

