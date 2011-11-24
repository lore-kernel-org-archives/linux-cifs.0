From: =?iso-8859-1?q?G=FCnter_Kukkukk?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Thu, 24 Nov 2011 06:08:29 +0100
Message-ID: <201111240608.31146.linux@kukkukk.com>
References: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com> <20111123171245.3e3f18a7@lxorguk.ukuu.org.uk> <CADDb1s2OcfjwAJoTTbR6547hDL68PJFg_jD_vAs-nGmgiO6YWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amit Sahrawat <amit.sahrawat83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, NamJae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	ashishsangwan2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>,
	Unix Support <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADDb1s2OcfjwAJoTTbR6547hDL68PJFg_jD_vAs-nGmgiO6YWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wednesday 23 November 2011 19:00:16 Amit Sahrawat wrote:
> Hi Alan,
> Ok, translations cannot be added easily. But any idea why surrogate
> pairs are not handled? I think handling for surrogate pairs can be
> added by identifying proper points(there are not many I guess). Pleas=
e
> share your views.
>=20
> Regards,
> Amit Sahrawat
>=20
> On Wed, Nov 23, 2011 at 10:42 PM, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>=
 wrote:
> > On Wed, 23 Nov 2011 11:31:47 -0500 (EST)
> >=20
> > Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> >> On Wed, 23 Nov 2011, NamJae Jeon wrote:
> >> > Hi. Alan.
> >> > Would you know why there is no upper/lower case table in nls utf=
8 ?
> >> > And Currently Surrogate pair is not supported also in nls utf8. =
Is
> >> > there the reason ?
> >>=20
> >> I don't know.
> >=20
> > For one case translations are locale specific and very very complic=
ated.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ker=
nel"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

"Surrogate pairs" had to been implemented to extend the former
16 bit limit of UCS-2/UTF-16.

Unicode has been limited to max 0x0010FFFF glyphs - which
would not fit in UCS-2/UTF-16.

To extend UTF-16, the "surrogate range" between D800 and DFFF was "stol=
en"=20
from the one of the previously named "Private Use Areas" of UCS-2.
-----

Have those "surrogate pairs" any impact on _todays_ linux file name con=
ventions?

I think the easy answer is NO !

AFAIK - _no_ current operating system is supporting this!

We are talking here about "allowed dir/file name characters"!

The main reason behind "Surrogate pairs" was to allow "userland" (!)
applications to use worldwide special character glyphs!
---------

Anyway - in nls_base.c
=2E....
static const struct utf8_table utf8_table[] =3D
{
    {0x80,  0x00,   0*6,    0x7F,           0,         /* 1 byte sequen=
ce */},
    {0xE0,  0xC0,   1*6,    0x7FF,          0x80,      /* 2 byte sequen=
ce */},
    {0xF0,  0xE0,   2*6,    0xFFFF,         0x800,     /* 3 byte sequen=
ce */},
    {0xF8,  0xF0,   3*6,    0x1FFFFF,       0x10000,   /* 4 byte sequen=
ce */},
    {0xFC,  0xF8,   4*6,    0x3FFFFFF,      0x200000,  /* 5 byte sequen=
ce */},
    {0xFE,  0xFC,   5*6,    0x7FFFFFFF,     0x4000000, /* 6 byte sequen=
ce */},
    {0,						       /* end of table    */}
};
=2E.......
that configured range exceeds the max. allowed unicode range 0x0010FFFF
and _must_ be changed to:

static const struct utf8_table utf8_table[] =3D
{
    {0x80,  0x00,   0*6,    0x7F,           0,         /* 1 byte sequen=
ce */},
    {0xE0,  0xC0,   1*6,    0x7FF,          0x80,      /* 2 byte sequen=
ce */},
    {0xF0,  0xE0,   2*6,    0xFFFF,         0x800,     /* 3 byte sequen=
ce */},
    {0xF8,  0xF0,   3*6,    0x1FFFFF,       0x10000,   /* 4 byte sequen=
ce */},
    {0,						       /* end of table    */}
};

Cheers, G=FCnter
