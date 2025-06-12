Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5D522652D
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749743122; cv=none; b=DJ+HK1RfZQG/KLaSI8e2mfkfQm0M9dUorqVMwBynmyPeax9vCIkH4zGRgdB3RujZOkDCBFs5idy9TosOPiN3NacFMm1/puuGT57Kz5D9HDIdCkgvS4bwzw08TBhmVyUdy1YUm1fFu+rm9dD2D0DPTa+7EWDnjYLH2/SJRGFZ3ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749743122; c=relaxed/simple;
	bh=tT/mzkdfmuTsp3YRI8S5x9J9PshhixjCoJVgR6mAmGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kPYjpH/c2jksmFpnLWns4p1jZrdNytJ5yL6UGovKWwhbQK3aXqNEWeb9mc816eJ4LB5SAcuVRm+zWdroKp/000aTuMh6QzpBoKpj2MctLql7Af7EXfY8EH1mILMZGZjwMgE+ERlAxkH9r3KLhuhGhHO0+vQ3WliiJv3fl11DEpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=f5EtIW4m; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="f5EtIW4m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OQgesrEzi39G5Lxb5NCvErnptfmQR1tgMFWo30MC9Dw=; b=f5EtIW4mhk9LuVLr0LTTdDf/s4
	jj6tLgUu58sysNto9KS/YgF3SKbjISZ/Rh29wtsOVGuuRXzPWwFZy8RsQCFcRsSEOs//CXyM+G+aO
	7z8hg+axUd+++EvDd2C6XA5YqlAIuMH98UIs+1plT4OKCaR8xzgFXUKcbDseOmH3hsxESQqNgBJhx
	i81zBVTN7zajKyDk8mffeOj+iiEktF3hOB3n7iiMMf+0lf+5VcyDgya/LHVvuwcG3ZlrbXothmSYs
	jJc74KJ3Gjkl+y4JnVR6N2Ft2AITHDyN1sGMvF/dFeKCh5Zi3TSKxWyis946ZEmac5jg0u7bWHpBH
	4IpBXMpQ==;
Authentication-Results: mx1.manguebit.org;
	iprev=fail smtp.remote-ip=143.255.12.172;
	auth=pass (LOGIN) smtp.auth=pc;
	dmarc=skipped
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uPk6z-000000003QI-1chh;
	Thu, 12 Jun 2025 12:45:07 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: [PATCH] smb: client: fix perf regression with deferred closes
Date: Thu, 12 Jun 2025 12:45:04 -0300
Message-ID: <20250612154504.246390-1-pc@manguebit.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 1.1 (+)

Customer reported that one of their applications started failing to
open files with STATUS_INSUFFICIENT_RESOURCES due to NetApp server
hitting the maximum number of opens to same file that it would allow
for a single client connection.

It turned out the client was failing to reuse open handles with
deferred closes because matching ->f_flags directly without masking
off O_CREAT|O_EXCL|O_TRUNC bits first broke the comparision and then
client ended up with thousands of deferred closes to same file.  Those
bits are already satisfied on the original open, so no need to check
them against existing open handles.

Reproducer:

 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <pthread.h>

 #define NR_THREADS      4
 #define NR_ITERATIONS   2500
 #define TEST_FILE       "/mnt/1/test/dir/foo"

 static char buf[64];

 static void *worker(void *arg)
 {
         int i, j;
         int fd;

         for (i = 0; i < NR_ITERATIONS; i++) {
                 fd = open(TEST_FILE, O_WRONLY|O_CREAT|O_APPEND, 0666);
                 for (j = 0; j < 16; j++)
                         write(fd, buf, sizeof(buf));
                 close(fd);
         }
 }

 int main(int argc, char *argv[])
 {
         pthread_t t[NR_THREADS];
         int fd;
         int i;

         fd = open(TEST_FILE, O_WRONLY|O_CREAT|O_TRUNC, 0666);
         close(fd);
         memset(buf, 'a', sizeof(buf));
         for (i = 0; i < NR_THREADS; i++)
                 pthread_create(&t[i], NULL, worker, NULL);
         for (i = 0; i < NR_THREADS; i++)
                 pthread_join(t[i], NULL);
         return 0;
 }

Before patch:

$ mount.cifs //srv/share /mnt/1 -o ...
$ mkdir -p /mnt/1/test/dir
$ gcc repro.c && ./a.out
...
number of opens: 1391

After patch:

$ mount.cifs //srv/share /mnt/1 -o ...
$ mkdir -p /mnt/1/test/dir
$ gcc repro.c && ./a.out
...
number of opens: 1

Cc: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Jay Shin <jaeshin@redhat.com>
Cc: Pierguido Lambri <plambri@redhat.com>
Fixes: b8ea3b1ff544 ("smb: enable reuse of deferred file handles for write operations")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d2df10b8e6fd..9835672267d2 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -999,15 +999,18 @@ int cifs_open(struct inode *inode, struct file *file)
 		rc = cifs_get_readable_path(tcon, full_path, &cfile);
 	}
 	if (rc == 0) {
-		if (file->f_flags == cfile->f_flags) {
+		unsigned int oflags = file->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
+		unsigned int cflags = cfile->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
+
+		if (cifs_convert_flags(oflags, 0) == cifs_convert_flags(cflags, 0) &&
+		    (oflags & (O_SYNC|O_DIRECT)) == (cflags & (O_SYNC|O_DIRECT))) {
 			file->private_data = cfile;
 			spin_lock(&CIFS_I(inode)->deferred_lock);
 			cifs_del_deferred_close(cfile);
 			spin_unlock(&CIFS_I(inode)->deferred_lock);
 			goto use_cache;
-		} else {
-			_cifsFileInfo_put(cfile, true, false);
 		}
+		_cifsFileInfo_put(cfile, true, false);
 	} else {
 		/* hard link on the defeered close file */
 		rc = cifs_get_hardlink_path(tcon, inode, file);
-- 
2.49.0

