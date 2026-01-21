Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8400635CB9D
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025162; cv=none; b=fV4D339Yz2vWUsWc8DXSNSgtD6EPK7xSaSMo77gj6AKOh44U8vNR0pVWsRANMGq7Kwvf4jOrYwnYc2mqptE4owx13ZG8Q8wELSsd3KIyUp9hicNWDRluATgDUpwqRdejfunIkjeQkZXLR8UWiEMtujLiKaQmoxo+pIc0AqNEGhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025162; c=relaxed/simple;
	bh=pR0zIWgYVg99s8q/+PWc+SZQISR0k2IDCzVEtKOlCdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hquhVcqWAf6BIyOPDvVGq8sW3pIri8ex8dyAMEiPmKubM6FdbsczmL37n7/NtHlKKiyEG/M4arZpCgAtOhJQKjFpw1ReNIG0fzg6sYQIaxtKv/zbXBUZ1eILOp4UAbYX3Km4PofN5jB2o7DuC8Zrbad4E95DwM0zeNeoYR6COsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OKrZ8p2k; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OKrZ8p2k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Djlg/+QF4JNHTLhzWkssdxxT2kVE3IUOW6ii5TweZp4=; b=OKrZ8p2k35On47PWnA9O9b7LhL
	MXBK2Tgeba2bklP9obkjNalrkxH3RbUAGn95a/QwL5BejT5vjpHlPdOWBkblXDROmdCaPIv6eb5PB
	B+1BSAdENa3MTmK4SotI4uySvs3445iY6ex295ntyH2fx/Gq9AJrvPILeTcYXpTNiSJ7mLvCXl/Kr
	JOiqj0SPH0kFzfONI9CtPpU8Rb/t3xdzPU8MOhyW4IPq/D4p1wTzxoqCZYAi+gYkS/lNpBTnL94Sv
	FVQdpL86AFh4UzBad9gekKDnn3s2crDXkjiqh4mf7IOxds9KjwbIN0cn+9OisQNP37fTXwwJr0uXu
	l9yWgmAshNsnSDo90WxEJ5fan1RjN98OE6opj7AepHkhsmFme8sHOix61Q/DyxrtKjpXh6JLFko8C
	UWvyTtsxF0v37vGfNrDCZQFbmyxa2pnDtJ92AtXBNW34boOz7I2Y0acRv06kiH9J3nRAUnl3gzwxj
	WWUD2H7td1iRZZ3HFk558BZf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieFp-00000001eDe-17Nl;
	Wed, 21 Jan 2026 19:52:37 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 19/19] smb: client: let send_done handle a completion without IB_SEND_SIGNALED
Date: Wed, 21 Jan 2026 20:50:29 +0100
Message-ID: <06cb009563965f00d8a5e422c90971694c45b582.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769024269.git.metze@samba.org>
References: <cover.1769024269.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index f179e0addb6c..2900b02f90cd 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -550,6 +550,32 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
 		request, ib_wc_status_msg(wc->status));
 
+	if (unlikely(!(request->wr.send_flags & IB_SEND_SIGNALED))) {
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
+		log_rdma_send(ERR,
+			"unexpected send completion wc->status=%s (%d) wc->opcode=%d\n",
+			ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+		smbd_disconnect_rdma_connection(sc);
+		return;
+	}
+
 	/*
 	 * Free possible siblings and then the main send_io
 	 */
@@ -563,6 +589,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
+skip_free:
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
 				ib_wc_status_msg(wc->status), wc->opcode);
-- 
2.43.0

