Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A953370E1;
	Fri, 17 Oct 2025 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713596; cv=none; b=JE1/3lqzBPefN+j8N+QlqBsM3gcKo7H2hFPP6KL3BAmkRE59fBT641ll5igmJ5Ce+3oH8bqkoZqTY2s4fxfb2N2r6ayDCeKUfQuQm8SVdUlMXkfuNA8KezyQ+dVnsO16q6I+8qwLMJ6mIMuwbKF93gAUJtz/DawMZmo/MktKkqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713596; c=relaxed/simple;
	bh=9t9nuUksHPNFlsXW/u+xcAUUODsE5gFCzeAJy7pHzpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LF5b15JFWykF1MK1GHrq7dHutsWvriwI3esxMSitCikoFJxKlNHCwFl7gHJV0NaKVUnG5AGmAP145SJpZFXdhOkk58Zg6LhtECgB9cxPxSKCpGUiqVdyYIVt2rwW1ULZ3OsMlhxoFoMZrZ4gNxdpN3pXVktVPiFmdFpBkS4tORM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHAvoplE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHAvoplE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423E9C4CEE7;
	Fri, 17 Oct 2025 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713596;
	bh=9t9nuUksHPNFlsXW/u+xcAUUODsE5gFCzeAJy7pHzpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHAvoplECEhHf8sXxehAszkIJ20CLGvTU25n6btFI3y/ILlD+WgyENv+chf1QWLUc
	 M7egtmSSR/9XbZj3iUkGC4qHLsg20HcGxbZ+wQC3tsgEVwVGXPIZuz1Tosz55PTntP
	 q7LovZDPD6G0CVxQ2bIAejUMzDOs80arMpeJJyOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/201] smb: client: fix missing timestamp updates after utime(2)
Date: Fri, 17 Oct 2025 16:51:54 +0200
Message-ID: <20251017145136.692822546@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit b95cd1bdf5aa9221c98fc9259014b8bb8d1829d7 ]

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
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 79641d1ee8675..232a3c2890556 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1216,31 +1216,33 @@ int
 smb2_set_file_info(struct inode *inode, const char *full_path,
 		   FILE_BASIC_INFO *buf, const unsigned int xid)
 {
-	struct cifs_open_parms oparms;
+	struct kvec in_iov = { .iov_base = buf, .iov_len = sizeof(*buf), };
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsFileInfo *cfile = NULL;
+	struct cifs_open_parms oparms;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	struct cifsFileInfo *cfile;
-	struct kvec in_iov = { .iov_base = buf, .iov_len = sizeof(*buf), };
-	int rc;
-
-	if ((buf->CreationTime == 0) && (buf->LastAccessTime == 0) &&
-	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0) &&
-	    (buf->Attributes == 0))
-		return 0; /* would be a no op, no sense sending this */
+	int rc = 0;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
-	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+	if ((buf->CreationTime == 0) && (buf->LastAccessTime == 0) &&
+	    (buf->LastWriteTime == 0) && (buf->ChangeTime == 0)) {
+		if (buf->Attributes == 0)
+			goto out; /* would be a no op, no sense sending this */
+		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+	}
+
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



