Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2533275B03
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267441; cv=none; b=WKXP64Z+AMSuSupzx5v50hxvFJjfXayc8HpwENesHmOaBdrHxHWamnX00JMe+96y27wPo+XBTRGb5Bq6pdjNr6YO/Gqjago3v77B5KwnqI09qW1FfB9Be1xIbTDDfisXAVbAyg5fRJ+8befEiByjD2Ot1oFHqgPUE39mHkS4GEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267441; c=relaxed/simple;
	bh=3jRrWVkTcbo6DdjKUyzXcC0lqaeTegJFupqNdfAn2Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehtsIqk3TcHw9DuZ6jQs5/Ohg993LiRHnbSN5jB4fjVl43iJ7Lrhs0bDEJ93kiRAkyYJRGeUjzqkJNIfY5qkkr5cxfl09eIKSB2PrsPTjLdEj7agaxmCypW5rfAlnluaE1tZy+ERN7Umkd6dTKsQTLJpvlqEQykRtCBtBtEWoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o6Qyy1Mi; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o6Qyy1Mi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782267438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7CoAVzvGRXJvu2D4xPUGPjIhdzwv5vNMfz2bRkI6Mk=;
	b=o6Qyy1Mir7m7Tc75IBZhZ0tF9DIMORMZZeu3pSItRLdUwi/Yr76QcNBSRE8Rq+sBrz7jSE
	IcaOdr+a6mi5+U7uxw4NECguALKzr9n6/iyNHawoHY+UG0AFcvUxebmC/GsKUznUZEvmZa
	6cP8vHzCDclGgNJzy0NKebN2tpWFyNc=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 4/9] smb/client: handle smb2_set_sparse() failure in non-extending fallocate
Date: Wed, 24 Jun 2026 10:15:45 +0800
Message-ID: <20260624021550.1548952-5-huiwen.he@linux.dev>
In-Reply-To: <20260624021550.1548952-1-huiwen.he@linux.dev>
References: <20260624021550.1548952-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

A non-extending fallocate on a sparse file can return success while the
requested range still contains holes. This affects FALLOC_FL_ALLOCATE_RANGE
within EOF and FALLOC_FL_KEEP_SIZE when CIFS clears the sparse attribute.
Later writes into the range may still fail.

CIFS emulates these requests by clearing the sparse attribute for the
whole file. However, it ignores failure from smb2_set_sparse() and returns
success unconditionally.

Return the smb2_set_sparse() error. This prevents CIFS from reporting
successful preallocation when the server rejected FSCTL_SET_SPARSE.

Fixes: f16994797ea8 ("cifs: fix incorrect handling of smb2_set_sparse() return in smb3_simple_falloc")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index f68c0df1b66e..b8474ed9af16 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3770,8 +3770,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		}
 	}
 
-	smb2_set_sparse(xid, tcon, cfile, inode, false);
-	rc = 0;
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, false);
 
 out:
 	if (rc)
-- 
2.43.0

