Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEECE2FA623;
	Tue, 17 Jun 2025 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179462; cv=none; b=QUpGuEOeYiicvkcwo3SWaxdg7//AkmU5lONBILbyETu3kU8lNXdC3qcuBeuepKZOByfvy0aL9kk03XTCyoMhu53DZRVZXxbQKimb5zEVukDpsfXgJSJPTG/+Blo3E8lJMj62cyBDHkYDpUUNc8cJpxTjcRVQLJrkM7XQGhOM2eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179462; c=relaxed/simple;
	bh=bGYgiib5zEydSqkIG2vIolAB/0l3a8WfRK4BTT7E5yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFO3mzZlEGkWHU3qTqZH4OpjHXKjZ23si2QJf3euivTM27NAOHw1RjQb0/Vs1KFH7tPlWrAjeXYgMCaEdAEd+uJT8zQTWMjro6xNlwKy2/EAlcwOSvL/ZCI7dOVCyrdBzQi0jOo+1qjwbElEOg0o5RiWedbcd7rGK6ren9lZP8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSM6OW75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSM6OW75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7E9C4CEE3;
	Tue, 17 Jun 2025 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179461;
	bh=bGYgiib5zEydSqkIG2vIolAB/0l3a8WfRK4BTT7E5yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSM6OW75c2c3ZWX5qCULJIuuFz1DYoDQ17biV3JYnv6soaDUxUZTpj/3ctrb2FDv7
	 oQBMpiRfWx1+rwmjgmMaZ9OfLMTBJpQc6NhYrdhMzVDgHkMPDGSWyypQFaLq5hVpIt
	 teBieYwZgJC6uvMWpT/myIZMVr68CNUk6ErZqjg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 736/780] smb: client: fix perf regression with deferred closes
Date: Tue, 17 Jun 2025 17:27:24 +0200
Message-ID: <20250617152521.476104026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit b64af6bcd3b0f3fc633d6a70adb0991737abfef4 ]

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
Acked-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d2df10b8e6fd8..9835672267d27 100644
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
2.39.5



