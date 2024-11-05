Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5001D9350
	for <linux-cifs@vger.kernel.org>; Tue,  5 Nov 2024 14:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730816976; cv=none; b=LBLjklJeEMSvZWsYws5tLFqAYHbOq7MMs7qSFNEoQ58YMd+EnnGm9Aq7IRxOx2OrfzPtQTPc6kYnl4K4xUwH3Xsx7xlCZ27BR7QKmmGtZPOOkdkObxmasNyOIIU5WmHLYyN6nVQpNp/CIJ9qLj0ulmSr/LS7V+BobGw3T2O9P8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730816976; c=relaxed/simple;
	bh=6Q21XBG/rkegRl0phZ335sIvAzzjFtK5j2o7saAseuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eawQO3/01O7FKYd4/bH4SUU343NVGYKARNEHEeMainqKhzn3wyWr6OOsYxZ+KfEtMOHuDlhEqmFNZTO/X5OLx4hs/goyMMFOUThUhv9k0TXtaY1iQ1xwGjVp8Ky1qnwlnzMoZ8dSx7rnJbZdz2Rb1/vdaxFqm2e+u2TFbAbouxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lx62HE2m; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lx62HE2m"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730816966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fTHpML+cXhXVk5sDOgFNdpjjjYAsXUVhALDoRO9IXDc=;
	b=lx62HE2mIT5yV6IjaQigoSAjcRMR3L4gQMevde6wgRw+knv/1FwvnqZhSIfSKUMNAyIyod
	rwORfNrTNolw89HDLGERgV6XsG+LpIwPpzRhIfMIx6jtCGNfhECQgJL2VEuRHWfglYvaE9
	X/zpGXtHXyTnogVBO0TnZKLyHLRsyU8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] cifs: Use str_yes_no() helper in cifs_ses_add_channel()
Date: Tue,  5 Nov 2024 15:29:09 +0100
Message-ID: <20241105142909.12604-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_yes_no() helper function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/client/sess.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index c88e9657f47a..3cd157c2c0a5 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -491,11 +491,11 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 
 	if (iface->sockaddr.ss_family == AF_INET)
 		cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ip:%pI4)\n",
-			 ses, iface->speed, iface->rdma_capable ? "yes" : "no",
+			 ses, iface->speed, str_yes_no(iface->rdma_capable),
 			 &ipv4->sin_addr);
 	else
 		cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ip:%pI6)\n",
-			 ses, iface->speed, iface->rdma_capable ? "yes" : "no",
+			 ses, iface->speed, str_yes_no(iface->rdma_capable),
 			 &ipv6->sin6_addr);
 
 	/*
-- 
2.47.0

