From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [CIFS] Cleanup use of CONFIG_CIFS_STATS2 ifdef to make
 transport routines more readable
Date: Fri, 18 Mar 2011 14:41:11 -0400
Message-ID: <20110318144111.75b4fe9a@corrin.poochiereds.net>
References: <AANLkTim2bOYRB9i-RzqTt62=Z_SF9BWk-7d-7qr2g0_p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim2bOYRB9i-RzqTt62=Z_SF9BWk-7d-7qr2g0_p-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 17 Mar 2011 14:12:23 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Christoph had requested that the stats related code (in
> CONFIG_CIFS_STATS2) be moved into helpers to make code flow more
> readable.   This patch should help.   For example the following
> section from transport.c
> 
> 			spin_unlock(&GlobalMid_Lock);
> #ifdef CONFIG_CIFS_STATS2
> 			atomic_inc(&ses->server->num_waiters);
> #endif
> 			wait_event(ses->server->request_q,
> 				   atomic_read(&ses->server->inFlight)
> 				     < cifs_max_pending);
> #ifdef CONFIG_CIFS_STATS2
> 			atomic_dec(&ses->server->num_waiters);
> #endif
> 			spin_lock(&GlobalMid_Lock);
> 
> becomes simpler (with the patch below):
> 			spin_unlock(&GlobalMid_Lock);
> 			cifs_num_waiters_inc(server);
> 			wait_event(server->request_q,
> 				   atomic_read(&server->inFlight)
> 				     < cifs_max_pending);
> 			cifs_num_waiters_dec(server);
> 			spin_lock(&GlobalMid_Lock);
> 
> 
> 

Nice cleanup. Don't forget the SoB line though ;)

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
