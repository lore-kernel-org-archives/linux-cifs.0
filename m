Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A300A3D16F1
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928966; cv=none; b=BPMpWifyYt7Vod615NOKqrrgQzMPyWDXdkIFDoqP40nX0+wTSaYzq8QQHhxoS9FI6Lmna9EzdRDDMery3Hvy9CkxSTWYFSSjK106kKvnc9tIddZrG6WTNBKwEOxz20rTXjTX/EoxNFG6z1O7lUZnQBkfmsfBCNXsRQ9sspzs5/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928966; c=relaxed/simple;
	bh=CG7u1fcRfMWimFv+3QTK0NPry+RtNtXTkCFmjyOQ3uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LOe3i/y058M1u0J00E7ZjRsoE4HqqfuIpBwff3u6tS5FO/I1eTF+jvrGHqy+YNn/dLwdoCY4hPT/aSbZRbpcWHHSbln5r4jO/VB0GHF6v3bTJWTQXiRB7zCTyuFbY0I3eFX7577PZT//zYOFyJNZ+hpogRbQQMTgCCFoh2GKye4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=j96YwCGH; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="j96YwCGH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780928959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yzyCyHWfBJX99aVEJzIaEA8icDK7KRH08RELhjIa52Y=;
	b=j96YwCGHc9cGX14Ll9YHdbAwCn2lO+ncvpCPKlASghOv2OZqspd1Cpi2JjNWQAYcmkjrRS
	JCYgy8V+v8Ne+o388iQ+HWcnGCx3HNG+kaDaQAfhM1nKHjjMstaQqw9F/RGLVYHiXpBj7L
	4QQnyFz7k6MoqFbWPRsH0dDKdnoIqmpl4kx+9cJQqsdTZHOzcd4o5RR1i878Q/CN2Yagyr
	VxzBtdFTY/+wZae+ZyQruGJOTJ2e4dcbockyreKnSIzab0gC12QNT7eYwt8WChLyAvMbmX
	VnW6rDbCMqP2Hs22mvBOp+hLvLpnjYXdqt7swzPU2zF391z+CEz5EgdOlozyQQ==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH samba v3 0/1] smbclient: cancel pending notify on SIGINT
Date: Mon,  8 Jun 2026 14:28:14 +0000
Message-ID: <20260608142815.388768-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I also created a merge request on GitLab: https://gitlab.com/samba-team/samba/-/merge_requests/4530

v2->v3: close file before `notify` exit 

v2: https://lore.kernel.org/linux-cifs/20260520153607.347960-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (1):
  smbclient: cancel pending notify on SIGINT

 source3/client/client.c | 64 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 7 deletions(-)

-- 
2.54.0

