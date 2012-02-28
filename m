From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Tue, 28 Feb 2012 14:03:53 -0600
Message-ID: <CAH2r5mvJE+ACNVuv+HEQMuwvaMTzfOb7Msk4U1ZVnZ046AEi1Q@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<20120228114341.1629ed85@tlielax.poochiereds.net>
	<CAH2r5mvFyw8Cn8nXN9ZBZogBGVr5L5T9aX7Zs8DOiZgDUqGp1Q@mail.gmail.com>
	<20120228144736.18124fc3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120228144736.18124fc3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Attempt to summarize after discussions with jra and Chris:

- don't make default case to Samba worse performance than it already is
- don't "fix" by adding restrictions on echo retries and blocking
locks when it is not broken (windows allows these, and counts blocking
locks against the pid not against the session).   For servers which
allow few mpx, perhaps those for 10 or fewer - if you think they are
buggy, I don't mind treating echo and blocking locks differently than
we do now - but echo and blocking locks don't need to be restricted
the way Pavel suggested to windows and samba and any normal server
(and there is some risk in restricting them that way).   We could
probably limit the number of blocking locks (out of resource error,
returning ENOLOCK) when there are 50 (e.g.) on a process (or 10 if the
server supports maxmpx of 10, and zero if maxmpx is less than 3 or
less than 10).
- for other smb requests (the ones we enforce today) enforce the limit
the server returns (rather than 50 always)

On Tue, Feb 28, 2012 at 1:47 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Tue, 28 Feb 2012 11:42:49 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I think the best way to handle this is to do the special casing
>> (limiting retries, turning off byte range blocking locks, turning of=
f
>> oplock) for the servers which do limit maxmpx to small values. =A0 F=
or
>> maxmpx=3D50 or higher (or if you wish to narrow this, distinguish
>> servers like Samba more narrowly by check for the unix extensions th=
at
>> is fine) which shouldn't be stricter than windows (whose client will
>> exceed 50 simultaneous requests for various cases Chris described).
>> There is a significant chance of deadlock if we don't allow writes
>> through due to counting blocking byte range locks against maxmpx too
>> strictly. =A0 We do have to fix the case of maxmpx =3D 1 or 2 (disab=
le
>> oplock and possibly echo) and enforce maxmpx for those which set it
>> lower than 50 - but the byte range lock issue has never come up, and
>> fixing it the way pavel describes would be stricter than windows and
>> risk deadlock by chewing up slots.
>>
>> Another issue is that we are significantly underutilizes Samba by
>> setting maxmpx so low, but if we expect to move to SMB2 soon, it may
>> not matter.
>>
>
> I'm having a hard time understanding what you're proposing above. It
> sounds like you're saying that when the server sends maxmpx >=3D 50 t=
hat
> you think we should effectively treat that as unlimited?
>
> Can you lay out the "rules" (and the exceptions thereof) that you're
> proposing here?
>
> - --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
>
> iQIcBAEBAgAGBQJPTS9YAAoJEAAOaEEZVoIVduYQANVGfFMVX0Z2TKKcPXN5NsUX
> aGssTTToK2JK6kSbKFmSxQHCmD4nSPHc3W5qpsk4VQ0F5KC6tuNMowcWHJaZ/f2f
> Qo2TiH7jgRneWOv2y7dxZ66Gs+1mPPIVREhHq0EJzVH/WPcUq+VRkwl3O8k+WQOh
> QVZYoj5Aap/sKzwjdX5LcS4jUEuqXVZG/np216grKr1zKpgo4fAXk22sFrpivKyP
> XUyyP6SU5EAg2EbA7lbEGGmmfQz7HRiWZ+Vnwd9gdbA1up6vtaSF4ms5aiE6y+XN
> c+kaGvgP6EWnNblavEEOJd9+dksHQ5fXRo6t3rGvFmdkAGZlk6kCse6N6zaKnpCi
> XEeoIhq/FDAlUNmU7/B4IoXkHqrf7LgXQvycuP3iUFK5N61FfO+NQvtOuHhhbhH8
> c4JoiVheQKJh3DJww6DkrLmmjKhwf1byrsYLyCs0Xm/YyK//tlKeN3zF0hS3j8f8
> f17P1QyeE1E+FWd+QEThTKuR5vMNcCA4yBFctC7gidi98vPY2L6+xNTqUWZkUTdr
> pBSiKahXms8oNyvf1ijqoy99wRLIOL0fXLUIBF/NXDw0Gy4YmJvR5PKewoXQYu+R
> JEITC1MPiizA7YKgx37OmkERGpVl97r9QS2FvpSUhBfsgoXOKWR4cs+7KPGZQBBF
> Ao/y7L/DAVGFoYbMuTZF
> =3DjJfp
> -----END PGP SIGNATURE-----



--=20
Thanks,

Steve
