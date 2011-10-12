From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: review of patch "cifs: untangle server->maxBuf and CIFSMaxBufSize"
Date: Wed, 12 Oct 2011 12:15:29 -0500
Message-ID: <CAH2r5mug5PmrbhmAazv62xQGgFmH8TjZEL84WOnbvO59hccPwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewing changes to fs/cifs/connect.c in
http://git.samba.org/?p=jlayton/linux.git;a=commit;h=b82a25501cb18b86fd247da15c886762fdc5404c

It looks like the following logic changes from setting rsize to what
the server claims it can support (negotiated maxBuf) to what our
maximum buffer size is:

@@ -3130,8 +3130,7 @@ try_mount_again:
                cFYI(DBG2, "no very large read support, rsize now 127K");
        }
        if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
-               cifs_sb->rsize = min(cifs_sb->rsize,
-                              (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
+               cifs_sb->rsize = min(cifs_sb->rsize, CIFSMaxBufSize);


Is that what we want?

-- 
Thanks,

Steve
