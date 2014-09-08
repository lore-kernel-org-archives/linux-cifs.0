From: Steve French <smfrench@gmail.com>
Subject: A pair of negative time problems: cifs.ko and Samba
Date: Mon, 8 Sep 2014 02:00:36 -0500
Message-ID: <CAH2r5mumvJxzROhpcgTvXW7N_Ghquyx8jqzW1PsgR9XMbVgBVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

There are at least two unrelated problems uncovered by xfstest generic/258

Samba does not actually process set info requests for times prior to
1970 (the set info does not return an error but doesn't update the
time) although it will report the correct time if a file is created
and set locally on ext4 (eg touch -t 196001010101 testfile)  to a time
before 1970.  This works to Windows over CIFS and SMB3.  I opened
Samba bug 10802 to track this.

In addition there is a bug in the cifs kernel client (and probably the
same bug in NTFS on linux) in displaying file times before 1970.   The
cifs kernel client (and Linux ntfs) assume the input to do_div is
unsigned during time conversion.   Is there an alternative to do_div
in kernel?

The following change fixes the problem but would be cleaner if there
were a signed/unsigned aware equivalent of do_div

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 6834b9c..3e17e9b 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -925,11 +925,19 @@ cifs_NTtimeToUnix(__le64 ntutc)
     /* BB what about the timezone? BB */

     /* Subtract the NTFS time offset, then convert to 1s intervals. */
-    u64 t;
+    s64 t;

     t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
-    ts.tv_nsec = do_div(t, 10000000) * 100;
-    ts.tv_sec = t;
+
+    if (t < 0) {
+        t = -t;
+        ts.tv_nsec = -(do_div(t, 10000000) * 100);
+        ts.tv_sec = -t;
+    } else {
+        ts.tv_nsec = do_div(t, 10000000) * 100;
+        ts.tv_sec = t;
+    }
+
     return ts;
 }

fs/ntfs/time.h seems to have the same bug in its equivalent function
ie in  ntfs2utc()

Is there a better function to call?  (In user space I thought that
div/ldiv/lldiv handled negative numbers but presumably we don't have
the equivalents in kernel).







-- 
Thanks,

Steve
