From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Trouble accessing Buffalo NAS with CIFSFS
Date: Thu, 19 Jan 2012 12:39:04 -0600
Message-ID: <CAH2r5mv5f-7PZ1vW3rtWG+DkDQ33SnExeaBvent6Z7YHGW_xPQ@mail.gmail.com>
References: <20120119090752.9b7aea6c.ralda@gmx.de>
	<4F18552A.3030804@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F18552A.3030804-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Would feel much more comfortable if at least one of us had a network
trace of the failure to look at

On Thu, Jan 19, 2012 at 11:38 AM, Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org=
> wrote:
> On 01/19/2012 01:37 PM, ralda-Mmb7MZpHnFY@public.gmane.org wrote:
>> new installation. With CIFS I can mount the NAS station and I can se=
e
>> the directory listings, but whenever I try to copy a file to the NAS
>> station the copy hangs and probably never return (leaving the proces=
s
>> with a D status in process list).
>
>> The NAS is mounted like this (output from /proc/mounts):
>>
>> //archiv/share /nas cifs rw,mand,nosuid,nodev,noexec,relatime,sec=3D=
ntlm,
>> =A0 unc=3D\\archiv\share,username=3Droot,uid=3D1002,forceuid,gid=3D6=
5534,forcegid,
>> =A0 addr=3D192.168.178.3,file_mode=3D0600,dir_mode=3D0700,nounix,rsi=
ze=3D16384,
>> =A0 wsize=3D65216,actimeo=3D1
>> =A0 0 0
>>
>> mount.cifs --version: 1.10
>>
>> dmesg output gives info like this:
>>
>> CIFS VFS: Autodisabling the use of server inode numbers on \\archiv
>> \share. This server doesn't seem to support them properly. Hardlinks
>> will not be recognized on this mount. Consider mounting with the
>> "noserverino" option to silence this message.
>> CIFS VFS: Server archiv has not responded in 300 seconds.
>> Reconnecting...
>> CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
>> CIFS VFS: Error -11 sending data on socket to server
>> CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
>> CIFS VFS: Error -11 sending data on socket to server
>> CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
>> CIFS VFS: Error -11 sending data on socket to server
>> CIFS VFS: Error -32 sending data on socket to server
>> CIFS VFS: Error -32 sending data on socket to server
>> CIFS VFS: Error -32 sending data on socket to server
>> ...
>>
>
> Error -32 is -EPIPE and it is kinda unusual from kernel_sendmsg(). I'=
m
> suspecting problems with CIFS socket/TCP state but hard to tell witho=
ut
> much information. Wondering perhaps, CIFS should also handle -EPIPE l=
ike
> sunrpc and try to gracefully shutdown the socket on -EPIPE allowing
> reconnections works without trouble...
>
>
> Suresh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
