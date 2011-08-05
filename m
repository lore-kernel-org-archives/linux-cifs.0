From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] cifs: cope with negative dentries in cifs_get_root
Date: Fri, 5 Aug 2011 16:15:50 +0100
Message-ID: <20110805151549.GT2203@ZenIV.linux.org.uk>
References: <1312549360-4317-1-git-send-email-jlayton@redhat.com>
 <20110805145428.GS2203@ZenIV.linux.org.uk>
 <CAH2r5mvB8jyZnnSaGCs1Z=NWMCh6LQBpwTR3hY1Fv9pxw54+Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mvB8jyZnnSaGCs1Z=NWMCh6LQBpwTR3hY1Fv9pxw54+Kw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 05, 2011 at 10:01:47AM -0500, Steve French wrote:
> On Fri, Aug 5, 2011 at 9:54 AM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> > On Fri, Aug 05, 2011 at 09:02:40AM -0400, Jeff Layton wrote:
> >> The loop around lookup_one_len doesn't handle the case where it might
> >> return a negative dentry, which can cause an oops on the next pass
> >> through the loop. Check for that and break out of the loop with an
> >> error of -ENOENT if there is one.
> >
> > Ouch. ?Nice catch and that one is my damn fault. ?Do you want that one
> > to go through cifs or vfs tree? ?ACK, in any case...
> 
> Probably safer to go through my tree, reduce chance of merge conflict
> Was planning on sending a merge request up soon in any case.

OK

Acked-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
