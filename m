From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 12/32] CIFS: Fix a wrong pointer in atomic_open
Date: Tue, 24 Jul 2012 13:35:12 -0400
Message-ID: <20120724133512.678cf10e@tlielax.poochiereds.net>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
	<1342166025-29377-13-git-send-email-pshilovsky@samba.org>
	<CAKywueREdACOXTaUGLdGbH9RkLk82m4DS-bQJEJUfBS1SPf2Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueREdACOXTaUGLdGbH9RkLk82m4DS-bQJEJUfBS1SPf2Ow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 Jul 2012 20:59:27 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> 2012/7/13 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > Commit 8ce5c35dd353cbf533383c54dca8aa7d2da6950f caused a regression
> > in cifs open codepath.
> >
> 
> Since Al Viro rebased his branch one more times from the last time I
> rebased on top of it the commit id has changed to
> 30d904947459cca2beb69e0110716f5248b31f2a.
> 
> Steve, can you fix the description or simply reapply the patch from
> here (smb2-mount branch - the equivalent of your for-next with a fixed
> description of this commit), please:
> 
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commit;h=546bb6548f0659bb55add6b956809928b7ad035b
> 

Patch looks correct...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
