Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C6F72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046153; cv=none; b=a/p6HLSIOaaJVSP36ObuGMuY3LKPiqq77cLMx0+RmHmfj1JhYLjby2c0iCnOasi59iyMCBK/iqmnsxqvb6eLFl0GLPfoRpkFeew+Lw8LICvchjyg2X0bQFbbFUwe8DIFYh5s5fW5yPoLWTCCswdcodGlHe4vBQ05I5zqkRzzv2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046153; c=relaxed/simple;
	bh=KEpLKxAeu1lC7QfUBsiTDs47VaXtTwJed6e2Ew6HTyA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LaUXMHEY/Ht89JnBGuPvKkffE+QNP2MmF6KW92m4ybfYeILpwKCiYQv8bYsJYQs91FDMWwJNW1hTMRL3FFwJQv9WMCSEq5Zn6gEg+ROPyGtOqvycunY1IthdAQrUuLOsg9PaR8xskFv3z3zUkI6sNOIuBnKKXmqCzb6YEpSuB48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVMQpVw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVMQpVw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891FF1F00A3D;
	Sun, 21 Jun 2026 12:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046152;
	bh=RRHMR2c3ACyn0lvPkALTDAyogruk1TcBW+KIjUjBhhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVMQpVw8LzZj26itsVLNY8+Ywptuz0MGIjG3EDNMGm3H8OUFLcCEeILqJJUf1ulMA
	 FFlRaPxC/XJtemwuSfOdHGTQR1YLnFr/y6gfEowZ2C5Qq0PHdVE0/lDB1LFqvgIFg6
	 Ju9nsNZ60K2btZUTklJxQXWauR3ul1/fPA7AmEhfCq/uv2ct5tDtfjRCwe64rz+Wis
	 PLC1SBVYEqI44UX+razqHbnyWOA3geChI6hk+rp/HQvTfurxCLxG9e8eKNutw4ntCO
	 9Z1OvukjB6ZxVwJFGbJDRCrKX19zIoSw4Uf4bPocxH0oZh3bCiZlsKekS2zJxL9d/A
	 XDmVSiwx1FGXQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 11/29] ksmbd: preserve compound responses for chained errors
Date: Sun, 21 Jun 2026 21:48:26 +0900
Message-Id: <20260621124844.6235-11-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set_smb2_rsp_status() resets the response iov and compound offsets before
building an error response. That is fine for a single request, but it
corrupts a compound response when an error is detected after an earlier
compound element has already been completed.

smb2.compound.invalid4 sends a READ as the first compound element and a
bogus command as the second one. The READ response must remain in
the compound response with STATUS_END_OF_FILE, followed by the bogus
command response with STATUS_INVALID_PARAMETER. Resetting the response
state for the second command breaks the compound framing and the client
reports NT_STATUS_INVALID_NETWORK_RESPONSE.

When setting an error for a chained command, update and pin only
the current compound response slot instead of resetting the whole response.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d3bd198ec938..35f23b427bd1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -246,6 +246,13 @@ void set_smb2_rsp_status(struct ksmbd_work *work, __le32 err)
 {
 	struct smb2_hdr *rsp_hdr;
 
+	if (work->next_smb2_rcv_hdr_off) {
+		rsp_hdr = ksmbd_resp_buf_next(work);
+		rsp_hdr->Status = err;
+		smb2_set_err_rsp(work);
+		return;
+	}
+
 	rsp_hdr = smb_get_msg(work->response_buf);
 	rsp_hdr->Status = err;
 
-- 
2.25.1

