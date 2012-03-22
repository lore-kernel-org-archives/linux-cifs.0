From: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Subject: Re: Inode link count on mounted Win98 shares
Date: Thu, 22 Mar 2012 10:28:18 +0100
Message-ID: <4F6AF0B2.1070403@innominate.com>
References: <4F69B8F9.9020808@innominate.com>	<20120321132300.42a95d51@redhat.com> <CAKywueR4v0MVpL-LoNsyjcDgzV3Tp9hkOvK3gLOP9o-SkJX_bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueR4v0MVpL-LoNsyjcDgzV3Tp9hkOvK3gLOP9o-SkJX_bQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/21/2012 07:24 PM, Pavel Shilovsky wrote:
> 21 =CD=C1=D2=D4=C1 2012 =C7. 21:23 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>  =CE=C1=D0=C9=D3=C1=CC:
>> On Wed, 21 Mar 2012 12:18:17 +0100
>> Federico Sauter<fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>  wrote:
>>
>>> Greetings,
>>>
>>> I want to make some CIFS shared drives accesible through a firewall=
=2E For
>>> that sake, I have a CIFS shared drive on a Linux box (box0, kernel
>>> 2.6.27.57) which is accesible from outside the firewall. On the sha=
re on
>>> that box I mount all the shared drives from within the firewall so =
that
>>> they can be accessed from client-external.
>>>
>>>     client-external
>>>       172.16.1.2
>>>            |
>>>            |
>>>       172.16.1.1/24
>>>      box0 (router, firewall)
>>>       192.168.1.1/24
>>>            |
>>>     +------+-------+
>>>     |              |
>>>    win98          winxp
>>> 192.168.1.2   192.168.1.3
>>>
>>> box0 exports a CIFS shared drive, say \\172.16.1.1\testshare, which
>>> refers to local directory, /mnt/share. On /mnt/share I mount two fu=
rther
>>> shared drives, say win98 and winxp. Thus, the contents from win98 a=
nd
>>> winxp become indirectly visible to the external network
>>> (client-external) via 172.16.1.1.
>>>
>>> This works well if I mount \\172.16.1.1\testshare using a Linux-bas=
ed
>>> client-external. Everything works as expected and I can browse the
>>> contents of both, winxp and win98. However, when I mount
>>> \\172.16.1.1\testshare on a Windows machine, I am unable to browse =
the
>>> contents of the win98 directory. While the winxp directory appears
>>> correctly as a folder in the Windows Explorer, the win98 directory
>>> appears as a zero byte file (even though it is mounted correctly on=
 box0.)
>>>
>>> I tested the same setup using my local workstation (with Debian squ=
eeze,
>>> kernel 2.6.32-5) and came to the same observations. The only differ=
ence
>>> I could find between the mounted winxp share and the win98 share on=
 box0
>>> is that the winxp mount point exhibits an inode link count of 1 aft=
er
>>> being mounted while the win98 mount point has an inode link count o=
f 0:
>>>
>>> root:/mnt/share# ls -l
>>> total 8
>>> (...)
>>> drwxr-xr-x 0 root root    0 Feb 23 01:39 win98
>>> drwxr-xr-x 1 root root    0 Mar 13 13:32 winxp
>>>
>>> I have tried pretty much every mount option and the behavior is alw=
ays
>>> the same.
>>>
>>> My questions are:
>>> 1. Why do Windows 98 mounted shares show this behavior?
>>> 2. Is there any way to correct this so as to be able to browse thes=
e
>>> shares indirectly (as described) from a Windows PC?
>>>
>>> Any information would be highly appreciated!
>>>
>>> Kind regards,
>>>
>>
>> That sounds like whatever tool you are using to "browse" is broken.
>> Just because the link count is 0 doesn't mean that it's a plain file=
=2E
>>
>> The inode link count is provided by the server via the NumberOfLinks
>> field in the QueryPathInfo response. What you are seeing here is jus=
t an
>> implementation difference between Linux and Windows. Linux usually h=
as
>> a non-zero inode link count on directories, but at least some versio=
ns
>> of windows will report a link count of 0 for a directory.
>>
>> As best I can tell -- neither one is more correct than the other.
>> They're just differences in how this is implemented.
>>
>> Most likely, this will change in very recent kernels with Pavel's fi=
x
>> to have the client fake up i_nlink values for directories, once Stev=
e
>> gets around to merging it.
>>
>> --
>> Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> It is already in mainline:
>
> http://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dcommit;h=3D71fece9=
511717750d86691e0f517ad04f3c8a801
>

Excellent! Thanks so much for the info!

--=20
=46ederico Sauter / Firmware developer
Innominate Security Technologies AG / protecting industrial networks
tel: +49.30.921028-210 / fax: +49.30.921028-020
Rudower Chaussee 13 / D-12489 Berlin / http://www.innominate.com/

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Christoph Leifer
