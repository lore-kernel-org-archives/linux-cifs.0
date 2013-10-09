From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][cifs-utils] getcifsacl: remove some dead code
Date: Wed, 9 Oct 2013 08:40:03 -0500
Message-ID: <CADT32e++ZuH5izh8doJXPwUw1bTmSRg3wnHW5P0UXM8t0az2cA@mail.gmail.com>
References: <1381324473-32474-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381324473-32474-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

That looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Oct 9, 2013 at 8:14 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Coverity says:
>
> Error: DEADCODE (CWE-561): [#def5]
> cifs-utils-6.2/getcifsacl.c:101: assignment: Assigning: "mflags" = "false".
> cifs-utils-6.2/getcifsacl.c:109: const: At condition "mflags", the value of "mflags" must be equal to 0.
> cifs-utils-6.2/getcifsacl.c:109: dead_error_condition: The condition "mflags" cannot be true.
> cifs-utils-6.2/getcifsacl.c:110: dead_error_line: Execution cannot reach this statement "printf("|");".
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  getcifsacl.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/getcifsacl.c b/getcifsacl.c
> index b8998ef..8a7f8ba 100644
> --- a/getcifsacl.c
> +++ b/getcifsacl.c
> @@ -106,10 +106,7 @@ print_ace_flags(uint8_t flags, int raw)
>         }
>
>         if (flags & OBJECT_INHERIT_FLAG) {
> -               if (mflags)
> -                       printf("|");
> -               else
> -                       mflags = true;
> +               mflags = true;
>                 printf("OI");
>         }
>         if (flags & CONTAINER_INHERIT_FLAG) {
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
