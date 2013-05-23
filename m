From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix composing of mount options for DFS referrals
Date: Thu, 23 May 2013 08:55:41 -0400
Message-ID: <20130523085541.2dcd55e5@corrin.poochiereds.net>
References: <1369270472-16408-1-git-send-email-jlayton@redhat.com>
	<20130523063715.557fbcc6@tlielax.poochiereds.net>
	<CAH2r5mtxN6faWt1-XWgFNHEWCaHAWrxBjYBZdD29FsF0QwRPkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtxN6faWt1-XWgFNHEWCaHAWrxBjYBZdD29FsF0QwRPkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 May 2013 07:48:21 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I will try to fix the comment up - and we can always update it later.  I
> will try to create the for 3.10 and for 3.11 branches later today
> (for-linus and for-next) so it is clearer what is going where
> 

Ok, thanks. I think all of the patches I sent yesterday are candidates
for 3.10. It's good to have a consistency when it comes to mount
options, and we want DFS to continue working.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
