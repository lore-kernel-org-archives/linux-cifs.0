From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: remove unneeded variable initialization in
 cifs_reconnect_tcon
Date: Tue, 5 Apr 2011 10:17:29 -0700
Message-ID: <20110405101729.27657db0@corrin.poochiereds.net>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
	<1301607405-4379-3-git-send-email-jlayton@redhat.com>
	<BANLkTin4Js462-nZcBcSYD6YO_1b9UEeRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTin4Js462-nZcBcSYD6YO_1b9UEeRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 5 Apr 2011 12:06:59 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This is fine, but what about this alternative (initializing variables
> can make code easier to read, and given dumb compiler warnings
> sometimes better to leave in variable initialization ...):
> 
> stevef@stevef-laptop:~/cifs-2.6$ git diff -a
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 92e33d4..e4993a2 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -117,7 +117,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
>          * calling routine
>          */
>         if (!tcon)
> -               return 0;
> +               return rc;
> 
>         ses = tcon->ses;
>         server = ses->server;
> 
> 

So instead of eliminating a useless variable initialization, we instead
manufacture a use for it? That seems sort of counter-productive, no?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
