Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25341322D
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996258; cv=none; b=Fehj09x5EXW/XMoPEfZSE6Xd2IC+8mcH2rbngiFXHCe/QwZlv87/KF9NZiSg2wRtJ8rnOe0MgAK4EwnnW6SfsErF5v+DO0SCwkDXTVZt45uXq25GdtVIE64xFYEz8jK5kv5g0DBcQmeGSvVmQBrXSJbD8YVlSdzzO1CrEMYcgVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996258; c=relaxed/simple;
	bh=ZsgycZA0PeXZUWg6+dVUGL738fuILo60FbqfP2/TU0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJhB/WFiJvx+jmbX82+aTwxrYvGT1YUxJ4cu04sIHAo4lpJzsJ1shcLtP7aZBweUi6CFC1Wp21xdV3IoeQSQDtToaA1N94aHB3rxvLsizrOjtNH/UihKRSv7TQW3NoRnHzySUgvfaarOzh4wsEWBg4gXonjjSDDUU9JKLAIPZf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tr1iMdjL; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tr1iMdjL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zihXf0PqIe025E0EAY8w1rfO59QoXzXBwKEGeqKtoi4=;
	b=Tr1iMdjL50VX6oJwA24zuZ/GT5A3AtQUThzUy9pcyqCpH+7BX5Z4nLlE+ak+h9Se6nK3op
	z+JRrEy0KGdugqLtPcSJ5nrXYpdg273TOY6hqMYmWwtP/enQn3uxSHfEsfJIdSQr4hv+eJ
	zl0Fa2r98MtPu38njA2DPwe4REKgsh0=
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
Subject: [PATCH 14/17] smb/client: add NT_STATUS_NO_USER_KEYS
Date: Wed, 21 Jan 2026 19:49:09 +0800
Message-ID: <20260121114912.2138032-15-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_NO_USER_KEYS.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 9f0a3283edc0..256f14209f56 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -689,6 +689,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_NO_RECOVERY_POLICY", NT_STATUS_NO_RECOVERY_POLICY},
 	{"NT_STATUS_NO_EFS", NT_STATUS_NO_EFS},
 	{"NT_STATUS_WRONG_EFS", NT_STATUS_WRONG_EFS},
+	{"NT_STATUS_NO_USER_KEYS", NT_STATUS_NO_USER_KEYS},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 72fb68a13c49..b34e522e6f87 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -559,6 +559,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_RECOVERY_POLICY (0xC0000000 | 0x028d)
 #define NT_STATUS_NO_EFS (0xC0000000 | 0x028e)
 #define NT_STATUS_WRONG_EFS (0xC0000000 | 0x028f)
+#define NT_STATUS_NO_USER_KEYS (0xC0000000 | 0x0290)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 7af766b81eaf..0e1c8763afff 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -666,7 +666,7 @@ static const struct {
 	ERRDOS, ERRnoaccess, NT_STATUS_NO_RECOVERY_POLICY}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_NO_EFS}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_WRONG_EFS}, {
-	ERRDOS, ERRnoaccess, 0xc0000290}, {
+	ERRDOS, ERRnoaccess, NT_STATUS_NO_USER_KEYS}, {
 	ERRDOS, ERRbadfunc, 0xc000029c}, {
 	ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
 	ERRDOS, ERRunknownlevel, NT_STATUS_OS2_INVALID_LEVEL}, {
-- 
2.43.0

