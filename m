Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90C23E9588
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996243; cv=none; b=IlhatEYh3ZuEFVdBjwz7/uj0rZTD4tZ4+bbTtgM0+ULOUuY5lkEsy/4oSSxHil8oxctLjvkOnN2Wd+mA3Exjp60oVZoVGzxQyp/f7JE2D7z8MSdn7PLVLNIAbXNxnVm0R/d3BZ4+ag0q6QjoTB6/ilFPR+0cfg2Eah46PmJm1Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996243; c=relaxed/simple;
	bh=4czU3mEkGXebD2plBANXCTpS+yWmTBzyH2R0QeM/D/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCoIP8lQH/aOhhDgp3XcnTODMMNe5FxiBywoW7utvN1nkgsePXilkP+Xu4OY+BgS0IiBvA/ZG42MVMDDpBlMDz3/8Fbns4u0bZYADvohUM+358N/F+MLu4Rv4E/2Ax2ZwMOVBbe7j6UD5pCiX2vKjKs6C3YLo0CnPY0VQMZLkNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fnhiEUyU; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fnhiEUyU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTzw/KQhrlNjvziw6C482ZgNhkL8vJTOOUK+rzjw9Hw=;
	b=fnhiEUyUAvBDRKKUvAo/9vmO4+/ny9uTBCSuuiWJV/RS4G7fFO7BRK90qSPzJ/BIIW4zHG
	toAjYXrIBc3P+KK/E3SmpTj6+UHTZ6VAbaU2WFI72ie4lEGNPfSSNfHOJft38x1DdpHNl1
	okn4YbFeSHshJkFaBmzfRPZ7Y5OyrpM=
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
Subject: [PATCH 09/17] smb/client: add NT_STATUS_DECRYPTION_FAILED
Date: Wed, 21 Jan 2026 19:49:04 +0800
Message-ID: <20260121114912.2138032-10-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_DECRYPTION_FAILED.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 38f28be12c30..fc81174aef5f 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -684,6 +684,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT",
 	 NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT},
 	{"NT_STATUS_ENCRYPTION_FAILED", NT_STATUS_ENCRYPTION_FAILED},
+	{"NT_STATUS_DECRYPTION_FAILED", NT_STATUS_DECRYPTION_FAILED},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index a5595f234b0c..8b7d108ed9e4 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -554,6 +554,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NOT_A_REPARSE_POINT (0xC0000000 | 0x0275)
 #define NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT (0xC0000000 | 0x0281)
 #define NT_STATUS_ENCRYPTION_FAILED (0xC0000000 | 0x028a)
+#define NT_STATUS_DECRYPTION_FAILED (0xC0000000 | 0x028b)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 175732910909..32a57ac2c789 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -661,7 +661,7 @@ static const struct {
 	ERRDOS, 21, NT_STATUS_VOLUME_DISMOUNTED}, {
 	ERRDOS, 161, NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT}, {
 	ERRDOS, ERRnoaccess, NT_STATUS_ENCRYPTION_FAILED}, {
-	ERRDOS, ERRnoaccess, 0xc000028b}, {
+	ERRDOS, ERRnoaccess, NT_STATUS_DECRYPTION_FAILED}, {
 	ERRHRD, ERRgeneral, 0xc000028c}, {
 	ERRDOS, ERRnoaccess, 0xc000028d}, {
 	ERRDOS, ERRnoaccess, 0xc000028e}, {
-- 
2.43.0

