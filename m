From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Wed, 11 Aug 2010 23:04:36 -0500
Message-ID: <AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com>
References: <20100812131741.f3a800d7.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Bryan Schumaker <bjschuma-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100812131741.f3a800d7.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 11, 2010 at 10:17 PM, Stephen Rothwell <sfr-3FnU+UHB4dM8huWDy8Hlbg@public.gmane.org=
u> wrote:
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> net/dns_resolver/dns_key.c: In function 'dns_resolver_instantiate':
> net/dns_resolver/dns_key.c:70: error: dereferencing pointer to incomp=
lete type
> net/dns_resolver/dns_key.c:70: error: dereferencing pointer to incomp=
lete type
> net/dns_resolver/dns_key.c:99: error: dereferencing pointer to incomp=
lete type
> net/dns_resolver/dns_key.c:128: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c:136: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c:143: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c:144: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c:149: error: implicit declaration of functi=
on 'key_payload_reserve'
> net/dns_resolver/dns_key.c:162: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c: In function 'dns_resolver_match':
> net/dns_resolver/dns_key.c:178: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c: In function 'dns_resolver_describe':
> net/dns_resolver/dns_key.c:211: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c:213: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c:217: error: dereferencing pointer to incom=
plete type
> net/dns_resolver/dns_key.c: At top level:
> net/dns_resolver/dns_key.c:220: error: variable 'key_type_dns_resolve=
r' has initializer but incomplete type
> net/dns_resolver/dns_key.c:221: error: unknown field 'name' specified=
 in initializer
> net/dns_resolver/dns_key.c:221: warning: excess elements in struct in=
itializer
> net/dns_resolver/dns_key.c:221: warning: (near initialization for 'ke=
y_type_dns_resolver')
> net/dns_resolver/dns_key.c:222: error: unknown field 'instantiate' sp=
ecified in initializer
> net/dns_resolver/dns_key.c:222: warning: excess elements in struct in=
itializer
> net/dns_resolver/dns_key.c:222: warning: (near initialization for 'ke=
y_type_dns_resolver')
> net/dns_resolver/dns_key.c:223: error: unknown field 'match' specifie=
d in initializer
> net/dns_resolver/dns_key.c:223: warning: excess elements in struct in=
itializer
> net/dns_resolver/dns_key.c:223: warning: (near initialization for 'ke=
y_type_dns_resolver')
> net/dns_resolver/dns_key.c:224: error: unknown field 'revoke' specifi=
ed in initializer
> net/dns_resolver/dns_key.c:224: warning: excess elements in struct in=
itializer
> net/dns_resolver/dns_key.c:224: warning: (near initialization for 'ke=
y_type_dns_resolver')
> net/dns_resolver/dns_key.c:225: error: unknown field 'destroy' specif=
ied in initializer
> net/dns_resolver/dns_key.c:225: warning: excess elements in struct in=
itializer
> net/dns_resolver/dns_key.c:225: warning: (near initialization for 'ke=
y_type_dns_resolver')
> net/dns_resolver/dns_key.c:226: error: unknown field 'describe' speci=
fied in initializer
> net/dns_resolver/dns_key.c:226: warning: excess elements in struct in=
itializer
> net/dns_resolver/dns_key.c:226: warning: (near initialization for 'ke=
y_type_dns_resolver')
> net/dns_resolver/dns_key.c:227: error: unknown field 'read' specified=
 in initializer
> net/dns_resolver/dns_key.c:227: warning: excess elements in struct in=
itializer
> net/dns_resolver/dns_key.c:227: warning: (near initialization for 'ke=
y_type_dns_resolver')
> net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
> net/dns_resolver/dns_key.c:237: error: invalid use of undefined type =
'struct key_type'
> net/dns_resolver/dns_key.c:249: error: implicit declaration of functi=
on 'key_alloc'
> net/dns_resolver/dns_key.c:249: error: 'key_type_keyring' undeclared =
(first use in this function)
> net/dns_resolver/dns_key.c:249: error: (Each undeclared identifier is=
 reported only once
> net/dns_resolver/dns_key.c:249: error: for each function it appears i=
n.)
> net/dns_resolver/dns_key.c:250: error: 'KEY_POS_ALL' undeclared (firs=
t use in this function)
> net/dns_resolver/dns_key.c:250: error: 'KEY_POS_SETATTR' undeclared (=
first use in this function)
> net/dns_resolver/dns_key.c:251: error: 'KEY_USR_VIEW' undeclared (fir=
st use in this function)
> net/dns_resolver/dns_key.c:251: error: 'KEY_USR_READ' undeclared (fir=
st use in this function)
> net/dns_resolver/dns_key.c:252: error: 'KEY_ALLOC_NOT_IN_QUOTA' undec=
lared (first use in this function)
> net/dns_resolver/dns_key.c:258: error: implicit declaration of functi=
on 'key_instantiate_and_link'
> net/dns_resolver/dns_key.c:262: error: implicit declaration of functi=
on 'register_key_type'
> net/dns_resolver/dns_key.c:268: error: 'struct cred' has no member na=
med 'thread_keyring'
> net/dns_resolver/dns_key.c:269: error: 'struct cred' has no member na=
med 'jit_keyring'
> net/dns_resolver/dns_key.c: In function 'exit_dns_resolver':
> net/dns_resolver/dns_key.c:285: error: implicit declaration of functi=
on 'unregister_key_type'
> net/dns_resolver/dns_key.c:288: error: invalid use of undefined type =
'struct key_type'

> Presumably this code has not been built on powerpc before. =A0Casued =
by
> commit 1a4240f4764ac78adbf4b0ebb49b3bd8c72ffa11 ("DNS: Separate out C=
IFS
> DNS Resolver code") (and the build was probably enabled by commit
> c2e8139c9f797baa46515af6d350c51823736cbb ("NFS: Use kernel DNS resolv=
er
> [ver #2]").
>
> I can only imagine that linux/key.h is included indirectly on x86.
Are you sure that this is a valid config file?  CONFIG_KEYS should be
set if CONFIG_DNS_RESOLVER is set?

key.h looks like it is included in all arch in this path

net/dns_resolver/dns_key.c includes
include/keys/dns_resolver-type.h which includes
include/linux/key-type.h which includes
include/linux/key.h

the line 258 "key_instantiate_and_link" error could occur if
"CONFIG_KEYS" is not set in .config
net/dns_resolver/Kconfig config DNS_RESOLVER "depends on NET && KEYS"
so ... CONFIG_KEYS should be set ....







--=20
Thanks,

Steve
