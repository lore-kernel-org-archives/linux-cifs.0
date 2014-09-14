From: Steve French <smfrench@gmail.com>
Subject: [PATCH] [CIFS] Fix setting time before epoch (negative time values)
Date: Sun, 14 Sep 2014 16:22:22 -0500
Message-ID: <CAH2r5mvXnxaAR=KMZ3ydxCEHv1K+jbDW4xX8uBLSTKs6HRfkSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

xfstest generic/258 sets the time on a file to a negative value
(before 1970) which fails since do_div can not handle negative
numbers.  In addition 'normal' division of 64 bit values does
not build on 32 bit arch so have to workaround this by special
casing negative values in cifs_NTtimeToUnix

Looks like fs/ntfs/time.h has the same bug

Samba server also has a similar bug (being tracked by Samba
bugzilla 7771), but Windows server works fine with this.

Signed-off-by: Steve French <smfrench@gmail.com>
---
 fs/cifs/netmisc.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 6834b9c..3cb7403 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -925,11 +925,22 @@ cifs_NTtimeToUnix(__le64 ntutc)
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
+        ts.tv_nsec = -(do_div(t, 10000000) * 100);
+        ts.tv_sec = -t;
+    } else {
+        ts.tv_nsec = do_div(t, 10000000) * 100;
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
