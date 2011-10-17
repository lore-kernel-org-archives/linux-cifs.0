From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] CIFS: cleanup min_t() cast in cifs_read()
Date: Mon, 17 Oct 2011 10:30:18 +0300
Message-ID: <20111017073018.GC7812@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Smatch complains that the cast to "int" in min_t() changes very large
values of current_read_size into negative values and so min_t()
could return the wrong value.

Also casting the "const" here doesn't make sense.

I've changed it to u32 ("unsigned int" take puts us past the 80
character limit).

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9f41a10..a61f581 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1861,13 +1861,13 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	for (total_read = 0, current_offset = read_data;
 	     read_size > total_read;
 	     total_read += bytes_read, current_offset += bytes_read) {
-		current_read_size = min_t(const int, read_size - total_read,
+		current_read_size = min_t(u32, read_size - total_read,
 					  cifs_sb->rsize);
 		/* For windows me and 9x we do not want to request more
 		than it negotiated since it will refuse the read then */
 		if ((pTcon->ses) &&
 			!(pTcon->ses->capabilities & CAP_LARGE_FILES)) {
-			current_read_size = min_t(const int, current_read_size,
+			current_read_size = min_t(u32, current_read_size,
 					pTcon->ses->server->maxBuf - 128);
 		}
 		rc = -EAGAIN;
