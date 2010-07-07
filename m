From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] Generalise dns_resolver
Date: Wed, 07 Jul 2010 10:14:00 +0100
Message-ID: <20100707091400.16573.2817.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

The associated patches extract the dns_resolver key type from the CIFS
filesystem and make it useful by AFS too.  Can you check at least the second
patch which actually modifies CIFS?

Thanks,
David
---

David Howells (1):
      KEYS: Authorise keyctl_set_timeout() on a key if we have its authorisation key

Wang Lei (3):
      Add DNS support for AFS
      Provide generic DNS query function
      Implement a DNS Resolver Module


 Documentation/networking/dnsresolver.txt |  150 +++++++++++++++
 fs/afs/Kconfig                           |    1 
 fs/afs/cell.c                            |   40 +++-
 fs/cifs/Kconfig                          |   17 +-
 fs/cifs/Makefile                         |    2 
 fs/cifs/cifs_dfs_ref.c                   |    4 
 fs/cifs/cifsfs.c                         |   13 -
 fs/cifs/dns_resolve.c                    |  168 -----------------
 fs/cifs/dns_resolve.h                    |   32 ---
 include/keys/dnsresolver-type.h          |   23 ++
 include/linux/dns_resolver.h             |   37 ++++
 net/Kconfig                              |    1 
 net/Makefile                             |    1 
 net/dnsresolver/Kconfig                  |   27 +++
 net/dnsresolver/Makefile                 |    7 +
 net/dnsresolver/dns_query.c              |  130 +++++++++++++
 net/dnsresolver/dns_resolver.c           |  293 ++++++++++++++++++++++++++++++
 net/dnsresolver/internal.h               |   39 ++++
 net/dnsresolver/resolv_unc_to_ip.c       |  111 +++++++++++
 security/keys/keyctl.c                   |   17 ++
 20 files changed, 879 insertions(+), 234 deletions(-)
 create mode 100644 Documentation/networking/dnsresolver.txt
 delete mode 100644 fs/cifs/dns_resolve.c
 delete mode 100644 fs/cifs/dns_resolve.h
 create mode 100644 include/keys/dnsresolver-type.h
 create mode 100644 include/linux/dns_resolver.h
 create mode 100644 net/dnsresolver/Kconfig
 create mode 100644 net/dnsresolver/Makefile
 create mode 100644 net/dnsresolver/dns_query.c
 create mode 100644 net/dnsresolver/dns_resolver.c
 create mode 100644 net/dnsresolver/internal.h
 create mode 100644 net/dnsresolver/resolv_unc_to_ip.c
