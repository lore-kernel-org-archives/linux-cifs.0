From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about notify.
Date: Mon, 25 Apr 2011 14:58:28 -0500
Message-ID: <BANLkTikrWsacPtU+4=Utva01APgXncOn7w@mail.gmail.com>
References: <BANLkTimAs2y121N6RZbzgmKC1+St4xuHrA@mail.gmail.com>
	<BANLkTin-osWCeYMAmmRACkVUWqmu2R9Hfg@mail.gmail.com>
	<BANLkTimYLdHH6wSWN3UcCPXuKPz1m3vNOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimYLdHH6wSWN3UcCPXuKPz1m3vNOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Apr 25, 2011 at 10:31 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> yes indeed for network filesystems it's a very usefull feature, but
> also for my FUSE fs it's a real plus.
>
> Can you please tell me something more. Jeff Layton mentioned you name
> in the (short) discussion on the linux fsdevel maillist. He says that
> you have been working on this topic before.
>
> I very much appreciate it when you could send some info, for example
> why it isn't implemented yet. I've seen more than one posts on this
> subject, but never heard about it since (for example some plans for
> GSOC 2010). Is it so hard?? I know it's getting more complicated when
> the backend is a server, which has to support these kinds of request,
> but when I first start with a simple FUSE overlay fs....

A few quick points.  OS/2 was the first common OS with a vfs
operation for file and directory change notification, but later on
Windows NT 4 or Windows 2000 improved the syntax of the
vfs and the corresponding SMB/CIFS network operation.   Since
Samba needed to implement this, Tridge requested a local
syscall for this years ago, and a dnotify call was implemented for Linux
for Samba to use.  On the client side, the Linux cifs kernel client
implemented experimental support.  Later on, Linux's inotify was implemented to
replace dnotify, which presumably helped Samba server a little, but hurt
the kernel client (inotify was more general IIRC than dnotify, but it has
been a while since I looked at the differences in detail).   I remember
looking again at the CIFS and SMB2 protocol support for file/directory
change notification a few years ago, and inotify seemed doable, but that
inotify was a more complicated interface to code to.

The protocol support for notify is in section 2.2.35 of MS-SMB2
(there is a similar section in the SMB/CIFS reference)
see http://msdn.microsoft.com/en-us/library/cc246553(v=PROT.13).aspx



-- 
Thanks,

Steve
