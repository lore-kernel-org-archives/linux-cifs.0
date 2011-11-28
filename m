From: Ashish Sangwan <ashishsangwan2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Mon, 28 Nov 2011 13:26:31 +0530
Message-ID: <CAOiN93nCXB_fi7Oh4X_GGysizRRqT=yMwEYXcAe5chymztXcxQ@mail.gmail.com>
References: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com>
	<20111123171245.3e3f18a7@lxorguk.ukuu.org.uk>
	<CADDb1s2OcfjwAJoTTbR6547hDL68PJFg_jD_vAs-nGmgiO6YWQ@mail.gmail.com>
	<201111240608.31146.linux@kukkukk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Amit Sahrawat <amit.sahrawat83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, NamJae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>,
	Unix Support <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: =?ISO-8859-1?Q?G=FCnter_Kukkukk?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201111240608.31146.linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/11/24 G=FCnter Kukkukk <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>:
> On Wednesday 23 November 2011 19:00:16 Amit Sahrawat wrote:
>> Hi Alan,
>> Ok, translations cannot be added easily. But any idea why surrogate
>> pairs are not handled? I think handling for surrogate pairs can be
>> added by identifying proper points(there are not many I guess). Plea=
se
>> share your views.
>>
>> Regards,
>> Amit Sahrawat
>>
>> On Wed, Nov 23, 2011 at 10:42 PM, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org=
> wrote:
>> > On Wed, 23 Nov 2011 11:31:47 -0500 (EST)
>> >
>> > Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
>> >> On Wed, 23 Nov 2011, NamJae Jeon wrote:
>> >> > Hi. Alan.
>> >> > Would you know why there is no upper/lower case table in nls ut=
f8 ?
>> >> > And Currently Surrogate pair is not supported also in nls utf8.=
 Is
>> >> > there the reason ?
>> >>
>> >> I don't know.
>> >
>> > For one case translations are locale specific and very very compli=
cated.
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ke=
rnel"
>> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> > Please read the FAQ at =A0http://www.tux.org/lkml/
>
> "Surrogate pairs" had to been implemented to extend the former
> 16 bit limit of UCS-2/UTF-16.
>
> Unicode has been limited to max 0x0010FFFF glyphs - which
> would not fit in UCS-2/UTF-16.
>
> To extend UTF-16, the "surrogate range" between D800 and DFFF was "st=
olen"
> from the one of the previously named "Private Use Areas" of UCS-2.
> -----
>
> Have those "surrogate pairs" any impact on _todays_ linux file name c=
onventions?
>
> I think the easy answer is NO !
>
> AFAIK - _no_ current operating system is supporting this!
>
> We are talking here about "allowed dir/file name characters"!

How about Chinese/Japanese/Korean characters?
User won't be able to create new file with CJK/HAN chars if there is
no surrogate pair support.
>
> The main reason behind "Surrogate pairs" was to allow "userland" (!)
> applications to use worldwide special character glyphs!
> ---------
>
> Anyway - in nls_base.c
> .....
> static const struct utf8_table utf8_table[] =3D
> {
> =A0 =A0{0x80, =A00x00, =A0 0*6, =A0 =A00x7F, =A0 =A0 =A0 =A0 =A0 0, =A0=
 =A0 =A0 =A0 /* 1 byte sequence */},
> =A0 =A0{0xE0, =A00xC0, =A0 1*6, =A0 =A00x7FF, =A0 =A0 =A0 =A0 =A00x80=
, =A0 =A0 =A0/* 2 byte sequence */},
> =A0 =A0{0xF0, =A00xE0, =A0 2*6, =A0 =A00xFFFF, =A0 =A0 =A0 =A0 0x800,=
 =A0 =A0 /* 3 byte sequence */},
> =A0 =A0{0xF8, =A00xF0, =A0 3*6, =A0 =A00x1FFFFF, =A0 =A0 =A0 0x10000,=
 =A0 /* 4 byte sequence */},
> =A0 =A0{0xFC, =A00xF8, =A0 4*6, =A0 =A00x3FFFFFF, =A0 =A0 =A00x200000=
, =A0/* 5 byte sequence */},
> =A0 =A0{0xFE, =A00xFC, =A0 5*6, =A0 =A00x7FFFFFFF, =A0 =A0 0x4000000,=
 /* 6 byte sequence */},
> =A0 =A0{0, =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* end of table =A0 =A0*/}
> };
> ........
> that configured range exceeds the max. allowed unicode range 0x0010FF=
=46F
> and _must_ be changed to:
>
> static const struct utf8_table utf8_table[] =3D
> {
> =A0 =A0{0x80, =A00x00, =A0 0*6, =A0 =A00x7F, =A0 =A0 =A0 =A0 =A0 0, =A0=
 =A0 =A0 =A0 /* 1 byte sequence */},
> =A0 =A0{0xE0, =A00xC0, =A0 1*6, =A0 =A00x7FF, =A0 =A0 =A0 =A0 =A00x80=
, =A0 =A0 =A0/* 2 byte sequence */},
> =A0 =A0{0xF0, =A00xE0, =A0 2*6, =A0 =A00xFFFF, =A0 =A0 =A0 =A0 0x800,=
 =A0 =A0 /* 3 byte sequence */},
> =A0 =A0{0xF8, =A00xF0, =A0 3*6, =A0 =A00x1FFFFF, =A0 =A0 =A0 0x10000,=
 =A0 /* 4 byte sequence */},
> =A0 =A0{0, =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* end of table =A0 =A0*/}
> };
>
> Cheers, G=FCnter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
