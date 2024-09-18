Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C427132464
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636576; cv=pass; b=gLN8P0FGyIZOTE8z9G6gOpMUFxxMGkcPNfR5Fen3BQ9ht07v31fmm2hXmjZRvDgV7n9fNeUgTDh4WCBr6d+QV0gKX1LVrJDhJBp+sh3LP7baddiGFMQyt8ZHp+x+gLBKgKAnG/AneIFnVLYARF+qU7FUn6piJM7Jd6/R7TqF/KE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636576; c=relaxed/simple;
	bh=Xel/Am3ycYmMf6qo9lo2zzjp2O13yv9Cj6ztaQWK3uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i78DR+V5t+dnJ/vxgFYmgQTrI99M8LaLlOpSkDd18JMF3mJa9vEFTJ6y51SW7V0Uro6+paU3N9oZLnu+3CKhmukcgRZ/bTWbhRTAsfSstKId77JHtY7Kamnys63dLhuSdXy+nd5skvS4BbCM+XNaqhAbjko8cfAWmDUB+oLhTzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=jqtXewC2; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="jqtXewC2"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQMyVYG0NCUiUwE0eVuz27cx/Q34Ji3m9025KeLs0tQ=;
	b=jqtXewC2rGg89G2wNt0tUgBPOR8G8Y0+wn/RrDNF8FmndTmnQwE6XwUjc8picMf4QqWRq0
	NgoUpHXfiaL+X6bDPcWaXDQzwsaLpatX208I/m3ri5rKXbv4RqStqEi5TojymsV+q6tmoj
	BlL0aX1ugBPuM9IT7PLhdVqWL/LWJBVfT6UX9qHRpqgY+Sx8mqVBrzWw0Ud45Q8EiHq8ZD
	1hX/GpW2NhSj6w/fgprOmg4B2rpwUgqO/Kdapl6TVWDszXSraP12ai8Q716Kwi3UQerERS
	ZVYydWPdSteRdq2g+wjgaBRND1LEf3rYZ5Ui9ko7jaAUf7kY5s5/Kj3jVmt1qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636573; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQMyVYG0NCUiUwE0eVuz27cx/Q34Ji3m9025KeLs0tQ=;
	b=AbZAjzr/hJsZwDLWA0n9rlyb12bWf84t7s59PLuswui3M5hW+NCD6hLDRP1R6XFKcGREdv
	YkROkOKSjUdYdpF96OlUrMUQopBQNWBEqTPD+D0/4TPoKBJZnl7VAu65F5+iuG4YEKUGJh
	103c6Onb4x0cNJ7ZsLRuQgcCho/OrIfwkazE8EAvRxZ3iImy6MOklmR3bMNXu7JwGaFjcZ
	GovmlAOgCey2nEGM3j9NhmUz+G5WvKceQLWJciDqXJu8hnuph8so1ygVrzKRoG/ssrwBXa
	1ZvSepYHFbDytOuw+LOTAc5n6LU2XLS+70N0BxKFHATctliL1DFsZQveOsGd+w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636573; a=rsa-sha256;
	cv=none;
	b=r4cu7yyQcmU8AXQ3QXQJ8hBnZGQkaoZnuNl4tnUMyjyBWC7xVMIi9zzIycuby8Pq5I1W20
	3OCJRvpDc7QGInYZvJl2tkIzLRZwA/d79tZkJD+7NRq/ZM9jnd7/Y0gmhBJjcWCpFlr13Y
	1iI0y7FjKf2m3JOjp23jly7uvnYKfHvPiRc0hD8ZKwwfuiuffScj5zbVwBmzCVa5CvN220
	bxWztddVUxoWa0w1i2LaynFw7h3Hr+QPX4w7I06CRQ+7NhfdorZw5GnJWdhJy41dnXvR3y
	9g+V3JxVYhKcT3se6nHu2rWsiVAOBeW3G/9WU4QI6BtG0h9Tk3C33kHJlWhFxQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 5/9] smb: client: print failed session logoffs with FYI
Date: Wed, 18 Sep 2024 02:15:38 -0300
Message-ID: <20240918051542.64349-5-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-1-pc@manguebit.com>
References: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not flood dmesg with failed session logoffs as kerberos tickets
getting expired or passwords being rotated is a very common scenario.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 76f02739dda5..e1df9f093339 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2064,8 +2064,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 	if (do_logoff) {
 		xid = get_xid();
 		rc = server->ops->logoff(xid, ses);
-		if (rc)
-			cifs_server_dbg(VFS, "%s: Session Logoff failure rc=%d\n",
+		cifs_server_dbg(FYI, "%s: Session Logoff: rc=%d\n",
 				__func__, rc);
 		_free_xid(xid);
 	}
-- 
2.46.0

