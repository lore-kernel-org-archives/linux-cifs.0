From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: add support for IPv6 addresses in brackets V2
Date: Mon, 22 Apr 2013 10:21:13 -0400
Message-ID: <CAFB9KM00JWSUSP28LrzJsgQ0po6ZtTpK9enbwv3-N5y2+E5G0A@mail.gmail.com>
References: <1365963558-20082-1-git-send-email-scott.lovenberg@gmail.com>
	<1366075789-23137-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366075789-23137-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Apr 15, 2013 at 9:29 PM, <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> This is a respin of the last patch that returns EX_USAGE rather than OPT_ERROR as per Jeff's suggestion.
>
> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  AUTHORS      |    1 +
>  mount.cifs.c |   62 ++++++++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 46 insertions(+), 17 deletions(-)
>
> diff --git a/AUTHORS b/AUTHORS
> index 2807079..081c2fe 100644
> --- a/AUTHORS
> +++ b/AUTHORS
> @@ -5,5 +5,6 @@ Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>  Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>  Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>  Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> +Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>  ...and others.
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 3b2b89e..561517b 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -751,6 +751,47 @@ static int parse_opt_token(const char *token)
>         return OPT_ERROR;
>  }
>
> +/*
> +  Extract an ipv4 or ipv6 address and put it into parsed_info.
> +  Returns 0 on success.
> +*/
> +static int parse_ip(char *value, struct parsed_mount_info *parsed_info)
> +{
> +       char *closingBracket = NULL;
> +
> +       if (!value || !*value) {
> +               fprintf(stderr, "target ip address argument missing\n");
> +               return EX_USAGE;
> +       }
> +
> +       /* check for ipv6 in brackets */
> +       if (value[0] == '[') {
> +               value++;
> +               /* temporarily null the closing bracket */
> +               closingBracket = strchr(value, ']');
> +               if (closingBracket)
> +                       *closingBracket = '\0';
> +       }
> +
> +       /* check length of address */
> +       if (strnlen(value, MAX_ADDRESS_LEN + 1) > MAX_ADDRESS_LEN) {
> +               fprintf(stderr, "ip address too long\n");
> +               if (closingBracket)
> +                       *closingBracket = ']';
> +               return EX_USAGE;
> +       }
> +
> +       strcpy(parsed_info->addrlist, value);
> +       if (parsed_info->verboseflag)
> +               fprintf(stderr, "ip address %s override specified\n", value);
> +
> +       /* put back closing bracket */
> +       if (closingBracket)
> +               *closingBracket = ']';
> +
> +       return 0;
> +}
> +
>  static int
>  parse_options(const char *data, struct parsed_mount_info *parsed_info)
>  {
> @@ -861,23 +902,10 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>                         break;
>
>                 case OPT_IP:
> -                       if (!value || !*value) {
> -                               fprintf(stderr,
> -                                       "target ip address argument missing\n");
> -                       } else if (strnlen(value, MAX_ADDRESS_LEN) <=
> -                               MAX_ADDRESS_LEN) {
> -                               strcpy(parsed_info->addrlist, value);
> -                               if (parsed_info->verboseflag)
> -                                       fprintf(stderr,
> -                                               "ip address %s override specified\n",
> -                                               value);
> -                               goto nocopy;
> -                       } else {
> -                               fprintf(stderr, "ip address too long\n");
> -                               return EX_USAGE;
> -
> -                       }
> -                       break;
> +                       rc = parse_ip(value, parsed_info);
> +                       if (rc)
> +                               return rc;
> +                       goto nocopy;
>
>                 /* unc || target || path */
>                 case OPT_UNC:
> --
> 1.7.10.4
>


Ping.
Any comments?

--
Peace and Blessings,
-Scott.
