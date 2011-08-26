From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Fri, 26 Aug 2011 16:36:38 +0400
Message-ID: <CAKywueTZndUW9YGVGHzvDy4YUMkM5EJP_i9kjz_-jRdt1nUqOQ@mail.gmail.com>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<20110826073437.743c06a3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110826073437.743c06a3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
=2E..
>> +static struct dentry *
>> +cifs_alloc_root(struct super_block *sb)
>> +{
>> + =A0 =A0 struct qstr q;
>> +
>> + =A0 =A0 q.name =3D "/";
>
> =A0 =A0 =A0 =A0I don't think you want a separator in the name. That s=
eems
> =A0 =A0 =A0 =A0like it should be "".

Ok, I will try.

>
>> + =A0 =A0 q.len =3D 1;
>> + =A0 =A0 q.hash =3D full_name_hash(q.name, q.len);
>> + =A0 =A0 return d_alloc_pseudo(sb, &q);
>> +}
>> +
=2E..
>> -             if (filldir(direntry, "..", 2, file->f_pos,
>> -                  parent_ino(file->f_path.dentry), DT_DIR) < 0) {
>> +             if (!file->f_path.dentry->d_parent->d_inode) {
>> +                     cFYI(1, "parent dir is negative, filling as cu=
rrent");
>> +                     ino =3D file->f_path.dentry->d_inode->i_ino;
>> +             } else
>> +                     ino =3D parent_ino(file->f_path.dentry);
>> +             if (filldir(direntry, "..", 2, file->f_pos, ino, DT_DI=
R) < 0) {
>>                       cERROR(1, "Filldir for parent dir failed");
>>                       rc =3D -ENOMEM;
>>                       break;
>>
> (cc'ing David Howells since he did the sb sharing code for NFS)
>
> This doesn't seem quite right to me...
>
> This implies that the parent in this situation would be the parent
> dentry on the server, but that shouldn't be the case right? Shouldn't
> this be the mountpoint's parent?
>
> For instance, suppose you have //server/share/d1/d2/d3 mounted
> on /mnt/cifs. During the mount, d1 and d2 are instantiated as negativ=
e
> dentries. Here, you try to fill in the i_ino for d2 as the inode numb=
er
> for "..", but that doesn't seem correct -- shouldn't it be the inode
> number for /mnt?

I think that doesn't seem correct too, but I looked through another
file systems code and found the same things.

>
> I don't have a great feel for this sort of dcache trickery, but I ten=
d
> to think we probably ought to follow NFS' example here. It has sort o=
f
> an "opportunistic" mechanism for filling in the dcache for a particul=
ar
> superblock. This is detailed in the comments on commit 54ceac45.

As I understand, NFS does the following:
1) requests fattr from the server
error =3D server->nfs_client->rpc_ops->getroot(server, mntfh, &fsinfo);

2) lookup an inode with ino got from the server
inode =3D nfs_fhget(sb, mntfh, fsinfo.fattr);

3) set dummy root
error =3D nfs_superblock_set_dummy_root(sb, inode);

4) get dentry for the inode
ret =3D d_obtain_alias(inode);

So, it lookup an existing dentry according to the ino got from the
server. As for CIFS, we can't do it because we may end up using a
different inode numbers for the same path (noserverino cases).

Thoughts?

--=20
Best regards,
Pavel Shilovsky.
