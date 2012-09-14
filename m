From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: checkpatch warning on single statement do ... while
Date: Fri, 14 Sep 2012 10:51:04 -0500
Message-ID: <CAH2r5mv2+m2+8+mYMo4qomGaOtpXs02TnToMH7PgCR4yrUaUeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Any thoughts about this checkpatch warning? (We have the same kind of
thing in cifssmb.c)

WARNING: Single statement macros should not use a do {} while (0) loop
#65: FILE: fs/cifs/cifsglob.h:608:
+#define cifs_kmap_lock() do { ; } while (0)

WARNING: Single statement macros should not use a do {} while (0) loop
#66: FILE: fs/cifs/cifsglob.h:609:
+#define cifs_kmap_unlock() do { ; } while (0)

total: 0 errors, 2 warnings, 307 lines checked

/home/stevef/3.7-patches/0019-CIFS-Add-SMB2-support-for-cifs_iovec_write.patch
has style problems, please review.


--
Thanks,

Steve


-- 
Thanks,

Steve
