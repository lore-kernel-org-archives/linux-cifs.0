From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Samba bug 9519 - patch for kernel client workaround
Date: Mon, 18 Feb 2013 11:02:38 -0600
Message-ID: <CAH2r5mtm=hnCQH8N=81COHsr3VBt=hVTYTtFJux5GcfFtMcbFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

    [CIFS] POSIX extensions disabled on client due to illegal O_EXCL
flag sent to Samba

    Samba rejected libreoffice's attempt to open a file with illegal
    O_EXCL (without O_CREAT).  Mask this flag off (as the local
    linux file system case does) for this case, so that we
    don't have disable Unix Extensions unnecessarily due to
    the Samba error (Samba server is also being fixed).

    See https://bugzilla.samba.org/show_bug.cgi?id=9519

    Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8ea6ca5..433743a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -43,6 +43,7 @@
 #include "cifs_fs_sb.h"
 #include "fscache.h"

+
 static inline int cifs_convert_flags(unsigned int flags)
 {
        if ((flags & O_ACCMODE) == O_RDONLY)
@@ -72,10 +73,15 @@ static u32 cifs_posix_convert_flags(unsigned int flags)
        else if ((flags & O_ACCMODE) == O_RDWR)
                posix_flags = SMB_O_RDWR;

-       if (flags & O_CREAT)
+       if (flags & O_CREAT) {
                posix_flags |= SMB_O_CREAT;
-       if (flags & O_EXCL)
-               posix_flags |= SMB_O_EXCL;
+               if (flags & O_EXCL)
+                       posix_flags |= SMB_O_EXCL;
+       } else if (flags & O_EXCL)
+               cFYI(1, "Application %s pid %d has incorrectly set O_EXCL flag"
+                       "but not O_CREAT on file open. Ignoring O_EXCL",
+                       current->comm, current->tgid);
+
        if (flags & O_TRUNC)
                posix_flags |= SMB_O_TRUNC;
        /* be safe and imply O_SYNC for O_DSYNC */


-- 
Thanks,

Steve
