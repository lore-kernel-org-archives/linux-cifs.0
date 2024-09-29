Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE32D143C49;
	Sun, 29 Sep 2024 10:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727605401; cv=none; b=msSsC30sfisG6ukC6MtWGl923JLapl1Y2IPtyK+/kyjB59tdfvNZQT85pF5/2Hcy6fyDK5oyV6yuqX/Gns+KWW6SIkeGoUtLrTS9p5I2f9Ejm6y4FPy7VS4m0SaE7AQpje3wyxbMwU5CgUeI45Z+b9uwJHQfpxyHrNfs1N0EUu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727605401; c=relaxed/simple;
	bh=UaGWP+4zjs3M99pVvwXMDrjAFXcpY/KbRidia/d7VM4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J8tYj9suRSs2Vv/Wecbw0lIM7ceu53baK4EvV83CAEpIQNncp7HStz7cMH/U4i4rsO2QY5rf0W7F5HF+87Zb3+1zIOyTQcaTkKgV6mLMQwSD6CdtZBKHwquWiVWbf3yl/KpNRpUFSSFFhIQrVQQSi/8x6D8fvxpToVa7weK/nxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDDRE2pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDDRE2pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E85C4CEC5;
	Sun, 29 Sep 2024 10:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727605401;
	bh=UaGWP+4zjs3M99pVvwXMDrjAFXcpY/KbRidia/d7VM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDDRE2pkSRpQnuY2fDWuudPg2NH/QinrS5XvIqFFvljt8BinGFZ03larlor5Y1gEz
	 v5CTHKb8deOEoK6qC1yc/XDHFY2ABrlqxy3mdXGZxdHd81QJdQOcybhBAb83MoAQnZ
	 swB6EM2j4fIq0Qk3Np3xka7e78x0ihHq69JxRd9xJ0DCxwEQWIFXUxRc9OP3yEL/x/
	 miv4tQM43a5Y+PSG3h8F+YnyZXy6cXH59yyI8HDG6I1Fc2paMW2W/aTb8Cvh8Vyozn
	 WK/cqJvo4YdcRwJ/27gIyobkrjow1ycFhUKIePa0Ra84zJTzD93vzgXvK+2m8YUnuS
	 0VF1I6IWPIWSA==
Received: by pali.im (Postfix)
	id 13C9D872; Sun, 29 Sep 2024 12:23:15 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Sun, 29 Sep 2024 12:22:40 +0200
Message-Id: <20240929102240.7016-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240928215948.4494-6-pali@kernel.org>
References: <20240928215948.4494-6-pali@kernel.org>
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
large enough. Check for reparse buffer size before calling reparse_mkdev().

Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
Changes in v2:
* Rebased on top of cifs-2.6 for-next (e5113352e8739469445b2211e809ac937f132aa9)
---
 fs/smb/client/reparse.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 0ad94d1cb57c..11cebb320012 100644
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
@@ -481,12 +488,18 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	u32 tag = data->reparse.tag;
 
 	if (tag == IO_REPARSE_TAG_NFS && buf) {
+		if (le16_to_cpu(buf->ReparseDataLength) < sizeof(buf->InodeType))
+			return false;
 		switch (le64_to_cpu(buf->InodeType)) {
 		case NFS_SPECFILE_CHR:
+			if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8)
+				return false;
 			fattr->cf_mode |= S_IFCHR;
 			fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 			break;
 		case NFS_SPECFILE_BLK:
+			if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8)
+				return false;
 			fattr->cf_mode |= S_IFBLK;
 			fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 			break;
-- 
2.20.1

