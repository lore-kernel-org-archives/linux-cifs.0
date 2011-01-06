From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 11/18] cifs: handle cancelled requests better
Date: Thu, 06 Jan 2011 12:39:15 +0530
Message-ID: <4D256A9B.90506@suse.de>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com> <1293417006-6417-12-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-12-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/27/2010 07:59 AM, Jeff Layton wrote:
> Currently, when a request is cancelled via signal, we delete the mid
> immediately. If the request was already transmitted however, the client
> is still likely to receive a response. When it does, it won't recognize
> it however and will pop a printk.
> 
> It's also a little dangerous to just delete the mid entry like this. We
> may end up reusing that mid. If we do then we could potentially get the
> response from the first request confused with the later one.
> 
> Prevent the reuse of mids by marking them as cancelled and keeping them
> on the pending_mid_q list. If the reply comes in, we'll delete it from
> the list then. If it never comes, then we'll delete it at reconnect
> or when cifsd comes down.
> 
> Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/transport.c |   43 ++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 36 insertions(+), 7 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
