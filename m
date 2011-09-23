From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: document sec=ntlmssp(i) and clean up discussion of signing (try #2)
Date: Fri, 23 Sep 2011 11:17:31 -0400
Message-ID: <1316791051-5057-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This version incorporates Shirish's comments about consistency and wording.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 64a8b64..81ebdbe 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -326,7 +326,7 @@ krb5 Use Kerberos version 5 authentication
 .sp -1
 .IP \(bu 2.3
 .\}
-krb5i Use Kerberos authentication and packet signing
+krb5i Use Kerberos authentication and forcibly enable packet signing
 .RE
 .sp
 .RS 4
@@ -348,7 +348,7 @@ ntlm Use NTLM password hashing (default)
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlmi Use NTLM password hashing with signing (if /proc/fs/cifs/PacketSigningEnabled on or if server requires signing also can be the default)
+ntlmi Use NTLM password hashing and force packet signing
 .RE
 .sp
 .RS 4
@@ -370,10 +370,32 @@ ntlmv2 Use NTLMv2 password hashing
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlmv2i Use NTLMv2 password hashing with packet signing
+ntlmv2i Use NTLMv2 password hashing and force packet signing
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
+ntlmssp Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message
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
+ntlmsspi Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message, and force packet signing
 .RE
-[NB This [sec parameter] is under development and expected to be available in cifs kernel module 1\&.40 and later]
+.sp
+If the server requires signing during protocol negotiation, then it may be enabled automatically. Packet signing may also be enabled automatically if it's enabled in /proc/fs/cifs/SecurityFlags.
 .RE
 .PP
 nobrl
-- 
1.7.6.2
