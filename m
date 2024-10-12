Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C58B19F43A;
	Sat, 12 Oct 2024 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728732410; cv=none; b=qVWq7UqZCv8T8y8VQca2vlbn1Jpvg0OZkd3Mu9+k0pKAUIpFHVbwO2BaiHLxrrYOljVCx+ZwBIYfDh13KXtQxDRDe9EpEGnoQ0g+mD0Mdis+wjChCFSkN+AdUSZ0miNHQLGj8bce4F1W1+BB/g/MzV/qPMXcu6srmBkTAwnTmS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728732410; c=relaxed/simple;
	bh=n4puN3NXxZUnE6ck5tpzUeGwM7AWiitHgrBK4NNHBgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=faRMBrlkONQIT8qp3OOLwADzGdKYe+ClBb/yaPqDai8JFK5U+ryFbJ3mE/VW3kcElNAk9RwIwN7VJZZ+RXM5WWEOHjlURt0/BsE0loWjDJ1sjEyulfdB7C61Q62o6STERAk3f8jAxl8EDYjOUVkWZ/T6IuFMyie8RcgKWTy3llg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r8u6zS9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8u6zS9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8225C4CEC7;
	Sat, 12 Oct 2024 11:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728732409;
	bh=n4puN3NXxZUnE6ck5tpzUeGwM7AWiitHgrBK4NNHBgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8u6zS9hHHYK12h5Y8tSgI//y7Rq4/RWFiyKI7Svl0f+Bf2caHlPu0ZTf7CYa61f+
	 aZK9c8cRj7MAoULASHKqrG0tdy1FsQNXEoyLowAh1Ld46x97pq5B33+GbqG+Y/9tFC
	 Hf/TBoaSE7g/JuswJr1BNicfmSucnWaJckI1fQjZ3vxrGSyrJvDRDxrErOsClBW8iQ
	 fFhWDVsG0u2xRPJfDHaGSuk8lx1sen9HFgik/0qxShO6Chilo0Rvjda4ZoIXkCYGao
	 tH6UeYBzwJ9G/i16p9sU3kxWXLNAvAAe4rlZcYqy7zUYpiyZrFtcP3IHTgi77bBb8m
	 3xZFD8O/I2NZA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.11 15/16] cifs: Validate content of NFS reparse point buffer
Date: Sat, 12 Oct 2024 07:26:11 -0400
Message-ID: <20241012112619.1762860-15-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241012112619.1762860-1-sashal@kernel.org>
References: <20241012112619.1762860-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.3
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 556ac52bb1e76cc28fd30aa117b42989965b3efd ]

Symlink target location stored in DataBuffer is encoded in UTF-16. So check
that symlink DataBuffer length is non-zero and even number. And check that
DataBuffer does not contain UTF-16 null codepoint because Linux cannot
process symlink with null byte.

DataBuffer for char and block devices is 8 bytes long as it contains two
32-bit numbers (major and minor). Add check for this.

DataBuffer buffer for sockets and fifos zero-length. Add checks for this.

Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index ad0e0de9a165d..7429b96a6ae5e 100644
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
2.43.0

