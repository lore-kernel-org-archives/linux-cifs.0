Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73D018D625;
	Mon, 25 Nov 2024 08:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732524526; cv=none; b=RoBnrzZjBE/WNnNwzMCezQOQ6XvKIALUWTESGLy/vhadI6d1bHbbDUXHykpUUwi9Z9bKXQmq++FGW9haqbaMSt3G1QeTSdBO7qnBxKwqfs3xQVnpCDw2EDS3F8GhBzShB9SRY9aM0O2LhF/e2xCb33q1gr5IPlULitZMegwoIVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732524526; c=relaxed/simple;
	bh=3YvzipYPfFV2jakg8Fbc4WUvkV05uL4Efwwq/PdVlgY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jkbpzwLIh5yvYSh67oraGWcG++eOoY1zEa60MrEKF3kx/cRFLpc/XHhMx6x1n3jNA1cJkBpY+BARJT7r0qZE3vF4mcKOdzeCicPa3uKn5rtCWnHlwksWeANze2CRMDeIP7ZndqXHP5hW1XAEfAhUQD+o9I3wmzAf3mJ+1wUjnvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=H+I3Kh2f; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="H+I3Kh2f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732524525; x=1764060525;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RTIdgc7sp/gKbDjV0AoVhb8dJtmhr23ne5FndD+qA9U=;
  b=H+I3Kh2fOPL4d28xypcM/6bKe8iH/m752S5ywEKWx1CinvHrjwWQjUSg
   jtcVTmv4FUCe3jthysunm8O2i5Ryxi73RJh8XArmpBo7f/5IEBSayUZCz
   NLGuBLvErmJuZP6vn6i/YHPGTxA2T+8GenolvuTiLE6ZOZfoZjlI0GKnN
   g=;
X-IronPort-AV: E=Sophos;i="6.12,182,1728950400"; 
   d="scan'208";a="249870923"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.124.125.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 08:48:42 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.29.78:52933]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.94.204:2525] with esmtp (Farcaster)
 id 52a63683-a512-4aba-b635-6b7f431ebefb; Mon, 25 Nov 2024 08:48:42 +0000 (UTC)
X-Farcaster-Flow-ID: 52a63683-a512-4aba-b635-6b7f431ebefb
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 25 Nov 2024 08:48:38 +0000
Received: from email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com
 (10.124.125.6) by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 25 Nov 2024 08:48:38 +0000
Received: from dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com [10.15.1.225])
	by email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com (Postfix) with ESMTP id 4366240392;
	Mon, 25 Nov 2024 08:48:38 +0000 (UTC)
Received: by dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (Postfix, from userid 23907357)
	id 021D71E9C; Mon, 25 Nov 2024 09:48:37 +0100 (CET)
From: Mahmoud Adam <mngyadam@amazon.com>
To: <gregkh@linuxfoundation.org>
CC: <stfrench@microsoft.com>, <pali@kernel.org>, <stable@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>
Subject: [PATCH v2 6.1] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Mon, 25 Nov 2024 09:48:01 +0100
Message-ID: <20241125084801.83439-1-mngyadam@amazon.com>
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
https://lore.kernel.org/stable/Z0Pd9slDKJNM0n3T@ca93ea81d97d/T/#m8cdb746a2527f2c27c95c9b2b25b5cc8f20ce74a
 fs/smb/client/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d1e5ff9a3cd39..fcfbc096924a8 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2897,6 +2897,12 @@ parse_reparse_posix(struct reparse_posix_data *symlink_buf,
 
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

