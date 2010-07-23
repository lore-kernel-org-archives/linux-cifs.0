From: =?iso-8859-1?Q?Bj=F6rn?= Jacke <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Fri, 23 Jul 2010 11:14:53 +0200
Message-ID: <E1OcEL8-00DP7W-V3@intern.SerNet.DE>
References: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
 <30448.1279800887@redhat.com>
 <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
 <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
 <E1Obxpd-00CRIo-SF@intern.SerNet.DE>
 <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
 <20100722162712.GB10352@jeremy-laptop>
 <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
 <19528.60019.28495.655512@samba.org>
 <20100723012130.GD16373@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, tridge-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Volk
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100723012130.GD16373-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2010-07-22 at 21:21 -0400 Ted Ts'o sent off:
> Well, not POSIX, because POSIX doesn't have CreationTime at all.
> BSD's birthtime doesn't allow it to be set, and the question here is
> largely philosophical.

actually, it can (partly :). But the way it can be done is an insane ha=
ck:

<quote "http://ace.delos.com/kirk/">
To provide a sensible birth time for applications that are unaware of t=
he birth
time attribute, we changed the semantics of the "utimes" system call so=
 that if
the birth time was newer than the value of the modification time that i=
t was
setting, it sets the birth time to the same time as the modification ti=
me. An
application that is aware of the birth time attribute can set both the =
birth
time and the modification time by doing two calls to "utimes". First it=
 calls
"utimes" with a modification time equal to the saved birth time, then i=
t calls
"utimes" a second time with a modification time equal to the (presumabl=
y newer)
saved modification time.
</quote>

Thus it can also be only be set more in the past.

Cheers
Bj=F6rn
--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
