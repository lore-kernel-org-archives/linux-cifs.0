From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: 2.6.37-rc1 kmemleak warnings when saving a file over cifs.
Date: Tue, 09 Nov 2010 12:35:13 +0530
Message-ID: <4CD8F2A9.6080907@suse.de>
References: <AANLkTikCnK7YN9F3JOv0rVZt65iQ=v=YJ_ONOuwj_=9D@mail.gmail.com>	<AANLkTindSKRu2SJoCwqwhdRmBaV-+oRDQ9fp9Cikh2_G@mail.gmail.com> <AANLkTi=nDY25GNpV=XVum0Cbg1tjX14v-fcA2K6NrhgW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=nDY25GNpV=XVum0Cbg1tjX14v-fcA2K6NrhgW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/09/2010 11:31 AM, Andrew Hendry wrote:
> The server is a qnap NAS, running linux 2.6.24

> On Tue, Nov 9, 2010 at 3:12 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> On Mon, Nov 8, 2010 at 6:13 PM, Andrew Hendry <andrew.hendry@gmail.c=
om> wrote:
>>> Have just noticed these in the past few days, now running 2.6.37-rc=
1+
>>> Seems to be 1 logged per file save when using a text file with gedi=
t over cifs.
>>
>> Can you tell the called function in cifs_setattr_unix vs. cifs_setat=
tr_nounix
>> (the former will usually be called when the server is Samba, the lat=
ter
>> when the server is Windows or NetApp). =EF=BF=BDWhat is the server t=
ype?
>>
>>> unreferenced object 0xffff88022ee08b40 (size 32):
>>> =EF=BF=BDcomm "gedit", pid 2524, jiffies 4300160388 (age 2633.655s)
>>> =EF=BF=BDhex dump (first 32 bytes):
>>> =EF=BF=BD =EF=BF=BD5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d =
=EF=BF=BD\.goutputstream-
>>> =EF=BF=BD =EF=BF=BD35 42 41 53 4c 56 00 de 09 00 00 00 2c 26 78 ee =
=EF=BF=BD5BASLV......,&x.
>>> =EF=BF=BDbacktrace:
>>> =EF=BF=BD =EF=BF=BD[<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
>>> =EF=BF=BD =EF=BF=BD[<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
>>> =EF=BF=BD =EF=BF=BD[<ffffffffa0313db0>] build_path_from_dentry+0xf0=
/0x230 [cifs]
>>> =EF=BF=BD =EF=BF=BD[<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [ci=
fs]
>>> =EF=BF=BD =EF=BF=BD[<ffffffff8115fe90>] notify_change+0x170/0x2e0
>>> =EF=BF=BD =EF=BF=BD[<ffffffff81145ceb>] sys_fchmod+0x10b/0x140
>>> =EF=BF=BD =EF=BF=BD[<ffffffff8100c172>] system_call_fastpath+0x16/0=
x1b
>>> =EF=BF=BD =EF=BF=BD[<ffffffffffffffff>] 0xffffffffffffffff
>>

Are you using the mount option 'nounix'? I spotted a memleak in the
nounix code path introduced by a recent patch and proposed a fix here:

	http://thread.gmane.org/gmane.linux.kernel.cifs/1549

Does this fix the leak for you?



--=20
Suresh Jayaraman
