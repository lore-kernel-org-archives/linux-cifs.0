From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [RFC][PATCH 2/2] cifs: add information about 'features' file to README
Date: Fri, 30 Jul 2010 15:30:59 +0530
Message-ID: <4C52A2DB.5070904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [RFC][PATCH 2/2] cifs: add information about 'features' file to README

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
 fs/cifs/README |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index a727b7c..ac03fcf 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -636,7 +636,9 @@ cifsFYI			If set to non-zero value, additional debug information
 			log slow responses (ie which take longer than 1 second)
 			  CONFIG_CIFS_STATS2 must be enabled in .config	0x04
 				
-				
+features		Displays information about the compiled in CIFS
+			features of the running kernel.
+
 traceSMB		If set to one, debug information is logged to the
 			system error log with the start of smb requests
 			and responses (default 0)
