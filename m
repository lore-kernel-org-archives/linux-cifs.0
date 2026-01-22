Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B36364EA4
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 05:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059521; cv=none; b=UMCy6t5R+uEnahlJQ+IzEcp/XO4lfl76Z1YDJIH9LdIUcGCNOV2r2uSfJqgD7lMvkHBuLamTJZyaHDo4oXNf4jbpZA2fSDsJ4F76A+ZI7xGq3das2A02gvIhew4hQz9HMyvIYAQyHBInOu/y4HX0au7gOwbNj1JDjb7Bu1cI/kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059521; c=relaxed/simple;
	bh=Wqy8xB/F8z9weFuY8wtHciJyiNvmgRyrcBQR8DAhVNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNMMpQVZfYfz8oFyQzKJsFTDHoECHgIDkeYZnGbzXe9SAx7UMslEmPboibNh/tJRYD00tGW76LIgeUH3J9J5RL1K0HP5eFS9zK1OdGQ/1fSFmo1q+qCGYTN+QYfUoEmlW2qcSrNqpybMCCKbcc97gCH2O1G3+XQC5HKxkYwldEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sWO0q//s; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sWO0q//s"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzDHXTqMc2OnVs5xTaT+JZmbuYn/elsJCADy/nftX+Y=;
	b=sWO0q//slyQvYxHTrH1B9iVwB/rIjbvYfxf8bBRXZ7RFZfEhbW2+DC6FDmp3ORGlTP1eVc
	mdRFMxQcnEiRpKlIihrPnDUx75yphxt/K7+S/Kio0A7kY4AaE4W/jXN25NN7sDLuWfKinN
	eSBgKYop13ePwfTFay+5t5JUULNefoM=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/7] smb/client: map NT_STATUS_NOTIFY_ENUM_DIR
Date: Thu, 22 Jan 2026 13:23:56 +0800
Message-ID: <20260122052402.2209206-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

See MS-CIFS 2.2.2.4 STATUS_NOTIFY_ENUM_DIR.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 2 +-
 fs/smb/client/smb1maperror.c | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index ab5a2119efd0..806ad6d7c22a 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -14,6 +14,7 @@
 const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_OK", NT_STATUS_OK},
 	{"NT_STATUS_PENDING", NT_STATUS_PENDING},
+	{"NT_STATUS_NOTIFY_ENUM_DIR", NT_STATUS_NOTIFY_ENUM_DIR},
 	{"NT_STATUS_MEDIA_CHANGED", NT_STATUS_MEDIA_CHANGED},
 	{"NT_STATUS_END_OF_MEDIA", NT_STATUS_END_OF_MEDIA},
 	{"NT_STATUS_MEDIA_CHECK", NT_STATUS_MEDIA_CHECK},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index b04cd0d786b1..e8306704f5e3 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -27,7 +27,6 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_ERROR_INVALID_PARAMETER     0x0057
 #define NT_ERROR_INSUFFICIENT_BUFFER   0x007a
 #define NT_STATUS_1804                 0x070c
-#define NT_STATUS_NOTIFY_ENUM_DIR      0x010c
 
 /*
  * Win32 Error codes extracted using a loop in smbclient then printing a netmon
@@ -37,6 +36,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_OK                   0x0000
 #define NT_STATUS_PENDING              0x0103
 #define NT_STATUS_SOME_UNMAPPED        0x0107
+#define NT_STATUS_NOTIFY_ENUM_DIR      0x010c
 #define NT_STATUS_BUFFER_OVERFLOW  0x80000005
 #define NT_STATUS_NO_MORE_ENTRIES  0x8000001a
 #define NT_STATUS_MEDIA_CHANGED    0x8000001c
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index e8aa7d44cbc6..10ab889a442c 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -113,6 +113,7 @@ static const struct {
 	__u32 ntstatus;
 } ntstatus_to_dos_map[] = {
 	{
+	ERRSRV, ERR_NOTIFY_ENUM_DIR, NT_STATUS_NOTIFY_ENUM_DIR}, {
 	ERRDOS, ERRgeneral, NT_STATUS_UNSUCCESSFUL}, {
 	ERRDOS, ERRbadfunc, NT_STATUS_NOT_IMPLEMENTED}, {
 	ERRDOS, ERRbadpipe, NT_STATUS_INVALID_INFO_CLASS}, {
-- 
2.43.0

