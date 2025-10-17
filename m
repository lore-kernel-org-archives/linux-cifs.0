Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC532D6E66
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 08:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690873; cv=none; b=i7Bk6xq8q8pR9jIwpzolxByCxaNUWZgAetSWJLbGP1Sjqa9BbWcMgkQTYy6at9SAJxG+r8IC1vLJ4jXUWV/S1DzyLigJe/uh00vgx7CHQE2vvDmTZ4nvwNl+aC5V/xOVhcl3AtSvrOAfYrHI1XlaFcxfUTfhURnMO3Xa7ZHatTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690873; c=relaxed/simple;
	bh=4eRYz3mKnTAvBwpEGpRVJVevMc1IYOTT5tGNt+ozL2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbK3HFCDKpcYWgLhK8GHoLY+lyKq77/Ndr1oKDAhWCJWvPt0p7o8oupqoesZDQfhN6GZXjeak8qpHklMlDPrRyby9Re16s/r2ob2q6DcFjHCArgB5TvzICuKlvyEcm/ngTLjGba3EONgY7MJxjMFz91uCaiYPzyyKMK++RVeDOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ciiXhzl8; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ciiXhzl8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760690869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IeylPqYoeDoBboS7TSWJZkfOUBBzD89xIxyEDj64vKo=;
	b=ciiXhzl8/hVBYpjZ7Tw/6Y0ZyGUNIWioc/8pPHnSl9dQIiHt3GgTlMbslqpXH57ZTY7GhO
	3UxMBYi2frBSCpW0Y+hhmVeMDi5ZqxRwpnPJjt+ln8Cp4qxyV1Y1a47Arkz5OAcpKNVzMW
	6JzrbPq/OXYivqdiXnL9HN9BFaLSnBw=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 5/6] smb/server: fix return value of smb2_oplock_break()
Date: Fri, 17 Oct 2025 16:46:09 +0800
Message-ID: <20251017084610.3085644-6-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

smb2_oplock_break() should return error code when an error occurs,
__process_request() will print the error messages.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 488915a8639b..0fb517838325 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8758,7 +8758,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
  * smb2_oplock_break() - dispatcher for smb2.0 and 2.1 oplock/lease break
  * @work:	smb work containing oplock/lease break command buffer
  *
- * Return:	0
+ * Return:	0 on success, otherwise error
  */
 int smb2_oplock_break(struct ksmbd_work *work)
 {
@@ -8781,6 +8781,7 @@ int smb2_oplock_break(struct ksmbd_work *work)
 			    le16_to_cpu(req->StructureSize));
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		smb2_set_err_rsp(work);
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.43.0

