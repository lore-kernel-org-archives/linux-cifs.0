Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9754B3A1E66
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 03:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766978201; cv=none; b=MpYhcQklyhOm6FWnUWk2sOC9FCyBURRUE7/rvDWtETrL63MPZdzb5t1bqd6hnWAWf1fV9+5usXDUIjuEuvz1J1fttpaCjMiKON8n/JLqA9aKR1dSTGBs2nLIiGeK74cXt//T3+HOTdDDXAVMLZ/lfhGfcAf2t9B6Xmmz5rR705s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766978201; c=relaxed/simple;
	bh=XZG1rMvy/pifYMA702duD6sJvIxfomlwPrngvSoa4r8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nGUnJSTCJnRWoIr/XyePebxz9CjFV8IE5nPmUrzkHxnMWZ5FZjuEJ6pfVzEAPrUnxZ6p/dqndxzAONYRirsHQrB8uml72VTO3gkt4TT6GHR9Z37XFcAA5TRTlilrkFyu0ni9KF22OgTzW588FNfjUnuYAPJJfkxXGObSeJijG1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e5A1FEwD; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e5A1FEwD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766978195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E0Ha8VPEWvNkXPtn0OvfIzT40DiwRwwsRk5YGRneN18=;
	b=e5A1FEwD/HUSzT4bgdEelss5ZaWc8U5DMvzvPGu9PzMpwgWOMoctQJr42wE3qRGTTvPWHh
	MSankjWMWrfgC5PCgfn0C1m+pE9FA2qMY3snDqmg9/fMgVf1pQkgApi+JDVNnd8S2iJtuZ
	lIOSaGVqp0tD+piu6PRpJiDoeqDtX0U=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/1] smb/server: fix some refcount leaks
Date: Mon, 29 Dec 2025 11:15:17 +0800
Message-ID: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1: https://lore.kernel.org/linux-cifs/20251229021330.1026506-1-chenxiaosong.chenxiaosong@linux.dev/
v1->v2:
  - Call ksmbd_put_durable_fd() immediately after ksmbd_vfs_getattr() has completed.

The following patches from v1 have already been merged into ksmbd.git ksmbd-for-next-next:
 - 0d762babd1db smb/server: fix refcount leak in parse_durable_handle_context()

My dear team member, ZhangGuoDong, has caught some refcount leak issues.

Other patches pending review (including those from others) can be found at the following link:
https://chenxiaosong.com/en/smb-patch.html

ZhangGuoDong (1):
  smb/server: fix refcount leak in smb2_open()

 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.43.0

