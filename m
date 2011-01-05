From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] manpage: change port option description (try #2)
Date: Wed, 5 Jan 2011 07:24:38 -0500
Message-ID: <20110105072438.2aadf245@tlielax.poochiereds.net>
References: <1290105010-2915-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290105010-2915-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 18 Nov 2010 21:30:10 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Provide changes according to new ip/port connection logic in CIFS.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mount.cifs.8 |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 7d2bf69..bde0770 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -132,7 +132,7 @@ instructs the client to ignore any gid provided by the server for files and dire
>  .PP
>  port=\fIarg\fR
>  .RS 4
> -sets the port number on the server to attempt to contact to negotiate CIFS support\&. If the CIFS server is not listening on this port or if it is not specified, the default ports will be tried i\&.e\&. port 445 is tried and if no response then port 139 is tried\&.
> +sets the port number on which the client will attempt to contact the CIFS server\&. If this value is specified, look for an existing connection with this port, and use that if one exists\&. If one doesn't exist, try to create a new connection on that port\&. If that connection fails, return an error\&. If this value isn't specified, look for an existing connection on port 445 or 139\&. If no such connection exists, try to connect on port 445 first and then port 139 if that fails\&. Return an error if both fail\&.
>  .RE
>  .PP
>  servern=\fIarg\fR

Pushed to cifs-utils master branch. Should make 4.8.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
