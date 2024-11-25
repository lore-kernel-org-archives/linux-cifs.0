Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACE2179BF;
	Mon, 25 Nov 2024 08:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732524093; cv=none; b=uVHzPwZmO2/Q505PEql8bj/oMJAdDqr/s5tv8Xl989s9Nvb4XLmA/GYyhr3bupOI7kU7GTc6DlTFMOaLhLjEgw3IUI86xqK3YhJtODksEy+uJMxxOBt3T7Wwn692H0MMdcQmAIUy1lUCDuoXGmu0NWq/vLapZZBs0q8aL7d+JT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732524093; c=relaxed/simple;
	bh=3T6wgIrtuiRWw7EoFb20kXZQJ1caKbCaJ71YfjsVk7E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kFm8DRXMUACCKn2dGuFB3o9Zott7gZjVVmCfGShHKz25Mf0Mddi+TLq59UWPTUy4C3TOslOCErYSD2OOkTmZTXoTH1xZIIGxye0xTwOftD06MbmjZJrJ2a19akS3ovgwy2U2oHRljaJ/qjdfhibjtPRe+n/3WblG/TdHzG4s2sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=on15LCS4; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="on15LCS4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732524091; x=1764060091;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HIxuupV+WIZ/50YA4RoxsZxMsMbAaazIS0w8AgGH/ew=;
  b=on15LCS4GH4paOobouIVheBfqc2hFww2osXt80trIXRZ+ERoF+32Vf53
   JwiP4qn6id0a+9ds1Up/E4UVoy6+DLpX538n34cN24eiRrhabrNEQGlsG
   HHOcuA3Ty83bohyR2XH5stz0E4+bk1FeruDCLLyY0aMNtXoMd9LaLAwzr
   M=;
X-IronPort-AV: E=Sophos;i="6.12,182,1728950400"; 
   d="scan'208";a="698007083"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 08:41:27 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:40094]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.2:2525] with esmtp (Farcaster)
 id f3feb54d-e4e8-4cbd-9b31-f8d18bc89e02; Mon, 25 Nov 2024 08:41:27 +0000 (UTC)
X-Farcaster-Flow-ID: f3feb54d-e4e8-4cbd-9b31-f8d18bc89e02
Received: from EX19EXOUWB001.ant.amazon.com (10.250.64.229) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 25 Nov 2024 08:41:27 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19EXOUWB001.ant.amazon.com (10.250.64.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 25 Nov 2024 08:41:26 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 25 Nov 2024 08:41:26 +0000
Received: from dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com [10.15.1.225])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTP id 2A088401E7;
	Mon, 25 Nov 2024 08:41:26 +0000 (UTC)
Received: by dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (Postfix, from userid 23907357)
	id D95902BEC; Mon, 25 Nov 2024 09:41:25 +0100 (CET)
From: Mahmoud Adam <mngyadam@amazon.com>
To: <gregkh@linuxfoundation.org>
CC: <stfrench@microsoft.com>, <pali@kernel.org>, <stable@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>
Subject: [PATCH v2 5.4/5.10/5.15] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Mon, 25 Nov 2024 09:37:46 +0100
Message-ID: <20241125083746.74543-1-mngyadam@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

commit e2a8910af01653c1c268984855629d71fb81f404 upstream.

ReparseDataLength is sum of the InodeType size and DataBuffer size.
So to get DataBuffer size it is needed to subtract InodeType's size from
ReparseDataLength.

Function cifs_strndup_from_utf16() is currentlly accessing buf->DataBuffer
at position after the end of the buffer because it does not subtract
InodeType size from the length. Fix this problem and correctly subtract
variable len.

Member InodeType is present only when reparse buffer is large enough. Check
for ReparseDataLength before accessing InodeType to prevent another invalid
memory access.

Major and minor rdev values are present also only when reparse buffer is
large enough. Check for reparse buffer size before calling reparse_mkdev().

Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[use variable name symlink_buf, the other buf->InodeType accesses are
not used in current version so skip]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
---
v2: fix upstream format.
https://lore.kernel.org/stable/20241122152943.76044-1-mngyadam@amazon.com/
 fs/cifs/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9ec67b76bc062..4f7639afa7627 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2807,6 +2807,12 @@ parse_reparse_posix(struct reparse_posix_data *symlink_buf,
 
 	/* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
 	len = le16_to_cpu(symlink_buf->ReparseDataLength);
+	if (len < sizeof(symlink_buf->InodeType)) {
+		cifs_dbg(VFS, "srv returned malformed nfs buffer\n");
+		return -EIO;
+	}
+
+	len -= sizeof(symlink_buf->InodeType);
 
 	if (le64_to_cpu(symlink_buf->InodeType) != NFS_SPECFILE_LNK) {
 		cifs_dbg(VFS, "%lld not a supported symlink type\n",
-- 
2.40.1

