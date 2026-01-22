Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899ED42EEDF
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 05:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059532; cv=none; b=AquVesasCi/7pJpiPN9z0XdlFmioHyhZXtEBh/L7kCCFtY+OYgqaNhb/XUMsen06wVwjtf3qWcFkz8T85Kb7+z8ifit2uRarKUkmXFi0krbruLGnc+7MuAUbrxgOeN3H5D8kWRDx/vYw6UESlUaBH5VJ0ywMnREDjfTb74HGl50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059532; c=relaxed/simple;
	bh=2ZTAh/Bxg6I9qNBx9oxh83hTKb1+1Reb8qvV9GMZcjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyVloo8q2WQe7ITEN9keZWq46RSSBe80mbRtP+NVtIdDVnVUaFve1a9KJ4Tce6jW1rqwmYOpf90uBjCMocb2NIU0H0lgthzi3eThPSxyOFWylWAbmLAc55cP/563MKBrZGXN9Msldj/DTmhxRVIZBR2Re0oQaWJC8UZO+QfmNlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w1bdFXbr; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w1bdFXbr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wArkXbktEi/QFiA506L3060oy20HX8XLs4ajUsMwhGU=;
	b=w1bdFXbrtagxF27ZXc06Aeb8sWBqFqHTOt6AvgCAJujn0TSK5GJADfCl/l4T1SSaq8EFon
	0TNYMItzxXA9+bWKOVJ8mEau2Pk6XNAckcsW1aHtKmvYHzDGpGItogOJuyyMvGFoCdoBtu
	YZdCgxeNLgAwqLPxg4W3yd1Bv4gTjwI=
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
Subject: [PATCH 4/7] smb/client: map NT_STATUS_PRIVILEGE_NOT_HELD
Date: Thu, 22 Jan 2026 13:23:59 +0800
Message-ID: <20260122052402.2209206-5-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-CIFS 2.2.2.4 STATUS_PRIVILEGE_NOT_HELD.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 421a7ab7bdfb..ceba8754f03b 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -116,6 +116,7 @@ static const struct {
 	ERRSRV, ERR_NOTIFY_ENUM_DIR, NT_STATUS_NOTIFY_ENUM_DIR}, {
 	ERRDOS, ERRmoredata, NT_STATUS_BUFFER_OVERFLOW}, {
 	ERRDOS, ERRmoredata, NT_STATUS_MORE_PROCESSING_REQUIRED}, {
+	ERRDOS, ERRnoaccess, NT_STATUS_PRIVILEGE_NOT_HELD}, {
 	ERRDOS, ERRgeneral, NT_STATUS_UNSUCCESSFUL}, {
 	ERRDOS, ERRbadfunc, NT_STATUS_NOT_IMPLEMENTED}, {
 	ERRDOS, ERRbadpipe, NT_STATUS_INVALID_INFO_CLASS}, {
-- 
2.43.0

