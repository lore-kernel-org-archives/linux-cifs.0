Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E0C3D523D
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996241; cv=none; b=U9U5zu4MaSbfZ2uyMgA1/kMARla+a0G3ACjKkTe6b4T5vDecyqk2cV1lX31HI8qw+Hy+Qde8TSAah68OUvcjo1CmsoxLFflXWN+2jVDVgNPWc/SaDLN67o1/rjUMkqz/+SmPnYcTn0fJCDyxnkE0J9wO0x9eO/snAAZ0SXCis8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996241; c=relaxed/simple;
	bh=UTDEyjADdLQVZ/GsO/Wqhnyx/j1aPkoudXk6YdwxgEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSbvba7wBfRXAip8Ayog/Z81wIQwgO566+ToqgeTFrDlwShw6C6t+JnMEGezqqBGwoxMd4ZPimfdX8sILXz2vQ0C2V1FACaG2a8sEKjwqqrwSabGSPS39u1T4SPNgSWFhmtYhtnABPK4CnYtE7TbcXUqmmGAkFCcuUHYfzZUbzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ighbgHy9; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ighbgHy9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3IqGN72Vef/OJJipOZ+IOVfh7DhKyDxsnVlJoQFmx/Y=;
	b=ighbgHy9PVSp1kD6lhigdbkQxbjW9ndkoDncZpt3OGUTGi9Usq2aX69meTfubDyZ0PjFHA
	mpGw4EwcL6IYz+hB1m+tydkb7rGt9T5S3qivPzkBOqF6issBCa10caSXwbN08OrSQO9NA4
	qDFadIPhS/U3OzNT4uSpNTpbdKZ2gNw=
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
Subject: [PATCH 07/17] smb/client: add NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT
Date: Wed, 21 Jan 2026 19:49:02 +0800
Message-ID: <20260121114912.2138032-8-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_DIRECTORY_IS_A_REPARSE_POINT.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 2 ++
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 28b6320f2d21..679ff5d600cf 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -681,6 +681,8 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_FILE_IS_OFFLINE", NT_STATUS_FILE_IS_OFFLINE},
 	{"NT_STATUS_VOLUME_DISMOUNTED", NT_STATUS_VOLUME_DISMOUNTED},
 	{"NT_STATUS_NOT_A_REPARSE_POINT", NT_STATUS_NOT_A_REPARSE_POINT},
+	{"NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT",
+	 NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT},
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 2056831ea631..087f970c6ceb 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -552,6 +552,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_FILE_IS_OFFLINE (0xC0000000 | 0x0267)
 #define NT_STATUS_VOLUME_DISMOUNTED (0xC0000000 | 0x026e)
 #define NT_STATUS_NOT_A_REPARSE_POINT (0xC0000000 | 0x0275)
+#define NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT (0xC0000000 | 0x0281)
 #define NT_STATUS_NETWORK_SESSION_EXPIRED  (0xC0000000 | 0x035c)
 #define NT_STATUS_NO_SUCH_JOB (0xC0000000 | 0xEDE)	/* scheduler */
 #define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP (0xC0000000 | 0x5D0000)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 164b721c7dda..e91d9a22d843 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -659,7 +659,7 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_QUOTA_LIST_INCONSISTENT}, {
 	ERRHRD, ERRgeneral, NT_STATUS_FILE_IS_OFFLINE}, {
 	ERRDOS, 21, NT_STATUS_VOLUME_DISMOUNTED}, {
-	ERRDOS, 161, 0xc0000281}, {
+	ERRDOS, 161, NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT}, {
 	ERRDOS, ERRnoaccess, 0xc000028a}, {
 	ERRDOS, ERRnoaccess, 0xc000028b}, {
 	ERRHRD, ERRgeneral, 0xc000028c}, {
-- 
2.43.0

