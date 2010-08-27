From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Cannot allocate memory error on mount
Date: Fri, 27 Aug 2010 11:54:03 +0530
Message-ID: <4C775A03.8010507@suse.de>
References: <514808.54527.qm@web56908.mail.re3.yahoo.com>	<4C7630D9.7060203@suse.de>	<20100826082305.1594ec4e@barsoom.rdu.redhat.com> <AANLkTi=qnTFUcnu-uS8NGTkjYUhO-hHstargorpJ8yZ9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=qnTFUcnu-uS8NGTkjYUhO-hHstargorpJ8yZ9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/26/2010 09:55 PM, Steve French wrote:
> This is a good one to go upstream soon - if others critical to go
> upstream soon let me know.

Do we need to Cc -stable as well? I don't feel strongly that we should
include this fix. However, unrelated memory allocation errors during
mount in supported kernels sounds more than annoying..

Thoughts?


> On Thu, Aug 26, 2010 at 7:23 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On Thu, 26 Aug 2010 14:46:09 +0530
>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>
>>> On 08/26/2010 01:56 AM, joe hefner wrote:
>>>> On a recent Fedora (13), I am seeing a mount failure message that =
I can not explain. I have a Windows Server 2003=EF=BF=BDa with a share =
set up for access only for a specific username (say userfoo). If I try =
to mount it from Linux,=EF=BF=BDusing userfoo and the correct password =
all is well. If I try with a bad password or with some other username (=
userbar), it fails with "Permission denied" as expected. If I try to mo=
unt as username =3D administrator, and give the correct administrator p=
assword, I would also expect "Permission denied", but I see "Cannot all=
ocate memory" instead.
>>>> =EF=BF=BD
>>>> dmesg and /var/log/messages show an odd=EF=BF=BDentry about failur=
e to get root inode. Setting cifsFYI shows that errno 13 is being seen =
on the client side, but then this=EF=BF=BDinode error occurs.
>>>> =EF=BF=BD
>>>> Has anyone seen this? Any ideas what is happening?
>>>> =EF=BF=BD
>>>> Thanks, Joe H.
>>>> =EF=BF=BD
>>>> =EF=BF=BDfs/cifs/netmisc.c: Mapping smb error code 5 to POSIX err =
-13
>>>> =EF=BF=BDfs/cifs/cifssmb.c: Send error in QPathInfo =3D -13
>>>> =EF=BF=BDCIFS VFS: cifs_read_super: get root inode failed
>>>> =EF=BF=BDfs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 443=
22319 with uid: 0
>>>> =EF=BF=BDfs/cifs/cifssmb.c: In tree disconnect
>>>> =EF=BF=BDfs/cifs/transport.c: For smb_command 113
>>>> =EF=BF=BDfs/cifs/transport.c: Sending smb:=EF=BF=BD total_len 39
>>>> =EF=BF=BDfs/cifs/connect.c: rfc1002 length 0x27
>>>> =EF=BF=BDfs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: =
44322320 with uid: 0
>>>> =EF=BF=BDfs/cifs/cifssmb.c: In SMBLogoff for session disconnect
>>>> =EF=BF=BDfs/cifs/transport.c: For smb_command 116
>>>> =EF=BF=BDfs/cifs/transport.c: Sending smb:=EF=BF=BD total_len 43
>>>> =EF=BF=BDfs/cifs/connect.c: rfc1002 length 0x2b
>>>>
>>>
>>> Looks like the commit 0b8f18e3 assumed that cifs_get_inode_info() a=
nd
>>> friends fail only due to memory allocation error when the inode is =
NULL
>>> which is not the case if CIFSSMBQPathInfo() fails and returns an er=
ror.
>>> Fix this by propagating the actual error code back.
>>>
>>> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>> ---
>>> =EF=BF=BDfs/cifs/inode.c | =EF=BF=BD =EF=BF=BD2 +-
>>> =EF=BF=BD1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>>> index 4bc47e5..86a164f 100644
>>> --- a/fs/cifs/inode.c
>>> +++ b/fs/cifs/inode.c
>>> @@ -834,7 +834,7 @@ struct inode *cifs_root_iget(struct super_block=
 *sb, unsigned long ino)
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD xid, NULL);
>>>
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD if (!inode)
>>> - =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD retur=
n ERR_PTR(-ENOMEM);
>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD retur=
n ERR_PTR(rc);
>>>
>>> =EF=BF=BD#ifdef CONFIG_CIFS_FSCACHE
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD /* populate tcon->resource_id */
>>
>> Good catch.
>>
>> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>=20
>=20
>=20


--=20
Suresh Jayaraman
