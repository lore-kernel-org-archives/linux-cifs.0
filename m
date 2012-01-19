From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: Trouble accessing Buffalo NAS with CIFSFS
Date: Thu, 19 Jan 2012 23:08:50 +0530
Message-ID: <4F18552A.3030804@suse.com>
References: <20120119090752.9b7aea6c.ralda@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ralda-Mmb7MZpHnFY@public.gmane.org" <ralda-Mmb7MZpHnFY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120119090752.9b7aea6c.ralda-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 01/19/2012 01:37 PM, ralda-Mmb7MZpHnFY@public.gmane.org wrote:
> new installation. With CIFS I can mount the NAS station and I can see
> the directory listings, but whenever I try to copy a file to the NAS
> station the copy hangs and probably never return (leaving the process
> with a D status in process list).

> The NAS is mounted like this (output from /proc/mounts):
> 
> //archiv/share /nas cifs rw,mand,nosuid,nodev,noexec,relatime,sec=ntlm,
>   unc=\\archiv\share,username=root,uid=1002,forceuid,gid=65534,forcegid,
>   addr=192.168.178.3,file_mode=0600,dir_mode=0700,nounix,rsize=16384,
>   wsize=65216,actimeo=1
>   0 0
> 
> mount.cifs --version: 1.10
> 
> dmesg output gives info like this:
> 
> CIFS VFS: Autodisabling the use of server inode numbers on \\archiv
> \share. This server doesn't seem to support them properly. Hardlinks
> will not be recognized on this mount. Consider mounting with the
> "noserverino" option to silence this message.
> CIFS VFS: Server archiv has not responded in 300 seconds.
> Reconnecting...
> CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
> CIFS VFS: Error -11 sending data on socket to server
> CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
> CIFS VFS: Error -11 sending data on socket to server
> CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
> CIFS VFS: Error -11 sending data on socket to server
> CIFS VFS: Error -32 sending data on socket to server
> CIFS VFS: Error -32 sending data on socket to server
> CIFS VFS: Error -32 sending data on socket to server
> ...
> 

Error -32 is -EPIPE and it is kinda unusual from kernel_sendmsg(). I'm
suspecting problems with CIFS socket/TCP state but hard to tell without
much information. Wondering perhaps, CIFS should also handle -EPIPE like
sunrpc and try to gracefully shutdown the socket on -EPIPE allowing
reconnections works without trouble...


Suresh
