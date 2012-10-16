From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs: move num_subauth check inside of
 CONFIG_CIFS_DEBUG2 check in parse_sid()
Date: Tue, 16 Oct 2012 09:19:13 -0500
Message-ID: <CADT32eKhyS0iit3MHb+EirYFECsT0QG5aTvc0HKA8hZmKgcF5Q@mail.gmail.com>
References: <1350386806-18356-1-git-send-email-jlayton@redhat.com>
	<1350386806-18356-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350386806-18356-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 16, 2012 at 6:26 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index d0b2bfb..eddadcd 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -987,8 +987,8 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
>                 return -EINVAL;
>         }
>
> -       if (psid->num_subauth) {
>  #ifdef CONFIG_CIFS_DEBUG2
> +       if (psid->num_subauth) {
>                 int i;
>                 cFYI(1, "SID revision %d num_auth %d",
>                         psid->revision, psid->num_subauth);
> @@ -1002,8 +1002,8 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
>                         num auths and therefore go off the end */
>                 cFYI(1, "RID 0x%x",
>                         le32_to_cpu(psid->sub_auth[psid->num_subauth-1]));
> -#endif
>         }
> +#endif
>
>         return 0;
>  }
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks correct.

Reviewed-by:  Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
