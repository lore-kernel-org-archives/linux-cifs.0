Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB0040B6E3
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996256; cv=none; b=a25YTQLXrjmUrAmDJRJRjiyKCr1shXExy6KTu2nvd1X3fo3vytbo7lNXxZSfDsxb5DTxuLurl79zOxStHhoJabaD7vEcgN1XuXBHPd5Hro3tOgVRohY/MTeWTBk9Q4nlF6kyC/tPrspzvEhdr6NkMNM6w28n68fVFR5SYt+wA4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996256; c=relaxed/simple;
	bh=JyhRRnWmnOk8Cn0wsnXfaljVgjYQylsl+Ch5/iwrpgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQ2PHHlgwIyx+ekpSlZJNUshWGXewwtp65QBwcmzIghEYJl7fzge2CDp5r6vchxeVfO/4TWIBxG49fRWTPUcm3ufVr0v405B0uD+B8HIz9pDQgGdOHTDkP47L4P+g/acqum2mx8Qx3au4BNj3L2zdo3KHKuresj/9C5VDUKXwKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cZdrb+xz; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cZdrb+xz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gCokvJojhWSd9Af6VuN/0Y3FvIkXWCW+1ACk+KejZBw=;
	b=cZdrb+xzry8hsLYbQ0wHsLgwevvPA3KC9k51LnjYYjGh89SpsrHQXN/2f5eWLc62HEYDHU
	QGefsDeC4ZK3wYCWnXYADPyQKueydJkgO7XiNEBykFDfU/LYKiLfVsfitElJ2sVxfp92S2
	Uc36DJEqG0kvpLTz31AaVPCCwLSUSeU=
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
Subject: [PATCH 13/17] smb/client: add NT_STATUS_WRONG_EFS
Date: Wed, 21 Jan 2026 19:49:08 +0800
Message-ID: <20260121114912.2138032-14-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_WRONG_EFS.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 5d649222a3be..9f0a3283edc0 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -688,6 +688,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_RANGE_NOT_FOUND", NT_STATUS_RANGE_NOT_FOUND},
 	{"NT_STATUS_NO_RECOVERY_POLICY", NT_STATUS_NO_RECOVERY_POLICY},
 	{"NT_STATUS_NO_EFS", NT_STATUS_NO_EFS},
+	{"NT_STATUS_WRONG_EFS", NT_STATUS_WRONG_EFS},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 9af4a21e1d9b..72fb68a13c49 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -558,6 +558,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_RANGE_NOT_FOUND (0xC0000000 | 0x028c)
 #define NT_STATUS_NO_RECOVERY_POLICY (0xC0000000 | 0x028d)
 #define NT_STATUS_NO_EFS (0xC0000000 | 0x028e)
+#define NT_STATUS_WRONG_EFS (0xC0000000 | 0x028f)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index cef67ea5720e..7af766b81eaf 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -665,7 +665,7 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_RANGE_NOT_FOUND}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_NO_RECOVERY_POLICY}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_NO_EFS}, {
-	ERRDOS, ERRnoaccess, 0xc000028f}, {
+	ERRDOS, ERRnoaccess, NT_STATUS_WRONG_EFS}, {
 	ERRDOS, ERRnoaccess, 0xc0000290}, {
 	ERRDOS, ERRbadfunc, 0xc000029c}, {
 	ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
-- 
2.43.0

