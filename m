Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939AE111A8;
	Fri, 22 Nov 2024 13:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732283150; cv=none; b=d+rPyZZtf426YheZDi/RtgQFl7LBHuKfSkYBFPEpIOBPN76RoBo8hUo0OHvltd2C4rPrS2ZaM7y0QT+VrEm/E/UDFbu+RytfNgv8VA6Kc9bq5pU6iLTt597DE1Z57v1Kci/8qc/kJp5vfBIMzl5yQClpHZtVJcjEhIbqBZh5ahM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732283150; c=relaxed/simple;
	bh=kVpFUw6KeqcfmPYVy+7qxqMon3nw6htHv56/6qvCofo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UwW3+UUIYpl8cYZhpOf4wAgAT3Gjq/vcQipXphlRgIt/qT7EMw3SHHk7xmlDlFVF6n3gYYULbhyhgqLchVa8dQV+JEF47wh5X/xPpxDKMchtRsMFpa0uayH1WzM2DJKIczO342k+5QKbswVFbcMfw7RbvjWLAzF/VHWZgKc+DYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=A1MXhXFy; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="A1MXhXFy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732283149; x=1763819149;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fyRPteTtuIqO8RufMBd/o0y8qtgzhVZbNPraZqKm98A=;
  b=A1MXhXFyM3KGWCVRKzwgOk/pdJmkDrZ4ikl584qagTX0FfK+6ttabKb3
   Ct6yFcfbueQ3Jr0YNTPgrhWT3IyQDvR+zO+HPRmJyC2/s9sTfcKl7Olor
   E3Wy/yLwxO9edu53x9/Vr0yVujWDWf8KR/DB/HF2sos/5Ai9eMXJGOoXu
   4=;
X-IronPort-AV: E=Sophos;i="6.12,175,1728950400"; 
   d="scan'208";a="675847250"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 13:45:46 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:65313]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.32.230:2525] with esmtp (Farcaster)
 id 86c97e87-f85a-4479-878f-b803a8007714; Fri, 22 Nov 2024 13:45:44 +0000 (UTC)
X-Farcaster-Flow-ID: 86c97e87-f85a-4479-878f-b803a8007714
Received: from EX19EXOUWA001.ant.amazon.com (10.250.64.209) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 22 Nov 2024 13:45:44 +0000
Received: from EX19MTAUWA002.ant.amazon.com (10.250.64.202) by
 EX19EXOUWA001.ant.amazon.com (10.250.64.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 22 Nov 2024 13:45:44 +0000
Received: from email-imr-corp-prod-pdx-all-2b-a57195ef.us-west-2.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Fri, 22 Nov 2024 13:45:44 +0000
Received: from dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com [10.15.1.225])
	by email-imr-corp-prod-pdx-all-2b-a57195ef.us-west-2.amazon.com (Postfix) with ESMTP id 4E2DEA06EA;
	Fri, 22 Nov 2024 13:45:44 +0000 (UTC)
Received: by dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (Postfix, from userid 23907357)
	id D4BEB23F5; Fri, 22 Nov 2024 14:45:43 +0100 (CET)
From: Mahmoud Adam <mngyadam@amazon.com>
To: <gregkh@linuxfoundation.org>
CC: <stfrench@microsoft.com>, <pali@kernel.org>, <stable@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>
Subject: [PATCH] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Fri, 22 Nov 2024 14:44:10 +0100
Message-ID: <20241122134410.124563-1-mngyadam@amazon.com>
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

upstream e2a8910af01653c1c268984855629d71fb81f404 commit.

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
This fixes CVE-2024-49996, and applies cleanly on 5.4->6.1, 6.6 and
later already has the fix.
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

