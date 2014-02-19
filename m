From: Dave Swanger <swangdb-7KF8pGZKO2M3uPMLIKxrzw@public.gmane.org>
Subject: Re: pam_mount
Date: Wed, 19 Feb 2014 12:51:59 +0000
Message-ID: <CF2A050A.1B169%swangdb@auburn.edu>
References: <20140218200348.35409603@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140218200348.35409603-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Language: en-US
Content-ID: <B25680E6FDAF2B48AE2D1190B235C68C-7KF8pGZKO2M3uPMLIKxrzw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks Jeff!

On 2/18/14, 7:03 PM, "Jeff Layton" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

>On Tue, 18 Feb 2014 21:31:30 +0000
>Dave Swanger <swangdb-7KF8pGZKO2M3uPMLIKxrzw@public.gmane.org> wrote:
>
>> Jeff,
>>=20
>> My name is David Swanger, I am computer analyst at Auburn University=
=2E
>>I have a server issue and your Red Hat Summit web site leads me to th=
ink
>>maybe you can help me.
>>=20
>
>Typically, these sorts of questions get sent to the linux-cifs mailing
>list. I've cc'ed it here...
>
>>=20
>>http://www.redhat.com/promo/summit/2010/presentations/summit/in-the-w=
eeds
>>/wed/jlayton-310-interoperability/jlayton_summit_2010-Final.pdf
>>=20
>> I have a RHEL 6 server.  Users authenticate with an AD server and th=
at
>>works fine.  I used Powerbroker to help connect to the AD server.
>>=20
>
>Never heard of powerbroker, sorry...
>
>> I want users to be able to cifs mount their home directories from a
>>Samba server using pam_mount and kerberos.  I have a pam_mount.conf.x=
ml
>>with mount information/flags.
>>=20
>> Here is what happens.  People log in and their home directories do n=
ot
>>mount.  In the system log, they are trying and failing to get a syste=
m
>>ticket.
>>=20
>>=20
>> Feb 18 15:15:38 mallard2 cifs.upcall: handle_krb5_mech: getting serv=
ice
>>ticket for ausamba.auburn.edu
>>=20
>> Feb 18 15:15:38 mallard2 cifs.upcall: cifs_krb5_get_req: unable to
>>resolve (null) to ccache
>>=20
>> Feb 18 15:15:38 mallard2 cifs.upcall: handle_krb5_mech: failed to
>>obtain service ticket (-1765328245)
>>=20
>> However, if they enter a kinit command, enter their password, log ou=
t
>>then log back in, then their home dirs are mounted.  Basically I gues=
s
>>I=B9d like the user to auto enter a kinit command when they first log=
 in.
>>Do you know how to make this work?
>>=20
>
>Typically, you use something like pam_krb5 to get krb5 creds at login
>time, or nowadays something like sssd.
>
>> If you can help, I would appreciate it.  If not, I understand.
>>=20
>
>Good luck!
>
>--=20
>Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
