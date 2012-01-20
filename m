From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: eliminate CONFIG_CIFS_WEAK_PW_HASH
Date: Fri, 20 Jan 2012 16:01:05 -0500
Message-ID: <20120120160105.5e2f7286@tlielax.poochiereds.net>
References: <1327091153-22391-1-git-send-email-jlayton@redhat.com>
	<CAH2r5msOk=4rz_XUGi+GitzVGyJrSo9B1iGXdjz0Bnymzt0NyQ@mail.gmail.com>
	<20120120153856.6ded308a@tlielax.poochiereds.net>
	<CAH2r5ms6YbZp+erat9RQw7-vMxem6vLWp72Yaf=Z8d4p=4+BBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms6YbZp+erat9RQw7-vMxem6vLWp72Yaf=Z8d4p=4+BBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Jan 2012 14:45:48 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> My general thinking on this is as follows:
>=20
> If the kernel is distributed to all the workstations in an organizati=
on
> with this Kconfig option disabled, it makes it harder for individual =
users
> to make the mistake of enabling lanman (sec=3Dlanman, or the Kconfig
> option) on a public network and thus send weak password hashes
> which could be discovered simply.   Most distros make the choice
> of enabling broader compatibility with old pre-1997 servers but
> it is a very small set of servers who would require lanman support,
> and a large number of potential attackers who could benefit if
> users enable lanman on a public network.  I suspect that there
> are environments where removing code (via Kconfig) is preferred
> to trusting all owners of all workstations running that organizations
> standard linux to never enable lanman at runtime.
>=20
> But ... the opinion of security specialists on this would be welcome.
>=20

There are myriads of ways for someone to screw themselves if you give
them root access. This one is pretty low on the list.

Code quality is important for security too, and the writhing mass of
ifdefs below is impossible to parse by eye and therefore debug. At some
point we have to weigh what requires a Kconfig option, and what doesn't=
=2E

Given that this can be administratively prohibited at runtime, I see
absolutely no need to keep this Kconfig option around. It just adds a
maintenance burden for no benefit.

While it's well and good to say you want to hear from "security
specialists", I'm not sure what that means and it sounds awfully open
ended. Is a lack of objection sufficient for you to take this patch or
do you need something else?

[...]

> >> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> > index 76e7d8b..0e56b1e 100644
> >> > --- a/fs/cifs/cifsglob.h
> >> > +++ b/fs/cifs/cifsglob.h
> >> > @@ -853,13 +853,8 @@ static inline void free_dfs_info_array(stru=
ct dfs_info3_param *param,
> >> > =C2=A0#define =C2=A0 CIFSSEC_MAY_NTLM =C2=A0 =C2=A0 0x00002
> >> > =C2=A0#define =C2=A0 CIFSSEC_MAY_NTLMV2 =C2=A0 0x00004
> >> > =C2=A0#define =C2=A0 CIFSSEC_MAY_KRB5 =C2=A0 =C2=A0 0x00008
> >> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> >> > =C2=A0#define =C2=A0 CIFSSEC_MAY_LANMAN =C2=A0 0x00010
> >> > =C2=A0#define =C2=A0 CIFSSEC_MAY_PLNTXT =C2=A0 0x00020
> >> > -#else
> >> > -#define =C2=A0 CIFSSEC_MAY_LANMAN =C2=A0 =C2=A00
> >> > -#define =C2=A0 CIFSSEC_MAY_PLNTXT =C2=A0 =C2=A00
> >> > -#endif /* weak passwords */
> >> > =C2=A0#define =C2=A0 CIFSSEC_MAY_SEAL =C2=A0 =C2=A0 0x00040 /* n=
ot supported yet */
> >> > =C2=A0#define =C2=A0 CIFSSEC_MAY_NTLMSSP =C2=A00x00080 /* raw nt=
lmssp with ntlmv2 */
> >> >
> >> > @@ -870,23 +865,13 @@ require use of the stronger protocol */
> >> > =C2=A0#define =C2=A0 CIFSSEC_MUST_NTLM =C2=A0 =C2=A00x02002
> >> > =C2=A0#define =C2=A0 CIFSSEC_MUST_NTLMV2 =C2=A00x04004
> >> > =C2=A0#define =C2=A0 CIFSSEC_MUST_KRB5 =C2=A0 =C2=A00x08008
> >> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> >> > =C2=A0#define =C2=A0 CIFSSEC_MUST_LANMAN =C2=A00x10010
> >> > =C2=A0#define =C2=A0 CIFSSEC_MUST_PLNTXT =C2=A00x20020
> >> > =C2=A0#ifdef CONFIG_CIFS_UPCALL
> >> > =C2=A0#define =C2=A0 CIFSSEC_MASK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00xBF0BF /* allows weak security but also krb5 */
> >> > -#else
> >> > +#else /* UPCALL */
> >> > =C2=A0#define =C2=A0 CIFSSEC_MASK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00xB70B7 /* current flags supported if weak */
> >> > =C2=A0#endif /* UPCALL */
> >> > -#else /* do not allow weak pw hash */
> >> > -#define =C2=A0 CIFSSEC_MUST_LANMAN =C2=A00
> >> > -#define =C2=A0 CIFSSEC_MUST_PLNTXT =C2=A00
> >> > -#ifdef CONFIG_CIFS_UPCALL
> >> > -#define =C2=A0 CIFSSEC_MASK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
x8F08F /* flags supported if no weak allowed */
> >> > -#else
> >> > -#define =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CIFSSEC_MASK =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00x87087 /* flags supported if no weak allowed *=
/
> >> > -#endif /* UPCALL */
> >> > -#endif /* WEAK_PW_HASH */
> >> > =C2=A0#define =C2=A0 CIFSSEC_MUST_SEAL =C2=A0 =C2=A00x40040 /* n=
ot supported yet */
> >> > =C2=A0#define =C2=A0 CIFSSEC_MUST_NTLMSSP 0x80080 /* raw ntlmssp=
 with ntlmv2 */
> >> >
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
