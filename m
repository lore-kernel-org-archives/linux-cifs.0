From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Thu, 1 Dec 2011 10:50:17 -0500
Message-ID: <20111201105017.189b653c@barsoom.rdu.redhat.com>
References: <4ED3017A.9030502@gmail.com>
	<20111128153207.163adbfe@tlielax.poochiereds.net>
	<CADT32eJ2oa--ER7NFf3wCbmRng7e_KL+D1PV8Lf+sk=_RH97bQ@mail.gmail.com>
	<20111129092339.1ae61788@tlielax.poochiereds.net>
	<jb6mp6$8kf$1@dough.gmane.org>
	<CADT32e+JgM82m5fOsxxj5RGa75d-3Sbv+6kU50UDYcvBL7ZDTg@mail.gmail.com>
	<jb6ogj$igl$1@dough.gmane.org>
	<CADT32eLH98tGFhSaE3uWSQ0pXpqqQeGCiJSiN1+9H4oxE4PTVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLH98tGFhSaE3uWSQ0pXpqqQeGCiJSiN1+9H4oxE4PTVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 1 Dec 2011 00:14:53 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Nov 30, 2011 at 8:24 PM, jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> > On 01/12/11 02:07, Shirish Pargaonkar wrote:
> >
> >> Would be useful if you can capture wireshark traces during
> >> successful attempt with smbclient and failing attempt with cifs cl=
ient.
> >
> > have never used this tool, will install it later tonight. =C2=A0wou=
ld you be kind
> > enough to suggest/supply command-line/usage?
> >
> > thanks.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
> You can use tcpdump (run that in a separate pty/tty) for each,
> smbclient mount and cifs client mount commands.
> Something like   tcpdump -s 4096 -w /tmp/<filename>.cap
> and send those two files with captured packets.
>=20
> and as well and send that file.
> Something like

See the directions here:

http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures

Ideally, you'd probably want to open a bug at bugzilla.samba.org so
you don't have to email these files around (they can be rather large).

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
