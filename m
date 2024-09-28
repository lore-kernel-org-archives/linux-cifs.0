Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B277187352;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727560848; cv=none; b=I9spRKOdhIpxo+Q5F34PU3BGB3OuK+8iGYH7HWPsVg9w6p/GWOaUD19HqB8COAi0p5s/jcpdBeAN9WMtPrUHGTO7uCe9HgJR229ZN4pJcEMmVgeKxdeBi2RNq0M5g5JQed1UYAe3nwcnK/TP9G80aPpzBK6P1+tvj9n/Dlg7OhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727560848; c=relaxed/simple;
	bh=a7tslZvUsg1bUvIyZkA6rSXDt4yPUK/VEUdHYfacFAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q7pTYzUXkRqBKogowgnbQUIGwWFc7Q2ReXZ4UFK4qVIc1E/32fkDOpWR1Pab0XKUJ+BAQMbfItfn/6ORvWM7NnCPsrlJrdWNd9GG4e+Y/tFKFlAVt3HMelG1rqf/T7anapiJcykxfeupIs390Z2vpa8Y36tbN5CdM/xlKQ/Ozhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vyq8lk/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vyq8lk/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9904AC4CECD;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727560847;
	bh=a7tslZvUsg1bUvIyZkA6rSXDt4yPUK/VEUdHYfacFAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vyq8lk/4dR8qzyMBTjwabn0ZlQl4ELoGmpHPzWNmlHb0V/afgVtwTVSp3RdlEFyFN
	 Ck/up4CcpXvQl5k/mQOgDqIWmHxUS2MOvOsw0twSJl97kD9Ydi8yKsj3R0ZazfyzaK
	 xua3aF6C1uyhnvlBp1DNkUyO8poyCWvDRGkaPupVBrBV6YYJgqOzRaE15y0enfGqf4
	 dLBd3VTgPvlCRW5YCbIRy9IoOYctG55FkTmxgSm2WzGSpgaau0B9fUEc7Es/tc5UVr
	 nyuPtVCxm82KJO6+Uhard0WJG61L5/C76y+tm0Gi+54FctfAxPOwQNwrrE3hEaoie+
	 oGlaR5V62iS6Q==
Received: by pali.im (Postfix)
	id 2C290BA8; Sun, 29 Sep 2024 00:00:41 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Sat, 28 Sep 2024 23:59:45 +0200
Message-Id: <20240928215948.4494-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240928215948.4494-1-pali@kernel.org>
References: <20240928215948.4494-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
large enough. Check for reparse buffer size in reparse_nfs_mkdev().

Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 11 ++++++++++-
 fs/smb/client/reparse.h |  3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 63984796721a..af32a7dbca4b 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -320,9 +320,16 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 	unsigned int len;
 	u64 type;
 
+	len = le16_to_cpu(buf->ReparseDataLength);
+	if (len < sizeof(buf->InodeType)) {
+		cifs_dbg(VFS, "srv returned malformed nfs buffer\n");
+		return -EIO;
+	}
+
+	len -= sizeof(buf->InodeType);
+
 	switch ((type = le64_to_cpu(buf->InodeType))) {
 	case NFS_SPECFILE_LNK:
-		len = le16_to_cpu(buf->ReparseDataLength);
 		data->symlink_target = cifs_strndup_from_utf16(buf->DataBuffer,
 							       len, true,
 							       cifs_sb->local_nls);
@@ -482,6 +489,8 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	u32 tag = data->reparse.tag;
 
 	if (tag == IO_REPARSE_TAG_NFS && buf) {
+		if (le16_to_cpu(buf->ReparseDataLength) < sizeof(buf->InodeType))
+			return false;
 		switch (le64_to_cpu(buf->InodeType)) {
 		case NFS_SPECFILE_CHR:
 			fattr->cf_mode |= S_IFCHR;
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 790360f8a53b..5be54878265e 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -22,6 +22,9 @@ static inline dev_t reparse_nfs_mkdev(struct reparse_posix_data *buf)
 {
 	u32 major, minor;
 
+	if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 2*sizeof(__le32))
+		return 0;
+
 	major = le32_to_cpu(((__le32 *)buf->DataBuffer)[0]);
 	minor = le32_to_cpu(((__le32 *)buf->DataBuffer)[1]);
 
-- 
2.20.1

