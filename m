From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix IP address bounds checking on mount utility.
Date: Wed, 21 Nov 2012 15:16:18 -0500
Message-ID: <CAFB9KM1NDQB3HTVCKBjRu=N9nvfoY0YK-5TZN91PwqduD=KJZA@mail.gmail.com>
References: <1353528652-8912-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353528652-8912-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 21, 2012 at 3:10 PM, <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mount.cifs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index a9632b4..f63c309 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -941,8 +941,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>                         if (!value || !*value) {
>                                 fprintf(stderr,
>                                         "target ip address argument missing\n");
> -                       } else if (strnlen(value, MAX_ADDRESS_LEN) <=
> -                               MAX_ADDRESS_LEN) {
> +                       } else if (strnlen(value, MAX_ADDR_LIST_LEN + 1) <=
> +                               MAX_ADDR_LIST_LEN) {
>                                 strcpy(parsed_info->addrlist, value);
>                                 if (parsed_info->verboseflag)
>                                         fprintf(stderr,
> --
> 1.7.5.4
>

I still suck at git send-email.  The body of that should have read:
"In the mount utility use MAX_ADDR_LIST_LEN for bounds checking on ip
addresses instead of MAX_ADDRESS_LEN.  Parsed_mount_info->addrlist is
MAX_ADDR_LIST_LEN chars long."

--
Peace and Blessings,
-Scott.
