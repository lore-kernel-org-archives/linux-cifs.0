From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC][PATCH 02/10] cifs: guard cifsglob.h against multiple
 inclusion
Date: Tue, 22 Jun 2010 17:37:42 -0400
Message-ID: <20100622173742.448e1e94@corrin.poochiereds.net>
References: <yes>
	<1277220170-3442-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277220170-3442-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 22 Jun 2010 20:52:50 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> Add conditional compile macros to guard the header file against multiple
> inclusion.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a88479c..6b2c39d 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -16,6 +16,9 @@
>   *   the GNU Lesser General Public License for more details.
>   *
>   */
> +#ifndef _CIFS_GLOB_H
> +#define _CIFS_GLOB_H
> +
>  #include <linux/in.h>
>  #include <linux/in6.h>
>  #include <linux/slab.h>
> @@ -733,3 +736,5 @@ GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
>  GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
>  
>  extern const struct slow_work_ops cifs_oplock_break_ops;
> +
> +#endif	/* _CIFS_GLOB_H */

Strong ACK

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
