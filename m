From: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 2.6.32/stable] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition
Date: Wed, 04 Aug 2010 08:32:13 +1000
Message-ID: <20749.1280874733@neuling.org>
References: <19826.1280811821@neuling.org> <19789.1280811783@neuling.org> <12482.1280871625@redhat.com>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <12482.1280871625-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In message <12482.1280871625-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> you wrote:
> Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org> wrote:
> 
> > An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error
> > 
> > fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attrib
ute__' before 'cifs_init_dns_resolver'
> > 
> > This removes the __init from cifs_init_dns_resolver()
> 
> That's not really a good idea as the assembler may choose different pieces of
> assembly to do variable references and jumps, depending on the section
> information.
> 
> A better fix is to add:
> 
> 	#include <linux/module.h>
> 
> to the header file.

Ok, new patch below.



CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition

An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error

fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'

This adds the correct header file to fix this. 

Signed-off-by: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org (for 2.6.32)

Index: linux-2.6-ozlabs/fs/cifs/dns_resolve.h
===================================================================
--- linux-2.6-ozlabs.orig/fs/cifs/dns_resolve.h
+++ linux-2.6-ozlabs/fs/cifs/dns_resolve.h
@@ -24,6 +24,8 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
+#include <linux/module.h>
+
 extern int __init cifs_init_dns_resolver(void);
 extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
