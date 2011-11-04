From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: How to test multiusermount?
Date: Fri, 4 Nov 2011 10:02:31 -0400
Message-ID: <20111104100231.57ad94d6@tlielax.poochiereds.net>
References: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA@mail.gmail.com>
	<20111101060428.5d474bb9@tlielax.poochiereds.net>
	<4EB37983.3080607@suse.com>
	<CAH2r5mtAbBhRj6SSB5TNWW4OtTJhno7szPH7FR6tn0rS1FB6=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtAbBhRj6SSB5TNWW4OtTJhno7szPH7FR6tn0rS1FB6=w@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 4 Nov 2011 00:56:16 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Nov 4, 2011 at 12:34 AM, Suresh Jayaraman <sjayaraman-WDPRK7U/wSs@public.gmane.org=
m> wrote:
> > On 11/01/2011 03:34 PM, Jeff Layton wrote:
> >> On Tue, 1 Nov 2011 00:12:21 +0100
> >> Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> Hi,
> >>>
> >>> I would like to test the multiusermounts?
> >>>
> >>> I know to set:
> >>>
> >>> =C2=A0echo 1 > /proc/fs/cifs/MultiuserMount
> >>>
> >>> and add an option to the mount command, but I can remember/read s=
omewhere
> >>> that one have to add some mapping somehwere:
> >>>
> >>> local user : remote user
> >>> ...
> >>>
> >>> Is this correct?
> >>>
> >>
> >> No. The MultiuserMount code that the above switch activates is
> >> basically deprecated (and never worked very well in the first plac=
e).
> >
> > So, time for planning its good riddance?
>=20
> Mainly waiting for some way to have ntlmv2 enablement of multiuser
> mount (krb5 only is too restrictive).
>=20

Right. The new multiuser code only works with krb5 so far. I=20
think in order to deprecate the old code, we need to do the following:

1) the cifscreds program in cifs-utils will need to be cleaned up and
completed. This would allow users to stash their NTLM creds in the
kernel's keyring. This includes username and password, and some info
about which creds should be used with which servers (or NT domains).
The existing format for stashing those creds is probably not what we
need so this is a bit of work and redesign I think.

2) code will need to be added to the kernel to fetch NTLM auth info out
of the kernel keyring for establishing new sessions.

3) better documentation for multiuser mounts. This is always an issue,
but multiuser is more complicated so we'll really need this.

At that point, I think we can schedule the old multiuser code for
deprecation.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
