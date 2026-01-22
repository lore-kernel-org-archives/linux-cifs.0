Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D775535D61C;
	Thu, 22 Jan 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102292; cv=none; b=MykF92+9ptDls56fcvh3FixwRxmdKDbtZdsDZZwp0lRfgmrl1gXEvbyarR74H8eOlWKA/09gpwGSmUw42eRGpwsQ6YHyWFnDhKaq7KUj+znt6bFGevCyIOlwU+E8/WGSLMurVZI5wW1QPfapgQjgg8/sXFzky9I4BkTxkI4ly6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102292; c=relaxed/simple;
	bh=gmjBqouVgAjoAW0cNpWPDmIehLwQZ78Jn2P6G6dkHmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJtSefHkkm1EGCP8cCbgBMCn3Zj7aujdTJyxYjMXaW0NpzDRJat0uH9s3BU2vQylGYovxO5OCDkyPaWwJ++UOEFwkxaj8ENIrD/QbmlwHpXSkToM/xUZsqvz0epifhK5369k4SbTXExRRLorQPSbjMyh5zUeUb7Z9GTKEqq4gGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=O/KAP8Da; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="O/KAP8Da"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=d08UIbiLZxlISyTqKx4cxuO+hj/eYNMSbUnKWLaqiCY=; b=O/KAP8DaO31h7pXleJqa8R/180
	kZ6SauP4cP2r3sQW7LviFNGWHvsV9pJ/L1YQezo3uwW9oxpxSZVJELjZLpkQfrGJ1D9xRsL7P3aJe
	mMH1NjsEFShc7V8Qq1SR0Xy4csKHbQvnasYT5C7EjLqa55++jfULHtcCkPCe8KGoXlKjy9Wun8Kxj
	RX3e5IcrQSD0xPzUE9UyjDjerEHlEsfU3ksjAbJyQV6/AirSlXfdVa8wntaFYYPnmoilGRQjAYGC0
	IaLQETF1ljDbLrTSPWdp4GmlpYLCzBajctGa4N9Wo88sCBFnuhupWjqtujitEgAj1AMp96X3chqKN
	Rd24vJfjh44BtVNkQ6r4DM1lK12EiHOQTng+k0G/YMnDMqRbT1YVq+Qdpb+QEP1hELQVrRnoge6vz
	e1KiVj445+dXwz7MPDWUZaDCECLTtfxEyiTx/SoA29tPNYMZI8T/c6HsAZrHMTC/KuUBYCGTBWmwg
	kjGVksxhbjfKNsOw895crBb3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyJZ-00000001pla-2UNW;
	Thu, 22 Jan 2026 17:17:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 07/20] smb: server: let send_done handle a completion without IB_SEND_SIGNALED
Date: Thu, 22 Jan 2026 18:16:47 +0100
Message-ID: <6f1ab798f3584ee2da3eaf34d4c8a744f8187b54.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With smbdirect_send_batch processing we likely have requests without
IB_SEND_SIGNALED, which will be destroyed in the final request
that has IB_SEND_SIGNALED set.

If the connection is broken all requests are signaled
even without explicit IB_SEND_SIGNALED.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_rdma.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 6c063c05a6ed..541e51a7c0ce 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1059,6 +1059,31 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		    ib_wc_status_msg(wc->status), wc->status,
 		    wc->opcode);
 
+	if (unlikely(!(sendmsg->wr.send_flags & IB_SEND_SIGNALED))) {
+		/*
+		 * This happens when smbdirect_send_io is a sibling
+		 * before the final message, it is signaled on
+		 * error anyway, so we need to skip
+		 * smbdirect_connection_free_send_io here,
+		 * otherwise is will destroy the memory
+		 * of the siblings too, which will cause
+		 * use after free problems for the others
+		 * triggered from ib_drain_qp().
+		 */
+		if (wc->status != IB_WC_SUCCESS)
+			goto skip_free;
+
+		/*
+		 * This should not happen!
+		 * But we better just close the
+		 * connection...
+		 */
+		pr_err("unexpected send completion wc->status=%s (%d) wc->opcode=%d\n",
+		       ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+		smb_direct_disconnect_rdma_connection(sc);
+		return;
+	}
+
 	/*
 	 * Free possible siblings and then the main send_io
 	 */
@@ -1072,6 +1097,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
+skip_free:
 		pr_err("Send error. status='%s (%d)', opcode=%d\n",
 		       ib_wc_status_msg(wc->status), wc->status,
 		       wc->opcode);
-- 
2.43.0

