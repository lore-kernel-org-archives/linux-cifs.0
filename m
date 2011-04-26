From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about notify.
Date: Tue, 26 Apr 2011 15:16:24 +0200
Message-ID: <BANLkTi=q6DeXZ-XgBy-xoh1hWi00A_99vg@mail.gmail.com>
References: <BANLkTimAs2y121N6RZbzgmKC1+St4xuHrA@mail.gmail.com>
	<BANLkTin-osWCeYMAmmRACkVUWqmu2R9Hfg@mail.gmail.com>
	<BANLkTimYLdHH6wSWN3UcCPXuKPz1m3vNOw@mail.gmail.com>
	<BANLkTikrWsacPtU+4=Utva01APgXncOn7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikrWsacPtU+4=Utva01APgXncOn7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,


OK, that's interesting!


It's getting much more clear now.

How did apps ( or anything else what was interested in file/dir
changes) instruct the mount.cifs
(or was it smbmount at those days?) prog to watch a particular inode/en=
try?

This is interesting cause that's the issue now, integration from the
notify subsytem in VFS and the fs (cifs/fuse or any other) is the key,
as I look at it.

I have to read a lot about this cause although I'm working already
some time now on FUSE fs's, but not on the kernel.

Stef

2011/4/25 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Mon, Apr 25, 2011 at 10:31 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi,
>>
>> yes indeed for network filesystems it's a very usefull feature, but
>> also for my FUSE fs it's a real plus.
>>
>> Can you please tell me something more. Jeff Layton mentioned you nam=
e
>> in the (short) discussion on the linux fsdevel maillist. He says tha=
t
>> you have been working on this topic before.
>>
>> I very much appreciate it when you could send some info, for example
>> why it isn't implemented yet. I've seen more than one posts on this
>> subject, but never heard about it since (for example some plans for
>> GSOC 2010). Is it so hard?? I know it's getting more complicated whe=
n
>> the backend is a server, which has to support these kinds of request=
,
>> but when I first start with a simple FUSE overlay fs....
>
> A few quick points. =C2=A0OS/2 was the first common OS with a vfs
> operation for file and directory change notification, but later on
> Windows NT 4 or Windows 2000 improved the syntax of the
> vfs and the corresponding SMB/CIFS network operation. =C2=A0 Since
> Samba needed to implement this, Tridge requested a local
> syscall for this years ago, and a dnotify call was implemented for Li=
nux
> for Samba to use. =C2=A0On the client side, the Linux cifs kernel cli=
ent
> implemented experimental support. =C2=A0Later on, Linux's inotify was=
 implemented to
> replace dnotify, which presumably helped Samba server a little, but h=
urt
> the kernel client (inotify was more general IIRC than dnotify, but it=
 has
> been a while since I looked at the differences in detail). =C2=A0 I r=
emember
> looking again at the CIFS and SMB2 protocol support for file/director=
y
> change notification a few years ago, and inotify seemed doable, but t=
hat
> inotify was a more complicated interface to code to.
>
> The protocol support for notify is in section 2.2.35 of MS-SMB2
> (there is a similar section in the SMB/CIFS reference)
> see http://msdn.microsoft.com/en-us/library/cc246553(v=3DPROT.13).asp=
x
>
>
>
> --
> Thanks,
>
> Steve
>
