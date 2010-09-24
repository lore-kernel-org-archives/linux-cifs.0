From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Zero size and zero blocks mountpoint.
Date: Fri, 24 Sep 2010 07:35:15 -0400
Message-ID: <20100924073515.7b441fa3@corrin.poochiereds.net>
References: <AANLkTinLwfXhcsAOPEK8reNRyWeyQnzGKm7uQOpYhM_5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Perez <quimicefa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinLwfXhcsAOPEK8reNRyWeyQnzGKm7uQOpYhM_5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 24 Sep 2010 13:18:45 +0200
Alex Perez <quimicefa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I've just found this thread on google, and I subscribed to the list.
> 
> http://www.spinics.net/lists/linux-cifs/msg00951.html
> 
> I'm experiencing the same problem. the mountpoint is showing a 4096
> size, but when I mount a cifs resource, it shows a 0-size. Other
> mountpoints that are not using cifs (nfs, ext2-3 ...) doesnt change
> the size.
> 
> The problem is that the mount point belongs to a directory structure
> that is accesed by an apache service (2.0.54). The mount point is
> /opt/www/dir1, while the apache's directoryRoot is /opt/www. So, the
> problem is that when a client is trying to access to "dir1" I get a
> error in apache logs, like:
> 
> [Fri Sep 24 10:57:26 2010] [error] [client 192.0.2.147] (75)Value too
> large for defined data type: access to /dir1 failed
> 
> And the client gets a 403 - forbidden error. It's very tricky because
> if I dismount /opt/www/dir1, the client can access without any
> problem.
> 
> Googling this error seem that is related to accessing files > 2Gb, but
> I think that apache doesn't know how to handle a 0-size directory or
> it's understanding that is a huge sized directory ...
> 
> how can I fix the directory-size that apache is receiving?
> 

Honestly, that sounds like an apache bug. You may want to report that
to them.

I asked Stef this question question and didn't get an answer however:

Does POSIX offer any guidance about what the size of a directory should
represent?

For a local filesystem this is simple -- it's a representation of the
space that the directory occupies on disk (directories are just inodes
like any other).

NFS returns a non-zero size for a directory inode because the server
returns one. CIFS servers however send 0 for the size of a directory.
We could replace that with a fake value, but it's not at all clear to
me what that value should be.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
