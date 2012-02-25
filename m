From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Sat, 25 Feb 2012 13:11:26 +0400
Message-ID: <CAKywueS0XKjuX_sLfb=Lhp=hLgrYpq7ndAtNGDjq1pFg16A7dA@mail.gmail.com>
References: <1329484410-30540-1-git-send-email-piastry@etersoft.ru>
	<20120221100006.7e43e8b9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120221100006.7e43e8b9-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/21 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Fri, 17 Feb 2012 16:13:30 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Currently we do inc/drop_nlink for a parent directory for every
>> mkdir/rmdir calls. That's wrong when Unix extensions are disabled
>> because in this case a server doesn't follow the same semantic and
>> returns the old value on the next QueryInfo request. As the result,
>> we update our value with the server one and then decrement it on
>> every rmdir call - go to negative nlink values.
>>
>> Fix this by removing inc/drop_nlink for the parent directory from
>> mkdir/rmdir, setting it for a revalidation and ignoring NumberOfLink=
s
>> for directories when Unix extensions are disabled.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/inode.c | =A0 28 +++++++++++++++++++---------
>> =A01 files changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index a5f54b7..745da3d 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -534,6 +534,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr=
, FILE_ALL_INFO *info,
>> =A0 =A0 =A0 if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_mode =3D S_IFDIR | cifs_sb->mn=
t_dir_mode;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_dtype =3D DT_DIR;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Server can return wrong NumberOfLinks=
 value for directories
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* when Unix extensions are disabled - f=
ake it.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_nlink =3D 2;
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_mode =3D S_IFREG | cifs_sb->mn=
t_file_mode;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_dtype =3D DT_REG;
>> @@ -541,9 +546,9 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr,=
 FILE_ALL_INFO *info,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clear write bits if ATTR_READONLY is =
set */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fattr->cf_cifsattrs & ATTR_READONLY)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_mode &=3D ~(S_=
IWUGO);
>> - =A0 =A0 }
>>
>> - =A0 =A0 fattr->cf_nlink =3D le32_to_cpu(info->NumberOfLinks);
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_nlink =3D le32_to_cpu(info->Numb=
erOfLinks);
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 fattr->cf_uid =3D cifs_sb->mnt_uid;
>> =A0 =A0 =A0 fattr->cf_gid =3D cifs_sb->mnt_gid;
>> @@ -1322,7 +1327,6 @@ int cifs_mkdir(struct inode *inode, struct den=
try *direntry, umode_t mode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0/*BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see=
 if need
>> =A0 =A0 =A0 to set uid/gid */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_nlink(inode);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_unix_basic_to_fattr=
(&fattr, pInfo, cifs_sb);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_fill_uniqueid(inode=
->i_sb, &fattr);
>> @@ -1355,7 +1359,6 @@ mkdir_retry_old:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 d_drop(direntry);
>> =A0 =A0 =A0 } else {
>> =A0mkdir_get_info:
>> - =A0 =A0 =A0 =A0 =A0 =A0 inc_nlink(inode);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pTcon->unix_ext)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_in=
fo_unix(&newinode, full_path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_sb, xid);
>> @@ -1436,6 +1439,11 @@ mkdir_get_info:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> =A0mkdir_out:
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Force revalidate to get parent dir info when needed s=
ince cached
>> + =A0 =A0 =A0* attributes are invalid now.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 CIFS_I(inode)->time =3D 0;
>> =A0 =A0 =A0 kfree(full_path);
>> =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>> @@ -1475,7 +1483,6 @@ int cifs_rmdir(struct inode *inode, struct den=
try *direntry)
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>>
>> =A0 =A0 =A0 if (!rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 drop_nlink(inode);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&direntry->d_inode->i_lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(direntry->d_inode, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_nlink(direntry->d_inode);
>> @@ -1483,12 +1490,15 @@ int cifs_rmdir(struct inode *inode, struct d=
entry *direntry)
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 cifsInode =3D CIFS_I(direntry->d_inode);
>> - =A0 =A0 cifsInode->time =3D 0; =A0 =A0/* force revalidate to go ge=
t info when
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nee=
ded */
>> + =A0 =A0 /* force revalidate to go get info when needed */
>> + =A0 =A0 cifsInode->time =3D 0;
>>
>> =A0 =A0 =A0 cifsInode =3D CIFS_I(inode);
>> - =A0 =A0 cifsInode->time =3D 0; =A0 =A0/* force revalidate to get p=
arent dir info
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sin=
ce cached search results now invalid */
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Force revalidate to get parent dir info when needed s=
ince cached
>> + =A0 =A0 =A0* attributes are invalid now.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 cifsInode->time =3D 0;
>>
>> =A0 =A0 =A0 direntry->d_inode->i_ctime =3D inode->i_ctime =3D inode-=
>i_mtime =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 current_fs_time(inode->i_sb);
>
> Looks good.
>
> Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Steve, what's about this patch? I think it should go to stable as well.

--=20
Best regards,
Pavel Shilovsky.
