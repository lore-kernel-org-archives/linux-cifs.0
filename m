From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/4] cifs: use the NUM_AUTHS and NUM_SUBAUTHS constants in
 cifsacl code
Date: Tue, 16 Oct 2012 09:19:58 -0500
Message-ID: <CADT32eKn-zKNDLjTpLXxVJLUDPfOSUSK+ukOQnh0XrEi6mrUrw@mail.gmail.com>
References: <1350386806-18356-1-git-send-email-jlayton@redhat.com>
	<1350386806-18356-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350386806-18356-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 16, 2012 at 6:26 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> ...instead of hardcoding in '5' and '6' all over the place.
>
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c | 6 +++---
>  fs/cifs/cifsacl.h | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index eddadcd..9819aa8 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -210,7 +210,7 @@ sid_to_str(struct cifs_sid *sidptr, char *sidstr)
>         sprintf(strptr, "-%d", sidptr->revision);
>         strptr = sidstr + strlen(sidstr);
>
> -       for (i = 0; i < 6; ++i) {
> +       for (i = 0; i < NUM_AUTHS; ++i) {
>                 if (sidptr->authority[i]) {
>                         sprintf(strptr, "-%d", sidptr->authority[i]);
>                         strptr = sidstr + strlen(sidstr);
> @@ -649,7 +649,7 @@ int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
>         }
>
>         /* compare all of the six auth values */
> -       for (i = 0; i < 6; ++i) {
> +       for (i = 0; i < NUM_AUTHS; ++i) {
>                 if (ctsid->authority[i] != cwsid->authority[i]) {
>                         if (ctsid->authority[i] > cwsid->authority[i])
>                                 return 1;
> @@ -811,7 +811,7 @@ static __u16 fill_ace_for_sid(struct cifs_ace *pntace,
>
>         pntace->sid.revision = psid->revision;
>         pntace->sid.num_subauth = psid->num_subauth;
> -       for (i = 0; i < 6; i++)
> +       for (i = 0; i < NUM_AUTHS; i++)
>                 pntace->sid.authority[i] = psid->authority[i];
>         for (i = 0; i < psid->num_subauth; i++)
>                 pntace->sid.sub_auth[i] = psid->sub_auth[i];
> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> index 5c902c7..80e0d66 100644
> --- a/fs/cifs/cifsacl.h
> +++ b/fs/cifs/cifsacl.h
> @@ -60,8 +60,8 @@ struct cifs_ntsd {
>  struct cifs_sid {
>         __u8 revision; /* revision level */
>         __u8 num_subauth;
> -       __u8 authority[6];
> -       __le32 sub_auth[5]; /* sub_auth[num_subauth] */
> +       __u8 authority[NUM_AUTHS];
> +       __le32 sub_auth[NUM_SUBAUTHS]; /* sub_auth[num_subauth] */
>  } __attribute__((packed));
>
>  struct cifs_acl {
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks correct.

Reviewed-by:  Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
