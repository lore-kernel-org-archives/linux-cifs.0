From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Connect notifyfs to cifs possible.
Date: Tue, 6 Mar 2012 13:37:14 -0600
Message-ID: <CAH2r5muEK8HYhXTU_w7Z9bVPVuguZ8mfwyQLMwVRCCtRupG2Fg@mail.gmail.com>
References: <CANXojczcNTpzgWf95Np9OHhFRu2hGqh=SrOe+UMm294t8HNuPw@mail.gmail.com>
	<CANXojcxVmSfJyCfoUHxiNVwyzr9hMKT6Of=rQfGY410r-DdZNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcxVmSfJyCfoUHxiNVwyzr9hMKT6Of=rQfGY410r-DdZNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Notify is great for cifs (smb/cifs clients regularly used it as far
back as OS/2, and Windows desktops use it with cifs and smb2 as a key
feature of their desktop).  What is going to be fun to figure out is
how "directory oplocks" (in smb2.2) can be used to simplify this and
make it perform even better.  There is

I am looking forward to understanding more how would like to tie this i=
n.

On Mon, Mar 5, 2012 at 7:15 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> I've got a clue howto do this, but it can be wromng, since I know
> howto program sockets since some months now.
>
> It's doable with a eventfd.
>
> Notifyfs can create when dealing with cifs an event fd, and pass it
> via a socket to mount.cifs.
> Mount.cifs passes this to the kernel via an option, and when it's
> finishing, closes the socket.
>
> This way the event fd is active, and can be used for forwarding notif=
y
> events/commands (and maybe others as well...)
>
> Please I do not want to push something here, but would like to make
> notifyfs work with filesystems like FUSE, nfs and cifs, and maybe
> others as well. I think that in near future, when more and more data
> is available remote on local servers (using existing fs's like cifs
> and nfs) AND on servers on the Internet, using a FUSE fs or something
> else (maybe cifs???) notifying the user and apps of changes is a very
> nice and good thing. Then it's up to the filesystem howto forward the
> notifyfs request.
>
> Stef
>
>
> 2012/3/5 Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Hi,
>>
>> I'm working on a successor of gamin, a file system change notifier.
>>
>> Like with gamin client apps can connect to it and instruct it to wat=
ch
>> a specific path.
>>
>> It's up to the notifyfs service to decide what backend (inotify,
>> polling etc) to use.
>>
>> New in my fs is the ability to "forward" the request to set a watch =
to
>> a fs. I do not have
>> a working example, but what I've got looks promising. I've got a
>> simple FUSE overlay fs, and this will use,
>> whenever it receives a request to set a watch from notifyfs, it set'=
s
>> a inotify watch on the underlying fs, and send any event back to
>> notify fs.
>>
>> To make this possible the filesystem, here thus the FUSE overlay fs,
>> has to connect to noitifyfs when it starts up, and register itself a=
s
>> client fs, and also has to send it's own mountpoint to notifyfs.
>>
>> I looked into the code of mount.cifs, but it's not that easy to
>> connect to via a socket, because the mainloop is in the kernel, not =
in
>> userspace. Is this somehowe (event fd??) still possible?
>>
>> Stef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
