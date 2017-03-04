From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: Re: New kernel, new problems...
Date: Sat, 04 Mar 2017 11:51:26 -0800
Message-ID: <58BB1ABE.1000000@tlinx.org>
References: <58BA5F50.5060402@tlinx.org> <CAH2r5msku6_7kx949eOVCkjs=CBRLdPmmhN=1tMeaiXPrKdGKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msku6_7kx949eOVCkjs=CBRLdPmmhN=1tMeaiXPrKdGKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve French wrote:
> Not all file system types in Windows support unique ids (although NTFS
> does).  Could this
> be a FAT filesystem on the server?
>   
----
    Nope.  Only 1 FS, the main/root one and that is NTFS.  Have only
seen this message when I tried using smb2.


> I should also mention that even with server inode numbers disabled,
> although this in theory could indicate a server problem, few client functions
> are affected

	If it doesn't think it is an NTFS file system, would that affect
the ability to unmount it?  I.e. I still don't know how to unmount the
file system.
