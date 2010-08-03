From: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 2.6.32/stable] CIFS: Remove __exit mark from cifs_init_dns_resolver() header
Date: Tue, 03 Aug 2010 15:03:41 +1000
Message-ID: <19826.1280811821@neuling.org>
References: <19789.1280811783@neuling.org>
Mime-Version: 1.0
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error

fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'

This removes the __init from cifs_init_dns_resolver()

Signed-off-by: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org (for 2.6.32)

Index: linux-2.6-ozlabs/fs/cifs/dns_resolve.h
===================================================================
--- linux-2.6-ozlabs.orig/fs/cifs/dns_resolve.h
+++ linux-2.6-ozlabs/fs/cifs/dns_resolve.h
@@ -24,7 +24,7 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
-extern int __init cifs_init_dns_resolver(void);
+extern int cifs_init_dns_resolver(void);
 extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
 #endif /* KERNEL */
