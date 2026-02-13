Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5031554723;
	Fri, 13 Feb 2026 13:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990731; cv=none; b=LiAJtvNSpq4mq/bTIzPHz3icTkUT3f6LC0gy7rEAi3Kc8osWP9KbDDbI9w4G153R8xDjJBjx2EHCyhuQQMSgfxEgVOYAkxK3mY/hmyl+Sue5Ez4d98m5c4J3BV1jvvc+BKgSz8YdGD2/qzzrTYoR9wFOwJD1s0lcj2Qk1HWXYiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990731; c=relaxed/simple;
	bh=thiNL7EhKyCijG77xTI9sCL7dc6xI3UGW43eo/v4Zfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNzjXaE9hYldmpRSC6N4vaHsRWvzAVPbrjHgSAYms7z7/jQwJdEgbTGjQMgD2Xf5eR5KPSNPq3WYy8FnZQe267SOwRyuognHg3OfJ0M01iZ5P7qY/Cqw1sF/iBxpLonivKjBMsePO3y79g+sn+3qsuH5tCSGtxWU1oShZmy68OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twwiFxAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twwiFxAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EEEC116C6;
	Fri, 13 Feb 2026 13:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990730;
	bh=thiNL7EhKyCijG77xTI9sCL7dc6xI3UGW43eo/v4Zfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twwiFxAkUg/EalZ+AeqodYHpaQjlJRCURPziStcLUjIjIlFRAb+pZsOJY96thD2QN
	 yTZAlOV5OZWo03Q5duvQIs1d0b6gACnCud/+T07ElJj9JUjoLf1z+seRzosb/qzYCH
	 uZYgHjnD/j348bLqKILgfRvU97R7pBxNcKICEE6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 26/49] smb: client: let send_done handle a completion without IB_SEND_SIGNALED
Date: Fri, 13 Feb 2026 14:47:45 +0100
Message-ID: <20260213134709.690884092@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit cf74fcdc43b322b6188a0750b5ee79e38be6d078 upstream.

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -554,6 +554,32 @@ static void send_done(struct ib_cq *cq,
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
@@ -567,6 +593,7 @@ static void send_done(struct ib_cq *cq,
 	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
+skip_free:
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
 				ib_wc_status_msg(wc->status), wc->opcode);


