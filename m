From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate error up to the caller during get/set
 acls [try #2]
Date: Tue, 9 Nov 2010 14:13:02 -0600
Message-ID: <AANLkTin6YTaxaXP=8H19qYi6gg9sRj9Vf2CUEpqM3taW@mail.gmail.com>
References: <1289330107-2273-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101109143542.72fa1f63@corrin.poochiereds.net>
	<AANLkTi=9N7H7MkBbx83TzG4s=X_oP=Pu_VknEgP=UPir@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=9N7H7MkBbx83TzG4s=X_oP=Pu_VknEgP=UPir-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 9, 2010 at 1:38 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Nov 9, 2010 at 1:35 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> On Tue, =A09 Nov 2010 13:15:07 -0600
>> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>
>>> --- a/fs/cifs/inode.c
>>> +++ b/fs/cifs/inode.c
>>> @@ -688,10 +688,9 @@ int cifs_get_inode_info(struct inode **pinode,
>>>
>>> =A0#ifdef CONFIG_CIFS_EXPERIMENTAL
>>> =A0 =A0 =A0 /* fill in 0777 bits from ACL */
>>> - =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Getting mode bits from ACL");
>>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_acl_to_fattr(cifs_sb, &fattr, *pinod=
e, full_path, pfid);
>>> - =A0 =A0 }
>>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_acl_to_fattr(cifs_sb, &fattr,=
 *pinode, full_path,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 pfid);
>>
>> Do you want to return an error from cifs_get_inode_info when fetchin=
g
>> the ACL fails? I think you either need to goto cgii_exit if rc !=3D =
0, or
>> keep ignoring the error code like you do today. If the function is
>> going to return an error, then there's no real point in doing the la=
ter
>> stuff (the iget, etc).
>>
>>
>> --
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>
> Jeff, I thought about that. I think we should handle the error in bot=
h
> cifs_get_inode_info and mode_to_acl. =A0Both the functions are in exp=
erimental
> mode. And mode_to_acl does not log any error on rc, so I removed from
> cifs_get_inode_info also although cifs_acl_to_fattr does.
>

I do not think this patch has caused this condition but investigating.


cifstest6:/usr/src/cthon04 # mount
/dev/sda2 on / type ext3 (rw,acl,user_xattr)
/proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
udev on /dev type tmpfs (rw)
devpts on /dev/pts type devpts (rw,mode=3D0620,gid=3D5)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
securityfs on /sys/kernel/security type securityfs (rw)

cifstest6:/usr/src/cthon04 # rmmod cifs
ERROR: Module cifs is in use

cifstest6:/usr/src/cthon04 # dmesg
CIFS VFS: Unexpected SMB signature
CIFS VFS: Unexpected SMB signature
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc
CIFS VFS: cifs_acl_to_fattr: error -26 getting sec desc


#define ETXTBSY         26      /* Text file busy */
