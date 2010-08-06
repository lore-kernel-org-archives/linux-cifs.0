From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH] CIFS: Include <linux/init.h> in dns_resolve.h
Date: Fri, 06 Aug 2010 01:53:02 +0100
Message-ID: <1281055982.2902.14.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

fs/cifs/dns_resolve.c fails to build on some architectures:

In file included from fs/cifs/dns_resolve.c:30:
fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'

We need to include <linux/init.h> to ensure that __init is defined.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org [after 51c20fc]
---
 fs/cifs/dns_resolve.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
index 5d7f291..71c4769 100644
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -24,6 +24,7 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
+#include <linux/init.h>
 extern int __init cifs_init_dns_resolver(void);
 extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
-- 
1.7.1
