From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] mount.cifs: manpage: add entry for "actimeo" option
Date: Wed,  1 Dec 2010 18:30:36 +0530
Message-ID: <1291208436-12371-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 mount.cifs.8 |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 7d2bf69..15dc2dc 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -403,6 +403,24 @@ Map user accesses to individual credentials when accessing the server\&. By defa
 With this change, it's feasible for the server to handle permissions enforcement, so this option also implies "noperm"\&. Furthermore, when unix extensions aren't in use and the administrator has not overriden ownership using the uid= or gid= options, ownership of files is presented as the current user accessing the share\&.
 .RE
 .PP
+actimeo=\fIarg\fR
+.RS 4
+The time (in seconds) that the CIFS client caches attributes of a file or
+directory before it requests attribute information from a server. During this
+period the changes that occur on the server remain undetected until the client
+checks the server again.
+.sp
+By default, the attribute cache timeout is set to 1 second. This means more
+frequent on-the-wire calls to the server to check whether attributes have
+changed which could impact performance. With this option the users can make
+tradeoff between performance and cache metadata correctness depending on the
+workload needs. Shorter timeouts mean better the cache coherency, but frequent
+increased number of calls to the server. Longer timeouts mean reduced number
+of calls to the server at the expense of stricter cache coherency\&. The
+actimeo value is a positive integral that can hold values between 0 and a
+maximum value of 2^30 * HZ (frequency of timer interrupt) setting\&. 
+.RE
+.PP
 \-\-verbose
 .RS 4
 Print additional debugging information for the mount\&. Note that this parameter must be specified before the \-o\&. For example:
