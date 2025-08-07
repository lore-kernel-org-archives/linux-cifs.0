Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60771400C
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754583154; cv=none; b=HYu86xxrB/dEIvBi7GmkgLYZbeGiZXn6+7x2OUK1xpxUQ2FTqX6bRm9NrXWuA91qsWTgmzOf+8Uei76vjgJzZo2oIEJKS32qVf01/49VDNBSbU28BbdwckKXv5Dp+2r2Ds68wNTt0WKMzEtu3+DqG1YhakTvijD+L0q3BBFbK5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754583154; c=relaxed/simple;
	bh=6MVFXXHcOv3iaQdQwL6vTenWcdDB7MHA4rgNZUMY7Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+JxDvOw4usFGjBtcehQQ4gniNxUn8+yvJruOEOLX9zu12dA5LE0FzGrAoc/YLjxdzOH+jQc43EySjIiqjN2wvla6KYSDSyN8gZgeb6Dx0IcIwBsJyh0zKxJ7Z4xs2bbCX0uGSnAuJd2TrirLvKRSB/hsXFQHvZpGOFpM91iObA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nTpXKaWr; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nTpXKaWr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=gJI2Cp84cI2jqYL00jY1Ab/mYja74+2CSqYptQEJH7U=; b=nTpXKaWrOD9PtoLWdEv07t35Hn
	XGxlojdENJBhCPL/Lb/C73llmilrz9+YD63ih2n2DX3idTGmsxFz1KZELZuxAIDDk6o9+ODzpCRmH
	YvdqTEb5RykCF6MsZ4Agmkklhky7j/vP5ZsZYgRxLvsO/vgvPwxSlSmJ5hcEkShG5P8p0lNNCDa0x
	QyCI3UOy6jiLW9kkuAc/XDjWVJny2WP3mCE0D1tr742EVdg371yOxvy4w7CrpDu2yyQVjXK8uyiOf
	lP6UV+IR8RokrIx1v9cy12+bwmtPc4eDt1NF43twRkxREP5Dsp5kyqmlJWHz11lMG8WVV7UkMoK0X
	LljNIZEh2Kktpch4DehYxsBMMWbiUsmSvTdkrdMemeupZy0ntCcReZSv08gF65V8fJyazoR+jU2G8
	1kbcZUmccB+YnXPiQcmNhjoSvgnzsNXa/OdVEg2QKw80+bzVPig0vTXeUMVlBJVhC7e3spOLtvsNP
	BIB6Lf3nBKExr2dFoiLantzy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk3EE-001cZ4-1J;
	Thu, 07 Aug 2025 16:12:30 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 1/9] smb: client: return an error if rdma_connect does not return within 5 seconds
Date: Thu,  7 Aug 2025 18:12:11 +0200
Message-ID: <7df130cd3be4e4f360980d45fd6335e3c92d16e2.1754582143.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754582143.git.metze@samba.org>
References: <cover.1754582143.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This matches the timeout for tcp connections.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 6c2af00be44c..181349eda7a3 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1653,8 +1653,10 @@ static struct smbd_connection *_smbd_get_connection(
 		goto rdma_connect_failed;
 	}
 
-	wait_event_interruptible(
-		info->conn_wait, sc->status != SMBDIRECT_SOCKET_CONNECTING);
+	wait_event_interruptible_timeout(
+		info->conn_wait,
+		sc->status != SMBDIRECT_SOCKET_CONNECTING,
+		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
 		log_rdma_event(ERR, "rdma_connect failed port=%d\n", port);
-- 
2.43.0

