Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D893A9634
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996238; cv=none; b=owGHhGXFFQBpHQec6Zrx5rCm6/QUP2UN6m7V1FrVMpz625eTqJYddefuAzqSzF9nL87So3xBIRbGUtows5rzTxRWtrMBSvA0gUBDXXBC1jGiWKbTwAoMRUIlTOT8AcuDkmRRtPhCLXHvkvjECWn7ZzKquG7phDJ6H6S/8KnwB3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996238; c=relaxed/simple;
	bh=EKfUwuqdiy+6324OLjE913VTClINBx4rVCP/ebU2CLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fb/r8IKC84OuRLrhWoJp/PEeZRT+hRYo0CWVJzG8zdQ/WgX8C5MIcXgxIk4AA/bE2Q/m6u1PsUMQk8/D0pR8WSJmb23VueIgoSihxj+nOhcxk5C85cApGFaCWj3/PNwtGOkr1wJC9s4O1J8Z9YfuVojIsdnNU7n2yqLTp7jKgZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VbQPbBHG; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VbQPbBHG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rWKn6uZ2LWtsCGt7eXcZEkG+L3gR/R0YwgIdaXcTiVo=;
	b=VbQPbBHGOUDRmGDv9WDsdGbV+0H1edUcehx0qOhMw6zCY+c+zQ9CZyagcnPIIoE5M6FXLb
	9iATb5g0lx/7tne7V1vP6K7zBCLLOHZUA5ytzl94gq0kWloWM47RKCWdQqRv9z3dJP7fAL
	M3qf93Szs7fmaW+Ge25/NqGQElaBJ+g=
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
Subject: [PATCH 06/17] smb/client: add NT_STATUS_VOLUME_DISMOUNTED
Date: Wed, 21 Jan 2026 19:49:01 +0800
Message-ID: <20260121114912.2138032-7-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_VOLUME_DISMOUNTED.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 1c5d7199f556..28b6320f2d21 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -679,6 +679,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_QUOTA_LIST_INCONSISTENT",
 	 NT_STATUS_QUOTA_LIST_INCONSISTENT},
 	{"NT_STATUS_FILE_IS_OFFLINE", NT_STATUS_FILE_IS_OFFLINE},
+	{"NT_STATUS_VOLUME_DISMOUNTED", NT_STATUS_VOLUME_DISMOUNTED},
 	{"NT_STATUS_NOT_A_REPARSE_POINT", NT_STATUS_NOT_A_REPARSE_POINT},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 1aa4bc394405..2056831ea631 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -550,6 +550,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_TOO_MANY_LINKS (0xC0000000 | 0x0265)
 #define NT_STATUS_QUOTA_LIST_INCONSISTENT (0xC0000000 | 0x0266)
 #define NT_STATUS_FILE_IS_OFFLINE (0xC0000000 | 0x0267)
+#define NT_STATUS_VOLUME_DISMOUNTED (0xC0000000 | 0x026e)
 #define NT_STATUS_NOT_A_REPARSE_POINT (0xC0000000 | 0x0275)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 3085e2084f99..164b721c7dda 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -658,7 +658,7 @@ static const struct {
 	ERRDOS, ErrTooManyLinks, NT_STATUS_TOO_MANY_LINKS}, {
 	ERRHRD, ERRgeneral, NT_STATUS_QUOTA_LIST_INCONSISTENT}, {
 	ERRHRD, ERRgeneral, NT_STATUS_FILE_IS_OFFLINE}, {
-	ERRDOS, 21, 0xc000026e}, {
+	ERRDOS, 21, NT_STATUS_VOLUME_DISMOUNTED}, {
 	ERRDOS, 161, 0xc0000281}, {
 	ERRDOS, ERRnoaccess, 0xc000028a}, {
 	ERRDOS, ERRnoaccess, 0xc000028b}, {
-- 
2.43.0

