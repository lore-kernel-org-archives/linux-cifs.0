Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED40F410D36
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996252; cv=none; b=RAqGV8L3YBJ8VcPu6tfSbGLQkyo0eMxlwZHytRF1xUnE7ajNDiHDRrVmfKLdvtG/TPggf4+a1AXrFEXKEnYYzeCE1pKfrIeCyT1TprT/iTbF+W/LMKFXnBSCuNCaUd+2aowU425TVvwPlg8zRUMF2wYnZvDTCCgXzAGZQ6io+Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996252; c=relaxed/simple;
	bh=SMT5exPcWIw6XakWRjWrQ8nTHYKG7oqf+7qdwbkwMJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JppkdeVTR5j53hdlnNcUSnhnaEcZL65Frsk5U9uyjM/KQPM18JPJXZ6En/VsjQPOzz1YejUHYPBIoILHYClYSZbTC5FxJH2g9dlNg9ZAXgERylVaZlftxTXot+yIaMZyGVXa2tkhcHEVtspAcNJRzGEs3E20AH64D6H7/RJxgoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GJlWc7Ff; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GJlWc7Ff"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0D1huLIIycw0gOcQS2n/8IQV7VjuuMhdafLHVpCEjIg=;
	b=GJlWc7FfxsA/vdJ/JWcbXpbDu9H0SbV8sdVcnyIDzgiFdeF0fGkA+VXWVizlFDDCmNKH1A
	AQgbLIpmlJjS09Wzt7HjsB3zGO/D6kK7M4CZBpCbm538fTrMhHHZ9JbnrCrQCjxJjpV78y
	BlaL+yE0Nvr2xh7RXmNxKIPNyaA++yA=
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
Subject: [PATCH 12/17] smb/client: add NT_STATUS_NO_EFS
Date: Wed, 21 Jan 2026 19:49:07 +0800
Message-ID: <20260121114912.2138032-13-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_NO_EFS.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 5e3efc3805a1..5d649222a3be 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -687,6 +687,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_DECRYPTION_FAILED", NT_STATUS_DECRYPTION_FAILED},
 	{"NT_STATUS_RANGE_NOT_FOUND", NT_STATUS_RANGE_NOT_FOUND},
 	{"NT_STATUS_NO_RECOVERY_POLICY", NT_STATUS_NO_RECOVERY_POLICY},
+	{"NT_STATUS_NO_EFS", NT_STATUS_NO_EFS},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index c0f317948714..9af4a21e1d9b 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -557,6 +557,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_DECRYPTION_FAILED (0xC0000000 | 0x028b)
 #define NT_STATUS_RANGE_NOT_FOUND (0xC0000000 | 0x028c)
 #define NT_STATUS_NO_RECOVERY_POLICY (0xC0000000 | 0x028d)
+#define NT_STATUS_NO_EFS (0xC0000000 | 0x028e)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 02a2233ea0dc..cef67ea5720e 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -664,7 +664,7 @@ static const struct {
 	ERRDOS, ERRnoaccess, NT_STATUS_DECRYPTION_FAILED}, {
 	ERRHRD, ERRgeneral, NT_STATUS_RANGE_NOT_FOUND}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_NO_RECOVERY_POLICY}, {
-	ERRDOS, ERRnoaccess, 0xc000028e}, {
+	ERRDOS, ERRnoaccess, NT_STATUS_NO_EFS}, {
 	ERRDOS, ERRnoaccess, 0xc000028f}, {
 	ERRDOS, ERRnoaccess, 0xc0000290}, {
 	ERRDOS, ERRbadfunc, 0xc000029c}, {
-- 
2.43.0

