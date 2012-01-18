From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Fix build break with multiuser patch when LANMAN disabled
Date: Wed, 18 Jan 2012 17:57:48 -0600
Message-ID: <CAH2r5mvA4DTn=4ekpQCfPpvzMNSYpVxzbnYmRkRHcsuoSj32rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit 88a4412b798236bfdd9284d5c251d76679f944e1
Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Wed Jan 18 17:13:47 2012 -0600



    CC: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ba53c1c..76e7d8b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -879,6 +879,8 @@ require use of the stronger protocol */
 #define   CIFSSEC_MASK          0xB70B7 /* current flags supported if weak */
 #endif /* UPCALL */
 #else /* do not allow weak pw hash */
+#define   CIFSSEC_MUST_LANMAN	0
+#define   CIFSSEC_MUST_PLNTXT	0
 #ifdef CONFIG_CIFS_UPCALL
 #define   CIFSSEC_MASK          0x8F08F /* flags supported if no weak
allowed */
 #else

-- 
Thanks,

Steve
