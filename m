Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4F23EFD17
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996247; cv=none; b=cDHV2w9EyvZeZvtemoJakSFSFB71FYx9QA5qp9/bSbFobf9rrqoA4L59P/SxtgDs4fTrPrS+WG2TL+/Z3GSycsd9zaQlmDEmtl+j3St2Oy+2JQlMybq0LM7wdP0fJobdVt0xpcojxp+GNP+rajMw2bF7AZ7gsK/l6rbofIlV0tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996247; c=relaxed/simple;
	bh=tRTAtNTPa2xxHg6ejdYRWuNY7Saua5GouzeKyJMDpCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vp1w2bfpI6PcjKAUmPZrEB128rDhCtTva414e5D4SuuJi4T5mdQd/pkSPnyu4yvyST37zuPjFBudtpWOWpo6+rU+wDxZAF0a/c4P5MxX6tci/QKPLh5/xcXZnXBBmfhv2+S0efrqsLLiUSxMO8epNQkLxW4wSVBvooZ8bi/JALQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NJSHSZcD; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NJSHSZcD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QvIYiEhOApqpNRl7rtOSrvj5FJnL4fDgZAGs1JX3FnI=;
	b=NJSHSZcDXT3MGzYtlTJqp9i5FVcfdlV2L/6bkKGcBCWXlWEMvtE5o6U7DyzTTpjAdQ0CZH
	Pi5ZQ7X2Ic5+pni28Mmm7w07+CJ/tJlDwzQt9WA5jyfonoEU9SMyy6rxLIxJjN1Kb1RXgH
	hLVlzkGZbD4cLxc9NN1GKvowwG5Kv7g=
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
Subject: [PATCH 10/17] smb/client: add NT_STATUS_RANGE_NOT_FOUND
Date: Wed, 21 Jan 2026 19:49:05 +0800
Message-ID: <20260121114912.2138032-11-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_RANGE_NOT_FOUND.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index fc81174aef5f..bdc9f6f84df8 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -685,6 +685,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	 NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT},
 	{"NT_STATUS_ENCRYPTION_FAILED", NT_STATUS_ENCRYPTION_FAILED},
 	{"NT_STATUS_DECRYPTION_FAILED", NT_STATUS_DECRYPTION_FAILED},
+	{"NT_STATUS_RANGE_NOT_FOUND", NT_STATUS_RANGE_NOT_FOUND},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 8b7d108ed9e4..56bd494b480d 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -555,6 +555,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT (0xC0000000 | 0x0281)
 #define NT_STATUS_ENCRYPTION_FAILED (0xC0000000 | 0x028a)
 #define NT_STATUS_DECRYPTION_FAILED (0xC0000000 | 0x028b)
+#define NT_STATUS_RANGE_NOT_FOUND (0xC0000000 | 0x028c)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 32a57ac2c789..4506fe3fd203 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -662,7 +662,7 @@ static const struct {
 	ERRDOS, 161, NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_ENCRYPTION_FAILED}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_DECRYPTION_FAILED}, {
-	ERRHRD, ERRgeneral, 0xc000028c}, {
+	ERRHRD, ERRgeneral, NT_STATUS_RANGE_NOT_FOUND}, {
 	ERRDOS, ERRnoaccess, 0xc000028d}, {
 	ERRDOS, ERRnoaccess, 0xc000028e}, {
 	ERRDOS, ERRnoaccess, 0xc000028f}, {
-- 
2.43.0

