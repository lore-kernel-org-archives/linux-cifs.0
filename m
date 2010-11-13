From: Jody Bruchon <jody-CwlhuK3P8e+1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH] fs/cifs/Kconfig: CIFS depends on CRYPTO_HMAC
Date: Sat, 13 Nov 2010 15:09:04 -0500
Message-ID: <4CDEF060.2050000@nctritech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

  I sent this patch in to LKML, but later realized it should probably go 
here.  I don't subscribe to the list, so please CC me directly with any 
replies.  Thanks!

Jody Bruchon

-------- Original Message --------
Subject: 	[PATCH] fs/cifs/Kconfig: CIFS depends on CRYPTO_HMAC
Date: 	Fri, 12 Nov 2010 13:41:06 -0500
From: 	Jody Bruchon <jody-CwlhuK3P8e+1Z/+hSey0Gg@public.gmane.org>
To: 	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


linux-2.6.37-rc1: I compiled a kernel with CIFS which subsequently
failed with an error indicating it couldn't initialize crypto module
"hmacmd5".  CONFIG_CRYPTO_HMAC=y fixed the problem.

This patch makes CIFS depend on CRYPTO_HMAC in kconfig.

Signed-off-by: Jody Bruchon<jody-CwlhuK3P8e+1Z/+hSey0Gg@public.gmane.org>
---

diff -Naur linux-2.6.37-rc1/fs/cifs/Kconfig b/fs/cifs/Kconfig
--- linux-2.6.37-rc1/fs/cifs/Kconfig    2010-11-12 13:22:31.742999981 -0500
+++ b/fs/cifs/Kconfig    2010-11-12 13:22:27.528998658 -0500
@@ -4,6 +4,7 @@
      select NLS
      select CRYPTO
      select CRYPTO_MD5
+    select CRYPTO_HMAC
      select CRYPTO_ARC4
      help
        This is the client VFS module for the Common Internet File System
