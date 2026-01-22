Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED7B2DECC5;
	Thu, 22 Jan 2026 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102363; cv=none; b=V4S30QA4sYB5Uy3yb7ae8zGy5+fHU76a8RU/QYENAVev5NfxLrdU3TM5CDiU8+lT/uKBZAW7zQTIyr8u1OkNyMKiT7LJPIrbvLaaEKMvFzlQc4lk2czLQM/qbuYfdg08INPNFgL57va9Etrtzj+pdowBrM0dYcyPdOAQzuUMIxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102363; c=relaxed/simple;
	bh=/rRFCH+ykYIjJQDEkEYpbFwT2vGPMunJB8qyBq0geC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1kyH448yJRFLk9dFG/iSTf+grhJ1bMN0NNIrRc4WMdP10PUEpyGR6bPPLmdSRBV9qbaNqDLMv1m9be1DS5DyESO7AVvXzKrjskpEaYuoyIYwsqlohumFJjRYT+0jY9Cj7q6yHQ8rugUd1oBi3IMKfM28Q+NmwjxQ4BkBIQyLvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=SLPQwO37; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="SLPQwO37"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=rukEouGRX99p96faBHev5UqIrepG8fvM58ceQz7LAVA=; b=SLPQwO37qNsSf0iSROgaUOXEIU
	Qunp+M93of8lV+iVZjoY0OkQAayEWFipWJKu6C8aL8lYrFFYtWsx6HnwtsVOJGpeQdrTu6xoDS7+e
	QVd+RNdvGwltzzBPndfKymVQk5ieCpM0HBhTicP1SQQDiCVMSbMjjvCOf0F0yCzOEWYtOIyEpu+79
	fOYOStcCQeHpWMVy5j4UC04HKvB5pBbf8QGXHOZ0xZ6V7mTnkuqexUYc55Eu6Omqe5TQkDQSmsWng
	ReRpMuo98pTPajKMO4YrlidOxDlApwyytj5ZagVdmqbRgdh38R6L2gm7uixnvFwyWefejG4LDXfcl
	t/8WV/LFV2Vw9h+l4NRQUVzOtRA/YJ+ytgTGUjtByDjw0qCQOEX/Yb21t+r7h7LHY/9Yf01os9QVh
	7brCG4zTNLwRIqIQ+3ZPfGYvwETFF+Lw3EBftRztdbVIi4br4wgeB9LdoBowbyCOrBLfSrz6FV6ym
	hEXwIge/8GHxxNDdfvPSzfpN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyKm-00000001q03-3ZRS;
	Thu, 22 Jan 2026 17:19:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 20/20] smb: client: let send_done handle a completion without IB_SEND_SIGNALED
Date: Thu, 22 Jan 2026 18:17:00 +0100
Message-ID: <9509720326ae8844b59032630ae8a5c90baffdc3.1769101771.git.metze@samba.org>
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
index 88fefb901c27..01d55bcc6d0f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -554,6 +554,32 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
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
@@ -567,6 +593,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
+skip_free:
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
 				ib_wc_status_msg(wc->status), wc->opcode);
-- 
2.43.0

