From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch v2] CIFS: cleanup min_t() cast in cifs_read()
Date: Tue, 18 Oct 2011 12:41:35 +0300
Message-ID: <20111018094135.GE25814@longonot.mountain>
References: <20111017073018.GC7812@elgon.mountain>
 <CAH2r5mufq0=BsZvfGuVdd1BU-gxRpnUmWAm-vzhsOR4KbvGSbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mufq0=BsZvfGuVdd1BU-gxRpnUmWAm-vzhsOR4KbvGSbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Smatch complains that the cast to "int" in min_t() changes very large
values of current_read_size into negative values and so min_t()
could return the wrong value.  I removed the const as well, as that
doesn't do anything here.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v2:  use "uint" instead of "u32".

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ab85699..34be15a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1900,13 +1900,13 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	for (total_read = 0, current_offset = read_data;
 	     read_size > total_read;
 	     total_read += bytes_read, current_offset += bytes_read) {
-		current_read_size = min_t(const int, read_size - total_read,
+		current_read_size = min_t(uint, read_size - total_read,
 					  cifs_sb->rsize);
 		/* For windows me and 9x we do not want to request more
 		than it negotiated since it will refuse the read then */
 		if ((pTcon->ses) &&
 			!(pTcon->ses->capabilities & CAP_LARGE_FILES)) {
-			current_read_size = min_t(const int, current_read_size,
+			current_read_size = min_t(uint, current_read_size,
 					CIFSMaxBufSize);
 		}
 		rc = -EAGAIN;
