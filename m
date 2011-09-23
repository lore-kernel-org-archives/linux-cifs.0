From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: document sec=ntlmssp(i) and clean up discussion of signing
Date: Fri, 23 Sep 2011 10:55:59 -0400
Message-ID: <1316789759-4314-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 64a8b64..48f9312 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -348,7 +348,7 @@ ntlm Use NTLM password hashing (default)
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlmi Use NTLM password hashing with signing (if /proc/fs/cifs/PacketSigningEnabled on or if server requires signing also can be the default)
+ntlmi Use NTLM password hashing with signing
 .RE
 .sp
 .RS 4
@@ -371,9 +371,31 @@ ntlmv2 Use NTLMv2 password hashing
 .IP \(bu 2.3
 .\}
 ntlmv2i Use NTLMv2 password hashing with packet signing
+.RE
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+ntlmssp Use NTLMv2 password hashing encapsulated in NTLMSSP message
+.RE
 .sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+ntlmsspi Use NTLMv2 password hashing encapsulated in NTLMSSP message and enable packet signing
 .RE
-[NB This [sec parameter] is under development and expected to be available in cifs kernel module 1\&.40 and later]
+.sp
+If the server requires signing during protocol negotiation, then it may be enabled automatically. Signing may also be enabled automatically if it's enabled in /proc/fs/cifs/SecurityFlags.
 .RE
 .PP
 nobrl
-- 
1.7.6.2
