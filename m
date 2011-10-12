From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2 3/3] cifs: update README about the kernel module parameters
Date: Wed, 12 Oct 2011 11:52:01 +0530
Message-ID: <4E953209.2020602@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/README |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index c5c2c5e..95b37a1 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -745,4 +745,18 @@ installed and something like the following lines should be added to the
 create cifs.spnego * * /usr/local/sbin/cifs.upcall %k
 create dns_resolver * * /usr/local/sbin/cifs.upcall %k
 
+CIFS kernel module parameters
+=============================
+These module parameters can be specified or modified either during the time of
+module loading or during the runtime by using the interface
+	/proc/module/cifs/parameters/<param>
+
+i.e. echo "value" > /proc/module/cifs/parameters/<param>
+
+1. echo_retries - The number of echo attempts before giving up and
+		  reconnecting to the server. The default is 5. The value 0
+		  means never reconnect.
+
+2. enable_oplocks - Enable or disable oplocks. Oplocks are enabled by default.
+		    [Y/y/1]. To disable use any of [N/n/0].
 
