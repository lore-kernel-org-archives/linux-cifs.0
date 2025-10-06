Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E060D253944
	for <linux-cifs@vger.kernel.org>; Mon,  6 Oct 2025 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759777739; cv=none; b=TtsBXNcoYxgBc4PObfP+fsaLpTQPOLRXfWm7e8+KBjdwZXdoYqTxAhIOEUn+0RpMyBSELjVKUwKrgLC5silTYlOjqMOLUk/XL4izPnuIKxf+MTZQiIJ3LZH4jAYjK13qo9H//kLm9Pmz7ydYqCWryxC9KKjZ9BGWU3xQw4LcGcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759777739; c=relaxed/simple;
	bh=OATEN0HbmPXY1ygU7EbWPSPvplXNQDNROPuIFe7j3UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LO+PBYJ9B2mh/X4gORA8jjVqzEbjKdLMqZ5LZKLsKaPxxe8Gs5oECa7q7MUgOXnjH7k/5ukA9OoAC3ec0iPheIcHN+dq1Yb1qBHj9I/8W0KOib2vw+oTZmmKRuks3hpAjx4Lo6M1FfGlAIiA8h474M0FbHVbXfLxcrNheiwEnKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=MgmDoN3j; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="MgmDoN3j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=a9wSQfwdxHebOZy6nqWvwCngBBA32s552TTHGI3rERw=; b=MgmDoN3jclXQuIP0R57oY4ncIb
	hYkpkoGorZ1f+sScmR5hLXRXHYrY9kn5pRFAMF39BhTOX349O0cuY9+Q+0I30ECNaK2mS4bvHdwK1
	BdJ/1JZRFjcZV8kqfdOkX8pUywT8Yu75nP85HUuxwJztW1X50VuL+Ik0nJnEbKxRtvw9DG73vsImO
	b+BSABf0EtPqnVSTKjIXRjfvrZwh+MMKTxoMWsBOWxddisDFKL+WiMhF4r5wFvtc5UZbBlIgnSRRg
	azsadt7xi3gdfXUihQvr7fnm9fevR6OXz4igAKW9/8LG91FwoecImcLpkFIQIFNQwOaq3bEchNsUG
	rGce6Bgg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v5qZq-00000000qkm-0MQ7;
	Mon, 06 Oct 2025 16:08:55 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 3/3] smb: client: fix missing timestamp updates after utime(2)
Date: Mon,  6 Oct 2025 16:08:54 -0300
Message-ID: <20251006190854.103483-3-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006190854.103483-1-pc@manguebit.org>
References: <20251006190854.103483-1-pc@manguebit.org>
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
 fs/smb/client/smb2inode.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0985db9f86e5..e441fa2e7689 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1382,31 +1382,33 @@ int
 smb2_set_file_info(struct inode *inode, const char *full_path,
 		   FILE_BASIC_INFO *buf, const unsigned int xid)
 {
-	struct cifs_open_parms oparms;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct tcon_link *tlink;
-	struct cifs_tcon *tcon;
-	struct cifsFileInfo *cfile;
 	struct kvec in_iov = { .iov_base = buf, .iov_len = sizeof(*buf), };
-	int rc;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsFileInfo *cfile = NULL;
+	struct cifs_open_parms oparms;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	int rc = 0;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
 
 	if ((buf->CreationTime == 0) && (buf->LastAccessTime == 0) &&
-	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0) &&
-	    (buf->Attributes == 0))
-		return 0; /* would be a no op, no sense sending this */
+	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0)) {
+		if (buf->Attributes == 0)
+			goto out; /* would be a no op, no sense sending this */
+		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+	}
 
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
-		return PTR_ERR(tlink);
-	tcon = tlink_tcon(tlink);
-
-	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_ATTRIBUTES,
 			     FILE_OPEN, 0, ACL_NO_MODE);
 	rc = smb2_compound_op(xid, tcon, cifs_sb,
 			      full_path, &oparms, &in_iov,
 			      &(int){SMB2_OP_SET_INFO}, 1,
 			      cfile, NULL, NULL, NULL);
+out:
 	cifs_put_tlink(tlink);
 	return rc;
 }
-- 
2.51.0

