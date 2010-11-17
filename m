From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: add attribute cache timeout (actimeo) tunable
Date: Wed, 17 Nov 2010 13:40:02 -0600
Message-ID: <AANLkTikN44ayabuHkYWz1Cd6WYVdyO25Tv0E_fKv7=Fi@mail.gmail.com>
References: <1290018214-9415-1-git-send-email-sjayaraman@suse.de>
	<20101117133919.07f9f0db@tlielax.poochiereds.net>
	<4CE429F8.6070105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE429F8.6070105-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 17, 2010 at 1:16 PM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
> On 11/18/2010 12:09 AM, Jeff Layton wrote:
>> On Wed, 17 Nov 2010 23:53:34 +0530
>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>
>>> Currently, the attribute cache timeout for CIFS is hardcoded to 1 s=
econd. This
>>> means that the client might have to issue a QPATHINFO/QFILEINFO cal=
l every 1
>>> second to verify if something has changes, which seems too expensiv=
e. On the
>>> other hand, if the timeout is hardcoded to a higher value, workload=
s that
>>> expect strict cache coherency might see unexpected results.
>>>
>>> Making attribute cache timeout as a tunable will allow us to make a=
 tradeoff
>>> between performance and cache metadata correctness depending on the
>>> application/workload needs.
>>>
>>> Add 'actimeo' tunable that can be used to tune the attribute cache =
timeout.
>>> The default timeout is set to 1 second.
>>>
>>> Also, display actimeo option value in /proc/mounts.
>>>
>>> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>> ---
>>> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
>>> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 =A01 +
>>> =A0fs/cifs/cifsglob.h =A0 | =A0 =A05 +++++
>>> =A0fs/cifs/connect.c =A0 =A0| =A0 10 ++++++++++
>>> =A0fs/cifs/inode.c =A0 =A0 =A0| =A0 =A06 +++---
>>> =A05 files changed, 20 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>>> index ff7d299..f30700d 100644
>>> --- a/fs/cifs/inode.c
>>> +++ b/fs/cifs/inode.c
>>> @@ -1648,6 +1648,7 @@ static bool
>>> =A0cifs_inode_needs_reval(struct inode *inode)
>>> =A0{
>>> =A0 =A0 =A0struct cifsInodeInfo *cifs_i =3D CIFS_I(inode);
>>> + =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>>>
>>> =A0 =A0 =A0if (cifs_i->clientCanCacheRead)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0return false;
>>> @@ -1658,12 +1659,11 @@ cifs_inode_needs_reval(struct inode *inode)
>>> =A0 =A0 =A0if (cifs_i->time =3D=3D 0)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0return true;
>>>
>>> - =A0 =A0/* FIXME: the actimeo should be tunable */
>>> - =A0 =A0if (time_after_eq(jiffies, cifs_i->time + HZ))
>>> + =A0 =A0if (time_after_eq(jiffies, cifs_i->time + (cifs_sb->actime=
o * HZ)))
>>
>> =A0 =A0 =A0 Problem:
>>
>> =A0 =A0 =A0 Suppose (cifs_i->time + (cifs_sb->actimeo * HZ)) carries=
 you
>> =A0 =A0 =A0 past two sign bit changes. At that point, it may look li=
ke
>> =A0 =A0 =A0 the resulting time is in the past, not the future.
>
> Good catch.
>
>> =A0 =A0 =A0 You actually do need to impose a limit here. I suggest l=
ooking
>> =A0 =A0 =A0 very closely at time_before/time_after macros. It'll als=
o be
>> =A0 =A0 =A0 easier to deal storing actimeo in terms of jiffies inste=
ad of
>> =A0 =A0 =A0 seconds.
>
>> =A0 =A0 =A0 Finally, this value needs to be displayed in /proc/mount=
s.
>>
>
> Did you mean displaying values in jiffies in /proc/mounts? Wouldn't i=
t
> be confusing for users to see such a higher numbers (usually) when th=
ey
> had used a simple 2 digit number for e.g. during mount?

That is a good question - seems like we ought to allow setting more gra=
nular
timeouts (ie jiffies) but nfs actimeo assumes the value is in seconds
by default.
I am fine with allowing actimeo to be specified more than one way (seco=
nds vs
milliseconds or seconds vs. jiffies) with suffix or prefix or keyword v=
ariant.

Probably should display it in seconds (or milliseconds) - jiffies
would be confusing
(I had trouble finding a way - short of looking at .config - what
jiffies equivalent
in seconds is)



--=20
Thanks,

Steve
