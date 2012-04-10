From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.4.0-rc2+ - CIFS mount failure
Date: Tue, 10 Apr 2012 14:28:36 +0100
Message-ID: <1334064516.2149.9.camel@localhost>
References: <201204100823.24207.chris2553@googlemail.com>
	 <1334050772.2149.4.camel@localhost>
	 <20120410071630.567d70cb@tlielax.poochiereds.net>
	 <201204101413.27748.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201204101413.27748.chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


> Signed-off-by: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> 
> --- linux/fs/cifs/connect.c~    2012-04-10 11:38:23.000000000 +0100
> +++ linux/fs/cifs/connect.c     2012-04-10 12:16:02.000000000 +0100
> @@ -110,6 +110,9 @@ enum {
>         /* Options which could be blank */
>         Opt_blank_pass,
> 
> +       /* Usernames which could be blank */
> +       Opt_blank_user,
> +
>         Opt_err
>  };
> 
> @@ -183,6 +186,7 @@ static const match_table_t cifs_mount_op
>         { Opt_wsize, "wsize=%s" },
>         { Opt_actimeo, "actimeo=%s" },
> 
> +       { Opt_blank_user, "user=" },
>         { Opt_user, "user=%s" },
>         { Opt_user, "username=%s" },
>         { Opt_blank_pass, "pass=" },
> @@ -1534,6 +1538,10 @@ cifs_parse_mount_options(const char *mou
> 
>                 /* String Arguments */
> 
> +               case Opt_blank_user:
> +                       vol->username = NULL;
> +                       vol->nullauth = 1;
> +                       break;
>                 case Opt_user:
>                         string = match_strdup(args);
>                         if (string == NULL)
> 

Hello Chris,

The approach is correct. However I was looking to fix up all such
instances where a NULL mount option could be passed.  

There are a number of cases where a check for a NULL string is made. The
token parser however will never match mount options where a NULL is
passed so these checks for NULL strings are redundant. I plan on
cleaning these up too with the new patch.

Sachin Prabhu
