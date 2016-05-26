From: "Jerome Marchand" <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: use CIFS_MAX_DOMAINNAME_LEN when converting the domain name
Date: Thu, 26 May 2016 11:52:24 +0200
Message-ID: <1464256345-26131-1-git-send-email-jmarchan@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently in build_ntlmssp_auth_blob(), when converting the domain
name to UTF16, CIFS_MAX_USERNAME_LEN limit is used. It should be
CIFS_MAX_DOMAINNAME_LEN. This patch fixes this.

Signed-off-by: Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index af0ec2d..c3d086e 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -430,7 +430,7 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	} else {
 		int len;
 		len = cifs_strtoUTF16((__le16 *)tmp, ses->domainName,
-				      CIFS_MAX_USERNAME_LEN, nls_cp);
+				      CIFS_MAX_DOMAINNAME_LEN, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->DomainName.Length = cpu_to_le16(len);
-- 
2.5.5
