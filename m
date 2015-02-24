From: "Bob Balsover" <cifs-MPfZBXey4klWk0Htik3J/w@public.gmane.org>
Subject: Re: Access denied in sub-folder
Date: Tue, 24 Feb 2015 13:05:24 -0800
Message-ID: <bfd8cb5eaa64ae12d794640ca5bce355.squirrel@mail.balsover.com>
References: <loom.20150224T112226-189@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Halvor Lund" <halvor.lund-YlzW+7GAZUhhl2p70BpVqQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20150224T112226-189-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Halvor,

This looks similar to an issue that I had with a 2.6 kernel.  It appears
that you might be using ntlmssp or ntlmsspi.  I don't use smbmount so I
don't know anything about that program but I assume that it runs in user
space where most of the heavy lifting for mount.cifs happens in kernel
space.

You might be connecting to a DFS share which requires that the
authentication level is the same on all shared directories used by the DFS
share.  If one machine is using NTLMSSP on the DFS namespace server but
the other machine that is also referenced by the DFS share is using NTLMv2
or NTLM you will get an authentication error because once mount.cifs is
called and you specify the protocol that is the only protocol that will be
used inside the kernel.  smbmount on the other hand might try to connect
using other protocols because it itself is doing all of the connecting. 
Just a wild guess....  What you should do is run a network trace on the
connection attempt and look for a DFS referral and if there is one this
might be the problem.  Once you have the address of the referral, it will
be passed as text, try to connect using the same parameters that you were
using before and see if it connects.

Good luck.

> Hello,
>
> I'm having trouble accessing a folder of a share on a Windows Server 2008
> R2. mount.cifs fails with "Permission denied", while smbclient succeeds,
> when listing (ls) the folder contents.
>
> In the path //server/share/folder I can access \\server\share using
> mount.cifs, but not //server/share/folder.
> By turning on debugging in /proc/fs/cifs/cifsFYI, I see the following
> status
> codes in dmesg when trying to list //server/share/folder:
> NT_STATUS_PATH_NOT_COVERED
> NT_STATUS_MORE_PROCESSING_REQUIRED
> NT_STATUS_NO_SUCH_DEVICE
> NT_STATUS_ACCESS_DENIED
>
> It seems that //server/share/folder is not a "true" path, but somehow
> remapped to //anotherserver/anothershare/folder1/folder2, and that this
> has
> something to do with the problem.
>
> Kernel: 3.16.0-30-generic
> mount.cifs version: 6.0
>
> /proc/fs/cifs/DebugData:
> 2) Name: xxx.xxx.xxx.xxx  Domain: <domain> Uses: 1 OS: Windows Server 2008
> R2 Enterprise 7601 Service Pack 1
> 	NOS: Windows Server 2008 R2 Enterprise 6.1	Capability: 0x1f3fc
> 	SMB session status: 1	TCP status: 1
> 	Local Users To Server: 1 SecMode: 0xf Req On Wire: 0
> 	Shares:
> 	1) \\server\share Mounts: 1 Type: NTFS DevInfo: 0x20 Attributes: 0xc700ff
> 	PathComponentMax: 255 Status: 0x1 type: DISK
>
> 	MIDs:
>
> Best regards,
> Halvor Lund
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
