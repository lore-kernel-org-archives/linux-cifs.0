Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404BC3EF0D8
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996222; cv=none; b=gAXX34SzMVaSEnTYOtViLf0K3J0JWSPnex+ccTqlboVng5/B/0HoxNXOWSrxTHb4+EyPX3FewPmNvypqt3ViuZYQcSXOQ5jl+WZurGNqIQnhxwwWkxgliEuDFDTAAPSCIAS0WBoU4orIHgi8RVH0FlO6v34etXI0vaYFSD6KGpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996222; c=relaxed/simple;
	bh=U/xu2IRNmPk+3F3Kel5UpljkQW2UHi9Su5e98+/afOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hpv95VuKGXuNiJV/iyTZXy4dCLXydZkGi/g3J0a58+Wn91xFBVM4LTcWpMzLjhZcrRidZlenMa5/T7cpOw8a09et7vsX8jDLqTzpKCMkeqDtJapo4JnpFH6zFAVb12EH0XgAf7l8dCY2uurpXE7LYLa6vWZtZ5/CJV7JeRbGl+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EAlDNb8n; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EAlDNb8n"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mWp53q80Z0nsPaBKdPo6kp2Mf3A1DciLTv5dSJhgV0Q=;
	b=EAlDNb8nYQ3TioUIqkkkX05LNFP8YI9UBffj8KzvV+Cd3AsGO2RKMZ+0yQGPU8a19BhpKH
	5QuDT965ThpWgzWLWY2JL5KeozZ6d4FHnVei0lYXzp2tFOlbeS+/2pGyNDN3L1AwzvXh5I
	5qaq9nDJHzH1Gm09MlcQBcymGAigiXo=
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
Subject: [PATCH 01/17] smb/client: map NT_STATUS_INVALID_INFO_CLASS to ERRbadpipe
Date: Wed, 21 Jan 2026 19:48:56 +0800
Message-ID: <20260121114912.2138032-2-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-CIFS 2.2.2.4 STATUS_INVALID_INFO_CLASS.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 1565f249452d..31b907362989 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -119,7 +119,7 @@ static const struct {
 	{
 	ERRDOS, ERRgeneral, NT_STATUS_UNSUCCESSFUL}, {
 	ERRDOS, ERRbadfunc, NT_STATUS_NOT_IMPLEMENTED}, {
-	ERRDOS, ERRinvlevel, NT_STATUS_INVALID_INFO_CLASS}, {
+	ERRDOS, ERRbadpipe, NT_STATUS_INVALID_INFO_CLASS}, {
 	ERRDOS, 24, NT_STATUS_INFO_LENGTH_MISMATCH}, {
 	ERRHRD, ERRgeneral, NT_STATUS_ACCESS_VIOLATION}, {
 	ERRHRD, ERRgeneral, NT_STATUS_IN_PAGE_ERROR}, {
-- 
2.43.0

