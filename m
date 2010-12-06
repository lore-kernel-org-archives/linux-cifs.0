From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove bogus remapping of error in cifs_filldir()
Date: Mon, 6 Dec 2010 11:54:01 -0600
Message-ID: <AANLkTin5DhDxxKq8RC2zc7pFTDjFdSzEyE4K=T1NPvQM@mail.gmail.com>
References: <1291623350-11347-1-git-send-email-sjayaraman@suse.de>
	<AANLkTimT4HbYuaFUTtQup9PNka6XQzBoXmZytYjSk2Hj@mail.gmail.com>
	<20101206124823.33522ed9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206124823.33522ed9-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Dec 6, 2010 at 11:48 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 6 Dec 2010 10:26:08 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Dec 6, 2010 at 2:15 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org=
> wrote:
>> >
>> > As the FIXME points out correctly, now filldir() itself returns -E=
OVERFLOW if
>> > it not possible to represent the inode number supplied by the file=
system in
>> > the field provided by userspace.
>> >
>> > Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> > ---
>> > =A0fs/cifs/readdir.c | =A0 12 ------------
>> > =A01 files changed, 0 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
>> > index 32d300e..a73eb9f 100644
>> > --- a/fs/cifs/readdir.c
>> > +++ b/fs/cifs/readdir.c
>> > @@ -759,18 +759,6 @@ static int cifs_filldir(char *pfindEntry, str=
uct file *file, filldir_t filldir,
>> > =A0 =A0 =A0 =A0rc =3D filldir(direntry, qstring.name, qstring.len,=
 file->f_pos,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ino, fattr.cf_dtype);
>> >
>> > - =A0 =A0 =A0 /*
>> > - =A0 =A0 =A0 =A0* we can not return filldir errors to the caller =
since they are
>> > - =A0 =A0 =A0 =A0* "normal" when the stat blocksize is too small -=
 we return remapped
>> > - =A0 =A0 =A0 =A0* error instead
>> > - =A0 =A0 =A0 =A0*
>> > - =A0 =A0 =A0 =A0* FIXME: This looks bogus. filldir returns -EOVER=
=46LOW in the above
>> > - =A0 =A0 =A0 =A0* case already. Why should we be clobbering other=
 errors from it?
>> > - =A0 =A0 =A0 =A0*/
>> > - =A0 =A0 =A0 if (rc) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "filldir rc =3D %d", rc);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOVERFLOW;
>> > - =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0dput(tmp_dentry);
>> > =A0 =A0 =A0 =A0return rc;
>> > =A0}
>>
>> Makes sense - Any objections to pushing this upstream now.
>>
>
> No objection, but if you're going to take this, then please also take
> the three patches I sent on 11/22.

(and perhaps the fourth one, the RFC1001 name clean-up patch also?)

>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
