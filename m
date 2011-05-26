From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs.upcall: don't syslog usage message
Date: Thu, 26 May 2011 14:39:29 -0400
Message-ID: <20110526143929.1b6a826c@tlielax.poochiereds.net>
References: <1306263194-28647-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306263194-28647-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 May 2011 14:53:14 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  cifs.upcall.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 479517c..de92092 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -749,7 +749,6 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
>  
>  static void usage(void)
>  {
> -	syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_serial", prog);
>  	fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", prog);
>  }
>  

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
