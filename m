Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1E478F59
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 19:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759865019; cv=none; b=lgvTBGihqRaK7zxXfEGjG40ASFbFxN+zi+Glo6VlJjRZUF4ndoWIfA/DXPPm2AoZ87N3bk0753x4Tjhpwb8qYreTPd3XXjSRVfAAw9wpb9hDcKf0yW0hNFLc3Z6aWM6z6tCyPVaZWtGM5/nHaOPPEgU5DV9bkgFTezOJqwBO3a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759865019; c=relaxed/simple;
	bh=822sRqwN3KNETc+t6GP1xD7J2xYrugoJRDfQpUeh9YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcqG5ZfmUesQ2l8cE6qLQYxL2UEG1pXciPuwo4aG1MgE2emScuk4BJzv3IBixgE8SheqgDpcpdFG5chToeaBlJLnzfoG/kYLxNVIn5Aqaw+flaUfkO0BnMFvh6rpK9/HH9exw+EgcXGmz1e2npSvW+A/BHU/ZZAuFJXnl6W3yPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=xCvyoOps; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="xCvyoOps"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=clIEPIkssuJ6wb8fz5QFEDr0ymJ5vGwWiJK3tiGhefo=; b=xCvyoOpsjmJ7hBdHnrWRAEaQFQ
	BWe+I8QjN5A6tEBoeFjOw2xcjFvLiSaiiSrQ54oJJ35+34W24oUQQ1BbYcZlmAV7qXALF6QVzNa5B
	JTecJks587Qqd1FqM/p7vKtdLl7MAoxLDaeoAStaN1HJTzMfjOSsa0nfQsXSV+ouMMLejZhDn/uPj
	dYx4Vj3S8fDI35rfNS4PxFjNjfRXldDxv8QZi302A2yVPoqrwGM+bv09X1EJz8RsqvJ0dD1fmlVpd
	3O0ilE9toQGbPK5CH3dmqgIHuPxlfq4MLlKyX68jCoqz3DtDKemB38ue+iHZR4EpZxGM7K6m2pT6G
	FtOqvCXg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v6DHR-00000000twY-1GSW;
	Tue, 07 Oct 2025 16:23:26 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v3 2/4] smb: client: fix missing timestamp updates after ftruncate(2)
Date: Tue,  7 Oct 2025 16:23:23 -0300
Message-ID: <20251007192326.234467-2-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251007192326.234467-1-pc@manguebit.org>
References: <20251007192326.234467-1-pc@manguebit.org>
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
index ce88bef4e44c..fbfd5b556815 100644
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

