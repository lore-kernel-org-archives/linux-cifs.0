From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: Add information about noserverino
Date: Fri, 10 Dec 2010 08:39:22 +0530
Message-ID: <4D0199E2.8030006@suse.de>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>	<20101206095725.78422138@tlielax.poochiereds.net>	<20101206101214.52a24415@tlielax.poochiereds.net>	<20101206163506.56232lqqhc5c3co4@webmail.df.eu>	<20101206103836.0714369a@tlielax.poochiereds.net>	<4D00C02C.4070006@suse.de>	<20101209070952.24793c23@barsoom.rdu.redhat.com>	<AANLkTimm=Ca51y-4kZwpBCiBoSUjxz=maYz6J=ys2z6C@mail.gmail.com>	<20101209143448.5c479e50@barsoom.rdu.redhat.com> <AANLkTikKkOEO1gZFCD+aVwVTCEXmR9Q6jVndrX6Bd08V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Bernhard Walle <bernhard-X9USDgGjgfuzQB+pC5nmwQ@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikKkOEO1gZFCD+aVwVTCEXmR9Q6jVndrX6Bd08V-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/10/2010 02:14 AM, Steve French wrote:
> On Thu, Dec 9, 2010 at 1:34 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> On Thu, 9 Dec 2010 12:26:39 -0600
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> On Thu, Dec 9, 2010 at 6:09 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>>> On Thu, 09 Dec 2010 17:10:28 +0530
>>>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>>>
>>>>> On 12/06/2010 09:08 PM, Jeff Layton wrote:
>>>>>> On Mon, 06 Dec 2010 16:35:06 +0100
>>>>>> Bernhard Walle <bernhard-X9USDgGjgfuzQB+pC5nmwQ@public.gmane.org> wrote:
>>>>>>
>>>>>>>
>>>>>>> Zitat von Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>>>>>>
>>>>>>>>
>>>>>>>> I'm still not sure I like this patch however. It potentially m=
eans a
>>>>>>>> lot of printk spam since these things have no ratelimiting. It=
 also
>>>>>>>> doesn't tell me anything about which server might be giving me=
 grief.
>>>>>>>>
>>>>>>>> Maybe this should be turned into a cFYI?
>>>>>>>
>>>>>>> Well, if I see it in the kernel log, it doesn't matter if it's =
info or
>>>>>>> something else.
>>>>>>>
>>>>>>>> The bottom line though is that running 32-bit applications tha=
t were
>>>>>>>> built without -D_FILE_OFFSET_BITS=3D64 on a 64-bit kernel is a=
 very bad
>>>>>>>> idea. It would be nice to be able to alert users that things a=
ren't
>>>>>>>> working the way they expect, but I'm not sure this is the righ=
t place
>>>>>>>> to do that.
>>>>>>>
>>>>>>> Well, but there *are* such application (in my case it was Softm=
aker Office
>>>>>>> which is a proprietary word processor) and it's quite nice if y=
ou know
>>>>>>> how you can workaround it when you encounter such a problem. Th=
at's all.
>>>>>>>
>>>>>>
>>>>>> Sure...but this problem is not limited to CIFS. Many modern file=
systems
>>>>>> use 64-bit inodes. Running this application on XFS or NFS for in=
stance
>>>>>> is likely to give you the same trouble. You just hit it on CIFS =
because
>>>>>> the server happened to give you a very large inode number.
>>>>>>
>>>>>> If we're going to add printk's for this situation, it probably o=
ught to
>>>>>> be in a more generic place.
>>>>>>
>>>>>
>>>>> By generic place, did you mean at the VFS level? I think at VFS l=
evel,
>>>>> there is little information about the Server or underlying fs and=
 this
>>>>> information doesn't seem too critical that VFS should warn/care m=
uch about.
>>>>>
>>>>> May be sticking to a cFYI along with Server detail is a good idea=
?
>>>>>
>>>> My poing was mainly that there's nothing special about CIFS in thi=
s
>>>> regard, other than the fact that servers regularly send us inodes =
that
>>>> are larger than 2^32. Why should we do this for cifs but not for n=
fs,
>>>> xfs, ext4, etc?
>>>>
>>>> The filldir function gets a dentry as an argument, so it could
>>>> reasonably generate a printk for this. I'm also not keen on
>>>> the printk recommending noserverino for this. That has its own
>>>> drawbacks.
>>>>
>>>> A cFYI for this sort of thing seems reasonable however.
>>>
>>> I agree that a cFYI is reasonable. =EF=BF=BDThe next obvious questi=
on is: do
>>> we need to add code to generate unique 32 bit inode numbers
>>> that don't collide (as IIRC Samba does by xor the high and low 32
>>> bits of the inode number) when the app can't support ino64
>>> I would prefer not to go back to noserverino since that has worse
>>> drawbacks.
>>>
>>
>> Right, the fact that noserverino works around this is really just du=
e
>> to an implementation detail of iunique(). That should probably be
>> discouraged as a solution since it's not guaranteed to be a workarou=
nd
>> in the future.
>>
>> If we did add such a switch, I'd suggest that we pattern it after wh=
at
>> NFS did for this. They added an "enable_ino64" module parameter a
>> couple of years ago that defaults to "true".

What are the advantages we have by making it a module parameter as
opposed to an mount option? XFS seems to have "inode64" mount option fo=
r
quite sometime now, without much issues..

> makes me uncomfortable to break ino64 for all mounts - when we
> may have one application on one mount that needs it (might be
> better to make a mount related)
>=20
>=20


--=20
Suresh Jayaraman
