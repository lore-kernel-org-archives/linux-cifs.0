From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: make OplockEnabled a module parameter
Date: Tue, 11 Oct 2011 10:23:18 -0500
Message-ID: <CAH2r5mvKdOmMCAdWL7AX=fYrCUu6Q7a6oGg67qvN822WXBf76A@mail.gmail.com>
References: <4E940E2B.4050705@suse.de>
	<20111011063236.3fb399e0@tlielax.poochiereds.net>
	<4E942399.8050807@suse.de>
	<CAH2r5muJ6xiW5iPALmdaSxh=vYKGfq6SdWoRcf7YFGDFnxnDWw@mail.gmail.com>
	<20111011111228.7de52ca4@corrin.poochiereds.net>
	<CAH2r5mubs3wpz=RU9SNRcsRHB=fD+7E8MHQiBW3VnZ79_6rNUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mubs3wpz=RU9SNRcsRHB=fD+7E8MHQiBW3VnZ79_6rNUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 11, 2011 at 10:21 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>>> I don't mind adding a module parm to change the default but it seem=
s
>>> odd, and removing the ability to temporarily turn off oplock seems =
to
>>> make things worse not better. =A0But I am not convinced of a good u=
se
>>> case for disabling oplocks on module load (rather than the more
>>> granular "forcedirectio" on mount, or the temporary ie at runtime v=
ia
>>> /proc). =A0 If oplock/caching on the client were broken, then we wo=
uld
>>> fix the bug rather than ask users to load with oplock off, if oploc=
k
>>> were broken on a server, we would not want to disable it for mounts=
 to
>>> all servers (as would a module parm) but just to workaround the bro=
ken
>>> server.
>>>
>>
>> This doesn't prevent you from changing this setting after the module=
 is
>> loaded. It just moves the control to a more standard location
>> (/sys/module/cifs/parameters).
>
> If "echo 1 > /sys/module/cifs/parameters/oplock_enabled" would work a=
t runtime,

I meant the reverse (obviously oplock is enabled by default)

 "echo 0 > /sys/module/cifs/parameters/oplock_enabled"
--=20
Thanks,

Steve
