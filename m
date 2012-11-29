From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFQ PATCH] cifs: Change default security error message
Date: Thu, 29 Nov 2012 13:25:09 -0500
Message-ID: <20121129132509.211c4977@corrin.poochiereds.net>
References: <20121129173053.GQ27196@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121129173053.GQ27196-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 29 Nov 2012 18:30:53 +0100
Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org> wrote:

> Hi!
> 
> Connecting with a default security mechanism prompts an KERN_ERROR
> output warning to the user that the default mechanism will be changed
> in Linux 3.3.
> 
> We're now at 3.7, so we either could remove the warning completely
> (if the default has been changed), or we could bump the number to
> what our current target for the change is.
> 
> 
> The below patch changes the cERROR (which turns into a printk with KERN_ERROR)
> into a straight printk with KERN_WARNING and changes the text to indicate
> that it was changed in 3.3.
> 
> I expect that the patch is incorrect and that we should choose
> another of the alternative solutions above, but I'd like to get
> some input on this.
> 
> Not-Signed-off-by: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
> ---
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c83f5b65..968456f 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2480,9 +2480,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>  	supported for many years, time to update default security mechanism */
>  	if ((volume_info->secFlg == 0) && warned_on_ntlm == false) {
>  		warned_on_ntlm = true;
> -		cERROR(1, "default security mechanism requested.  The default "
> -			"security mechanism will be upgraded from ntlm to "
> -			"ntlmv2 in kernel release 3.3");
> +		printk(KERN_WARNING "default security mechanism requested.  "
> +			"The default security mechanism was changed "
> +			" from ntlm to ntlmv2 in kernel release 3.3");
>  	}
>  	ses->overrideSecFlg = volume_info->secFlg;
>  
> 
> 
> /^JN - Jesper Nilsson

I think this warning has lived long enough and needs to go away. Steve
supposedly has a patch that finally makes this change, but it hasn't
been sent to the list yet... Steve?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
