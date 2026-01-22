Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFD530E0F2
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 05:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059529; cv=none; b=CwxHra1KL6eJImC/ljx5IhNdY/ILUOkb6YDMcInJlyuxKagDjDOOBEjTUf/y/Nc0RjM+fReW5p4Q75eRRbfeQCaxq9SqSXMgR8EEQLONu1YITQAfXWwziLXEZ4P11qxpcSQWHvuu4NgOCMuBnTlfSw1S85jV4Z010/y6bjAIjmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059529; c=relaxed/simple;
	bh=THoD9dxVSMhKe8JgHK5z53X12TzaTAVpv6D1iT1ttBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/Rf6si/MPxCDYAFmZA2Gpx+Lv1lRGNtxwYYyjwRz74ESjkUqcdMPUq/l9e0UYejKPCtiQoYoTz+nRg+ZCM+d4zJmxdlFrBdTAsVCyxvkH5wxfjhideGR4OJ1p/m3WydS/PHTYwfuQy2Xgx7BJN0SLx248e1Jg0aZpXLrJ630/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O08UPdkt; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O08UPdkt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OlJyllVuSrVbdF5v8454B1nTqvzBAzF3GjO2cOUXCek=;
	b=O08UPdktw+qURncW/iw59WG2yavmDty82RJHaGkkNILLrujZEbm6tc9VbTmR9vpzPx9NXg
	tlZe0FWbRKEXrCzU3shqjjFKOSzvFQTgRGM1F1HcockeqQHnSeRAfpRk+LikyI726PapIC
	oqvBMS6zEyoM+fwfe8t2mwXTDXbpjvI=
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
Subject: [PATCH 3/7] smb/client: map NT_STATUS_MORE_PROCESSING_REQUIRED
Date: Thu, 22 Jan 2026 13:23:58 +0800
Message-ID: <20260122052402.2209206-4-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-CIFS 2.2.2.4 STATUS_MORE_PROCESSING_REQUIRED.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index c1330d32ef09..421a7ab7bdfb 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -115,6 +115,7 @@ static const struct {
 	{
 	ERRSRV, ERR_NOTIFY_ENUM_DIR, NT_STATUS_NOTIFY_ENUM_DIR}, {
 	ERRDOS, ERRmoredata, NT_STATUS_BUFFER_OVERFLOW}, {
+	ERRDOS, ERRmoredata, NT_STATUS_MORE_PROCESSING_REQUIRED}, {
 	ERRDOS, ERRgeneral, NT_STATUS_UNSUCCESSFUL}, {
 	ERRDOS, ERRbadfunc, NT_STATUS_NOT_IMPLEMENTED}, {
 	ERRDOS, ERRbadpipe, NT_STATUS_INVALID_INFO_CLASS}, {
-- 
2.43.0

