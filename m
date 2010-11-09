From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix a memleak in cifs_setattr_nounix()
Date: Tue, 9 Nov 2010 09:19:13 -0600
Message-ID: <AANLkTi=Atr6NsExXim2+UhGwYPQ3GtGnFubDJ7K3-Cxh@mail.gmail.com>
References: <1289285861-12033-1-git-send-email-sjayaraman@suse.de>
	<20101109062024.010ab599@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101109062024.010ab599-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 9, 2010 at 5:20 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, =A09 Nov 2010 12:27:41 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>
>> Andrew Hendry reported a kmemleak warning in 2.6.37-rc1 while editin=
g a
>> text file with gedit over cifs.
>>
>> unreferenced object 0xffff88022ee08b40 (size 32):
>> =A0 comm "gedit", pid 2524, jiffies 4300160388 (age 2633.655s)
>> =A0 hex dump (first 32 bytes):
>> =A0 =A0 5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d =A0\.goutput=
stream-
>> =A0 =A0 35 42 41 53 4c 56 00 de 09 00 00 00 2c 26 78 ee =A05BASLV...=
=2E..,&x.
>> =A0 backtrace:
>> =A0 =A0 [<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
>> =A0 =A0 [<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
>> =A0 =A0 [<ffffffffa0313db0>] build_path_from_dentry+0xf0/0x230 [cifs=
]
>> =A0 =A0 [<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [cifs]
>> =A0 =A0 [<ffffffff8115fe90>] notify_change+0x170/0x2e0
>> =A0 =A0 [<ffffffff81145ceb>] sys_fchmod+0x10b/0x140
>> =A0 =A0 [<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
>> =A0 =A0 [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> The commit 1025774c that removed inode_setattr() seems to have intro=
duced this
>> memleak by returning early without freeing 'full_path'.
>>
>> Reported-by: Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>> =A0fs/cifs/inode.c | =A0 =A01 -
>> =A01 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 39869c3..ef3a55b 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -2177,7 +2177,6 @@ cifs_setattr_nounix(struct dentry *direntry, s=
truct iattr *attrs)
>>
>> =A0 =A0 =A0 setattr_copy(inode, attrs);
>> =A0 =A0 =A0 mark_inode_dirty(inode);
>> - =A0 =A0 return 0;
>>
>> =A0cifs_setattr_exit:
>> =A0 =A0 =A0 kfree(full_path);
>
> That's almost certainly the bug.

Yes.  Agreed.

Merged.


--=20
Thanks,

Steve
