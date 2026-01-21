Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB70C3F23BE
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996250; cv=none; b=JBRmZdRYneeK1JWUi09UiHY2ujk4BKc9UEZq5x39zvvIoqAoO0wkmqMUSMETG+T8onlpOgrUtLLksqqhso5wDHalImbMg0JOtLYnPzPSprJmF2BpESRoNe06lgB5PMHuYSn5N8VW1dx3klt7zcQAsHzmamQmGl1uqGrevYvLoB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996250; c=relaxed/simple;
	bh=F6c/kvQumyKmupHMc1MDDsHOvIHo92w0HC3nXXjtl2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TljiQIasLco/pVsUFmTAvDTlDfNwR4IqkxWUdxu7yheJGYGPhbyqPhaKTZrBoTCl0DPCxG+PnPYlRUmM/nF6bQFlFCK6Cw93zNCcNnK9JGoBUEn1JK2irYUJd1+EMinYPcNOQQxsMhTtJUa0gNOKSS3+IqyYEITaSzYo9bFo6RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BNiJ6YwX; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BNiJ6YwX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqQtoCuEv3Ejbzsj/u6fwlGJUSP4utkbG8AF9pY5U44=;
	b=BNiJ6YwXZvGiAVojzRHIuKcCSPgjjl4/oDabvQJyTmUtJKrFBhD9aihONvkMR9xv0V2vUh
	rpv0AFKWHL4W1dr+cHcf8KIWhJccF/pkrBbuReQ47lIcIOqAUKt+SSVKtCRaSYiz0vDcDd
	FkVeN5EvkW6FdlgKewXI3Eew+d6q4Rc=
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
Subject: [PATCH 11/17] smb/client: add NT_STATUS_NO_RECOVERY_POLICY
Date: Wed, 21 Jan 2026 19:49:06 +0800
Message-ID: <20260121114912.2138032-12-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_NO_RECOVERY_POLICY.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index bdc9f6f84df8..5e3efc3805a1 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -686,6 +686,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_ENCRYPTION_FAILED", NT_STATUS_ENCRYPTION_FAILED},
 	{"NT_STATUS_DECRYPTION_FAILED", NT_STATUS_DECRYPTION_FAILED},
 	{"NT_STATUS_RANGE_NOT_FOUND", NT_STATUS_RANGE_NOT_FOUND},
+	{"NT_STATUS_NO_RECOVERY_POLICY", NT_STATUS_NO_RECOVERY_POLICY},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 56bd494b480d..c0f317948714 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -556,6 +556,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_ENCRYPTION_FAILED (0xC0000000 | 0x028a)
 #define NT_STATUS_DECRYPTION_FAILED (0xC0000000 | 0x028b)
 #define NT_STATUS_RANGE_NOT_FOUND (0xC0000000 | 0x028c)
+#define NT_STATUS_NO_RECOVERY_POLICY (0xC0000000 | 0x028d)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 4506fe3fd203..02a2233ea0dc 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -663,7 +663,7 @@ static const struct {
 	ERRDOS, ERRnoaccess, NT_STATUS_ENCRYPTION_FAILED}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_DECRYPTION_FAILED}, {
 	ERRHRD, ERRgeneral, NT_STATUS_RANGE_NOT_FOUND}, {
-	ERRDOS, ERRnoaccess, 0xc000028d}, {
+	ERRDOS, ERRnoaccess, NT_STATUS_NO_RECOVERY_POLICY}, {
 	ERRDOS, ERRnoaccess, 0xc000028e}, {
 	ERRDOS, ERRnoaccess, 0xc000028f}, {
 	ERRDOS, ERRnoaccess, 0xc0000290}, {
-- 
2.43.0

