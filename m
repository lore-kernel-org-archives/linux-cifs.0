From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use type __u32 instead of int for the oplock parameter
Date: Fri, 17 Sep 2010 16:42:44 -0500
Message-ID: <AANLkTimB+cx5bTnj1Y22+wjhCd_ZFkLgT7ypJOwN7pes@mail.gmail.com>
References: <4C937776.909@suse.de>
	<20100917103957.5cbde780@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100917103957.5cbde780-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Obviously correct (and merged this along with the previous patch from y=
ou).

Wonder why sparse didn't spot this - we avoided the cast in the other
(posix) helper.

On Fri, Sep 17, 2010 at 9:39 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 17 Sep 2010 19:43:10 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>
>> ... and avoid implicit casting from a signed type. Also, pass oplock=
 by value
>> instead by reference as we don't intend to change the value in
>> cifs_open_inode_helper().
>>
>> Thanks to Jeff Layton for spotting this.
>>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>>
>> =A0fs/cifs/file.c | =A0 =A08 ++++----
>> =A01 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index de748c6..d33da45 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -165,7 +165,7 @@ psx_client_can_cache:
>>
>> =A0/* all arguments to this function must be checked for validity in=
 caller */
>> =A0static inline int cifs_open_inode_helper(struct inode *inode,
>> - =A0 =A0 struct cifsTconInfo *pTcon, int *oplock, FILE_ALL_INFO *bu=
f,
>> + =A0 =A0 struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_INFO *b=
uf,
>> =A0 =A0 =A0 char *full_path, int xid)
>> =A0{
>> =A0 =A0 =A0 struct cifsInodeInfo *pCifsInode =3D CIFS_I(inode);
>> @@ -207,11 +207,11 @@ client_can_cache:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, full_=
path, buf, inode->i_sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0xid, NULL);
>>
>> - =A0 =A0 if ((*oplock & 0xF) =3D=3D OPLOCK_EXCLUSIVE) {
>> + =A0 =A0 if ((oplock & 0xF) =3D=3D OPLOCK_EXCLUSIVE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on ino=
de %p", inode);
>> - =A0 =A0 } else if ((*oplock & 0xF) =3D=3D OPLOCK_READ)
>> + =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true;
>>
>> =A0 =A0 =A0 return rc;
>> @@ -365,7 +365,7 @@ int cifs_open(struct inode *inode, struct file *=
file)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D cifs_open_inode_helper(inode, tcon, &oplock, buf, f=
ull_path, xid);
>> + =A0 =A0 rc =3D cifs_open_inode_helper(inode, tcon, oplock, buf, fu=
ll_path, xid);
>> =A0 =A0 =A0 if (rc !=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>



--=20
Thanks,

Steve
