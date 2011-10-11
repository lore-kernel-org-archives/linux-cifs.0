From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: make OplockEnabled a module parameter
Date: Tue, 11 Oct 2011 10:35:07 -0500
Message-ID: <CAH2r5mt8fzUzS=Jeb+uHm1sE1HB9rAM77eDW=0tpBQiTuXsLFg@mail.gmail.com>
References: <4E940E2B.4050705@suse.de>
	<20111011063236.3fb399e0@tlielax.poochiereds.net>
	<4E942399.8050807@suse.de>
	<CAH2r5muJ6xiW5iPALmdaSxh=vYKGfq6SdWoRcf7YFGDFnxnDWw@mail.gmail.com>
	<20111011111228.7de52ca4@corrin.poochiereds.net>
	<CAH2r5mubs3wpz=RU9SNRcsRHB=fD+7E8MHQiBW3VnZ79_6rNUA@mail.gmail.com>
	<20111011112420.679251a3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111011112420.679251a3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 11, 2011 at 10:24 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Tue, 11 Oct 2011 10:21:21 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Oct 11, 2011 at 10:12 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>> > On Tue, 11 Oct 2011 10:03:31 -0500
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Tue, Oct 11, 2011 at 6:08 AM, Suresh Jayaraman <sjayaraman@sus=
e.de> wrote:
>> >> > On 10/11/2011 04:02 PM, Jeff Layton wrote:
>> >> >> On Tue, 11 Oct 2011 15:06:43 +0530
>> >> >> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>> >> >>
>> >> >>> Thus spake Jeff Layton:
>> >> >>>
>> >> >>> "Making that a module parm would allow you to set that parame=
ter at boot
>> >> >>> time without needing to add special startup scripts. IMO, all=
 of the
>> >> >>> procfile "switches" under /proc/fs/cifs should be module parm=
s
>> >> >>> instead."
>> >> >>>
>> >> >>> This seems reasonable so this patch makes OplockEnabled a mod=
ule
>> >> >>> parameter and rename it to enable_oplocks to comply with the =
coding
>> >> >>> conventions. This patch removes the proc file handling pertai=
ning to
>> >> >>> /proc/fs/cifs/OplockEnabled which would no longer be required=
 if this
>> >> >>> patch gets accepted.
>> >> >>>
>> >> >>> This patch doesn't alter the default behavior (Oplocks enable=
d by
>> >> >>> default). To disable oplocks when loading the module, use
>> >> >>>
>> >> >>> =A0 =A0modprobe cifs enable_oplocks=3D0
>> >> >>>
>> >> >>> Note:
>> >> >>> (a) I'm little worried about eliminating an already known int=
erace to
>> >> >>> =A0 =A0 enable/disable Oplocks. An update to README file ment=
ioning this info
>> >> >>> =A0 =A0 is planned. Do we need to warn users before pulling i=
t off? Any
>> >> >>> =A0 =A0 suggestions on how we could do this?
>> >> >>> (b) Most of the /proc/fs/cifs switches could be converted to =
a module
>> >> >>> =A0 =A0 param for e.g. LookupCacheEnabled, LinuxExtensionsEna=
bled,
>> >> >>> =A0 =A0 MultiuserMount etc. I'll post further patches once th=
is gets
>> >> >>> =A0 =A0 accepted.
>> >> >>>
>> >> >>
>> >> >> Yeah, I don't think we ought to just rip out these interfaces
>> >> >> unannounced. What should probably happen is this:
>> >> >>
>> >> >> Add the new module parms, and a patch that makes a printk pop =
when the
>> >> >> old interfaces are used. The printk should announce something =
like:
>> >> >>
>> >> >> "The /proc/fs/cifs/foo interface will be removed in kernel ver=
sion 3.x.
>> >> >> Please migrate to using the 'enable_foo' module parameter in c=
ifs.ko."
>> >> >>
>> >> >> Make the 3.x version be 2 releases out. Then have patches read=
y to go
>> >> >> to remove those interfaces when the 3.x merge window opens.
>> >> I don't mind adding a module parm to change the default but it se=
ems
>> >> odd, and removing the ability to temporarily turn off oplock seem=
s to
>> >> make things worse not better. =A0But I am not convinced of a good=
 use
>> >> case for disabling oplocks on module load (rather than the more
>> >> granular "forcedirectio" on mount, or the temporary ie at runtime=
 via
>> >> /proc). =A0 If oplock/caching on the client were broken, then we =
would
>> >> fix the bug rather than ask users to load with oplock off, if opl=
ock
>> >> were broken on a server, we would not want to disable it for moun=
ts to
>> >> all servers (as would a module parm) but just to workaround the b=
roken
>> >> server.
>> >>
>> >
>> > This doesn't prevent you from changing this setting after the modu=
le is
>> > loaded. It just moves the control to a more standard location
>> > (/sys/module/cifs/parameters).
>>
>> If "echo 1 > /sys/module/cifs/parameters/oplock_enabled" would work =
at runtime,
>> then I fine with the change. =A0 We could leave them both in for one=
 release,
>> and throw a onetime syslog message if you use the one in /proc/fs/ci=
fs/ (so
>> that users know that the old interface is going away)??
>>
>>
>
> Yes, that will work at runtime.
>
> I suggest leaving the old control in for 2 releases since that's the
> kernel "standard" for user-visible changes. There's no rush to
> deprecate the old code, so we should err on the side of caution.

Next obvious question - do we have other module parameters that
need to be changed to make config possible runtime.  Today only
echo_retries is configurable that way. The only other possible one
I see is cifs_max_pending (whose meaning will change in any case
when the maxmpx patch is merged - with the patch the upper limit will
be the minimum of cifs_max_pending and the server's returned
maxmpx rather than simply using cifs_max_pending).

There are six other parms (besides OplockEnabled) in /proc/fs/cifs
but I doubt that it is worth the trouble and confusion to change any
of them (although security flags is one that is more likely to want to =
be
changed at module install time)
--=20
Thanks,

Steve
