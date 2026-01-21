Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5403EF0D1
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996225; cv=none; b=X4E4+sqgP+SNKM/d6qysKGaJGnPjbiy77bzHgQRs0oHtWZlq3Iue2FX8N9wNjPrdN7hdrrXqqIcAcEsCd8au4bK8xg2Dd8ZZWj3LoWGi8jZO/5Bz6eboZL1/q1Yz2cJMBR9VcoERhBcntiRgzmo3QsX+F6zw5y/G9M3SFs8Nayw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996225; c=relaxed/simple;
	bh=7dJDAiJpFIQ+B6U/f2Llr5ypcfGOXGQ9mRj5ynwp+3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4kTBXk//1pdI8/jEIwt4Bgi/di7SYmssRLFExo3JLFpqJ8w4uqVz7gCbm3VZKZpzGz88fODUsJrqR25WHXpjmqZG/blBGomtrh4isvMkcNhvBCnehpxIVfwZ+Uh0ow05KSQNaLNYE+EWiawtfz6UlLFWh36Shl2bfsw4QS7YAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DLWfHtmg; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DLWfHtmg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F5HSRlqaOdnjEOZ2Y7E4BfHKotaIfI55ltPNDE0oPqg=;
	b=DLWfHtmgPX94Ui5jFc70LNnSJX7DckHunNaIqBzcnp6wih5c7lb85g8P5UCprUQCCH1iuq
	3J5Bw2kGbb+zQODCkfDR0I81GNFkDObQHQ8FSfFUXIjrSx6RCbqMClWD5g6iLVeYGSb4uZ
	xkcP41/aPu5Lkr/3eTNz8rtBZGSaTug=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	hehuiwen@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 02/17] smb/client: add NT_STATUS_OS2_INVALID_LEVEL
Date: Wed, 21 Jan 2026 19:48:57 +0800
Message-ID: <20260121114912.2138032-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

See MS-CIFS 2.2.2.4 STATUS_OS2_INVALID_LEVEL.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 77f84767b7df..7f29fd5a482d 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -684,5 +684,6 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_NO_SUCH_JOB", NT_STATUS_NO_SUCH_JOB},
 	{"NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP",
 	 NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP},
+	{"NT_STATUS_OS2_INVALID_LEVEL", NT_STATUS_OS2_INVALID_LEVEL},
 	{NULL, 0}
 };
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 81f1a78cf41f..be74410da6d5 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -552,5 +552,6 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
+#define NT_STATUS_OS2_INVALID_LEVEL 0x007c0001
 
 #endif				/* _NTERR_H */
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 31b907362989..6347b2b856e5 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -669,7 +669,7 @@ static const struct {
 	ERRDOS, ERRnoaccess, 0xc0000290}, {
 	ERRDOS, ERRbadfunc, 0xc000029c}, {
 	ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
-	ERRDOS, ERRinvlevel, 0x007c0001}, {
+	ERRDOS, ERRinvlevel, NT_STATUS_OS2_INVALID_LEVEL}, {
 	0, 0, 0 }
 };
 
-- 
2.43.0

