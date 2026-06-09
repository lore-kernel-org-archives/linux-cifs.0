Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AA01632E7
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 06:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780985500; cv=none; b=Cr+yoXiW64J1+PNuLdlAfkrNx6VnRF0gX/kuO3F2Od28uvvlC4AJqy3jHgg3Ka5wF5KwMkeOm7RXKD5q8E3i/pm08rDAGuppk7yqNRo763QSK/XztY5+xDWsWcSnHPPQDaCNSRhOEGl4clxHAMRNHoB3v5/ype/t2qzo9rdApNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780985500; c=relaxed/simple;
	bh=2ePXOl8ifBPomToxRuvDNDQXdcyzEIaw/Rz8HKO80BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpPE5HsbdgjMrSH20nssM4V2+AdaRu7olQCCw3iVCImPaI/YV/YADrXCZjuW2LEUY/VUMM661vS30vnRQBzr+MqkBqkF3DTXezh9ESUEMgRDfY6Rg4WAMEIofw7CGRmozL5usBAnAUmZs2Kks6lBcBig0ihyyyEwQ93NTLWrEjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=G6Zq2gXw; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="G6Zq2gXw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780985496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jMBPcE24goYV+HuHi6ppA1c9+dVv4myvatW9UE+pbN8=;
	b=G6Zq2gXwjNPEJeQGJl5d8ahg7NLTrAKbzwykePWXqMhHT10aUMxdlo6CQ+gFLcd9oHf3c/
	in6xnVEdBF21n5dRSwZeFlka3LtpThFWXM74/52yWjljfrGWQ8IkgDuvhnUhDzqsc32+xb
	g1ypTJMs7VI6SOXHupglxPyUGmvmEREVUYfpPfXfI1GPjLOyDMT6BUyZfkz+1s+3ENz0DK
	MWlT6m9Z6FabvMNHizkpR3wjF6fHWJ4NNP51OVl9TDfOdq3dVg3q5cRmxWzA/aePJNAVew
	95eV6KNEfzYcJOvjHe51doNCNmey+whcXOVqEXI6FZxAbg39J2a2DQxBLYqzdg==
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
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 1/1] smb/server: fix incorrect file size in get_file_compression_info()
Date: Tue,  9 Jun 2026 06:10:28 +0000
Message-ID: <20260609061028.402886-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260609061028.402886-1-chenxiaosong@chenxiaosong.com>
References: <20260609061028.402886-1-chenxiaosong@chenxiaosong.com>
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
index 7150e77ff113..464117b27f24 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5291,7 +5291,7 @@ static int get_file_compression_info(struct smb2_query_info_rsp *rsp,
 		return ret;
 
 	file_info = (struct smb2_file_comp_info *)rsp->Buffer;
-	file_info->CompressedFileSize = cpu_to_le64(stat.blocks << 9);
+	file_info->CompressedFileSize = cpu_to_le64(min_t(u64, stat.blocks << 9, stat.size));
 	file_info->CompressionFormat = cpu_to_le16(fmt);
 	file_info->CompressionUnitShift = 0;
 	file_info->ChunkShift = 0;
-- 
2.54.0

