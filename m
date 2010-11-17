From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: add attribute cache timeout (actimeo) tunable
Date: Wed, 17 Nov 2010 23:36:01 +0530
Message-ID: <4CE41989.3080106@suse.de>
References: <1289902177-12963-1-git-send-email-sjayaraman@suse.de>	<20101116140302.6efd2e3d@corrin.poochiereds.net>	<AANLkTinJhXfjca1ck9Q4xPCcoWyzLv3zNdw=GXXXaAoh@mail.gmail.com>	<20101116144245.10c63c3c@corrin.poochiereds.net>	<AANLkTi=ikz9k6jbnOOfQy91omK477xB2eZ3PfNX73eOc@mail.gmail.com> <20101116152234.71f06a6f@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101116152234.71f06a6f-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/17/2010 01:52 AM, Jeff Layton wrote:
>>>> On Tue, Nov 16, 2010 at 1:03 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>>>>> On Tue, 16 Nov 2010 15:39:37 +0530
>>>>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>>>>
>>>>>> Currently, the attribute cache timeout for CIFS is 1 sec. This m=
eans that the
>>>>>> client might have to issue a QPATHINFO/QFILEINFO call every 1 se=
c to verify if
>>>>>> something has changed, which seems too expensive. On the otherha=
nd, increasing
>>>>>> this value further may not work well for all the users.
>>>>>>
>>>>>> This patch introduces a tunable mount option 'actimeo' that can =
be used to tune
>>>>>> the attribute cache timeout. This patch takes a conservative app=
roach and sets
>>>>>> the default timeout is set to 3 seconds while limiting maximum t=
imeout to 60
>>>>>> seconds. Ideally, it is preferred to set attribute cache timeout=
s separately
>>>>>> for files and directories like how NFS does. However, I think it=
 is better to
>>>>>> keep it simple without too many options, introduce the option to=
 users, get
>>>>>> feedback from them and then decide what is working better for CI=
=46S.
>>>>>>
>>>>>> This patch has been tested lightly and no adverse effects were s=
een.
>>>>>>
>>>>>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>>>>> ---
>>>>>> =EF=BF=BDfs/cifs/cifs_fs_sb.h | =EF=BF=BD =EF=BF=BD1 +
>>>>>> =EF=BF=BDfs/cifs/cifsglob.h =EF=BF=BD | =EF=BF=BD =EF=BF=BD3 +++
>>>>>> =EF=BF=BDfs/cifs/connect.c =EF=BF=BD =EF=BF=BD| =EF=BF=BD 16 +++=
+++++++++++++
>>>>>> =EF=BF=BDfs/cifs/inode.c =EF=BF=BD =EF=BF=BD =EF=BF=BD| =EF=BF=BD=
 =EF=BF=BD6 +++---
>>>>>> =EF=BF=BD4 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
>>>>>> index e9a393c..efd2d73 100644
>>>>>> --- a/fs/cifs/cifs_fs_sb.h
>>>>>> +++ b/fs/cifs/cifs_fs_sb.h
>>>>>> @@ -48,6 +48,7 @@ struct cifs_sb_info {
>>>>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD struct nls_table *local_nls;
>>>>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD unsigned int rsize;
>>>>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD unsigned int wsize;
>>>>>> + =EF=BF=BD =EF=BF=BD unsigned int actimeo;
>>>>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD atomic_t active;
>>>>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD uid_t =EF=BF=BD mnt_uid;
>>>>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD gid_t =EF=BF=BD mnt_gid;
>>>>>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>>>>> index b577bf0..eb22130 100644
>>>>>> --- a/fs/cifs/cifsglob.h
>>>>>> +++ b/fs/cifs/cifsglob.h
>>>>>> @@ -44,6 +44,9 @@
>>>>>>
>>>>>> =EF=BF=BD#define CIFS_MIN_RCV_POOL 4
>>>>>>
>>>>>> +#define CIFS_DEF_ACTIMEO (3) /* default attribute cache timeout=
 (seconds) */
>>>>>> +#define CIFS_MAX_ACTIMEO (60) =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD/* max allowed attribute cache timeout */
>>>>>> +
>>>>>
>>>>> I too think that the 1s actimeo is too aggressive in general, but=
 I'm a
>>>>> little leery that changing the default here might mean subtle
>>>>> regressions. Cache consistency is really hard to get right, so we=
 need
>>>>> to take great care when we change its behavior.
>>>>>
>>>>> What do you think about respinning this patch and leaving the def=
ault
>>>>> at 1s? We could consider increasing it later if we can prove to
>>>>> ourselves that it won't cause problems.
>>>>

I thought 3 sec was on the conservative side, but you're right - it
might cause regressions with applications which expect strict cache
coherency.

>>>>
>>>> Also probably should allow maximum that is longer than 60 seconds
>>>> timeout (perhaps an hour? a day?).
>>>>
>>>> IIRC there is no maximum specified for DirectoryCacheTimeout in
>>>> Windows - and there are cases where I can imagine longer than 60
>>>> seconds being useful.

>>>
>>> Agreed. I don't see any reason not to allow someone to shoot themse=
lves
>>> in the foot. I see no need for an arbitrary limit. If you do that
>>> though, you probably do want to limit it to 2^31 jiffies or so to a=
void
>>> wraparound issues on 32 bit arches.

I thought about this a bit and I'm leaning towards not setting any
arbitrary maximum limit primarily because different HZ values would lea=
d
to different cache timeout values and it could be problematic in a setu=
p
with multiple clients with different HZ values.

I'll respin the patch with 1 sec default.


--=20
Suresh Jayaraman
