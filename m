Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77FB396B97
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996235; cv=none; b=QM389cClG9DaF+zfGyxVN26oyBfZSUepiKvHb2zaJinGzyWos0SaIB9iupa7KrZkk8eu1eWO9IgeSEnKQjy3T1oV42xhSLeISkHm5TBUHkQY9Jm1zmGIACAEbTakjIfSBcxKv0GwQc0piaZE7kWaA7NFro/xLbWCZE7wAB6GRBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996235; c=relaxed/simple;
	bh=3KjE4e3EjCgPdea4YDJxkAesIPU6EfX/sq3dG1ZqJu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAng1/NDdDb6YVPp5lX4d06/P76KIY6irmpwNa8x2IdtXayM8r9eUpfhVWESt+U52XSmjidD+MRclIAW+DIAlkhG4lRp9SCoZbdViNHsOEHbLert96rFv6fpQH4vc7LSC0twBKZqnPkIMcqu8sgPfDDoTIJGYRKEq9AIgXDAB3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tcPkinnO; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tcPkinnO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wTDNp1KhIdN4pwqg+LhLLuijo2VW6uD0XmU90BadzI0=;
	b=tcPkinnOPEKwZSm6q3OVomEBosa3BZsRYBHeS1rKTUML7mOX7SQsMmSvSXtTCCUYe98ngn
	52QzzHi+seyi3DBzqyhT72tbg9tXkVUfyeSexugxW5ObloLRwQPZA5/aHeVimxuxjB6pq9
	iHwNGi0Zxx0nwdAATLaX4/hZjczUZ6c=
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
Subject: [PATCH 05/17] smb/client: add NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT
Date: Wed, 21 Jan 2026 19:49:00 +0800
Message-ID: <20260121114912.2138032-6-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREf 2.3.1 STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 2 ++
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 6f30bd5dcf61..1c5d7199f556 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -487,6 +487,8 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_DISK_RESET_FAILED", NT_STATUS_DISK_RESET_FAILED},
 	{"NT_STATUS_SHARED_IRQ_BUSY", NT_STATUS_SHARED_IRQ_BUSY},
 	{"NT_STATUS_FT_ORPHANING", NT_STATUS_FT_ORPHANING},
+	{"NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT",
+	 NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT},
 	{"NT_STATUS_PARTITION_FAILURE", NT_STATUS_PARTITION_FAILURE},
 	{"NT_STATUS_INVALID_BLOCK_LENGTH", NT_STATUS_INVALID_BLOCK_LENGTH},
 	{"NT_STATUS_DEVICE_NOT_PARTITIONED",
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index e7d431d43b76..1aa4bc394405 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -411,6 +411,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_DISK_RESET_FAILED (0xC0000000 | 0x016b)
 #define NT_STATUS_SHARED_IRQ_BUSY (0xC0000000 | 0x016c)
 #define NT_STATUS_FT_ORPHANING (0xC0000000 | 0x016d)
+#define NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT (0xC0000000 | 0x016e)
 #define NT_STATUS_PARTITION_FAILURE (0xC0000000 | 0x0172)
 #define NT_STATUS_INVALID_BLOCK_LENGTH (0xC0000000 | 0x0173)
 #define NT_STATUS_DEVICE_NOT_PARTITIONED (0xC0000000 | 0x0174)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 2f81c4adef81..3085e2084f99 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -501,7 +501,7 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_DISK_RESET_FAILED}, {
 	ERRHRD, ERRgeneral, NT_STATUS_SHARED_IRQ_BUSY}, {
 	ERRHRD, ERRgeneral, NT_STATUS_FT_ORPHANING}, {
-	ERRHRD, ERRgeneral, 0xc000016e}, {
+	ERRHRD, ERRgeneral, NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT}, {
 	ERRHRD, ERRgeneral, 0xc000016f}, {
 	ERRHRD, ERRgeneral, 0xc0000170}, {
 	ERRHRD, ERRgeneral, 0xc0000171}, {
-- 
2.43.0

