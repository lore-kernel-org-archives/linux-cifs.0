From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 01/45] CIFS: Make CAP_* checks protocol independent
Date: Tue, 24 Jul 2012 10:37:30 +0400
Message-ID: <CAKywueQ8r4i6P3S6Po+DSb0rKafQW9n_-HOF49xuWFEOaGYUzg@mail.gmail.com>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-2-git-send-email-pshilovsky@samba.org>
	<20120723095536.46fbda6c@tlielax.poochiereds.net>
	<CAKywueTxSBkBfp4wZW8Hy71F3dZ1gsthuHcLVO28--a4oEAMjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTxSBkBfp4wZW8Hy71F3dZ1gsthuHcLVO28--a4oEAMjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/23 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Smb2 will use posix extensions further - we can easily modify the cod=
e to
> support it and avoid code dublication. So, I created the patches this=
 way -
> it let us abstract open code logic from protocol. I don't think that =
having
> several open routines with almost the same code help us to keep the c=
ode
> clean and easy to maintain.
> 23.07.2012 17:55 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8 "Jeff Layton" <=
jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
>
>
>>
>> On Wed, 18 Jul 2012 19:48:17 +0400
>> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>
>> > --- a/fs/cifs/file.c
>> > +++ b/fs/cifs/file.c
>> > @@ -385,9 +385,8 @@ int cifs_open(struct inode *inode, struct file
>> > *file)
>> >               oplock =3D 0;
>> >
>> >       if (!tcon->broken_posix_open && tcon->unix_ext &&
>> > -         (tcon->ses->capabilities & CAP_UNIX) &&
>> > -         (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>> > -                     le64_to_cpu(tcon->fsUnixInfo.Capability))) {
>> > +         cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>> > +                             le64_to_cpu(tcon->fsUnixInfo.Capabil=
ity)))
>> > {
>> >               /* can not refresh inode info since size could be st=
ale */
>> >               rc =3D cifs_posix_open(full_path, &inode, inode->i_s=
b,
>> >                               cifs_sb->mnt_file_mode /* ignored */=
,
>>
>> While I'm in general OK with abstracting out things like this with a
>> set of operations, I'm not sure it makes much sense to make things s=
o
>> granular in the name of code-sharing
>>
>> Would it be better for instance, to simply have a different f_ops->o=
pen
>> routine for SMB2, and simply check the right bit for CAP_UNIX in eac=
h
>> one?
>>
>> --
>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Best regards,
Pavel Shilovsky.
