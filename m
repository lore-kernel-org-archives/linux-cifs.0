Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA033403FF;
	Sun,  6 Sep 2026 20:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788725122; cv=none; b=k3gDpKurwQeNiTDs1HoLqTpX5sedh3OmMzOlIPMXbWvnXy8U2ZgCL+yNUaZ2OJ2adoBt8B13wTj9Nq3GO8AxTzbHUmKBBhWtoE5OCG5vzX3YV28z0moWx4vORuC6RHw2sOrmIhAN3qc7OpLvtztZibWHXmLkmMcqALzmKfcQdVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788725122; c=relaxed/simple;
	bh=pAntnRlzm1/jYzt/fcLb9ZWxUyBar++AR1axQX5ATY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxjxSGhzweoIYXMvMcDLsgu1g8UQsePcvSwQ7bsZE7T9x0nYi+0t1x4pYlh+dLn98ARssKIqjPI+qsrEiBjVgPTuYMqwZp5CYYRyicHpTbRROXiZlRr+DzUxHFgcA0+CF1JRkRe8uiUQZ0+B00Vwdx3QjfqiWR+JdBijAvtCMC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=VGyLnfb5; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="VGyLnfb5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=dgblc8nInfyQ1An66Ln8iYKQLcoRc6Pze+b7Hf0q/PE=; b=VGyLnfb5/SSgAbeGJ8x4ZgZC5P
	yXst8MN8jbOfb78QpKbO8ARHLroIix+I9AOrce8rAzNRKvRbbp6FkWz01r40uJjSoZRn/6CUqc6dC
	jzha5jnPZCmPCd8W2NkjlwP0IqVbpIPoF/c9tyX45MM4YTgjgPmKvwNCJkkuPO1DoGtGLiTMfmN+b
	o8QaBTYvgXLEUI8DKZ9KEBt74og/DN4t+YGZq6XZXk8QIWOET5cNVu/UJdCDnexv95/zkQZ5C8xeX
	q6hdDt7yIjooGolmqPoeyp1CdvMtM4Pu9mft1CFJV3bd1IjDa0BN/7w/nghBd3oFBpIRyLov8qk5l
	UUBGqPhw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3J78-00000000oEQ-3TN4;
	Sun, 06 Sep 2026 17:05:18 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 5/7] smb: client: fix file type corruption in wsl_to_fattr()
Date: Sun,  6 Sep 2026 17:05:15 -0300
Message-ID: <20260906200517.725015-5-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906200517.725015-1-pc@manguebit.org>
References: <20260906200517.725015-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Clear S_IFMT before the switch statement.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 178da801e775..8a19dee564b8 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1145,6 +1145,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 
+	fattr->cf_mode &= ~S_IFMT;
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;
-- 
2.55.0

