From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: pam_mount
Date: Tue, 18 Feb 2014 20:03:48 -0500
Message-ID: <20140218200348.35409603@tlielax.poochiereds.net>
References: <CF292D56.1B153%swangdb@auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Dave Swanger <swangdb-7KF8pGZKO2M3uPMLIKxrzw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF292D56.1B153%swangdb-7KF8pGZKO2M3uPMLIKxrzw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 18 Feb 2014 21:31:30 +0000
Dave Swanger <swangdb-7KF8pGZKO2M3uPMLIKxrzw@public.gmane.org> wrote:

> Jeff,
>=20
> My name is David Swanger, I am computer analyst at Auburn University.=
  I have a server issue and your Red Hat Summit web site leads me to th=
ink maybe you can help me.
>=20

Typically, these sorts of questions get sent to the linux-cifs mailing
list. I've cc'ed it here...

> http://www.redhat.com/promo/summit/2010/presentations/summit/in-the-w=
eeds/wed/jlayton-310-interoperability/jlayton_summit_2010-Final.pdf
>=20
> I have a RHEL 6 server.  Users authenticate with an AD server and tha=
t works fine.  I used Powerbroker to help connect to the AD server.
>=20

Never heard of powerbroker, sorry...

> I want users to be able to cifs mount their home directories from a S=
amba server using pam_mount and kerberos.  I have a pam_mount.conf.xml =
with mount information/flags.
>=20
> Here is what happens.  People log in and their home directories do no=
t mount.  In the system log, they are trying and failing to get a syste=
m ticket.
>=20
>=20
> Feb 18 15:15:38 mallard2 cifs.upcall: handle_krb5_mech: getting servi=
ce ticket for ausamba.auburn.edu
>=20
> Feb 18 15:15:38 mallard2 cifs.upcall: cifs_krb5_get_req: unable to re=
solve (null) to ccache
>=20
> Feb 18 15:15:38 mallard2 cifs.upcall: handle_krb5_mech: failed to obt=
ain service ticket (-1765328245)
>=20
> However, if they enter a kinit command, enter their password, log out=
 then log back in, then their home dirs are mounted.  Basically I guess=
 I=92d like the user to auto enter a kinit command when they first log =
in.  Do you know how to make this work?
>=20

Typically, you use something like pam_krb5 to get krb5 creds at login
time, or nowadays something like sssd.

> If you can help, I would appreciate it.  If not, I understand.
>=20

Good luck!

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
