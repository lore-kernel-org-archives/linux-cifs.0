From: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Subject: [26/34] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition
Date: Fri, 06 Aug 2010 11:57:21 -0700
Message-ID: <20100806185836.185076461@clark.site>
References: <20100806185853.GA28270@kroah.com>
Cc: stable-review-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100806185853.GA28270-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------
 [stable] [PATCH 2.6.32/stable] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition

From: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>

An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error

fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'

This adds the correct header file to fix this.

Signed-off-by: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>

---
 fs/cifs/dns_resolve.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -24,6 +24,8 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
+#include <linux/module.h>
+
 extern int __init cifs_init_dns_resolver(void);
 extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
