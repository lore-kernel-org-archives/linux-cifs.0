From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Define ENONAMESERVICE and ENAMEUNKNOWN to indicate
 name service errors
Date: Wed, 8 Feb 2012 10:50:34 -0600
Message-ID: <CAH2r5msPsdUJ6uAAfWvDL75Cr=jXfFVNy_AO8PeKCuU6agptKw@mail.gmail.com>
References: <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
	<20120208122917.8902.78395.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120208122917.8902.78395.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Interesting ... may allow us to map a few of the NT STATUS codes
to this new rc 135.  We will have to scan the error mapping table

On Wed, Feb 8, 2012 at 6:29 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> Now that the kernel has filesystems (and possibly other services) tha=
t want to
> look up internet addresses corresponding to arbitrary hostnames retri=
eved from
> the server, it would seem useful to provide a couple of error codes t=
o indicate
> problems with the look up, rather than overloading some other error c=
ode.
>
> Define ENONAMESERVICE to indicate "Network name service unavailable".=
 =A0This can
> be used to indicate, for example, that an attempt was made by dns_que=
ry() to
> make a query, but the name server (e.g. a DNS server) it is supposed =
to contact
> didn't answer or that it couldn't determine the location of a suitabl=
e server.
>
> Define ENAMEUNKNOWN to indicate "Network name unknown". =A0This can b=
e used to
> indicate, for example, that an attempt was made by dns_query() to mak=
e a query,
> but the name server (e.g. a DNS server) replied indicating that it ha=
d no
> matching records.
>
> The DNS query upcall program can report these to keyctl_reject() so t=
hat cached
> failed queries will respond with these errors until they expire.
>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
> =A0arch/alpha/include/asm/errno.h =A0| =A0 =A02 ++
> =A0arch/mips/include/asm/errno.h =A0 | =A0 =A02 ++
> =A0arch/parisc/include/asm/errno.h | =A0 =A02 ++
> =A0arch/sparc/include/asm/errno.h =A0| =A0 =A02 ++
> =A0include/asm-generic/errno.h =A0 =A0 | =A0 =A02 ++
> =A05 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/arch/alpha/include/asm/errno.h b/arch/alpha/include/asm/=
errno.h
> index 5edc21e..d6e8582 100644
> --- a/arch/alpha/include/asm/errno.h
> +++ b/arch/alpha/include/asm/errno.h
> @@ -122,6 +122,8 @@
>
> =A0#define =A0 =A0 =A0 =A0ERFKILL =A0 =A0 =A0 =A0 138 =A0 =A0 /* Oper=
ation not possible due to RF-kill */
> =A0#define =A0 =A0 =A0 =A0ENOAUTHSERVICE =A0139 =A0 =A0 /* Authentica=
tion service not available */
> +#define =A0 =A0 =A0 =A0ENONAMESERVICE =A0140 =A0 =A0 /* Network name=
 service unavailable */
> +#define =A0 =A0 =A0 =A0ENAMEUNKNOWN =A0 =A0141 =A0 =A0 /* Network na=
me unknown */
>
> =A0#define EHWPOISON =A0 =A0 =A0139 =A0 =A0 /* Memory page has hardwa=
re error */
>
> diff --git a/arch/mips/include/asm/errno.h b/arch/mips/include/asm/er=
rno.h
> index 9e0b83f..5ae25aa 100644
> --- a/arch/mips/include/asm/errno.h
> +++ b/arch/mips/include/asm/errno.h
> @@ -121,6 +121,8 @@
>
> =A0#define =A0 =A0 =A0 =A0ERFKILL =A0 =A0 =A0 =A0 167 =A0 =A0 /* Oper=
ation not possible due to RF-kill */
> =A0#define =A0 =A0 =A0 =A0ENOAUTHSERVICE =A0168 =A0 =A0 /* Authentica=
tion service not available */
> +#define =A0 =A0 =A0 =A0ENONAMESERVICE =A0169 =A0 =A0 /* Network name=
 service unavailable */
> +#define =A0 =A0 =A0 =A0ENAMEUNKNOWN =A0 =A0170 =A0 =A0 /* Network na=
me unknown */
>
> =A0#define EHWPOISON =A0 =A0 =A0168 =A0 =A0 /* Memory page has hardwa=
re error */
>
> diff --git a/arch/parisc/include/asm/errno.h b/arch/parisc/include/as=
m/errno.h
> index c4598b6..6b3bc7f 100644
> --- a/arch/parisc/include/asm/errno.h
> +++ b/arch/parisc/include/asm/errno.h
> @@ -122,6 +122,8 @@
>
> =A0#define =A0 =A0 =A0 =A0ERFKILL =A0 =A0 =A0 =A0 256 =A0 =A0 /* Oper=
ation not possible due to RF-kill */
> =A0#define =A0 =A0 =A0 =A0ENOAUTHSERVICE =A0257 =A0 =A0 /* Authentica=
tion service not available */
> +#define =A0 =A0 =A0 =A0ENONAMESERVICE =A0258 =A0 =A0 /* Network name=
 service unavailable */
> +#define =A0 =A0 =A0 =A0ENAMEUNKNOWN =A0 =A0259 =A0 =A0 /* Network na=
me unknown */
>
> =A0#define EHWPOISON =A0 =A0 =A0257 =A0 =A0 /* Memory page has hardwa=
re error */
>
> diff --git a/arch/sparc/include/asm/errno.h b/arch/sparc/include/asm/=
errno.h
> index ab4f9f5..5fab088 100644
> --- a/arch/sparc/include/asm/errno.h
> +++ b/arch/sparc/include/asm/errno.h
> @@ -112,6 +112,8 @@
>
> =A0#define =A0 =A0 =A0 =A0ERFKILL =A0 =A0 =A0 =A0 134 =A0 =A0 /* Oper=
ation not possible due to RF-kill */
> =A0#define =A0 =A0 =A0 =A0ENOAUTHSERVICE =A0135 =A0 =A0 /* Authentica=
tion service not available */
> +#define =A0 =A0 =A0 =A0ENONAMESERVICE =A0136 =A0 =A0 /* Network name=
 service unavailable */
> +#define =A0 =A0 =A0 =A0ENAMEUNKNOWN =A0 =A0137 =A0 =A0 /* Network na=
me unknown */
>
> =A0#define EHWPOISON =A0 =A0 =A0135 =A0 =A0 /* Memory page has hardwa=
re error */
>
> diff --git a/include/asm-generic/errno.h b/include/asm-generic/errno.=
h
> index 52325ca..719f60c 100644
> --- a/include/asm-generic/errno.h
> +++ b/include/asm-generic/errno.h
> @@ -108,6 +108,8 @@
>
> =A0#define ERFKILL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0132 =A0 =A0 /* Oper=
ation not possible due to RF-kill */
> =A0#define =A0 =A0 =A0 =A0ENOAUTHSERVICE =A0133 =A0 =A0 /* Authentica=
tion service not available */
> +#define =A0 =A0 =A0 =A0ENONAMESERVICE =A0134 =A0 =A0 /* Network name=
 service unavailable */
> +#define =A0 =A0 =A0 =A0ENAMEUNKNOWN =A0 =A0135 =A0 =A0 /* Network na=
me unknown */
>
> =A0#define EHWPOISON =A0 =A0 =A0133 =A0 =A0 /* Memory page has hardwa=
re error */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
