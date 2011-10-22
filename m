From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix DFS handling in cifs_get_file_info
Date: Sat, 22 Oct 2011 14:38:36 +0400
Message-ID: <CAKywueQ2RHEmoLsmoryZiOYuA6rpGZPFL2GkOCKhTb3dQa9USg@mail.gmail.com>
References: <1319278757-17008-1-git-send-email-piastry@etersoft.ru>
	<20111022062419.6fa1a239@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111022062419.6fa1a239-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/22 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sat, 22 Oct 2011 14:19:17 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> We should call cifs_all_info_to_fattr in rc =3D=3D 0 case only.
>>
>> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/inode.c | =A0 11 ++++++-----
>> =A01 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 663c4e3..b84c346 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -562,7 +562,12 @@ int cifs_get_file_info(struct file *filp)
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>> =A0 =A0 =A0 rc =3D CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_=
data);
>> - =A0 =A0 if (rc =3D=3D -EOPNOTSUPP || rc =3D=3D -EINVAL) {
>> + =A0 =A0 if (!rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_all_info_to_fattr(&fattr, &find_data,=
 cifs_sb, false);
>> + =A0 =A0 else if (rc =3D=3D -EREMOTE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_create_dfs_fattr(&fattr, inode->i_sb)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> + =A0 =A0 } else if (rc =3D=3D -EOPNOTSUPP || rc =3D=3D -EINVAL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* FIXME: legacy server -- fall back t=
o path-based call?
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* for now, just skip revalidating and=
 mark inode for
>> @@ -571,9 +576,6 @@ int cifs_get_file_info(struct file *filp)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->time =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cgfi_exit;
>> - =A0 =A0 } else if (rc =3D=3D -EREMOTE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_create_dfs_fattr(&fattr, inode->i_sb)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> =A0 =A0 =A0 } else if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cgfi_exit;
>>
>> @@ -581,7 +583,6 @@ int cifs_get_file_info(struct file *filp)
>> =A0 =A0 =A0 =A0* don't bother with SFU junk here -- just mark inode =
as needing
>> =A0 =A0 =A0 =A0* revalidation.
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false)=
;
>> =A0 =A0 =A0 fattr.cf_uniqueid =3D CIFS_I(inode)->uniqueid;
>> =A0 =A0 =A0 fattr.cf_flags |=3D CIFS_FATTR_NEED_REVAL;
>> =A0 =A0 =A0 cifs_fattr_to_inode(inode, &fattr);
>
> This looks correct to me. Nice catch.
>
> Since you're in here though...maybe this would be better expressed wi=
th
> a switch statement?
>

Good idea - resent it.

--=20
Best regards,
Pavel Shilovsky.
