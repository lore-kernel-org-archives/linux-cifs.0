Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F940B6C4
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996228; cv=none; b=J8LG6nlHLgNzH5UPwc106XB18THwCXXtYIVAXpT85I3lkt/3U3VjH3XLPYKdLOsrNxZeeCke1fFALz4G131QONVbWLVoTlhAv8La16gUlScULo2OJUlU1Bu7G9uTRw3+gXW8l1qjg15SCtMi6dnvo+eZTTKzJuXO3DrIOFDD/IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996228; c=relaxed/simple;
	bh=XK8yKkyzn7hoEBcwuTbTTlRehrDVVzvckckTM367YNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJsZEUKZno2KqhmAjNoKfsRO/TSjXzgo6zIyf/SUulG0zPnTEmgBL55NPlynW/Pvp0o7GgkoXIR+VWQWRiHx4DjAdNALx5Evxxiqtkq/bQG9Y440bsTuHyRiSvNlnpSDWEkZU7DiDbCgMmd6svO2ZD7GkRURl51aXZHXdAzkITM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GUJoQBp/; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GUJoQBp/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FE4wye0Qjw37iHrpZNgrzF5ZOeooSFYvos4arNKavas=;
	b=GUJoQBp/OaZ1YaMXivO8XgcdDRXJADp4Yo+2IaVTDHY4VFGhedlFpVkkrLtaecx4iRezJv
	MQfHO5sOBucxbFMdh/zePSDSB75x7ETthOmXhaeaQKcytdJvn1gg7dVERq4vs6t0YBxODD
	UF2tPDrwZsvkvM26uwavHXOWBugFKhQ=
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
Subject: [PATCH 03/17] smb/client: rename ERRinvlevel to ERRunknownlevel
Date: Wed, 21 Jan 2026 19:48:58 +0800
Message-ID: <20260121114912.2138032-4-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-CIFS 2.2.2.4 ERRunknownlevel. Keep the name consistent with the
documentation.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 4 ++--
 fs/smb/client/smberr.h       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 6347b2b856e5..0735f7ed676d 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -47,7 +47,7 @@ static const struct smb_to_posix_error mapping_table_ERRDOS[] = {
 	{ERRinvparm, -EINVAL},
 	{ERRdiskfull, -ENOSPC},
 	{ERRinvname, -ENOENT},
-	{ERRinvlevel, -EOPNOTSUPP},
+	{ERRunknownlevel, -EOPNOTSUPP},
 	{ERRdirnotempty, -ENOTEMPTY},
 	{ERRnotlocked, -ENOLCK},
 	{ERRcancelviolation, -ENOLCK},
@@ -669,7 +669,7 @@ static const struct {
 	ERRDOS, ERRnoaccess, 0xc0000290}, {
 	ERRDOS, ERRbadfunc, 0xc000029c}, {
 	ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
-	ERRDOS, ERRinvlevel, NT_STATUS_OS2_INVALID_LEVEL}, {
+	ERRDOS, ERRunknownlevel, NT_STATUS_OS2_INVALID_LEVEL}, {
 	0, 0, 0 }
 };
 
diff --git a/fs/smb/client/smberr.h b/fs/smb/client/smberr.h
index aeffdad829e2..6fb63f9e9a95 100644
--- a/fs/smb/client/smberr.h
+++ b/fs/smb/client/smberr.h
@@ -80,7 +80,7 @@
 #define ERRinvparm		87
 #define ERRdiskfull		112
 #define ERRinvname		123
-#define ERRinvlevel		124
+#define ERRunknownlevel		124
 #define ERRdirnotempty		145
 #define ERRnotlocked		158
 #define ERRcancelviolation	173
-- 
2.43.0

