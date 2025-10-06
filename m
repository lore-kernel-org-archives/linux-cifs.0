Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0518252904
	for <linux-cifs@vger.kernel.org>; Mon,  6 Oct 2025 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759777739; cv=none; b=rqFnZL6U0FqEpR16E9T35UELeH9fKbJjYd61tMfKYQ9UzhwTxgfFoBRh0fGoV2BwNRB6G5RQfVGn5Gfsz+rLpJ4jHyhiI4UOSe+biA0rwcoF5nphEN9YiRY78GYn5g5oE3v3s4hXud8Iyal57GIi332kRjyh7nrZN9obS96gAQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759777739; c=relaxed/simple;
	bh=822sRqwN3KNETc+t6GP1xD7J2xYrugoJRDfQpUeh9YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql+Sj2nApw3xq++XnqkVvXeVDN3gWF/YoezrXTvji2IpRyqIGU4DHEBmCSWpwJXYI/T67WkLvKfiJmiI/ynA4w7Rpd5oMIYsIDi0qjNy/dDTmKiQLb9uouxJu5BJKUvpUVYkw3RgETzxeG1ZTlBuSMIDD0FtlvryAKuKGu973Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=ZtZlfx7J; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="ZtZlfx7J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=clIEPIkssuJ6wb8fz5QFEDr0ymJ5vGwWiJK3tiGhefo=; b=ZtZlfx7JSk29KiXfz8A3u9ojik
	3uBeGkXFQ9nFOx2IRkDsedQRG1JpY+yHHhSkcVaRGH02uQfoze1xA9VIQgC/01QCQYmcX5s3/bR+f
	th4jozzlw39jjYlEeYrISoKys1ftsizoW60wni7TpikSoQpkqc6gp6IHQIzhSRWXTkpSrVoQo2csd
	ZpwgLSgtCZHfL36G1Ulz8qXjBx4V6p1U01oe8fTXI2T7rLZOh2i/zT7viuBx4NToQAlCnW7fjXfOq
	tE+twtUCOLeV9TYWJuuzMdb5pJUu1oAHOGvy6IYLTlKNxGkyz6GmXR59ehSY6udPDiKZkKnTSYsdm
	UkngugMw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v5qZp-00000000qkh-3tpt;
	Mon, 06 Oct 2025 16:08:54 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 2/3] smb: client: fix missing timestamp updates after ftruncate(2)
Date: Mon,  6 Oct 2025 16:08:53 -0300
Message-ID: <20251006190854.103483-2-pc@manguebit.org>
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

