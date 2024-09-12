Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59781A2567;
	Thu, 12 Sep 2024 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142761; cv=none; b=fAFE5Ha6eE9kRXG3DQs2JqJwdipgtwdb5gIrhPvU6YFkh1xS3K0XTf53WmhT1yaT+h8VWFUVPAMwN8BviRZAThA+QXU6WCLyLa9Hy05m35WkLYwJaHvTcOnkNWijHeevq8La9hvHT0jnCjuxeG94XG+bBVQJP0jxi6Xfxmrek9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142761; c=relaxed/simple;
	bh=s9pzhGr6IQGirw9NZ/o8ju+Zf44+KXPQ4IDwtq5jQBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQHDXjE9QdFH2qqcF//iNL2dbhnbg99lds/Em7w5wQTCQ58J3IRnrLh41LvxNdJqO+mnXMx/RnYn1cBAz/iWfkoUYXUucopHWi1tyKh3NLg/SSwanjEbiPaiSVdT3WycIvvY9E1uBQY1QBl1VhSAKYSRY2MKFZrkx4JtN8YHfPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AckGn0sZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AckGn0sZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6986C4CECC;
	Thu, 12 Sep 2024 12:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726142760;
	bh=s9pzhGr6IQGirw9NZ/o8ju+Zf44+KXPQ4IDwtq5jQBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AckGn0sZ7z2uXuN0jwwS7x3sc/uC2d7+DnySKDz9N1hsWwQJvTV00zgxXi6oi5IU3
	 GA+71ABPYO/XBPiHvSD+K8Sk11QeHnWjKWfm+PD7qQGpngA4BCtZaijOUlgdXKwV+R
	 GnvZhD/kYDxwIXk0zSYek1/3igDYYF3IT/yMTdijzLsOpT/N/BM48Rfkb7ZMy6uR8D
	 ZqAUuLcTLIooDGR/fJtxGx3P0xlOGd7nWmHqwBjFl6oI0uXEdEVRgKDduykzdcl4CR
	 dqvUIv3zuOJthCKnjuZLKS1SXCA8RsvpFebmhq4R65LMFrWdIUXV9MxtHVMv8L3V4+
	 5a7BRb+dEaiwg==
Received: by pali.im (Postfix)
	id 31B80A4E; Thu, 12 Sep 2024 14:05:55 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] cifs: Add support for reading SFU symlink location
Date: Thu, 12 Sep 2024 14:05:43 +0200
Message-Id: <20240912120548.15877-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912120548.15877-1-pali@kernel.org>
References: <20240912120548.15877-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently when sfu mount option is specified then CIFS can recognize SFU
symlink, but is not able to read symlink target location. readlink()
syscall just returns that operation is not supported.

Implement this missing functionality in cifs_sfu_type() function. Read
target location of SFU-style symlink, parse it and fill into fattr's
cf_symlink_target member.

SFU-style symlink is file which has system attribute set and file content
is buffer "IntxLNK\1" (8th byte is 0x01) followed by the target location
encoded in little endian UCS-2/UTF-16. This format was introduced in
Interix 3.0 subsystem, as part of the Microsoft SFU 3.0 and is used also by
all later versions. Previous versions had no symlink support.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 7d424e769a56..e8567ed63f22 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -529,6 +529,8 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 	struct cifs_fid fid;
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
+	char *symlink_buf_utf16;
+	unsigned int symlink_len_utf16;
 	char buf[24];
 	unsigned int bytes_read;
 	char *pbuf;
@@ -616,6 +618,33 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 			cifs_dbg(FYI, "Symlink\n");
 			fattr->cf_mode |= S_IFLNK;
 			fattr->cf_dtype = DT_LNK;
+			if ((fattr->cf_eof > 8) && (fattr->cf_eof % 2 == 0)) {
+				symlink_buf_utf16 = kmalloc(fattr->cf_eof-8 + 1, GFP_KERNEL);
+				if (symlink_buf_utf16) {
+					io_parms.offset = 8;
+					io_parms.length = fattr->cf_eof-8 + 1;
+					buf_type = CIFS_NO_BUFFER;
+					rc = tcon->ses->server->ops->sync_read(xid, &fid, &io_parms,
+									       &symlink_len_utf16,
+									       &symlink_buf_utf16,
+									       &buf_type);
+					if ((rc == 0) &&
+					    (symlink_len_utf16 > 0) &&
+					    (symlink_len_utf16 < fattr->cf_eof-8 + 1) &&
+					    (symlink_len_utf16 % 2 == 0)) {
+						fattr->cf_symlink_target =
+							cifs_strndup_from_utf16(symlink_buf_utf16,
+										symlink_len_utf16,
+										true,
+										cifs_sb->local_nls);
+						if (!fattr->cf_symlink_target)
+							rc = -ENOMEM;
+					}
+					kfree(symlink_buf_utf16);
+				} else {
+					rc = -ENOMEM;
+				}
+			}
 		} else if (memcmp("LnxFIFO", pbuf, 8) == 0) {
 			cifs_dbg(FYI, "FIFO\n");
 			fattr->cf_mode |= S_IFIFO;
-- 
2.20.1

