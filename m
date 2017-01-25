From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 3/3] cifs: Add soft dependencies
Date: Wed, 25 Jan 2017 16:09:10 +0100
Message-ID: <20170125160910.12928e3c@endymion>
References: <20170125160639.255cd58e@endymion>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170125160639.255cd58e@endymion>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

List soft dependencies of cifs so that mkinitrd and dracut can include
the required helper modules.

Signed-off-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- linux-4.10-rc5.orig/fs/cifs/cifsfs.c	2017-01-16 11:13:06.974673377 +0100
+++ linux-4.10-rc5/fs/cifs/cifsfs.c	2017-01-25 14:57:06.724389810 +0100
@@ -1365,5 +1365,17 @@ MODULE_DESCRIPTION
     ("VFS to access servers complying with the SNIA CIFS Specification "
      "e.g. Samba and Windows");
 MODULE_VERSION(CIFS_VERSION);
+MODULE_SOFTDEP("pre: arc4");
+MODULE_SOFTDEP("pre: des");
+MODULE_SOFTDEP("pre: ecb");
+MODULE_SOFTDEP("pre: hmac");
+MODULE_SOFTDEP("pre: md4");
+MODULE_SOFTDEP("pre: md5");
+MODULE_SOFTDEP("pre: nls");
+#ifdef CONFIG_CIFS_SMB2
+MODULE_SOFTDEP("pre: aes");
+MODULE_SOFTDEP("pre: cmac");
+MODULE_SOFTDEP("pre: sha256");
+#endif /* CONFIG_CIFS_SMB2 */
 module_init(init_cifs)
 module_exit(exit_cifs)

-- 
Jean Delvare
SUSE L3 Support
