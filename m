Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EDB30DEBE
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426461; cv=none; b=IW9nEKsMKjG8Qbw0QeMDeAptiVt8LYsK23WxCVGuaz/Ooc7kVLLBF8TG/mI7d1wAN4hGxcQQbZGWMCo7biK/yj8hzFrXyW9DE+DR+m0a8WWv6p0uPGBDFu9RwicyCyNv/rAxF+c0c6rYN31JYR/sql4G9tPZHZSbfOD+PiXmLb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426461; c=relaxed/simple;
	bh=+Y1i4ZX5YAVz0aE+JKDU1tjQg9Po8/DgENzqiLN/5r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSaX0kE/y/IbCTInM5UYcrTX6LH1PYYsGu7zUqyvavJgt2B4iSy1L3RcjY/J6KjhbisMmga0VaM7iVbhRz6PLIBo1BhOIWhMhrw2r2MtKEr2/29P78VMgj+out+c4RJbuwO6K1m15bO4iRFz6597txbFs/nYmiLjt9avcK87654=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZPpfb8R6; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZPpfb8R6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760426457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSRewhMs0xcK2C1fYqR5qEmLPIT+QjryLkw7YlI2BEM=;
	b=ZPpfb8R67M7XWE7N3VCMDSoriLLB7AGUPHYdpOQx2wr/1NoJS5ct4YiwwgUwlTeXqMc9uq
	PPztDI077jhltjsdHGe8qleP6YMrfWt6qo3vfmY6HHhXdLCxeN+VY6QN+BZC9PEb5oewD0
	4yfXbOlAmeS2F+ee3rGTcA6gMzIZkq8=
From: chenxiaosong.chenxiaosong@linux.dev
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	christophe.jaillet@wanadoo.fr,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 01/22] smb/server: fix possible memory leak in smb2_read()
Date: Tue, 14 Oct 2025 15:18:56 +0800
Message-ID: <20251014071917.3004573-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Memory leak occurs when ksmbd_vfs_read() fails.
Fix this by adding the missing kvfree().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ab1d45fcebde..e81e615f322a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6824,6 +6824,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.43.0

