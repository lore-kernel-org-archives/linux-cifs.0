Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A6E2367AC
	for <linux-cifs@vger.kernel.org>; Mon,  6 Oct 2025 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759769315; cv=none; b=qt+39WUpIW0LQ8FdTVLdxm+nkmgB5zycfONX+dwCNEyXp/mv42JJs9VA9CzDumZ1kgeGJ8OsSjigtRT+Y5RGUwxvsWILsslB3gkGfkHF94ogivoLxaviOAi4CcC/BboPbaI1tov4a1/ZWliIIHTgYm+Ez71DLHJHCyRWfq61q/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759769315; c=relaxed/simple;
	bh=0akxWanxndG/uzLARdJWZ1bCi3RISBQvBz8eN/0wJ1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqFhwey1dyGhJig+aBdSlC6QOeIDhYIo3iHBGx7mkPemJk0znxAtIhDWqgA5vQe7fpYLl54KCuzTWc4/9BCkHIMtpFDvXMBlviJ1hoQBPRQNxjXziBhwvJCXknJB1+8PYRVvEZESydjUGPA/phP2mpkqWQlbmpvIKlq+tiofo7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=jXKyVCmP; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="jXKyVCmP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=+hq2V8tUx2mIOMYV/PIjykPL8JnKmAvZYcbeYdVIU64=; b=jXKyVCmP08+8g3KenHy/i/U7eR
	QhhFw5S7T6bfbqVn2YmSiecKaL2eSErfGGgdGFaUCC9R+PWJ0pUfr20zpTmdamdbND5V2qEfWXUOW
	3OQ0voSEeJr+MShtfzIPTPmWzgTmDzXQeMjrNi3LNZNck9KDadEOupyqgMchjjDW3UB7DpiZYw4Dh
	qGUYCUDxBWjZM96H08HzhaePvbDs+wE9ad7cFYz6/IYnEO8GZD/93xJkx8vdSAL+ZJ6HMpayK47OU
	wSmHSP3AFCUr5mVds/qel11CvLmA9Abz3d/ohcj1UuC6nkeeEz+c+vJHBl9aL++zN05l1fLtS5lNz
	Xjfb9EDQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v5oHz-00000000qJf-2lDz;
	Mon, 06 Oct 2025 13:42:20 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 3/3] smb: client: fix missing timestamp updates after utime(2)
Date: Mon,  6 Oct 2025 13:42:20 -0300
Message-ID: <20251006164220.67333-3-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006164220.67333-1-pc@manguebit.org>
References: <20251006164220.67333-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't reuse open handle when changing timestamps to prevent the server
from disabling automatic timestamp updates as per MS-FSA 2.1.4.17.

---8<---
import os
import time

filename = '/mnt/foo'

def print_stat(prefix):
    st = os.stat(filename)
    print(prefix, ': ', time.ctime(st.st_atime), time.ctime(st.st_ctime))

fd = os.open(filename, os.O_CREAT|os.O_TRUNC|os.O_WRONLY, 0o644)
print_stat('old')
os.utime(fd, None)
time.sleep(2)
os.write(fd, b'foo')
os.close(fd)
time.sleep(2)
print_stat('new')
---8<---

Before patch:

$ mount.cifs //srv/share /mnt -o ...
$ python3 run.py
old :  Fri Oct  3 14:01:21 2025 Fri Oct  3 14:01:21 2025
new :  Fri Oct  3 14:01:21 2025 Fri Oct  3 14:01:21 2025

After patch:

$ mount.cifs //srv/share /mnt -o ...
$ python3 run.py
old :  Fri Oct  3 17:03:34 2025 Fri Oct  3 17:03:34 2025
new :  Fri Oct  3 17:03:36 2025 Fri Oct  3 17:03:36 2025

Fixes: b6f2a0f89d7e ("cifs: for compound requests, use open handle if possible")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/smb2inode.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0985db9f86e5..89407ca9df9f 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1382,25 +1382,26 @@ int
 smb2_set_file_info(struct inode *inode, const char *full_path,
 		   FILE_BASIC_INFO *buf, const unsigned int xid)
 {
-	struct cifs_open_parms oparms;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct tcon_link *tlink;
-	struct cifs_tcon *tcon;
-	struct cifsFileInfo *cfile;
 	struct kvec in_iov = { .iov_base = buf, .iov_len = sizeof(*buf), };
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsFileInfo *cfile = NULL;
+	struct cifs_open_parms oparms;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
 	int rc;
 
 	if ((buf->CreationTime == 0) && (buf->LastAccessTime == 0) &&
-	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0) &&
-	    (buf->Attributes == 0))
-		return 0; /* would be a no op, no sense sending this */
+	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0)) {
+		if (buf->Attributes == 0)
+			return 0; /* would be a no op, no sense sending this */
+		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+	}
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
-	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_ATTRIBUTES,
 			     FILE_OPEN, 0, ACL_NO_MODE);
 	rc = smb2_compound_op(xid, tcon, cifs_sb,
-- 
2.51.0

