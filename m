From: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 2.6.32/stable] CIFS: Remove __exit mark from cifs_exit_dns_resolver()
Date: Tue, 03 Aug 2010 15:03:03 +1000
Message-ID: <19789.1280811783@neuling.org>
Mime-Version: 1.0
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

commit 51c20fcced5badee0e2021c6c89f44aa3cbd72aa

CIFS: Remove __exit mark from cifs_exit_dns_resolver()

Remove the __exit mark from cifs_exit_dns_resolver() as it's called by the
module init routine in case of error, and so may have been discarded during
linkage.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org (for 2.6.32)
---
This fixes a compile error on ppc64 allmodconfig with 2.6.32.17

fs/cifs/dns_resolve.h:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_exit_dns_resolver

Index: linux-2.6-ozlabs/fs/cifs/dns_resolve.c
===================================================================
--- linux-2.6-ozlabs.orig/fs/cifs/dns_resolve.c
+++ linux-2.6-ozlabs/fs/cifs/dns_resolve.c
@@ -226,7 +226,7 @@ failed_put_cred:
 	return ret;
 }
 
-void __exit cifs_exit_dns_resolver(void)
+void cifs_exit_dns_resolver(void)
 {
 	key_revoke(dns_resolver_cache->thread_keyring);
 	unregister_key_type(&key_type_dns_resolver);
Index: linux-2.6-ozlabs/fs/cifs/dns_resolve.h
===================================================================
--- linux-2.6-ozlabs.orig/fs/cifs/dns_resolve.h
+++ linux-2.6-ozlabs/fs/cifs/dns_resolve.h
@@ -25,7 +25,7 @@
 
 #ifdef __KERNEL__
 extern int __init cifs_init_dns_resolver(void);
-extern void __exit cifs_exit_dns_resolver(void);
+extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
 #endif /* KERNEL */
 
