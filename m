Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1D1187347;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727560848; cv=none; b=BQ5v49ceOM8iTwRmwCvnG4pF7TO8d0Y0bQ0Jvkqyb0TWtAjwZvJzO16yKzDRPkMfyV/xOkSceEK4eTEu7S+7gsd5QeweLsROF2vX46W1UV4/5vT3TQ6QGVt1P1H1YQHgTtIyskirwrZ22upnoc55h2ui2VaGWOqSJIP7gf4sFO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727560848; c=relaxed/simple;
	bh=Nqkkzjy+oFOwXzYUoBJUIL1MmPuVBHIvi/pv18rAyK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMJc0mf9UsPY6vbT5EbqKW7PF+/zXUGfFeYoDXe90hjkVRss7t7ZOD1tohqYp5y8JSdwc/L02JcVMgadU6BnGcdGyPGsB+4rQ3muQHSvHzIwysvVLvcmPXl+T9geL41SdK3s5cBHdohTf0Pbf3+bHZhIyss3c7dEJg1Sh4vspH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cksvZ6JC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cksvZ6JC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32E8C4CED0;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727560847;
	bh=Nqkkzjy+oFOwXzYUoBJUIL1MmPuVBHIvi/pv18rAyK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cksvZ6JCi5VSD4a7dMInohSiPPyy0WI4KbyeJWJ0sheXwEQCyuKjuV6WT2+4RwOy8
	 S4MoyMnT5rZ+0K7rt8y/nOvzAOXyPaYXHl3F2WUTVhhj+809lSNF9bI5WQ2fn+vCW6
	 z8p9cb5URZdiFSCclJBWL2qKO/em1Q8fk9xYYxz565pq/lB1RYHX88287tSUaE7SBu
	 5AZkYLtmDxCWmhMkNUol1kEINleTnObQpBlibQMij+knFlbPHALcPBDhPxIg2zHUnr
	 KayKqvgXUUSxc6bHLvI3RXx/Px5FDZtg6cEITuUzBNcJQjwNilApDTYAA6X4+Oxolc
	 2n8TrShDFvn5w==
Received: by pali.im (Postfix)
	id 9A42AC7D; Sun, 29 Sep 2024 00:00:41 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] cifs: Validate content of NFS reparse point buffer
Date: Sat, 28 Sep 2024 23:59:47 +0200
Message-Id: <20240928215948.4494-8-pali@kernel.org>
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

Symlink target location stored in DataBuffer is encoded in UTF-16. So check
that symlink DataBuffer length is non-zero and even number. And check that
DataBuffer does not contain UTF-16 null codepoint because Linux cannot
process symlink with null byte.

DataBuffer for char and block devices is 8 bytes long as it contains two
32-bit numbers (major and minor). Add check for this.

DataBuffer buffer for sockets and fifos zero-length. Add checks for this.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index e3cf7ae516cb..35e8f2e18530 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -330,6 +330,18 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 
 	switch ((type = le64_to_cpu(buf->InodeType))) {
 	case NFS_SPECFILE_LNK:
+		if (len == 0 || (len % 2)) {
+			cifs_dbg(VFS, "srv returned malformed nfs symlink buffer\n");
+			return -EIO;
+		}
+		/*
+		 * Check that buffer does not contain UTF-16 null codepoint
+		 * because Linux cannot process symlink with null byte.
+		 */
+		if (UniStrnlen((wchar_t *)buf->DataBuffer, len/2) != len/2) {
+			cifs_dbg(VFS, "srv returned null byte in nfs symlink target location\n");
+			return -EIO;
+		}
 		data->symlink_target = cifs_strndup_from_utf16(buf->DataBuffer,
 							       len, true,
 							       cifs_sb->local_nls);
@@ -340,8 +352,19 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 		break;
 	case NFS_SPECFILE_CHR:
 	case NFS_SPECFILE_BLK:
+		/* DataBuffer for block and char devices contains two 32-bit numbers */
+		if (len != 8) {
+			cifs_dbg(VFS, "srv returned malformed nfs buffer for type: 0x%llx\n", type);
+			return -EIO;
+		}
+		break;
 	case NFS_SPECFILE_FIFO:
 	case NFS_SPECFILE_SOCK:
+		/* DataBuffer for fifos and sockets is empty */
+		if (len != 0) {
+			cifs_dbg(VFS, "srv returned malformed nfs buffer for type: 0x%llx\n", type);
+			return -EIO;
+		}
 		break;
 	default:
 		cifs_dbg(VFS, "%s: unhandled inode type: 0x%llx\n",
-- 
2.20.1

