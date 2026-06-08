Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2924A3C343E
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927385; cv=none; b=IP6eKaizUAa295TaTwD/CEZeq/XRrQ15jJ/rnxeIOvyfEsAXGpcQPLwFFzRFK6qQNeKWRzd44/AMIYq7SfN6CKVx38g0hGP0jreeSXRTXRhVzjER7+MuHDfAtPfALM41tNY905cD89QR0gN6CvPq+DxPKEK7CnLpMX5qNnGlb48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927385; c=relaxed/simple;
	bh=oZQP6uqLA26ybG0sLT3Y8E/G51hd0/A64br44xYf8iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7ufnonff+MgsiELPcdGgjkFDwIHMcwDx72FtR2Ek4gJ7m01dWkSOzHnzxyHaStf5vt/TiEt3oUW1eSz/P9lrxZc1Hm8fh3quA/u63X6xpL528d/CPS6EkuH+IyAq3PlPeFR9LyTdKv5HU8O0A0QdszJNJvIU+NkpD+sl6GIu44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=REAcFt18; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="REAcFt18"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780927381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KLtITZRyqzSX8882p9s1OjR3959PaZgD7R/HSnHFbZM=;
	b=REAcFt18V66u2cG2T03tsUms2dtqalQKUIlX8eXd2/D8UIo7llqt+kzoFizBTl5YzB6ERA
	KS9AAfBk2Fi5HjoBrR8wSc0bkJUVb8sbNQ3848FkIoyVjpT4C//Wciyd0LBSnOLqhzf8lg
	DGu1B8gg9VAuEzn76vn6W1wPWi1MAuW8y9+ejnotUsfthWVE8AZ1uPHw0L2/Tky6E3z18H
	mY8vZZGsXS1+Fnzu/XgfDvy2huDIj9U7lM4PftqfOUZEJZsKlSh/TCJNC5hfp/XW2UBQAY
	VJDF1i/Eoa59osAeyklmyQhBd3J8nga5I6POLApPV4lPRCxegda0dodisT1YfA==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 6/7] smb/server: get compression format in get_file_compression_info()
Date: Mon,  8 Jun 2026 14:01:27 +0000
Message-ID: <20260608140128.387844-7-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
References: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I have added `filecompressioninfo` subcommand to `smbinfo`
in cifs-utils.git.

Example:

  1. client: smbinfo setcompression lznt1 /mnt/file
  2. client: smbinfo filecompressioninfo /mnt/file
             Compressed File Size: 104857600
             Compression Format: 2 (LZNT1)
             Compression Unit Shift: 0
             Chunk Shift: 0
             Cluster Shift: 0

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2b67c5926c67..7150e77ff113 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5278,6 +5278,7 @@ static int get_file_compression_info(struct smb2_query_info_rsp *rsp,
 {
 	struct smb2_file_comp_info *file_info;
 	struct kstat stat;
+	u16 fmt;
 	int ret;
 
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
@@ -5285,9 +5286,13 @@ static int get_file_compression_info(struct smb2_query_info_rsp *rsp,
 	if (ret)
 		return ret;
 
+	ret = ksmbd_vfs_get_compression(fp, &fmt);
+	if (ret)
+		return ret;
+
 	file_info = (struct smb2_file_comp_info *)rsp->Buffer;
 	file_info->CompressedFileSize = cpu_to_le64(stat.blocks << 9);
-	file_info->CompressionFormat = COMPRESSION_FORMAT_NONE;
+	file_info->CompressionFormat = cpu_to_le16(fmt);
 	file_info->CompressionUnitShift = 0;
 	file_info->ChunkShift = 0;
 	file_info->ClusterShift = 0;
-- 
2.54.0

