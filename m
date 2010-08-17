From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Problems with writing to CIFS share on RHEL5U2
Date: Tue, 17 Aug 2010 08:29:31 -0400
Message-ID: <20100817082931.7943941b@tlielax.poochiereds.net>
References: <loom.20100813T121322-55@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Decker <martin.decker-W6hacnnSDYuikuSvNLsyVV6hYfS7NtTn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20100813T121322-55-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 13 Aug 2010 10:14:17 +0000 (UTC)
Martin Decker <martin.decker-W6hacnnSDYuikuSvNLsyVV6hYfS7NtTn@public.gmane.org> wrote:

> Problems with writing to CIFS share on RHEL5U2
> Antworten
> |
> Martin Decker
>  an linux-cifs-cli.
> 	
> Details anzeigen 12:06 (Vor 6 Minuten)
> 	
> Dear List,
> 
> I am having different kinds of problems when writing Oracle backups to a CIFS
> share on RHEL5U2. Server is Windows Server 2003.
> 

RHEL5U2 is quite old, I'd suggest using something newer.


> cat /proc/fs/cifs/DebugData
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 1.50cRH
> Active VFS Requests: 1
> Servers:
> 
> 1) Name: 10.1.1.4  Domain: DOM1 Mounts: 2 OS: Windows Server 2003 R2 3790
> Service Pack 2
>         NOS: Windows Server 2003 R2 5.2 Capability: 0x1f3fd
>         SMB session status: 1   TCP status: 1
>         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 1
> MIDs:
> State: 2 com: 47 pid: 15478 tsk: ffff81016a30a040 mid 20561
> 
> 
> Shares:
> 1) \\10.1.1.4\Backup$ Uses: 1 Type: NTFS DevInfo: 0x20 Attributes: 0x700ff
> PathComponentMax: 255 Status: 1 type: DISK
> 
> 
> modinfo cifs
> filename:       /lib/modules/2.6.18-92.1.22.el5/kernel/fs/cifs/cifs.ko
> version:        1.50cRH
> 
> 
> /etc/fstab:
> //10.1.1.4/Backup$ /backup cifs
> directio,username=WinUser,password=xxx,_netdev,uid=oracle,gid=oinstall 0 0
> 
> 
> 
> The errors are
> 
> 1.
> 
> ORA-27041: unable to open file
> 27041, 00000, "unable to open file"
> // *Cause:  open system call returned an error, additional information
> //          indicates which function encountered the error
> // *Action: check errno
> 
> Linux-x86_64 Error: 26: Text file busy
> Additional information: 4
> 

That probably means that the server returned
NT_STATUS_SHARING_VIOLATION. Perhaps the file is opened someplace else
with a restrictive share mode?

> 2.
> 
> ORA-27072: File I/O error
> Linux-x86_64 Error: 13: Permission denied
> Additional information: 4
> Additional information: 33280769
> Additional information: -1
> 
> // *Cause:  read/write/readv/writev system call returned error, additional
> //          information indicates starting block number of I/O
> // *Action: check errno
> 

This could be a lot of different things. You'll probably need to
troubleshoot it using network traces or cifs debugging.

> 
> 3.
> ORA-27072: File I/O error
> Linux-x86_64 Error: 9: Bad file descriptor
> Additional information: 4
> Additional information: 574977
> Additional information: 458752
> 
> 27072, 00000, "File I/O error"
> // *Cause:  read/write/readv/writev system call returned error, additional
> //          information indicates starting block number of I/O
> // *Action: check errno
> 

Probably a bug. Again, hard to say without understanding what's
happening on the wire.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
