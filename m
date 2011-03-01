From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Use ecb des kernel crypto APIs instead of local
 cifs functions (repost)
Date: Tue, 1 Mar 2011 16:42:30 -0500
Message-ID: <20110301164230.7d41539e@tlielax.poochiereds.net>
References: <1298926301-30636-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298926301-30636-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 28 Feb 2011 14:51:41 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Using kernel crypto APIs for DES encryption during LM and NT hash generation
> instead of local functions within cifs.
> Source file smbdes.c is deleted sans four functions, one of which
> uses ecb des functionality provided by kernel crypto APIs.
> 
> Remove function SMBOWFencrypt.
> 
> Add return codes to various functions such as calc_lanman_hash,
> SMBencrypt, and SMBNTencrypt.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/Kconfig       |    1 +
>  fs/cifs/Makefile      |    2 +-
>  fs/cifs/cifsencrypt.c |   10 +-
>  fs/cifs/cifsproto.h   |    7 +-
>  fs/cifs/sess.c        |    2 +-
>  fs/cifs/smbdes.c      |  418 -------------------------------------------------
>  fs/cifs/smbencrypt.c  |  124 ++++++++++++---
>  7 files changed, 109 insertions(+), 455 deletions(-)
>  delete mode 100644 fs/cifs/smbdes.c
> 

Nice work. I'm almost always a fan of less code to maintain ;). That
said, I'm not terribly well versed in the intricacies of lanman auth so
I'll offer an Acked-by instead of a Reviewed-by:

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
