From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: clarify the meaning of tcpStatus == CifsGood
Date: Wed, 9 Feb 2011 07:00:41 -0500
Message-ID: <20110209070041.5d0ca858@tlielax.poochiereds.net>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
	<1297086876-19165-3-git-send-email-jlayton@redhat.com>
	<AANLkTikiPgAbei+p2gnqOmuKdHnLpcYOshz7iqBotm1s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikiPgAbei+p2gnqOmuKdHnLpcYOshz7iqBotm1s-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 8 Feb 2011 17:50:33 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I discussed a simpler alternative with Jeff today.
> maxBuf is set by SMB Negotiate Protocol, and when
> reconnecting is reset to zero to indicate
> that Negotiate Protocol needs to be done, so it
> is a smaller patch to just check that
> (we could eliminate the tcpStatus == CifsGood check
> as well, but it is harmless and as it was tested/works
> I lean toward simply leaving that in, and adding
> the most trivial change).  See below:
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 257b6d8..10011e9 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -341,7 +341,7 @@ cifs_echo_request(struct work_struct *work)
>  	 * We cannot send an echo until the NEGOTIATE_PROTOCOL request is done.
>  	 * Also, no need to ping if we got a response recently
>  	 */
> -	if (server->tcpStatus != CifsGood ||
> +	if ((server->tcpStatus != CifsGood) || (server->maxBuf == 0) ||
>  	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
>  		goto requeue_echo;
> 

It's a reasonable fix that should work. I think we should remove the
check for tcpStatus != CifsGood since it's meaningless. I'd also like
to see the comment altered to mention why you're checking for
maxBuf == 0 as it's not at all obvious.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
