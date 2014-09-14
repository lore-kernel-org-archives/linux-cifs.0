From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][v2][CIFS] Fix setting time before epoch (negative time values)
Date: Sun, 14 Sep 2014 17:11:46 -0500
Message-ID: <CAH2r5mscOTdr9WzazvhydC9DazgBs1MrEkdzQSzarF4XVmfjiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(Updated version of this patch now removes kbuild test robot complaint
about lack of cast on tv_nsec)

xfstest generic/258 sets the time on a file to a negative value
(before 1970) which fails since do_div can not handle negative
numbers.  In addition 'normal' division of 64 bit values does
not build on 32 bit arch so have to workaround this by special
casing negative values in cifs_NTtimeToUnix

Samba server also has a bug with this (see samba bugzilla 7771)
but it works to Windows server.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/netmisc.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 6834b9c..b333ff6 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -925,11 +925,23 @@ cifs_NTtimeToUnix(__le64 ntutc)
     /* BB what about the timezone? BB */

     /* Subtract the NTFS time offset, then convert to 1s intervals. */
-    u64 t;
+    s64 t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
+
+    /*
+     * Unfortunately can not use normal 64 bit division on 32 bit arch, but
+     * the alternative, do_div, does not work with negative numbers so have
+     * to special case them
+     */
+    if (t < 0) {
+        t = -t;
+        ts.tv_nsec = (long)(do_div(t, 10000000) * 100);
+        ts.tv_nsec = -ts.tv_nsec;
+        ts.tv_sec = -t;
+    } else {
+        ts.tv_nsec = (long)do_div(t, 10000000) * 100;
+        ts.tv_sec = t;
+    }

-    t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
-    ts.tv_nsec = do_div(t, 10000000) * 100;
-    ts.tv_sec = t;
     return ts;
 }


-- 
Thanks,

Steve
