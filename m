From: Kristian Rink <kawazu428-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux CIFS client, Windows 2012 CIFS file server => files not
 found?
Date: Fri, 21 Aug 2015 08:38:55 +0200
Message-ID: <55D6C77F.3000307@gmail.com>
References: <55D5D6FF.1070207@gmail.com> <CAH2r5mv6k7Yw5My-k0b_c32y9QRv+3g-L=e3UagexXfpSMFnXA@mail.gmail.com> <55D62C59.4000903@gmail.com> <CAH2r5mtfjj6-XvPoGTSOA8Cd9-wOEpUd5xhYGJzMHbDYboQ-ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtfjj6-XvPoGTSOA8Cd9-wOEpUd5xhYGJzMHbDYboQ-ZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve, *;

Am 20.08.2015 um 22:23 schrieb Steve French:
>
> Last thing in the trace is a parallelized read with lots of reads in
> flight at once which should be ok and I do see a response.

Ok. It's a bit strange, we used to have a similar behaviour a while ago
after switching the NetApp filer to SMB2.0, which would end up in a
situation in which some (Linux) part applications created files on the
CIFS share which this particular application was unable to see. In that
particular case however it seemed a timing problem in the application
and happened when creating files on CIFS from Linux and trying to access
them from Windows clients.


>
> Note that you should try the same dialect on both the mount to
> NetApp and Windows to make the comparison easier:  e.g. after -o in
> the mount command specify "vers=2.1" or "vers=3.0" (or don't specify
> any vers (or "vers=1.0") and it should default to cifs)

I tried all dialects while connecting to Windows, which didn't change 
this behaviour, just mounting with vers=3.0 makes it fail considerably 
faster.

Actually, to use the same dialect for both mounts means using vers=1.0; 
though the NetApp filer does support some understanding of at least 
SMB2.0 (and the shares can be accessed using SMB2.0 from Windows 
clients), mount.cifs can't mount any of our NetApp shares using SMB2.0.

We figured this out only a few weeks ago when starting moving our stores 
and tried to mount things consistently using SMB2.0 for performance 
reasons, and mounting the NetApp shares using anything else than CIFS 
will reproducibly end up in errors like this:

-------------------
mount error(95): Operation not supported
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

[3959136.173555] CIFS VFS: cifs_read_super: get root inode failed
-------------------

That's a different problem however and I am unsure whether this is a 
general problem or just an issue our fairly old NetApp / ONTAP version 
is to blame for. I surely can provide you with more information on that 
if that is of interest.


> 2) Are there any things logged in the message log on the Linux
> client (type "dmesg" to see what is logged) by cifs.ko during the
> failure on running to Windows.

No. Unfortunately not.

> Does the status of the session show
> disconnected at the end of the failure to Windows?   (See the "SMB
> session status" and "TCP status" in the output of "cat
> /proc/fs/cifs/DebugData")

Unsure. This is what DebugData so far says for this particular filer 
connection:


CIFS Version 2.03
Features: dfs fscache lanman posix spnego xattr acl
Active VFS Requests: 0
Servers:
1) entry for 192.168.1.138 not fully displayed
         TCP status: 1
         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
         Shares:
         1) \\192.168.1.138\Store Mounts: 1 Type: NTFS DevInfo: 0x60020
		Attributes: 0xc700ff
         PathComponentMax: 255 Status: 0x1 type: DISK
         MIDs:


Can you make anything of this?

Thanks bunches and all the best,
Kristian
