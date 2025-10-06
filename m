Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3157721FF5F
	for <linux-cifs@vger.kernel.org>; Mon,  6 Oct 2025 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759769307; cv=none; b=LF1rIKRltfy2rQ7gQjYgICH1uwBxdyHMrn9uQMzgjfbAdI85l7p1VjGnbCUO9YQqlWtp3jD8KkroU2kTNDtF1AjMiFSQ968Oa4FpkY2tmYXKOoHDuVui69WBBUmtDUUpC0lcPMBVS3bVUAXcrZatZ7Hxc2CGRowh8nqUajzzM0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759769307; c=relaxed/simple;
	bh=apk5ZI/8OmZZL9G+vaWcuyV5qYfJPS/5afJPhOeufNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSEEvq3VB7cStjYMzGCNe+kf46wk0NdMGL49Ocv83vXFb0s1f2m5U8Y+UTCcbMa4KeqyhzK3SG0Q/PiQWhHaNnXMVTt6anIJNd+sFTk/fQdj9HASfAJkY9D7917fsLCko/2xlKaVO+t5IGzI79pGpvdUo0njVunIgT14PkP+EiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=DDBosTtt; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="DDBosTtt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=+wLUSQ0KzBjiOddSqvKj/SXs2nJpCptNeTAoVmeOXM0=; b=DDBosTttIHCEVygrzswpE2g9hx
	Vu1BI/naCn0BxMco3ykJ7tBiatSJ4+BV7bsFX0lTSXZHs0eysx4hthhREFBgoTc7WMdgzzfUx+NH1
	eus8RjeQzHYwk7a69OITxSHLFzyeXblfsbnu3QjYHWx7dWB/vGxporo+3y29IKJz3tMKE+9vo6gjq
	cV6OomYgMZnQ+wVBkKjDrS2pViMnhHKt5nP9Cau0v8V9Ac9ccZSkyCpc2xTyQnj/4y4cd/3xzzAko
	8Z3LMQRrfArJjxzjc5PnmcuaCOY/9DkdYlEPrCO38DXAOOzBiaeYfgDcRPBf2N2ssJmk7+6Jmf0kV
	Xskl3PaQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v5oHz-00000000qJa-27CX;
	Mon, 06 Oct 2025 13:42:20 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/3] smb: client: fix missing timestamp updates after ftruncate(2)
Date: Mon,  6 Oct 2025 13:42:19 -0300
Message-ID: <20251006164220.67333-2-pc@manguebit.org>
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

Mask off ATTR_MTIME|ATTR_CTIME bits on ATTR_SIZE (e.g. ftruncate(2))
to prevent the client from sending set info calls and then disabling
automatic timestamp updates on server side as per MS-FSA 2.1.4.17.

---8<---
import os
import time

filename = '/mnt/foo'

def print_stat(prefix):
    st = os.stat(filename)
    print(prefix, ': ', time.ctime(st.st_atime), time.ctime(st.st_ctime))

fd = os.open(filename, os.O_CREAT|os.O_TRUNC|os.O_WRONLY, 0o644)
print_stat('old')
os.ftruncate(fd, 10)
time.sleep(2)
os.write(fd, b'foo')
os.close(fd)
time.sleep(2)
print_stat('new')
---8<---

Before patch:

$ mount.cifs //srv/share /mnt -o ...
$ python3 run.py
old :  Fri Oct  3 13:47:03 2025 Fri Oct  3 13:47:03 2025
new :  Fri Oct  3 13:47:00 2025 Fri Oct  3 13:47:03 2025

After patch:

$ mount.cifs //srv/share /mnt -o ...
$ python3 run.py
old :  Fri Oct  3 13:48:39 2025 Fri Oct  3 13:48:39 2025
new :  Fri Oct  3 13:48:41 2025 Fri Oct  3 13:48:41 2025

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/inode.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 17d3fa9f88fc..b7245189fc98 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3156,12 +3156,11 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		if (rc != 0)
 			goto out;
 		/*
-		 * The man page of truncate says if the size changed,
-		 * then the st_ctime and st_mtime fields for the file
-		 * are updated.
+		 * Avoid setting timestamps on the server for ftruncate(2) to
+		 * prevent it from disabling automatic timestamp updates as per
+		 * MS-FSA 2.1.4.17.
 		 */
-		attrs->ia_ctime = attrs->ia_mtime = current_time(inode);
-		attrs->ia_valid |= ATTR_CTIME | ATTR_MTIME;
+		attrs->ia_valid &= ~(ATTR_CTIME | ATTR_MTIME);
 	}
 
 	/* skip mode change if it's just for clearing setuid/setgid */
@@ -3335,12 +3334,11 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 		if (rc != 0)
 			goto cifs_setattr_exit;
 		/*
-		 * The man page of truncate says if the size changed,
-		 * then the st_ctime and st_mtime fields for the file
-		 * are updated.
+		 * Avoid setting timestamps on the server for ftruncate(2) to
+		 * prevent it from disabling automatic timestamp updates as per
+		 * MS-FSA 2.1.4.17.
 		 */
-		attrs->ia_ctime = attrs->ia_mtime = current_time(inode);
-		attrs->ia_valid |= ATTR_CTIME | ATTR_MTIME;
+		attrs->ia_valid &= ~(ATTR_CTIME | ATTR_MTIME);
 	}
 
 	if (attrs->ia_valid & ATTR_UID)
-- 
2.51.0

