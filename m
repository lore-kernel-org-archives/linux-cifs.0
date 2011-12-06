From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
Date: Tue, 6 Dec 2011 22:33:50 +0100
Message-ID: <201112062233.50317.rjw@sisk.pl>
References: <4ED56C12.1040708@gmail.com> <4ED5C047.6040500@linux.vnet.ibm.com> <20111130062502.68d9db59@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Woody Suwalski <terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux PM mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Belisko Marek <marek.belisko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111130062502.68d9db59-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wednesday, November 30, 2011, Jeff Layton wrote:
> On Wed, 30 Nov 2011 11:03:59 +0530
> "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

[...]
> 
> cifs: attempt to freeze while looping on a receive attempt
> 
> In the recent overhaul of the demultiplex thread receive path, we
> neglected to ensure that we attempt to freeze on each pass through the
> loop.
> 
> Reported-by: Woody Suwalski <terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I suppose this patch is going to go through the CIFS tree?

Rafael


> ---
>  fs/cifs/connect.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index bf82f88..d166e3a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -441,6 +441,8 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
>  	smb_msg.msg_controllen = 0;
>  
>  	for (total_read = 0; to_read; total_read += length, to_read -= length) {
> +		try_to_freeze();
> +
>  		if (server_unresponsive(server)) {
>  			total_read = -EAGAIN;
>  			break;
> 
