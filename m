From: Joseph Salisbury <joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [v3.2.y][PATCH 1/1] cifs: set MAY_SIGN when sec=krb5
Date: Fri, 28 Feb 2014 16:07:35 -0500
Message-ID: <4f795fd099859c91c56b7a05996bc38a040bc9c0.1393535604.git.joseph.salisbury@canonical.com>
References: <cover.1393535604.git.joseph.salisbury@canonical.com>
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1393535604.git.joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
In-Reply-To: <cover.1393535604.git.joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
References: <cover.1393535604.git.joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Backport from mainline commit: 0b7bc84000d71f3647ca33ab1bf5bd928535c846.
This backport was done so including mainline commit
8830d7e07a5e38bc47650a7554b7c1cfd49902bf is not needed.

BugLink: http://bugs.launchpad.net/bugs/1285723

Signed-off-by: Joseph Salisbury <joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 56c152d..49d6e21 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1113,7 +1113,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				cERROR(1, "Krb5 cifs privacy not supported");
 				goto cifs_parse_mount_err;
 			} else if (strnicmp(value, "krb5", 4) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_KRB5;
+				vol->secFlg |= CIFSSEC_MAY_KRB5 | 
+					CIFSSEC_MAY_SIGN;
 			} else if (strnicmp(value, "ntlmsspi", 8) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_NTLMSSP |
 					CIFSSEC_MUST_SIGN;
-- 
1.7.9.5
