Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173F63A9D8B;
	Sun,  6 Sep 2026 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788718546; cv=none; b=TfDFrl4M9xtP0Rwz4NyrhhlXQKBRUjpCq82+7pYPuPEc4xd8K7lawsLa+GUeeBuE9aGm6Gfzo3qZxGJJgE3w7mbe9Qs+BUk4vSbEg72liabiz3RtVMmWr+tMByGz7WEHZQc/foE+5mKluhDqiG7Z5ebqFXcRJFgzua1fixlQS4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788718546; c=relaxed/simple;
	bh=DwKl/Ybx8U39TXvM8UpOVW0Qi7LK2eu9evJzyiioO8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lR3cKt74SsoMorLAEyDRoHvsqUhzx8DQWhIr3DcXool9aey+HWXfOS/zmKltdKQatE0d1hf9ybnZnkbTyp+kqN6cFrxwObbiBuQoXZFrsZj4Zk6/F0JgAJ4rm3+DKd/Y9HvzUdcuEBYWERgm+YEVv6uzje42WbEvUOf3GOjnSZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=vk9djoA9; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="vk9djoA9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=0gmucofUWueKp4eRQoBCRPC6i/o47qfE7AH8TKwPyXk=; b=vk9djoA9VV8SF2kp9W8RePYVOz
	SXYNxDV/k0iFQNbnHv3rCE0I8RkJLevQkwIL8+jIJ9VQko3GWLSNt3PbUSP1M7bwVEOOVHuSkqv1u
	AC52R9YRYl4YHbvab40NpribqlvajojCeVrC/dHVJGolikastAbxJ2ntn/sVTGgUoF9FyhLRxffg0
	evs5Me+F+Xf9vJOZ7dlIXm8gIFVQlN7MelhkS63/2hfjiE9tiQaEvReR+4Nr1ct5fs4Ctn5sQX7dw
	zuL45VqJsB2d+dPiX9f52zY84YVg+SNL5iHgAnzgxHYtlhwgCZ62tZA9ED5uJ0xQuL/cnysu/q4h2
	NLV+qo1w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3HP4-00000000nxg-1E2d;
	Sun, 06 Sep 2026 15:15:42 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 5/5] smb: client: fix reparse point file type corruption
Date: Sun,  6 Sep 2026 15:15:40 -0300
Message-ID: <20260906181540.647469-5-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906181540.647469-1-pc@manguebit.org>
References: <20260906181540.647469-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wsl_to_fattr() and posix_reparse_to_fattr() set the file type from
reparse point tags (e.g. fattr->cf_mode |= S_IFCHR).  When cf_mode
already has S_IFMT bits set by the caller, this corrupts the file
type.

For example, smb311_posix_info_to_fattr() sets cf_mode via
wire_mode_to_posix() which includes S_IFREG, then calls
cifs_reparse_point_to_fattr().  If the reparse tag indicates a
character device, the result is S_IFREG | S_IFCHR = S_IFLNK,
incorrectly turning the inode into a symlink.

Fix both functions by clearing the S_IFMT bits before the switch
statement, so the reparse point tag can set the correct file type
without interference from previously set bits.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 10ef82d46d86..773ad2e21b47 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1146,6 +1146,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 
+	fattr->cf_mode &= ~S_IFMT;
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;
@@ -1234,6 +1235,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 		return false;
 	}
 
+	fattr->cf_mode &= ~S_IFMT;
 	switch (le64_to_cpu(buf->InodeType)) {
 	case NFS_SPECFILE_CHR:
 		if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8) {
-- 
2.55.0

