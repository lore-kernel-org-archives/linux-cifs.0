From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/16] cifs: eliminate oflags option from
 cifs_new_fileinfo
Date: Mon, 11 Oct 2010 15:25:08 -0400
Message-ID: <20101011152508.452f6599@corrin.poochiereds.net>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
	<1286824053-12084-6-git-send-email-jlayton@redhat.com>
	<AANLkTik4nwj6W+Pp08+dRPMZw=w-8Z8OXdiutLVS5+v8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik4nwj6W+Pp08+dRPMZw=w-8Z8OXdiutLVS5+v8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Oct 2010 14:14:36 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Oct 11, 2010 at 2:07 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Eliminate the poor, misunderstood "oflags" option from cifs_new_fileinfo.
> > The callers mostly pass in the filp->f_flags here.
> >
> > That's not correct however since we're checking that value for
> > the presence of FMODE_READ. Luckily that only affects how the f_list is
> > ordered. What it really wants here is the file->f_mode, but this check
> > really makes no sense whatsoever. FMODE_READ will be set for O_RDWR or
> > O_RDONLY opens. So this in effect just moves those to the front of the
> > list and leaves O_WRONLY at the end.
> >
> > That might make some sense if more things paid attention to the list
> > order, but the only thing that does is find_readable_file, which uses
> > it to stop scanning the list when it hits a write-only one.
> 
> Removing a small optimization for small simplification of code seems
> less useful type of patch.   Not sure how often the acl calls get hit
> - but it is remotely possible that this could affect performance.
> 

Emphasis on _remotely_ :)

They don't get hit at all unless you're mounting with -o cifsacl. If
you're doing that, performance is already going to suck and this won't
make the least bit of difference.

It's really hard to see how this would have any measurable performance
impact. I think we'll all be better off with clear, defensive code for
this sort of stuff rather than questionable optimizations.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
