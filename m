From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS hang
Date: Sat, 26 Mar 2016 21:40:26 -0500
Message-ID: <CAH2r5ms5BG+YBvn8inRk0giw-rmj8kdno_wNXBZKMHiC=-zCRA@mail.gmail.com>
References: <CAOE4rSwtpUqzLUkUytNBJgTfe5kSKqZeKFgrhAP_TD4ms3wyVA@mail.gmail.com>
 <CAH2r5mshFG2FGaRhXnQ4nVKGd_V+1-eQj1K1JPMBBptdvOJL1Q@mail.gmail.com>
 <CAOE4rSzGegs_ttUsNcd7KPPRcpeZLPCBPMYO9hjuZ2FA+AQUEg@mail.gmail.com>
 <CAH2r5mtPHB=c-9Ds5JV2gXPLawS3HR+FMYDP1bzE=8otgkhEFw@mail.gmail.com> <CAOE4rSzU9+D94ZcOfyQNkgEKbtfj=JtxxSsrkDBOdrDma3=ybg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOE4rSzU9+D94ZcOfyQNkgEKbtfj=JtxxSsrkDBOdrDma3=ybg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Well the good news is that you can increase the trace level for the
kernel cifs tracing and just look at the end of the kernel message log
around the time of failure and that may give additional information -
but fairly clearly this is reconnection related (since you had 523
reconnection attempts, and only 280 total file operations) and it is
"normal" to hang (depending on "hard" vs. "soft" mount options and the
type of operation) if the server or network goes down - but obviously
it is usually interruptible.  We may be able to make additional code
paths interruptible that currently aren't to allow you to ctl-c around
server hangs.

On Sat, Mar 26, 2016 at 9:34 PM, D=C4=81vis Mos=C4=81ns <davispuh@gmail=
=2Ecom> wrote:
> 2016-03-27 5:10 GMT+03:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> How reproducible is it?
>
> Currently it happens randomly and I've no idea what or how it's cause=
d
> so I can't reproduce only wait when it happens. But it have happened
> like once every few days.
>
>> Do you see a timeout occurring (ie if you look at /proc/fs/cifs/Stat=
s
>> and /proc/fs/cifs/DebugData you may see session disconnect)?
>>
>
> After it did hung and then restarting smbd, right now everything is w=
orking
> and it shows
>
> $ cat /proc/fs/cifs/Stats
> Resources in use
> CIFS Session: 1
> Share (unique mount targets): 1
> SMB Request/Response Buffer: 1 Pool size: 5
> SMB Small Req/Resp Buffer: 1 Pool size: 30
> Operations (MIDs): 0
>
> 523 session 5 share reconnects
> Total vfs operations: 280 maximum at one time: 3
>
> 1) \\192.168.1.2\Data$
> SMBs: 30
> Negotiates: 0 sent 0 failed
> SessionSetups: 0 sent 0 failed
> Logoffs: 0 sent 0 failed
> TreeConnects: 0 sent 0 failed
> TreeDisconnects: 0 sent 0 failed
> Creates: 0 sent 2 failed
> Closes: 0 sent 0 failed
> Flushes: 0 sent 0 failed
> Reads: 0 sent 0 failed
> Writes: 0 sent 0 failed
> Locks: 0 sent 0 failed
> IOCTLs: 0 sent 0 failed
> Cancels: 0 sent 0 failed
> Echos: 0 sent 0 failed
> QueryDirectories: 0 sent 2 failed
> ChangeNotifies: 0 sent 0 failed
> QueryInfos: 0 sent 0 failed
> SetInfos: 0 sent 0 failed
> OplockBreaks: 0 sent 0 failed
>
>
> $ cat /proc/fs/cifs/DebugData
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 2.08
> Features: dfs fscache lanman posix spnego xattr acl
> Active VFS Requests: 0
> Servers:
> 1) entry for 192.168.1.2 not fully displayed
>         TCP status: 1
>         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
>         Shares:
>         1) \\192.168.1.2\Data$ Mounts: 1 DevInfo: 0x60020 Attributes:=
 0xc700ff
>         PathComponentMax: 255 Status: 1 type: DISK
>         Share Capabilities: None Aligned, Partition Aligned,    Share
> Flags: 0x0        Optimal sector size: 0x1000
>
>         MIDs:
>
>
>> If the scenario can be narrowed to something small - can you capture=
 a
>> network trace and send it to me
>>
>> https://wiki.samba.org/index.php/Capture_Packets
>>
>> or another page describing how to do this:
>>
>> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>>
>> (the 2nd link also includes information on how to make a more detail=
ed
>> trace of dmesg, the kernel messages which also would be useful)
>
> I'll try to when it happens, but because I don't know how to reproduc=
e it
> will have to wait when it happens again. Also after hang there might =
not
> be any cifs/samba network traffic at all... So I guess first should
> find out how to
> reproduce it but I've no idea even how... It might be related so some=
 specific
> file access pattern, timing or some other event.
>
>
> Anyway thanks! And hope we'll be able to figure out this one.



--=20
Thanks,

Steve
