From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch 1/2] cifs: add kfree() on error path
Date: Wed, 27 Oct 2010 23:19:32 +0200
Message-ID: <20101027211932.GK6062@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We leak 256 bytes here on this error path. 

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 45af003..06a006b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1353,6 +1353,7 @@ static int cifs_writepages(struct address_space *mapping,
 	if (!experimEnabled && tcon->ses->server->secMode &
 			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
 		cifsFileInfo_put(open_file);
+		kfree(iov);
 		return generic_writepages(mapping, wbc);
 	}
 	cifsFileInfo_put(open_file);
