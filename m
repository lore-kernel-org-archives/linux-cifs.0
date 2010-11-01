From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New read logic
Date: Mon, 1 Nov 2010 12:41:31 -0500
Message-ID: <AANLkTinyh5zxKsyZetpN4WwiDMWQ-Y9E-1uu9_dzDQTY@mail.gmail.com>
References: <AANLkTimbGk9zKbVBU+Fd-d4XwQdFyEJFzcxi84dVEjQx@mail.gmail.com>
	<20101101131930.18d35c34@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101101131930.18d35c34-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

My reaction is that over modern networks 1 second attribute timeout is
probably ok and 60 seconds is too slow (certainly slowing it down
beyond 5 seconds could be noticeable to user, not just create a higher
data integrity risk) - but the obvious exception is over slow
networks.   Since we can get the SMB echo times - we could base the
value of actimeout 1 second vs 60 second based on what we estimate
round trip delay is.

On Mon, Nov 1, 2010 at 12:19 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sun, 31 Oct 2010 22:44:13 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Add cifs_file_aio_read to let the client works with strict cache mod=
e.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 34 ++++++++++++++++++++++++++++++++--
>> =A01 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index e8b9523..21e0f47 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -570,6 +570,36 @@ cifs_get_sb(struct file_system_type *fs_type,
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> +static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct =
iovec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uns=
igned long nr_segs, loff_t pos)
>> +{
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 ssize_t read;
>> +
>> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>> + =A0 =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
>> +
>> + =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) =3D=3D=
 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 int retval;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_revalidate_file(iocb->ki_f=
ilp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (retval < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (loff_t)retval;
>> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^
> I don't think we can reasonably do the above without some discussion =
of
> increasing the attribute cache timeout. It's currently hardcoded to 1=
s
> in cifs_inode_needs_reval.
>
> Doing a QFileInfo every second in order to see if the file has change=
d
> seems prohibitively expensive. OTOH, streaming reads without ever
> checking to see whether it has changed is dangerous. We'll have to tr=
y
> and strike a balance here.
>
> What may be best is to add a actimeo mount option that sets that valu=
e
> to something sane (60s?) and allows people to set to whatever they
> like. Even better might be a sliding scale like NFS uses -- set the
> value to something low (and user-settable) initially and every time w=
e
> check it and it hasn't changed, double the timeout up to a maximum
> (also settable by user).
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_read(iocb, iov, nr=
_segs, pos);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 read =3D cifs_user_read(iocb->ki_filp, iov=
->iov_base,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 iov->iov_len, &pos);
>> + =A0 =A0 =A0 =A0 =A0 =A0 iocb->ki_pos =3D pos;
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 read =3D generic_file_aio_read(iocb, iov, =
nr_segs, pos);
>> +
>> + =A0 =A0 return read;
>> +}
>> +
>> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u=
nsigned long nr_segs, loff_t pos)
>> =A0{
>> @@ -692,7 +722,7 @@ const struct inode_operations cifs_symlink_inode=
_ops =3D {
>> =A0const struct file_operations cifs_file_ops =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> - =A0 =A0 .aio_read =3D generic_file_aio_read,
>> + =A0 =A0 .aio_read =3D cifs_file_aio_read,
>> =A0 =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> @@ -729,7 +759,7 @@ const struct file_operations cifs_file_direct_op=
s =3D {
>> =A0const struct file_operations cifs_file_nobrl_ops =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> - =A0 =A0 .aio_read =3D generic_file_aio_read,
>> + =A0 =A0 .aio_read =3D cifs_file_aio_read,
>> =A0 =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
