Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392982E7F25
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jun 2026 02:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781663894; cv=none; b=PcjTF0Axw/+HxSkCDJ6XWsEDBvBpOixg+xoyLlx/AgLo8qBuFg1SF9PfLZDN4aGAXqdFdytuffCb0SocPw6vI8OjthaoTFeTsp+cNO5FE9BsEavRiTBynhcCa8chgDl1JiCh0vJYecghcIr8WJvxaBsa59gAkbA7cnAV2UROEp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781663894; c=relaxed/simple;
	bh=KZBEppmyGVvT72hBYFPBB9Q4v8YH1polMReAJA2fZFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jv2FsizDMhdqOMO3+vTCYChYRsm7/pJ7DzowT087kdsBULJd1L068oL7r0f5GwTNkCvUD+zZP0xRXBa4nD7Nt4E+z+7K5QUuAhnVBhPIV6OuFGMHI+oQe6fOaw1qAgFKH9ynC8j6dyh87BBic1CSW9i6Rj9+00os+HmrijYL4u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=h5QiIpLO; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="h5QiIpLO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781663887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g6hylRYbGtxM9p8XQpOabvI9cMsR2RwUrN2BxEZWCDQ=;
	b=h5QiIpLOckQ7YY0layQ8nRSbHfLnIOAgbDLRla/TZeiFYEr4mvcNuBfQkMyWRy0NYFkFjW
	SKjqRQj0SptM04Lh2Y4C/YDWmxnF1zvY+C4TxzQLOFbYr7aPHFprc3N1jsFSk+FS8YBo8V
	X1VulYYzeQVwKgZMhCYU+ht/J3l70TD4YRcxA5VR6XksCauHlx4YZfJ1pDAEyFtogXSnhA
	SpcjYeNghAmrssRZO/QLUkSIp0wQM0ZXwmAeXprfnM8e4uO8aYKknv0+rWmDpZmMqQyEvV
	FIApF2JP7IqBVceWzOBc30fDzkJiRX7JAB6gVBb2/CWwXy0OaM/K74taqqClcQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
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
Subject: [PATCH] smb/server: fix debug log endianness in smb2_cancel()
Date: Wed, 17 Jun 2026 02:36:32 +0000
Message-ID: <20260617023632.122384-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Convert to CPU byte order to avoid incorrect debug log
on big-endian architectures.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 852236043bc6..13c5b0c6e65c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7435,7 +7435,8 @@ int smb2_cancel(struct ksmbd_work *work)
 		hdr = ksmbd_resp_buf_next(work);
 
 	ksmbd_debug(SMB, "smb2 cancel called on mid %llu, async flags 0x%x\n",
-		    hdr->MessageId, hdr->Flags);
+		    le64_to_cpu(hdr->MessageId),
+		    le32_to_cpu(hdr->Flags));
 
 	if (hdr->Flags & SMB2_FLAGS_ASYNC_COMMAND) {
 		command_list = &conn->async_requests;
-- 
2.54.0

