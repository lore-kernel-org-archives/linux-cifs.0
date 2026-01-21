Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6436B3EDAD9
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996263; cv=none; b=VU9XI3+kU7jmCXgvUClJ/CoqN1/hsae9TGM8ivc8jddYbb3X3YAeaWcjpA1X47HjUDQVI6AL1P8a4hLR+bgAaN7GK8QQ+6erG2Ukw7iF2JsDKYU91IJf9QNIpASlYbYjlkLOoJFdPhKezIVSLKwqEhVrogrQQ+/Bso3gswnj1TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996263; c=relaxed/simple;
	bh=SS++7wcd17eBgx+HwSt1YMvZlsgr7Ha8sbUXsgAxE6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPDrK86woyCEUFwQpNZmjoz3X84R3SuPryYmzzgmVuZ5CA20BXXrTgDFxxL4q3yBEsjuudCDj1sncp56K2vhS1wASuRJT9doXLvNTLtrbwdqpRbuHzq+ZGtSMe351M8JGAigq+maKybWmox+cFaHY3l9xOxpTdozhQvuQMM1sqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nq1iXF7k; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nq1iXF7k"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ndigFnSC2EPF+zc5l52kdxBCv3Twr9y8hFXYouVfIg=;
	b=Nq1iXF7ku4zu97JK9fUBBxc5jB4ITcJ2J0IdrYYxcLs12YkOWFK/mdFCR+6NQjIaBW/2wN
	5Dgu2iwDcoTuaSfi5JAETLaQ7WXwgnz8ITIUjBDxsTqMP347VFcNxKIySKJFeGEQiJX40I
	W1GTrq1mD9t/NzoBnu3ZO/ZvW//YKbA=
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
Subject: [PATCH 16/17] smb/client: remove some literal NT error codes from ntstatus_to_dos_map
Date: Wed, 21 Jan 2026 19:49:11 +0800
Message-ID: <20260121114912.2138032-17-chenxiaosong.chenxiaosong@linux.dev>
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

When an NT error code is not in ntstatus_to_dos_map, ntstatus_to_dos()
will return the default ERRHRD and ERRGENERAL.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 2de241f89cb6..0924ebebb65a 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -502,9 +502,6 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_SHARED_IRQ_BUSY}, {
 	ERRHRD, ERRgeneral, NT_STATUS_FT_ORPHANING}, {
 	ERRHRD, ERRgeneral, NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT}, {
-	ERRHRD, ERRgeneral, 0xc000016f}, {
-	ERRHRD, ERRgeneral, 0xc0000170}, {
-	ERRHRD, ERRgeneral, 0xc0000171}, {
 	ERRHRD, ERRgeneral, NT_STATUS_PARTITION_FAILURE}, {
 	ERRHRD, ERRgeneral, NT_STATUS_INVALID_BLOCK_LENGTH}, {
 	ERRHRD, ERRgeneral, NT_STATUS_DEVICE_NOT_PARTITIONED}, {
@@ -512,7 +509,6 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_UNABLE_TO_UNLOAD_MEDIA}, {
 	ERRHRD, ERRgeneral, NT_STATUS_EOM_OVERFLOW}, {
 	ERRHRD, ERRgeneral, NT_STATUS_NO_MEDIA}, {
-	ERRHRD, ERRgeneral, 0xc0000179}, {
 	ERRHRD, ERRgeneral, NT_STATUS_NO_SUCH_MEMBER}, {
 	ERRHRD, ERRgeneral, NT_STATUS_INVALID_MEMBER}, {
 	ERRHRD, ERRgeneral, NT_STATUS_KEY_DELETED}, {
@@ -628,12 +624,6 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_LOGIN_TIME_RESTRICTION}, {
 	ERRHRD, ERRgeneral, NT_STATUS_LOGIN_WKSTA_RESTRICTION}, {
 	ERRDOS, 193, NT_STATUS_IMAGE_MP_UP_MISMATCH}, {
-	ERRHRD, ERRgeneral, 0xc000024a}, {
-	ERRHRD, ERRgeneral, 0xc000024b}, {
-	ERRHRD, ERRgeneral, 0xc000024c}, {
-	ERRHRD, ERRgeneral, 0xc000024d}, {
-	ERRHRD, ERRgeneral, 0xc000024e}, {
-	ERRHRD, ERRgeneral, 0xc000024f}, {
 	ERRHRD, ERRgeneral, NT_STATUS_INSUFFICIENT_LOGON_INFO}, {
 	ERRHRD, ERRgeneral, NT_STATUS_BAD_DLL_ENTRYPOINT}, {
 	ERRHRD, ERRgeneral, NT_STATUS_BAD_SERVICE_ENTRYPOINT}, {
@@ -647,7 +637,6 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_PWD_TOO_SHORT}, {
 	ERRHRD, ERRgeneral, NT_STATUS_PWD_TOO_RECENT}, {
 	ERRHRD, ERRgeneral, NT_STATUS_PWD_HISTORY_CONFLICT}, {
-	ERRHRD, ERRgeneral, 0xc000025d}, {
 	ERRHRD, ERRgeneral, NT_STATUS_PLUGPLAY_NO_DEVICE}, {
 	ERRHRD, ERRgeneral, NT_STATUS_UNSUPPORTED_COMPRESSION}, {
 	ERRHRD, ERRgeneral, NT_STATUS_INVALID_HW_PROFILE}, {
-- 
2.43.0

