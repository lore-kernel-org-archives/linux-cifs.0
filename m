From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: set rc to 0 in libcap toggle_dac_capability
Date: Thu, 14 Jun 2012 11:00:13 -0400
Message-ID: <20120614110013.13afa373@corrin.poochiereds.net>
References: <1339495950-27793-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roderburg-31N1O1AsgN5n68oJJulU0Q@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339495950-27793-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 12 Jun 2012 06:12:30 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Thus spake Jochen:
> 
> The mount.cifs program from the cifs-utils package 5.5 did not work on
> my Linux system. It just exited without an error message and did not
> mount anything.
> 
> [...]
> 
> I think, when this variable rc is now used in this function, it has also
> to be properly initialized there.
> 
> Reported-by: Jochen Roderburg <roderburg-31N1O1AsgN5n68oJJulU0Q@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index a1b0454..6f3f382 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -495,7 +495,7 @@ free_caps:
>  static int
>  toggle_dac_capability(int writable, int enable)
>  {
> -	int rc;
> +	int rc = 0;
>  	cap_t caps;
>  	cap_value_t capability = writable ? CAP_DAC_OVERRIDE : CAP_DAC_READ_SEARCH;
>  

Merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
