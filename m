From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Zero size and zero blocks mountpoint.
Date: Mon, 20 Sep 2010 09:29:38 +0200
Message-ID: <AANLkTik04e_d9HPeGsB8Adcm2tpGh-qEOwcQvu6ScP3D@mail.gmail.com>
References: <AANLkTi=GPOoF5bOdySz2izWTEEBShZ8LG=SWPKZVHCU8@mail.gmail.com>
	<20100919150427.16ab30d9@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100919150427.16ab30d9-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/9/20 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Sun, 19 Sep 2010 21:28:41 +0200
> Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hello,
>>
>>
>> It's causing some unwanted behaviour.
>> How can I change that, or is this not changeable?
>> Stef
>
> I think it's just a matter of setting the inode->i_size on the
> directory. I *think* that when you do a QPathInfo call to a directory
> via cifs the size comes back 0. Setting this to something else probably
> means an extra call to the server to get the "real" size (whatever that
> means). The question is, what should this be set to?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Yes that's a good question. But a share mounted with cifs should
behave like it is's just a local harddrive partition right? So these
values are obligatory...

 In my construction - so I'm speaking only for my own here -
it's also set the size (and the blocks) in the FUSE fs. Remember, I'm
using the FUSE fs fuse-workspace
as the one which is used, and the various mounts to resources like smb
shares (mounted with cifs of course, managed with autofs) are the
underlying backend.

My FUSE can correct things, like this.

I wonder, it can correct things, but is it also a must?
My fuse fs takes these values just from the underlying fs, and this
can result in
a size of directories of 4096 when the underlying fs is a mounted
partition (of for example an USB disk) and zero
when it's a cifs mounted smb share. Is it a bad thing that these
values differ in the same fs (in my case thus fuse-workspace)??

Maybe you know this, else I'll try at the fsdevel list.

Stef
