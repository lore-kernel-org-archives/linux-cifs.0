From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Fix number parsing in cifs_parse_mount_options
Date: Fri, 13 Apr 2012 09:17:53 -0400
Message-ID: <20120413091753.60dccc93@tlielax.poochiereds.net>
References: <201204130712.51693.chris2553@googlemail.com>
	<1334322272.2308.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334322272.2308.1.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 13 Apr 2012 14:04:32 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> The function kstrtoul() used to parse number strings in the mount
> option parser is set to expect a base 10 number . This treats the octal
> numbers passed for mount options such as file_mode as base10 numbers
> leading to incorrect behavior.
> 
> Change the 'base' argument passed to kstrtoul from 10 to 0 to
> allow it to auto-detect the base of the number passed.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> 
> ---
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6a86f3d..f31dc9a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1123,7 +1123,7 @@ static int get_option_ul(substring_t args[], unsigned long *option)
>  	string = match_strdup(args);
>  	if (string == NULL)
>  		return -ENOMEM;
> -	rc = kstrtoul(string, 10, option);
> +	rc = kstrtoul(string, 0, option);
>  	kfree(string);
>  
>  	return rc;

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
