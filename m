Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C375F3B5319
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927390; cv=none; b=E/IeyLf/cbwBTUWTEgO4Ww7eg38skCB0GQWHCNPsFvBAqBGtkP9EdSF4rZ5wei9X+BRASqg8BlwcTwKJI0/ph6nOkZUBMJ/J4a389fHu6M+9hm3czNG9HenyAX4cjQAgs5uUeQpHUJK3kMogCgaxa4zblO0CgRn9Q9DHbzWCsgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927390; c=relaxed/simple;
	bh=Q+pMljTG72dS49IpgSsdzbQaS3tGbBPqGVyiRSfAaLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th533Qio8oXMHcByLiB1N5dw4jLzlOz8JW7rLp/iKSVaJh85JWL/UIAHJNdRMYxEXPMFAWzkKD5iaMiWe18g+QhdIK3noo/sKN2NnJ/3fgwxnOFau6lTYx+/3P5d7KlrzV68+UPR1F7lW5AoOxNPI+W09SAKginTWXgpGobFWxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=dSiuubeM; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="dSiuubeM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780927387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxS8o5tC14XIr+IHqe9NYO9AE4Y5JaFgIw5hE065EHk=;
	b=dSiuubeMeC7nlTw8CoIUleDJIN68SkF6tqXPDlguFBgiYueQXec8H5LDuNshXW/oV6Ib3g
	vnaZ8couKf2lzNsRMvTm9O7S/Oiryzt7lF1LosE5EiEJsOOGQ5uKdxyfWJ22+VBVG9XJbv
	9Ii30ZCP9fhLxKmxeBcqqwgZbluHUIgUTyTy9r5fJhD59YfPQiUjFaONB33aoHKFfCaqK6
	yOopWXYGYG1a7VISCdpL2w2rjQwakwdbxVOvDG9x1ue2joRbReqhDxH1Lt/Nome0pTWlID
	1/th0rGmC/1ylmYKIHDlbX8lP8CFE2Ro8q23cycMkVwPGzkrRHr+R/uwmgcr0w==
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
Subject: [PATCH v3 7/7] smb/server: fix incorrect file size in get_file_compression_info()
Date: Mon,  8 Jun 2026 14:01:28 +0000
Message-ID: <20260608140128.387844-8-chenxiaosong@chenxiaosong.com>
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

Before this patch, we got the wrong file size:

  - client: touch /mnt/file
  - client: smbinfo setcompression default /mnt/file
  - client: dd if=/dev/zero of=/mnt/file bs=1 count=1000
  - client: smbinfo filecompressioninfo /mnt/file
            Compressed File Size: 4096
            Compression Format: 2 (LZNT1)

After this patch, we get the correct file size:

  - client: smbinfo filecompressioninfo /mnt/file
            Compressed File Size: 1000
            Compression Format: 2 (LZNT1)

Note that the actual compressed file size must be got by other methods.
For Btrfs, use the following command to get actual compressed file size:

  - server: compsize /export/file
            Processed 1 file, 0 regular extents (0 refs), 1 inline.
            Type       Perc     Disk Usage   Uncompressed Referenced
            TOTAL        4%       47B        1000B        1000B
            zlib         4%       47B        1000B        1000B

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7150e77ff113..5781695d1094 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5291,7 +5291,7 @@ static int get_file_compression_info(struct smb2_query_info_rsp *rsp,
 		return ret;
 
 	file_info = (struct smb2_file_comp_info *)rsp->Buffer;
-	file_info->CompressedFileSize = cpu_to_le64(stat.blocks << 9);
+	file_info->CompressedFileSize = cpu_to_le64(stat.size);
 	file_info->CompressionFormat = cpu_to_le16(fmt);
 	file_info->CompressionUnitShift = 0;
 	file_info->ChunkShift = 0;
-- 
2.54.0

