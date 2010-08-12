From: Bryan Schumaker <bjschuma-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Thu, 12 Aug 2010 11:18:44 -0400
Message-ID: <4C6410D4.6050100@netapp.com>
References: <20100812131741.f3a800d7.sfr@canb.auug.org.au>	<AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com> <20100812174621.b1dbc20f.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100812174621.b1dbc20f.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi

I updated my NFS DNS patch.  The new version will set CONFIG_KEYS when CONFIG_NFS_USE_KERNEL_DNS is set.

Thanks for letting me know about this!

Bryan Schumaker



Use the kernel DNS resolver to translate hostnames to IP addresses.  Create a
new config option to choose between the legacy DNS resolver and the new
resolver.

Signed-off-by: Bryan Schumaker <bjschuma-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Acked-by: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
---
Fix for KEYS dependency

 fs/nfs/Kconfig       |   16 ++++++++++++++++
 fs/nfs/dns_resolve.c |   24 ++++++++++++++++++++++++
 fs/nfs/dns_resolve.h |   12 ++++++++++++
 3 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index cc1bb33..c5bbdca 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -100,3 +100,19 @@ config NFS_FSCACHE
 	help
 	  Say Y here if you want NFS data to be cached locally on disc through
 	  the general filesystem cache manager
+
+config NFS_USE_LEGACY_DNS
+	bool "Use the legacy NFS DNS resolver"
+	depends on NFS_V4
+	help
+	  The kernel now provides a method for translating a host name into an
+	  IP address.  Select Y here if you would rather use your own DNS
+	  resolver script.
+
+	  If unsure, say N
+
+config NFS_USE_KERNEL_DNS
+	bool
+	depends on NFS_V4 && !NFS_USE_LEGACY_DNS
+	select DNS_RESOLVER
+	select KEYS
+	default y
diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
index 76fd235..dba50a5 100644
--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -6,6 +6,29 @@
  * Resolves DNS hostnames into valid ip addresses
  */

+#ifdef CONFIG_NFS_USE_KERNEL_DNS
+
+#include <linux/sunrpc/clnt.h>
+#include <linux/dns_resolver.h>
+
+ssize_t nfs_dns_resolve_name(char *name, size_t namelen,
+		struct sockaddr *sa, size_t salen)
+{
+	ssize_t ret;
+	char *ip_addr = NULL;
+	int ip_len;
+
+	ip_len = dns_query(NULL, name, namelen, NULL, &ip_addr, NULL);
+	if (ip_len > 0)
+		ret = rpc_pton(ip_addr, ip_len, sa, salen);
+	else
+		ret = -ESRCH;
+	kfree(ip_addr);
+	return ret;
+}
+
+#else
+
 #include <linux/hash.h>
 #include <linux/string.h>
 #include <linux/kmod.h>
@@ -346,3 +369,4 @@ void nfs_dns_resolver_destroy(void)
 	nfs_cache_unregister(&nfs_dns_resolve);
 }

+#endif
diff --git a/fs/nfs/dns_resolve.h b/fs/nfs/dns_resolve.h
index a3f0938..199bb55 100644
--- a/fs/nfs/dns_resolve.h
+++ b/fs/nfs/dns_resolve.h
@@ -6,8 +6,20 @@

 #define NFS_DNS_HOSTNAME_MAXLEN	(128)

+
+#ifdef CONFIG_NFS_USE_KERNEL_DNS
+static inline int nfs_dns_resolver_init(void)
+{
+	return 0;
+}
+
+static inline void nfs_dns_resolver_destroy(void)
+{}
+#else
 extern int nfs_dns_resolver_init(void);
 extern void nfs_dns_resolver_destroy(void);
+#endif
+
 extern ssize_t nfs_dns_resolve_name(char *name, size_t namelen,
 		struct sockaddr *sa, size_t salen);




On 08/12/2010 03:46 AM, Stephen Rothwell wrote:
> Hi Steve,
> 
> On Wed, 11 Aug 2010 23:04:36 -0500 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Are you sure that this is a valid config file?  CONFIG_KEYS should be
>> set if CONFIG_DNS_RESOLVER is set?
> 
> It is a ppc64_defconfig.  It has:
> 
> # CONFIG_KEYS is not set
> CONFIG_DNS_RESOLVER=y
> 
> CONFIG_NFS_USE_KERNEL_DNS just selects CONFIG_DNS_RESOLVER but there is
> no dependency on CONFIG_KEYS (select does not care about the
> dependencies of the selected config option).
> 
>> key.h looks like it is included in all arch in this path
>>
>> net/dns_resolver/dns_key.c includes
>> include/keys/dns_resolver-type.h which includes
>> include/linux/key-type.h which includes
>> include/linux/key.h
>>
>> the line 258 "key_instantiate_and_link" error could occur if
>> "CONFIG_KEYS" is not set in .config
> 
> Which t isn't.
> 
>> net/dns_resolver/Kconfig config DNS_RESOLVER "depends on NET && KEYS"
>> so ... CONFIG_KEYS should be set ....
> 
> See above.  You need CONFIG_NFS_USE_KERNEL_DNS to also depend on
> CONFIG_KEYS ...
> 
