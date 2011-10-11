From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs ignores sysct setting
Date: Tue, 11 Oct 2011 09:09:37 -0500
Message-ID: <CAH2r5mu49o4o-zc_1Yg7BG3i9nya3WfxBttMm-W-w755t=UtmQ@mail.gmail.com>
References: <02d643a6-776c-4ab4-9561-591934939ae8@absint.swen.nu>
	<4E92EDC7.30101@suse.com>
	<20111010093716.68c55bff@corrin.poochiereds.net>
	<4E940912.1000408@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E940912.1000408-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Actually, it seems more likely that you would turn off oplock temporari=
ly
(ie via /proc) rather than permanently (until cifs is reloaded or the
system reboots).   Wouldn't you only turn oplock off to temporarily
work around a buggy server?

On Tue, Oct 11, 2011 at 4:14 AM, Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>=
 wrote:
> On 10/10/2011 07:07 PM, Jeff Layton wrote:
>> On Mon, 10 Oct 2011 18:36:15 +0530
>> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>>
>>> On 10/10/2011 03:02 PM, Alexander Swen wrote:
>>>>
>>>> Hi Steve and other CIFS developers,
>>>>
>>>> please help me with the following:
>>>> 1. fix the bug I explain below ;-)
>>>> 2. tell me to what bug tracking system I should to file it to.
>>>>
>>>> so, imho this is a bug: when I load the cifs module it insists in =
setting oplockenabled to 1 while we want to have locking disabled (due =
to our poormen's nas who's performance sinks to subzero when we do seri=
ous io ;-)
>>>>
>>>> I've filed this bug at Debian: http://bugs.debian.org/cgi-bin/bugr=
eport.cgi?bug=3D644135
>>>>
>>>> I paste all details over here as well:
>>>> <paste>
>>>> Package: linux-mage
>>>> Version: 2.6.32-5-amd64
>>>>
>>>> cifs.ko module (which is included in the kernel pkg as far as i kn=
ow)
>>>> cifs driver version 1.61
>>>>
>>>> when cifs module loads oplock is enabled by default.
>>>> so I can do
>>>> echo 0 >/proc/fs/cifs/OplockEnabled
>>>> but that won't persist through a driver reload. so we tried adding=
 this to /etc/sysctl.conf:
>>>> fs.cifs.OplockEnabled =3D 0
>>>> however:
>>>>
>>>> root@nl14s0008-vm1:~# echo 0 >/proc/fs/cifs/OplockEnabled
>>>> root@nl14s0008-vm1:~# cat /proc/fs/cifs/OplockEnabled
>>>> 0
>>>> root@nl14s0008-vm1:~# modprobe -r cifs
>>>> root@nl14s0008-vm1:~# tail -1 /etc/sysctl.conf
>>>> fs.cifs.OplockEnabled =3D 0
>>>
>>> IIUC, CIFS OplockEnabled is not a proper sysctl, it is just a proc
>>> entry. Sysctls are listed below /proc/sys/ directory.
>>>
>>> For e.g. try
>>> =A0 =A0sysctl -w fs.cifs.OplockEnabled=3D0
>>>
>>> you'll see the error: "/proc/sys/fs/cifs/OplockEnabled: No such fil=
e or
>>> directory". Also,
>>>
>>> =A0 =A0sysctl -p
>>>
>>> will throw the error: "/proc/sys/fs/cifs/OplockEnabled: No such fil=
e or
>>> directory"
>>>
>>> It is not clear to me why do you want to unload and reload cifs mod=
ule
>>> often? The general usage is load module during boot or on first use=
 and
>>> the module lives on till the machine goes down.
>>>
>>> I'm not seeing an justification for making it an module parameter. =
Could
>>> you please explain more on how it will be useful?
>>>
>>
>> I agree with Alexander on this one...
>>
>> Making that a module parm would allow you to set that parameter at b=
oot
>> time without needing to add special startup scripts. IMO, all of the
>> procfile "switches" under /proc/fs/cifs should be module parms
>> instead.
>
> Making it a module parm would mean that it would no longer be possibl=
e
> to dynamically change OplockEnabled. But, that might be Ok, because i=
t
> is quite unusual to change this setting once the module is loaded,
> right?. Also, someone won't be able to see what is the current settin=
g.
> Again, not a big deal.
>
>> That would also allow us to get rid of some of the special procfile
>> handling code for those files as well.
>>
>
> Agreed.
>
> I'll whip up a patch and post it soon.
>
>
> -Suresh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
