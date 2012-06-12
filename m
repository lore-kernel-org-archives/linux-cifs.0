From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] automake: revert -Werror by default
Date: Tue, 12 Jun 2012 21:22:28 +0530
Message-ID: <4FD765BC.1020309@suse.com>
References: <1339496358-27940-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339496358-27940-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/12/2012 03:49 PM, Jeff Layton wrote:
> I think in hindsight, that adding -Werror by default was a mistake.
> cifs-utils is built in a wide range of environments and tools, and it's
> very difficult to eliminate all of the possible warnings.
> 
> Let's go ahead and remove it and reduce the steady trickle of patches
> that are simply to silence obscure warnings.
> 
> Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  Makefile.am |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 05729ca..b412262 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,4 +1,4 @@
> -AM_CFLAGS = -Wall -Wextra -Werror -D_FORTIFY_SOURCE=2
> +AM_CFLAGS = -Wall -Wextra -D_FORTIFY_SOURCE=2
>  ACLOCAL_AMFLAGS = -I aclocal
>  

+ 1

Sounds like the right thing to do.

Acked-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
