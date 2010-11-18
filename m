From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] manpage: change port option description
Date: Thu, 18 Nov 2010 10:48:05 +0300
Message-ID: <1290066485-2618-1-git-send-email-piastryyy@gmail.com>
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
index 7d2bf69..b7fe2ad 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -132,7 +132,7 @@ instructs the client to ignore any gid provided by the server for files and dire
 .PP
 port=\fIarg\fR
 .RS 4
-sets the port number on the server to attempt to contact to negotiate CIFS support\&. If the CIFS server is not listening on this port or if it is not specified, the default ports will be tried i\&.e\&. port 445 is tried and if no response then port 139 is tried\&.
+sets the port number on the server to attempt to contact to negotiate CIFS support\&. If this value is specified, looking for an existing connection with this port and try to connect if no such a connection\&. Return an error if it fails\&. If this value isn't specified, looking for an existing connection with 445 or 139 port\&. If no such a connection, try to connect with 445 port and if it fails - with 139 port\&. Return an error if both fail\&.
 .RE
 .PP
 servern=\fIarg\fR
-- 
1.7.3.2
