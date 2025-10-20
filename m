Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149B202961
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 18:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760985410; cv=none; b=mx8iZib2QgZBmQY5GFecpQiR+IqtuPl85nweR3Z1S0m2wZDByVyka6QBzH+Z0qtp5R1rvGZCN4aley9PSWd/8pLhKGYso62K8+fCSaGbYUHa1ELBipXm1h5IF+gx6nbbA3p27NHMUWttXy3LYD3Axf97x8uTKWYvAhZD0izXCqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760985410; c=relaxed/simple;
	bh=YZ5p9xK0spTEANPveM4KnIy5ove4OQl3ynahwK/lOeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMFZmmEtoRvww1Z7VCLMWPOTsJhjrNvggRWpqA61o3qhUrHAKvjcNPv4ZubZlMp2xGyexf47eIjszE+V5cBcr+uyrNT6lDCluENCurqOmZfBAr1hiI77fuRdfLJN4ltC34J3KFTowPOQkArkIQD5aCMOOdkHEj1XKDbkMbaIofs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IbtZdUAG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IbtZdUAG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=bKT/jLXyefae+ZUWasm33iQv809olK9DwbEhtIFD0xM=; b=IbtZdUAGxAVnYwNdxyv/EC+mtd
	BgeF6i5HaTkVV8Zl2lz0Sv/rYewXf9vJLCWCNtHcGmN65+yZyo5q1hp8SLTLksQEal/cHgf4fc+oo
	uwsx4kJQxgU1EZwFW0g7yRommnZh/7uv9ywBgGw/SevgInvRBmLuOGSP1hJhKI+1lEpNm42qGWG0a
	23YcXgF0NURM4Q2956V1FlqWF1C+CJAID1yUO7vEnxoSumkuBgln8aEtQZelXRxGflStusCVcImch
	P8UBbo6KJBK9y692yTwpXZV/PxkwadbvnyYoHhKNjoULbftsaQA1tMRKe+n67SmoDiKn/TxmC8aCv
	KyYU57fpDwmDHhdTYb+dsB/nUjyjyj/z1f2vb725MThuNH5yjZbRhOo3fqGkdRUts+Ji1bCQQqmoN
	IGnZ/CpA0r7TjAha4NTcSiNd6zsI1zE85Ic0ulyjqOG4TcXBZeTf9ZTWXIe1+etn8DOKsQt43Nomc
	QiGrAWM9QToXm+LhBOMRRJdK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vAukO-00ACOx-0K;
	Mon, 20 Oct 2025 18:36:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 4/5] smb: server: make use of smbdirect_socket.send_io.lcredits.*
Date: Mon, 20 Oct 2025 20:36:01 +0200
Message-ID: <dfd0ee41de293120c45723e51feafaa021f33b64.1760984605.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760984605.git.metze@samba.org>
References: <cover.1760984605.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This introduces logic to prevent on overflow of
the send submission queue with ib_post_send() easier.

As we first get a local credit and then a remote credit
before we mark us as pending.

From reading the git history of the linux smbdirect
implementations in client and server) it was seen
that a peer granted more credits than we requested.
I guess that only happened because of bugs in our
implementation which was active as client and server.
I guess Windows won't do that.

So the local credits make sure we only use the amount
of credits we asked for.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 42 ++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index e7e2388c00c2..7d86553fcc7c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -219,6 +219,7 @@ static void smb_direct_disconnect_wake_up_all(struct smbdirect_socket *sc)
 	 * in order to notice the broken connection.
 	 */
 	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.lcredits.wait_queue);
 	wake_up_all(&sc->send_io.credits.wait_queue);
 	wake_up_all(&sc->send_io.pending.zero_wait_queue);
 	wake_up_all(&sc->recv_io.reassembly.wait_queue);
@@ -917,6 +918,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_send_io *sendmsg, *sibling, *next;
 	struct smbdirect_socket *sc;
+	int lcredits = 0;
 
 	sendmsg = container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
 	sc = sendmsg->socket;
@@ -931,9 +933,11 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	list_for_each_entry_safe(sibling, next, &sendmsg->sibling_list, sibling_list) {
 		list_del_init(&sibling->sibling_list);
 		smb_direct_free_sendmsg(sc, sibling);
+		lcredits += 1;
 	}
 	/* Note this frees wc->wr_cqe, but not wc */
 	smb_direct_free_sendmsg(sc, sendmsg);
+	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
 		pr_err("Send error. status='%s (%d)', opcode=%d\n",
@@ -943,6 +947,9 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
+	atomic_add(lcredits, &sc->send_io.lcredits.count);
+	wake_up(&sc->send_io.lcredits.wait_queue);
+
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
 		wake_up(&sc->send_io.pending.zero_wait_queue);
 }
@@ -1082,6 +1089,23 @@ static int wait_for_credits(struct smbdirect_socket *sc,
 	} while (true);
 }
 
+static int wait_for_send_lcredit(struct smbdirect_socket *sc,
+				 struct smbdirect_send_batch *send_ctx)
+{
+	if (send_ctx && (atomic_read(&sc->send_io.lcredits.count) <= 1)) {
+		int ret;
+
+		ret = smb_direct_flush_send_list(sc, send_ctx, false);
+		if (ret)
+			return ret;
+	}
+
+	return wait_for_credits(sc,
+				&sc->send_io.lcredits.wait_queue,
+				&sc->send_io.lcredits.count,
+				1);
+}
+
 static int wait_for_send_credits(struct smbdirect_socket *sc,
 				 struct smbdirect_send_batch *send_ctx)
 {
@@ -1269,9 +1293,13 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	int data_length;
 	struct scatterlist sg[SMBDIRECT_SEND_IO_MAX_SGE - 1];
 
+	ret = wait_for_send_lcredit(sc, send_ctx);
+	if (ret)
+		goto lcredit_failed;
+
 	ret = wait_for_send_credits(sc, send_ctx);
 	if (ret)
-		return ret;
+		goto credit_failed;
 
 	data_length = 0;
 	for (i = 0; i < niov; i++)
@@ -1279,10 +1307,8 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 
 	ret = smb_direct_create_header(sc, data_length, remaining_data_length,
 				       &msg);
-	if (ret) {
-		atomic_inc(&sc->send_io.credits.count);
-		return ret;
-	}
+	if (ret)
+		goto header_failed;
 
 	for (i = 0; i < niov; i++) {
 		struct ib_sge *sge;
@@ -1320,7 +1346,11 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	return 0;
 err:
 	smb_direct_free_sendmsg(sc, msg);
+header_failed:
 	atomic_inc(&sc->send_io.credits.count);
+credit_failed:
+	atomic_inc(&sc->send_io.lcredits.count);
+lcredit_failed:
 	return ret;
 }
 
@@ -1897,6 +1927,8 @@ static int smb_direct_init_params(struct smbdirect_socket *sc)
 		return -EINVAL;
 	}
 
+	atomic_set(&sc->send_io.lcredits.count, sp->send_credit_target);
+
 	maxpages = DIV_ROUND_UP(sp->max_read_write_size, PAGE_SIZE);
 	sc->rw_io.credits.max = rdma_rw_mr_factor(sc->ib.dev,
 						  sc->rdma.cm_id->port_num,
-- 
2.43.0

