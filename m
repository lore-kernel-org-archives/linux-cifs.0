Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A8E13792B
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636575; cv=pass; b=VWV+/xGWD5DDEEiLQJ8/iIqtvb8OkiTdt4kfKntrScBB3wkP5ZRepcQ0sWUi0oCcrHbRsTFTvqY0PnVYgXvtBxTUKuv9hg2qmCgTy1pS3i0XhOdYfT7d0PyLN0oB4Wt5J3CY8eBMweRfpDtEqEAj/QJT6BP8gHsh7RBRPDnjii0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636575; c=relaxed/simple;
	bh=EIpCt1Pif6m1MkOu0Pqy1nWpYGf6z8o/aN+CGRROdeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JApjrXIZFfqFbt7Yc3Cjo0fcxVuiN/Ch/EI+WNfq8iiz1MrUCDibT2oOOWNjMJ7Dxh43SAzyUMeK6PQsmLx/vvGZOLJVsalvVRYcxGjOE58nv0lAQIY+ETsZ4v5VoRln3puWwA5TkYuW0NfMPBo5x2vD2oTV6J7qv2mEt/1xvkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=DqqoE1Y/; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DqqoE1Y/"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X61xWO3F0fJnJ3tQgzZri7RuhJxa3stG+DtYLiZtyb0=;
	b=DqqoE1Y/3rz+f3e3sKb0gCrrPoj19p1ZIZlJP4Wnf6MY7G/0TpjvfXbNG5/JY/TU53Wae1
	ipcLwk1bcrYPOxb+STN7Wz5UPhUbV8RYyHFs/JL/U38iyAoPHx8l35F95g25eMEnIwdoc2
	7C4pO+ssWRGaEW735GDId6LciiIuLfjcx9mT/SScaFXy02uKrGC5lKb+PoqW/ARmLWG1du
	CcBW5ygDv/Na/y2UUBGn4B6Vg4i5kotwmzxQpxt3E0mKTlCrtXj8z77Vy+2G5vd7EG9qJ9
	G/UJ+iZDS00oqcs/HoDLVfk1xp9+VCg4Ddp6vDV60u/UqoE4wY0nNhxkhX3Jfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636572; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X61xWO3F0fJnJ3tQgzZri7RuhJxa3stG+DtYLiZtyb0=;
	b=AbodPH1Hzz7fbqDV/+U4wT6D0H1FtY5jFM/AECoFv+Z3fCzzBvM19bqjLJ+08mVC1D2AYl
	gvOhhWSv0OV/8Or8WYDFa0sHZFEXvq/T1mK1xES2mrNA3GjNvoYMCDcG9WQOCD6ZpI4tMG
	rTpoq3bhmOmWvepP6jAD7AISLKNe2jTKn+auRiO9jzHALmLgGMFbWBoE6PP8k1DHcomBoz
	tUYoDa5V4BmGQ5qflkk8a08BcvtYYFnzJYKcPbyYkcj7pK02HjiJ3ujOOY9k6wTVDdWMVY
	Xp2NntRTFOprtaYUQ2oEEtJsF3jKTGR3xyAoqXJ7N/vizl9nT8F3UpXE/O1S2Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636572; a=rsa-sha256;
	cv=none;
	b=kiJH/isp89yKZIoOVsye2MNXVcyhw6awQSXG/KV7drQG23vzy0q18cbNS9dl2l9YuTSHKW
	oX8h7LYLt0hvy8+czFb1cKe+UMJcLbMw1FRl58fWYgQpC17o47M6CuUfyH+Owqf5JZlHrg
	jb0KhXrgPtjv9wjqONpEqm6W8GAXSZUBgJeLn5GI77L5g1IjvfDbUo8NaKSewVNXVgggOm
	s7VQsrTixqKfswUFdVt+4tUj5dBVQ/bO9KNMv01vl4EBXzTUOT02Q12DL/8WT0uFI4EKPA
	c874Bs2sX+0s1funcBfHAaCDYp8XBufs9goBIipXLDwXf8liE6M8jnIlYOn9sA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/9] smb: client: stop flooding dmesg in smb2_calc_signature()
Date: Wed, 18 Sep 2024 02:15:37 -0300
Message-ID: <20240918051542.64349-4-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-1-pc@manguebit.com>
References: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When having several mounts that share same credential and the client
couldn't re-establish an SMB session due to an expired kerberos ticket
or rotated password, smb2_calc_signature() will end up flooding dmesg
when not finding SMB sessions to calculate signatures.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index e4636fca821d..c8bf0000f73b 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -242,7 +242,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 
 	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
 	if (unlikely(!ses)) {
-		cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
+		cifs_server_dbg(FYI, "%s: Could not find session\n", __func__);
 		return -ENOENT;
 	}
 
-- 
2.46.0

