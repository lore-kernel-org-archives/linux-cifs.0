Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D826ED37
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242724; cv=none; b=PZeZlfoJ1xAQs0kIS228OxrKD4KcE9v9SbAuAr8suDRffaAVmD3JgWqDFuT1lTj6DBITfHwgWXKM+VidwqHaOwQvdw5Xe0PXs3GLYimZSmPN/duoSr0COot+2ytG4XaIxx2IwhO5LusQlyb2tIlh5Q6eUFwO5o4IkNE58dm1i48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242724; c=relaxed/simple;
	bh=sQK8eLEkp4BIHiVv1CBFKM5zTuVydPMz89HNse+sAVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIwMbnQYTyKo9yQLhRbGQOnmrOAjTeGsBmg97s5gPAmFmecuWwGJGEWAbPban94eSFJAGBXmOTAXiJ3AAIiId7zcVR7gHD4g1HGBbZK48ZLWogQ/IzeZ5O6653gh1GWVVF63OeZSvThepDNrKuRIp5t5OIbTPCntZH0ssdgkY9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WdHTFZko; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WdHTFZko"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LMkLbDt/VKtpayHT+2mPR9hOr31a66XLCMLNbr2kSpo=;
	b=WdHTFZko/w52XBGtSJh9di2A+mCxccp0sAjgt8PL6YhnUxecNztmHIMI+iEf7yGH/ou2v8
	GG2EPkErcC9Pu7+uSgxgbcqvUHFV/kfvK0DiFDSwCGYv/mGkqKSZ3yn6dtyXaVPN/8uMit
	lbBAV9q4ncRgSBNXyPL7JWNPF8Xacog=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 07/13] smb/server: add comment to FileSystemName of FileFsAttributeInformation
Date: Tue,  9 Dec 2025 09:10:13 +0800
Message-ID: <20251209011020.3270989-8-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Explained why FileSystemName is always set to "NTFS".

Link: https://github.com/namjaejeon/ksmbd/commit/84392651b0b740d2f59bcacd3b4cfff8ae0051a0
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7ea6144c692c..ddd031ad7689 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5497,6 +5497,13 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 			info->Attributes |= cpu_to_le32(FILE_NAMED_STREAMS);
 
 		info->MaxPathNameComponentLength = cpu_to_le32(stfs.f_namelen);
+		/*
+		 * some application(potableapp) can not run on ksmbd share
+		 * because only NTFS handle security setting on windows.
+		 * So Although local fs(EXT4 or F2fs, etc) is not NTFS,
+		 * ksmbd should show share as NTFS. Later, If needed, we can add
+		 * fs type(s) parameter to change fs type user wanted.
+		 */
 		len = smbConvertToUTF16((__le16 *)info->FileSystemName,
 					"NTFS", PATH_MAX, conn->local_nls, 0);
 		len = len * 2;
-- 
2.43.0

