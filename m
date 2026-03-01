Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D2A1DF271;
	Sun,  1 Mar 2026 01:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329590; cv=none; b=bAEFTLtS/iDpygIK7rh2N54znuidBvtzP0pbwn6JNvod4n/1DdDCDFoOVvDptnLim7/dem2cLyf3ZtBVVAlywrvmz/tbsZTlU/LoG0aIPJ0mwdYjQZDrJI/jTvORz/UqoNrZ3pJ59D6Q8R45PMwupR0LiV2UoAlIvR7AaiRwmeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329590; c=relaxed/simple;
	bh=VKaTm4OSxeAy2B9v/snKREnkT7sUpb2RR9lyFfrM4g4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Apsn6YK6AUCMqGpKdnHiqmGEvYxwmfW4Qm1Fsg9i4hW6WDqRNwdC/e7R9eqNQXx8v9SaMyjsx4yN03WeQvQTy2STZu//o5yKFKUEGf26mTD/7K5R77uCMFa37jzXKvlRMdZ72Jrab4O7EJ9sb7RGlbVWb1cswNZa487kDMStOso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzHLle/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzHLle/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E400AC19424;
	Sun,  1 Mar 2026 01:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329589;
	bh=VKaTm4OSxeAy2B9v/snKREnkT7sUpb2RR9lyFfrM4g4=;
	h=From:To:Cc:Subject:Date:From;
	b=hzHLle/zyinVjQpMplrflUadnflQBdhBl9ePeayXpPfWcGXFyXyyl/BzItKUgQIbp
	 IoL8k+UX52Bkm/ipC9PRzExN58MmD6V1SDjAGuJMAxAgzfPqFID9UMZAcPhU/5MNtX
	 ZvV2Sk63MiSDCYcKZuEHO8I/GIz4ZNIGdr0v7/jRteyFLCl+CWi5hHNf8I38ImMHkw
	 7TE+eI8hBuzz/SZz/uqpPgl7c8M6ku9usIT03X8kusMEgpyrCQFL+vWXazvipnBhSW
	 dINekiV5lsau+xVtyau3j7nrlUxjAFTlH1sjYlnLYEf8Z/KtnkzFzsZkJtgonWhXiK
	 xbKwlL8C16iPw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: let send_done handle a completion without IB_SEND_SIGNALED" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:46:27 -0500
Message-ID: <20260301014627.1709443-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From cf74fcdc43b322b6188a0750b5ee79e38be6d078 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:17:00 +0100
Subject: [PATCH] smb: client: let send_done handle a completion without
 IB_SEND_SIGNALED

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
---
 fs/smb/client/smbdirect.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 88fefb901c27f..01d55bcc6d0f9 100644
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
2.51.0




