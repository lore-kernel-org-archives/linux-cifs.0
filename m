From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next workflow question for cifs
Date: Wed, 9 May 2012 09:45:11 -0400
Message-ID: <20120509094511.29ca89ea@corrin.poochiereds.net>
References: <CAH2r5mtBK-C0Uc6gVY0Dk+YfbaFE+OfCbM+A_2BmiTVzZMchmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtBK-C0Uc6gVY0Dk+YfbaFE+OfCbM+A_2BmiTVzZMchmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 May 2012 08:19:05 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Trying to figure out the easiest way for the workflow for the new
> cifs-2.6.git linux-next branch for this scenario:
> 
> - push a series of patches to cifs-2.6.git linux-next
> - someone adds an ack to a patch in the middle, or even a coding
> change to a patch in the middle
> - how do I easiest make this change and repush (without constantly
> doing git push --force)
> 
> Do I rename the branch on my local workstation, do a git push (what is
> the option to delete a branch remotely...?), then switch on the local
> box to the newly renamed branch, amend the patch (will gitk or other
> gui tool make this easier than what I use today which is git command
> line option which launches a vi-like interface  which is a little bit
> of a pain), rename the branch back and then push the new linux-next
> branch (and create it on the remote server) ....
> 

The upstream linux-next tree is recreated from scratch every time. So,
there's no harm in rebasing that branch, or rewriting its history. Only
the end product matters.

I use stgit heavily, so editing a patch description in the middle of a
stack is trivial. Not sure what you can do with regular git tools or
something like gitk.

I guess you could create a new branch and cherry-pick all of the
patches from the old, while doing something like "git commit --amend"
to add Reviewed-by lines and such. It's a bit cumbersome, but the basic
git tools are sort of primitive for this sort of thing...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
