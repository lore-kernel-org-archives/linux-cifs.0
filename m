From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: patch status
Date: Thu, 28 Jul 2011 09:22:59 -0400
Message-ID: <20110728092259.3717b890@barsoom.rdu.redhat.com>
References: <CAH2r5mtRqCQQiwSuzUv9tjGnmfb9jtqo0odZPrUYyGMBBPor6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtRqCQQiwSuzUv9tjGnmfb9jtqo0odZPrUYyGMBBPor6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Jul 2011 08:07:50 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Reviewed and merged
>       cifs: advertise the right receive buffer size to the server
>       cifs: trivial: goto out here is unnecessary
>       cifs: don't start signing too early
>       cifs: fix name parsing in CIFSSMBQAllEAs
> 
> am currently looking at the oplock refcounting patch, and Pavel's
> demultiplex simplification series, the on to the others.
> 
> -- 
> Thanks,
> 
> Steve

Thanks, If you're not going to take this patch that I sent back in
March, then I'd appreciate an official "NAK", preferably with the
reasoning, so I can stop carrying it in my tree:

    cifs: remove unneeded variable initialization in cifs_reconnect_tcon

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
