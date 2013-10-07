From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mount failure due to restricted access to a point along the mount path
Date: Sun, 6 Oct 2013 22:22:31 -0500
Message-ID: <CADT32eJz0v-ChdfeuLuRaPER-4_vgMy7Q1Z5PQXy0MY67aSuxg@mail.gmail.com>
References: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
	<20130510102754.184cd90d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130510102754.184cd90d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

So instead of breaking superblock sharing and fscache functionality
with 2), it may be better off to explore 1).  Will spend some time doing so.

Regards,

Shirish

On Fri, May 10, 2013 at 9:27 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 10 May 2013 16:13:30 +0200
> Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org> wrote:
>
>> Hi,
>>
>> A while ago this was discussed:
>>
>>   http://thread.gmane.org/gmane.linux.kernel.cifs/7779
>>
>> This is essentially a regression introduced by the shared superblock
>> changes in 3.0 and several SUSE customers are complaining about it.
>> I've created a temporary fix which reverts 29 commits related to the
>> shared superblock changes.  It works, but it's obviously not a
>> permanent fix, especially since we definitely don't want to diverge
>> from mainline.
>>
>> Is this issue being worked on?  Don't other distros have similar reports?
>>
>> Thanks,
>> Miklos
>
> I don't know of anyone currently working on it. There are a couple of
> possible approaches to fixing it, I think:
>
> 1) if the dentries to get down to the root of the mount don't already
> exist, then attach some sort of "placeholder" inode that can be fleshed
> out later if and when the dentry is accessed via other means.
>
> 2) do something like what NFS does (see commit 54ceac45). This becomes
> a bit more complicated due to the fact that the server may not hand out
> real inode numbers and we sometimes have to fake them up.
>
> #1 is probably simpler to implement, but I'll confess that I haven't
> thought through all of the potential problems with it.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
