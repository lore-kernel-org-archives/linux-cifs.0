From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Remove noisy log message in smb2 readdir
Date: Fri, 28 Oct 2011 10:31:07 -0500
Message-ID: <CAH2r5mtoLp0D2Cgxffpt4=D1VE2y_6ga0P6nWpyQmMbBtgotWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel,
smb2 readdir is noisy (logging every time).  Do you want to merge
this in to an existing patch, or add it as distinct patch.

Also readdir logs the "expected" return codes (status code) on
medium to large directories since smb2_sendrcv2 is being called for
smb2 search with the "LOG_ERROR" flag.

diff --git a/fs/cifs/smb2readdir.c b/fs/cifs/smb2readdir.c
index 7d80e8b..b4c32d5 100644
--- a/fs/cifs/smb2readdir.c
+++ b/fs/cifs/smb2readdir.c
@@ -412,7 +412,6 @@ static int initiate_smb2_search(const int xid,
struct file *file)
 	if (full_path == NULL)
 		return -ENOMEM;

-	cifs_dump_mem("about to search on name: ", full_path, 4);
 	rc = SMB2_open(xid, tcon, full_path, &persistent_fid, &volatile_fid,
 			FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0,
 			&oplock);

-- 
Thanks,

Steve
