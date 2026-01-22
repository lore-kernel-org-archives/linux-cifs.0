Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313BF28D8D0
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 05:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059536; cv=none; b=mmUUWv5Op50OEAkA2q2GVKjegwE5Esd+MqxiAOPrOLz75VUtxOW27/KQ3fR3SfqegMg6o3sr6E73hNVFp5V8XkWvsgGY6XyGmi9dBbN7w0XD8FxowAFqmDYpl7QvBHiRL9+SJMZsibGm4oKhHF4lMRXZur8AGymxM57xfO9n+kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059536; c=relaxed/simple;
	bh=OuVqWYghhnHK8hfynMmRcoTO3LdQT2pKTCoKc/SI2lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ+XCsrbsJ/2kIjiJM1WtU2Qg77AK0Ki5wkYxZ/0Q9EWuDQ+7DAetmc1ywnG45bNqqEcIK2xPaBQUz64fskZj5UE/25zPtYriIYhrLLGu0EOqGz0bz2FlQpuJgDHXAqgZyYS2dlEy1d6q0zy7gno0KWsrlVsbdjzN86x0E8NkFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kbTtxp+Z; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kbTtxp+Z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Vmx7jptj071K4LahlLpJqBMjXKkVavKEx8yRAXj21U=;
	b=kbTtxp+Z5nmeAyrJRJTdlVLFNQ1QYK+1s3K2GLEGrhwHNdtGoaf9o51V0hpuE4Uk8UESoX
	LtnWx8Tfrj32QOBjlLTFT0NbItNtIqraEk7lS/lSAVW0RKRoeB8KT/yBRowHUfUI30wp5d
	CmwV7k5Fh7qpdobWtRmA/9VIpzY0chk=
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
Subject: [PATCH 5/7] smb/client: rename to NT_STATUS_SOME_NOT_MAPPED
Date: Thu, 22 Jan 2026 13:24:00 +0800
Message-ID: <20260122052402.2209206-6-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREF 2.3.1 STATUS_SOME_NOT_MAPPED.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c | 2 +-
 fs/smb/client/nterr.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 806ad6d7c22a..279566cac435 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -695,7 +695,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
-	{"NT_STATUS_SOME_UNMAPPED", NT_STATUS_SOME_UNMAPPED},
+	{"NT_STATUS_SOME_NOT_MAPPED", NT_STATUS_SOME_NOT_MAPPED},
 	{"NT_STATUS_NO_SUCH_JOB", NT_STATUS_NO_SUCH_JOB},
 	{"NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP",
 	 NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index e8306704f5e3..cab16d53e11c 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -35,7 +35,7 @@ extern const struct nt_err_code_struct nt_errs[];
 
 #define NT_STATUS_OK                   0x0000
 #define NT_STATUS_PENDING              0x0103
-#define NT_STATUS_SOME_UNMAPPED        0x0107
+#define NT_STATUS_SOME_NOT_MAPPED      0x0107
 #define NT_STATUS_NOTIFY_ENUM_DIR      0x010c
 #define NT_STATUS_BUFFER_OVERFLOW  0x80000005
 #define NT_STATUS_NO_MORE_ENTRIES  0x8000001a
-- 
2.43.0

