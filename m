From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] manpage: change port option description (try #2)
Date: Thu, 18 Nov 2010 21:30:10 +0300
Message-ID: <1290105010-2915-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Provide changes according to new ip/port connection logic in CIFS.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.8 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 7d2bf69..bde0770 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -132,7 +132,7 @@ instructs the client to ignore any gid provided by the server for files and dire
 .PP
 port=\fIarg\fR
 .RS 4
-sets the port number on the server to attempt to contact to negotiate CIFS support\&. If the CIFS server is not listening on this port or if it is not specified, the default ports will be tried i\&.e\&. port 445 is tried and if no response then port 139 is tried\&.
+sets the port number on which the client will attempt to contact the CIFS server\&. If this value is specified, look for an existing connection with this port, and use that if one exists\&. If one doesn't exist, try to create a new connection on that port\&. If that connection fails, return an error\&. If this value isn't specified, look for an existing connection on port 445 or 139\&. If no such connection exists, try to connect on port 445 first and then port 139 if that fails\&. Return an error if both fail\&.
 .RE
 .PP
 servern=\fIarg\fR
-- 
1.7.3.2
