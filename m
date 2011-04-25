From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question about notify.
Date: Mon, 25 Apr 2011 17:31:47 +0200
Message-ID: <BANLkTimYLdHH6wSWN3UcCPXuKPz1m3vNOw@mail.gmail.com>
References: <BANLkTimAs2y121N6RZbzgmKC1+St4xuHrA@mail.gmail.com>
	<BANLkTin-osWCeYMAmmRACkVUWqmu2R9Hfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTin-osWCeYMAmmRACkVUWqmu2R9Hfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

yes indeed for network filesystems it's a very usefull feature, but
also for my FUSE fs it's a real plus.

Can you please tell me something more. Jeff Layton mentioned you name
in the (short) discussion on the linux fsdevel maillist. He says that
you have been working on this topic before.

I very much appreciate it when you could send some info, for example
why it isn't implemented yet. I've seen more than one posts on this
subject, but never heard about it since (for example some plans for
GSOC 2010). Is it so hard?? I know it's getting more complicated when
the backend is a server, which has to support these kinds of request,
but when I first start with a simple FUSE overlay fs....


Any info, history, hints, suggestions welcome how to implement it are w=
elcome.

Stef


2011/4/25 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Mon, Apr 25, 2011 at 4:06 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi,
>>
>> some of you may already know I'm busy with this, I've posted here
>> before and at other places about this topic.
>>
>> see:
>>
>> http://marc.info/?l=3Dlinux-fsdevel&m=3D130052497829681&w=3D2
>>
>>
>> In short, I want to make fs's like my FUSE fs and cifs handle inotif=
y
>> request, done on userspace.
>
> Interesting. =C2=A0I think notify support is particularly important f=
or network
> file systems (to enable user space file managers to see
> when files are added/deleted - without having to poll). =C2=A0Windows
> desktop (and even years ago OS/2) have used SMB/CIFS
> notifications to refresh open directory listings automatically.
>
>
> --
> Thanks,
>
> Steve
>
