From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/6] cifs: make error on lack of a unc= option more
 explicit
Date: Sun, 25 Nov 2012 20:07:04 -0500
Message-ID: <20121125200704.663ac10c@corrin.poochiereds.net>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
	<1353087414-32152-2-git-send-email-jlayton@redhat.com>
	<CAH2r5mtADZ6D3+1sOTKvZzVbzb4k6FTDGEoSEJFYHB_kT6HA3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org,
	almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtADZ6D3+1sOTKvZzVbzb4k6FTDGEoSEJFYHB_kT6HA3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 25 Nov 2012 15:30:18 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This looks fine but wondering if you plan to add support for mounting
> to DFS root (which was supposed to be the only reason for allowing ip=
> but not unc= to be specified)?
> 

I have no plans to do so in the near future, but don't let me stop you
from doing so if you choose...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
