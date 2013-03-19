From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: better document the default sec= mount option
Date: Tue, 19 Mar 2013 11:01:12 -0400
Message-ID: <1363705272-24271-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The default changed in mainline kernel v3.8.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 6f105ad..1a2bfc8 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -344,7 +344,7 @@ Security mode\&. Allowed values are:
 .sp -1
 .IP \(bu 2.3
 .\}
-none attempt to connection as a null user (no name)
+none - attempt to connection as a null user (no name)
 .RE
 .sp
 .RS 4
@@ -355,7 +355,7 @@ none attempt to connection as a null user (no name)
 .sp -1
 .IP \(bu 2.3
 .\}
-krb5 Use Kerberos version 5 authentication
+krb5 - Use Kerberos version 5 authentication
 .RE
 .sp
 .RS 4
@@ -366,7 +366,7 @@ krb5 Use Kerberos version 5 authentication
 .sp -1
 .IP \(bu 2.3
 .\}
-krb5i Use Kerberos authentication and forcibly enable packet signing
+krb5i - Use Kerberos authentication and forcibly enable packet signing
 .RE
 .sp
 .RS 4
@@ -377,7 +377,7 @@ krb5i Use Kerberos authentication and forcibly enable packet signing
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlm Use NTLM password hashing (default)
+ntlm - Use NTLM password hashing
 .RE
 .sp
 .RS 4
@@ -388,7 +388,7 @@ ntlm Use NTLM password hashing (default)
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlmi Use NTLM password hashing and force packet signing
+ntlmi - Use NTLM password hashing and force packet signing
 .RE
 .sp
 .RS 4
@@ -399,7 +399,7 @@ ntlmi Use NTLM password hashing and force packet signing
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlmv2 Use NTLMv2 password hashing
+ntlmv2 - Use NTLMv2 password hashing
 .RE
 .sp
 .RS 4
@@ -410,7 +410,7 @@ ntlmv2 Use NTLMv2 password hashing
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlmv2i Use NTLMv2 password hashing and force packet signing
+ntlmv2i - Use NTLMv2 password hashing and force packet signing
 .RE
 .sp
 .RS 4
@@ -421,7 +421,7 @@ ntlmv2i Use NTLMv2 password hashing and force packet signing
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlmssp Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message
+ntlmssp - Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message
 .RE
 .sp
 .RS 4
@@ -432,9 +432,11 @@ ntlmssp Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message
 .sp -1
 .IP \(bu 2.3
 .\}
-ntlmsspi Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message, and force packet signing
+ntlmsspi - Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message, and force packet signing
 .RE
 .sp
+The default in mainline kernel versions prior to v3.8 was sec=ntlm. In v3.8, the default was changed to sec=ntlmssp.
+.sp
 If the server requires signing during protocol negotiation, then it may be enabled automatically. Packet signing may also be enabled automatically if it's enabled in /proc/fs/cifs/SecurityFlags.
 .RE
 .PP
-- 
1.7.11.7
