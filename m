Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4A4407562
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996241; cv=none; b=LyVEIQrOxk6fpJeek/pj8oLzR3agE8OmPFQAJiM63mEmOTJrXdJDhm2ULe1rY5kPdms7o5jIDZxFpxn9L6Tw7FByiVXsVzMoVgPkhz8b7cw65gDXqfoXnTfOVcVroBoM6g2nQnPxvltkSlmQrXvoPK9O7kS2KUak5YxOBlIHOgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996241; c=relaxed/simple;
	bh=Ajo2H6+5yVn/2T0xYMB6QVPNDy5bb+IsaOaXB20bWuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5MhbtsvgwqgovdcJ6Ro4iY2nHgsJgPTlfVr6r56J3WP+zgKW/ujcFrWJpLABQyKbdOsn0T9drWFBSBNdVnBZvUEbW+1Bt3AKqG0wfCePruaMx6uDdv7Gm9cbArzYyW5edF+GcxZW+Zwps58yd2fYngeCkmCMe20oGrp/pSJYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xmwAxMZG; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xmwAxMZG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t4x+yGZwYaDZVHTGomRh6LV2MSk/aEocOt/ShgBwbIc=;
	b=xmwAxMZGJ0opC83usE+ivLCL9iE8LbKtr5wp8z3d/9IEks3yXYuOIoUBpQBNWqMYcHTCVA
	vhE8qeb+q6ojugW3j5YVgyltSF3iIlkOyz9RIbisnsHJQxhdKwadIZiHvbnkBo/OOWYqPY
	Fo+8ue89qdzPCywqAJSm7ZxlppZoh7Q=
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
Subject: [PATCH 08/17] smb/client: add NT_STATUS_ENCRYPTION_FAILED
Date: Wed, 21 Jan 2026 19:49:03 +0800
Message-ID: <20260121114912.2138032-9-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_ENCRYPTION_FAILED.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 679ff5d600cf..38f28be12c30 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -683,6 +683,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_NOT_A_REPARSE_POINT", NT_STATUS_NOT_A_REPARSE_POINT},
 	{"NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT",
 	 NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT},
+	{"NT_STATUS_ENCRYPTION_FAILED", NT_STATUS_ENCRYPTION_FAILED},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 087f970c6ceb..a5595f234b0c 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -553,6 +553,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_VOLUME_DISMOUNTED (0xC0000000 | 0x026e)
 #define NT_STATUS_NOT_A_REPARSE_POINT (0xC0000000 | 0x0275)
 #define NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT (0xC0000000 | 0x0281)
+#define NT_STATUS_ENCRYPTION_FAILED (0xC0000000 | 0x028a)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index e91d9a22d843..175732910909 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -660,7 +660,7 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_FILE_IS_OFFLINE}, {
 	ERRDOS, 21, NT_STATUS_VOLUME_DISMOUNTED}, {
 	ERRDOS, 161, NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT}, {
-	ERRDOS, ERRnoaccess, 0xc000028a}, {
+	ERRDOS, ERRnoaccess, NT_STATUS_ENCRYPTION_FAILED}, {
 	ERRDOS, ERRnoaccess, 0xc000028b}, {
 	ERRHRD, ERRgeneral, 0xc000028c}, {
 	ERRDOS, ERRnoaccess, 0xc000028d}, {
-- 
2.43.0

