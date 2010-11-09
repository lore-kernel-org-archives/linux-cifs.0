From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate error up to the caller during get/set
 acls [try #2]
Date: Tue, 9 Nov 2010 13:38:32 -0600
Message-ID: <AANLkTi=9N7H7MkBbx83TzG4s=X_oP=Pu_VknEgP=UPir@mail.gmail.com>
References: <1289330107-2273-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101109143542.72fa1f63@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101109143542.72fa1f63-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 9, 2010 at 1:35 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, =A09 Nov 2010 13:15:07 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -688,10 +688,9 @@ int cifs_get_inode_info(struct inode **pinode,
>>
>> =A0#ifdef CONFIG_CIFS_EXPERIMENTAL
>> =A0 =A0 =A0 /* fill in 0777 bits from ACL */
>> - =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Getting mode bits from ACL");
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_acl_to_fattr(cifs_sb, &fattr, *pinode=
, full_path, pfid);
>> - =A0 =A0 }
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_acl_to_fattr(cifs_sb, &fattr, =
*pinode, full_path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 pfid);
>
> Do you want to return an error from cifs_get_inode_info when fetching
> the ACL fails? I think you either need to goto cgii_exit if rc !=3D 0=
, or
> keep ignoring the error code like you do today. If the function is
> going to return an error, then there's no real point in doing the lat=
er
> stuff (the iget, etc).
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Jeff, I thought about that. I think we should handle the error in both
cifs_get_inode_info and mode_to_acl.  Both the functions are in experim=
ental
mode. And mode_to_acl does not log any error on rc, so I removed from
cifs_get_inode_info also although cifs_acl_to_fattr does.
