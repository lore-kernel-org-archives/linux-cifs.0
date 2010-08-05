From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: update README to include details about 'fsc' option
Date: Thu, 05 Aug 2010 18:52:21 +0530
Message-ID: <4C5ABB0D.6000504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/README |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index a7081ee..7099a52 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -301,6 +301,16 @@ A partial list of the supported mount options follows:
   gid		Set the default gid for inodes (similar to above).
   file_mode     If CIFS Unix extensions are not supported by the server
 		this overrides the default mode for file inodes.
+  fsc		Enable local disk caching using FS-Cache (off by default). This
+  		option could be useful to improve performance on a slow link,
+		heavily loaded server and/or network where reading from the
+		disk is faster than reading from the server (over the network).
+		This could also impact scalability positively as the
+		number of calls to the server are reduced. However, local
+		caching is not suitable for all workloads for e.g. read-once
+		type workloads. So, you need to consider carefully your
+		workload/scenario before using this option. Currently, local
+		disk caching is functional for CIFS files opened as read-only.
   dir_mode      If CIFS Unix extensions are not supported by the server 
 		this overrides the default mode for directory inodes.
   port		attempt to contact the server on this tcp port, before
