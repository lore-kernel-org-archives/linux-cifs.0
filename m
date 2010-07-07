From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] Generalise dns_resolver
Date: Wed, 7 Jul 2010 14:08:12 -0500
Message-ID: <AANLkTik3NOauuQNsaUbdMj-jTjIT6AKUN8PpZrOpoDqK@mail.gmail.com>
References: <20100707091400.16573.2817.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707091400.16573.2817.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ok - sounds fine at first glance to me, but I will look. thx (this
will help smb2 too - to have dns code separated out)

On Wed, Jul 7, 2010 at 4:14 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> Hi Steve,
>
> The associated patches extract the dns_resolver key type from the CIF=
S
> filesystem and make it useful by AFS too. =A0Can you check at least t=
he second
> patch which actually modifies CIFS?
>
> Thanks,
> David
> ---
>
> David Howells (1):
> =A0 =A0 =A0KEYS: Authorise keyctl_set_timeout() on a key if we have i=
ts authorisation key
>
> Wang Lei (3):
> =A0 =A0 =A0Add DNS support for AFS
> =A0 =A0 =A0Provide generic DNS query function
> =A0 =A0 =A0Implement a DNS Resolver Module
>
>
> =A0Documentation/networking/dnsresolver.txt | =A0150 +++++++++++++++
> =A0fs/afs/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 | =A0 =A01
> =A0fs/afs/cell.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0| =A0 40 +++-
> =A0fs/cifs/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
| =A0 17 +-
> =A0fs/cifs/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=
 =A0 =A02
> =A0fs/cifs/cifs_dfs_ref.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0=
4
> =A0fs/cifs/cifsfs.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=
 =A0 13 -
> =A0fs/cifs/dns_resolve.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
168 -----------------
> =A0fs/cifs/dns_resolve.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 32 ---
> =A0include/keys/dnsresolver-type.h =A0 =A0 =A0 =A0 =A0| =A0 23 ++
> =A0include/linux/dns_resolver.h =A0 =A0 =A0 =A0 =A0 =A0 | =A0 37 ++++
> =A0net/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0| =A0 =A01
> =A0net/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 | =A0 =A01
> =A0net/dnsresolver/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 2=
7 +++
> =A0net/dnsresolver/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0=
7 +
> =A0net/dnsresolver/dns_query.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0130 ++=
+++++++++++
> =A0net/dnsresolver/dns_resolver.c =A0 =A0 =A0 =A0 =A0 | =A0293 ++++++=
++++++++++++++++++++++++
> =A0net/dnsresolver/internal.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 39 ++=
++
> =A0net/dnsresolver/resolv_unc_to_ip.c =A0 =A0 =A0 | =A0111 ++++++++++=
+
> =A0security/keys/keyctl.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 1=
7 ++
> =A020 files changed, 879 insertions(+), 234 deletions(-)
> =A0create mode 100644 Documentation/networking/dnsresolver.txt
> =A0delete mode 100644 fs/cifs/dns_resolve.c
> =A0delete mode 100644 fs/cifs/dns_resolve.h
> =A0create mode 100644 include/keys/dnsresolver-type.h
> =A0create mode 100644 include/linux/dns_resolver.h
> =A0create mode 100644 net/dnsresolver/Kconfig
> =A0create mode 100644 net/dnsresolver/Makefile
> =A0create mode 100644 net/dnsresolver/dns_query.c
> =A0create mode 100644 net/dnsresolver/dns_resolver.c
> =A0create mode 100644 net/dnsresolver/internal.h
> =A0create mode 100644 net/dnsresolver/resolv_unc_to_ip.c
>
>



--
Thanks,

Steve
