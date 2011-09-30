From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS kernel module bug
Date: Fri, 30 Sep 2011 13:30:10 -0500
Message-ID: <CAH2r5mvu=dYwai5yoCsy6SO5aLfD-eaYuMXuwZUN3rYqjHZY9Q@mail.gmail.com>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
	<20110930140409.51c1a94c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110930140409.51c1a94c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 30, 2011 at 1:04 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 30 Sep 2011 14:58:58 +0100
> Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> wrote:
>
>> Hi,
>>
>> Looking at the current kernel (in Linus' repository on github) there=
 is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_llse=
ek() there is this bit of code:
>>
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D=
> we must revalidate
>> =A0 =A0 =A0 =A0* the cached file length
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
>>
>> The logical or should be a logical and, i.e. this should be:
>>
>> =A0 =A0 =A0 if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR) {
>>
>> As the code is at present that line is ALWAYS true because origin is=
 ALWAYS either !=3D SEEK_SET or !=3D SEEK_CUR as if it equals one it ca=
nnot equal the other and vice versa=85
>>
>> So at the moment it always does the revalidation instead of only for=
 SEEK_END, SEEK_DATA, and SEEK_HOLE.
>>
>> Best regards,
>>
>> =A0 =A0 =A0 Anton
>
>
> Haha, good catch. Care to roll up a patch to fix that?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>


Yes - obviously that code was wrong, fortunately not a disaster.
Thanks for pointing this out.  If you don't want to write up
the patch let us know and we will make the trivial fix.



--=20
Thanks,

Steve
