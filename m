From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove unnecessary getuid() check in libcap
 version of toggle_dac_capability
Date: Fri, 20 Apr 2012 11:47:49 -0400
Message-ID: <20120420114749.1a9618fd@corrin.poochiereds.net>
References: <1334863493-18978-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lmuelle-IBi9RG/b67k@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334863493-18978-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 19 Apr 2012 15:24:53 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> I'm not sure what I was thinking when I added that check in, but it's
> been there since the inception. We shouldn't care at all what the
> real uid is when we call toggle_dac_capability and indeed we don't
> care with the libcap-ng version. Remove that check.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 06715dd..c90ce3e 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -552,9 +552,6 @@ toggle_dac_capability(int writable, int enable)
>  	cap_t caps;
>  	cap_value_t capability = writable ? CAP_DAC_OVERRIDE : CAP_DAC_READ_SEARCH;
>  
> -	if (getuid() != 0)
> -		return 0;
> -
>  	caps = cap_get_proc();
>  	if (caps == NULL) {
>  		fprintf(stderr, "Unable to get current capability set: %s\n",

Merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
