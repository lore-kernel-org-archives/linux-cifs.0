From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Zero size and zero blocks mountpoint.
Date: Fri, 24 Sep 2010 19:44:30 +0200
Message-ID: <AANLkTim5dVdQuihXizVSey7VmRZOEKDh9STqKzxy1Vv2@mail.gmail.com>
References: <AANLkTinLwfXhcsAOPEK8reNRyWeyQnzGKm7uQOpYhM_5@mail.gmail.com>
	<20100924073515.7b441fa3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Alex Perez <quimicefa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100924073515.7b441fa3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/9/24 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:

>> how can I fix the directory-size that apache is receiving?
>>
>
> Honestly, that sounds like an apache bug. You may want to report that
> to them.
>
> I asked Stef this question question and didn't get an answer however:
>
> Does POSIX offer any guidance about what the size of a directory should
> represent?

I'm happy to see this question is again an issue.

I do not know about POSIX, but my common sense says that a directory,
even it is a
network directory, never has zero size.

As you mention, it's the space reserved for the directoryobject.

With a network fs (and every virtual fs) the link with the object on
the harddrive isn't there,
but a directory takes always some memory! In C there would be an entry
object allocated, I do not have to explain that. The size will
probably will be much less than the 4Kb with Ext2/3/4,
but my point is it is never zero.

Stef
