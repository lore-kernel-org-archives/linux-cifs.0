From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 3/3] cifs: Add soft dependencies
Date: Fri, 22 Jan 2016 10:23:50 +0100
Message-ID: <20160122102350.01fb58e1@endymion.delvare>
References: <20160122101654.20fa96e3@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122101654.20fa96e3-R0o5gVi9kd7kN2dkZ6Wm7A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

List soft dependencies of cifs so that mkinitrd and dracut can include
the required helper modules.

Signed-off-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- linux-4.5-rc0.orig/fs/cifs/cifsfs.c	2016-01-22 09:52:03.649746373 +0100
+++ linux-4.5-rc0/fs/cifs/cifsfs.c	2016-01-22 10:03:03.156927472 +0100
@@ -1359,5 +1359,17 @@ MODULE_DESCRIPTION
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
