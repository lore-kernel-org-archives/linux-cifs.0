From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] cifs: make compare_sids static
Date: Tue, 16 Oct 2012 09:23:41 -0500
Message-ID: <CADT32eJ4ThoSST-ezgS6MNNrhOGnvhT4Nc_TQU2djacLacxJOA@mail.gmail.com>
References: <1350386806-18356-1-git-send-email-jlayton@redhat.com>
	<1350386806-18356-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350386806-18356-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 16, 2012 at 6:26 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> ..nothing outside of cifsacl.c calls it. Also fix the incorrect
> comment on the function. It returns 0 when they match.
>
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c | 98 ++++++++++++++++++++++++++++---------------------------
>  fs/cifs/cifsacl.h |  2 --
>  2 files changed, 50 insertions(+), 50 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 9819aa8..500bdfb 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -224,6 +224,56 @@ sid_to_str(struct cifs_sid *sidptr, char *sidstr)
>         }
>  }
>
> +/*
> + * if the two SIDs (roughly equivalent to a UUID for a user or group) are
> + * the same returns zero, if they do not match returns non-zero.
> + */
> +static int
> +compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
> +{
> +       int i;
> +       int num_subauth, num_sat, num_saw;
> +
> +       if ((!ctsid) || (!cwsid))
> +               return 1;
> +
> +       /* compare the revision */
> +       if (ctsid->revision != cwsid->revision) {
> +               if (ctsid->revision > cwsid->revision)
> +                       return 1;
> +               else
> +                       return -1;
> +       }
> +
> +       /* compare all of the six auth values */
> +       for (i = 0; i < NUM_AUTHS; ++i) {
> +               if (ctsid->authority[i] != cwsid->authority[i]) {
> +                       if (ctsid->authority[i] > cwsid->authority[i])
> +                               return 1;
> +                       else
> +                               return -1;
> +               }
> +       }
> +
> +       /* compare all of the subauth values if any */
> +       num_sat = ctsid->num_subauth;
> +       num_saw = cwsid->num_subauth;
> +       num_subauth = num_sat < num_saw ? num_sat : num_saw;
> +       if (num_subauth) {
> +               for (i = 0; i < num_subauth; ++i) {
> +                       if (ctsid->sub_auth[i] != cwsid->sub_auth[i]) {
> +                               if (le32_to_cpu(ctsid->sub_auth[i]) >
> +                                       le32_to_cpu(cwsid->sub_auth[i]))
> +                                       return 1;
> +                               else
> +                                       return -1;
> +                       }
> +               }
> +       }
> +
> +       return 0; /* sids compare/match */
> +}
> +
>  static void
>  cifs_copy_sid(struct cifs_sid *dst, const struct cifs_sid *src)
>  {
> @@ -630,54 +680,6 @@ cifs_destroy_idmaptrees(void)
>         spin_unlock(&gidsidlock);
>  }
>
> -/* if the two SIDs (roughly equivalent to a UUID for a user or group) are
> -   the same returns 1, if they do not match returns 0 */
> -int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
> -{
> -       int i;
> -       int num_subauth, num_sat, num_saw;
> -
> -       if ((!ctsid) || (!cwsid))
> -               return 1;
> -
> -       /* compare the revision */
> -       if (ctsid->revision != cwsid->revision) {
> -               if (ctsid->revision > cwsid->revision)
> -                       return 1;
> -               else
> -                       return -1;
> -       }
> -
> -       /* compare all of the six auth values */
> -       for (i = 0; i < NUM_AUTHS; ++i) {
> -               if (ctsid->authority[i] != cwsid->authority[i]) {
> -                       if (ctsid->authority[i] > cwsid->authority[i])
> -                               return 1;
> -                       else
> -                               return -1;
> -               }
> -       }
> -
> -       /* compare all of the subauth values if any */
> -       num_sat = ctsid->num_subauth;
> -       num_saw = cwsid->num_subauth;
> -       num_subauth = num_sat < num_saw ? num_sat : num_saw;
> -       if (num_subauth) {
> -               for (i = 0; i < num_subauth; ++i) {
> -                       if (ctsid->sub_auth[i] != cwsid->sub_auth[i]) {
> -                               if (le32_to_cpu(ctsid->sub_auth[i]) >
> -                                       le32_to_cpu(cwsid->sub_auth[i]))
> -                                       return 1;
> -                               else
> -                                       return -1;
> -                       }
> -               }
> -       }
> -
> -       return 0; /* sids compare/match */
> -}
> -
> -
>  /* copy ntsd, owner sid, and group sid from a security descriptor to another */
>  static void copy_sec_desc(const struct cifs_ntsd *pntsd,
>                                 struct cifs_ntsd *pnntsd, __u32 sidsoffset)
> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> index 80e0d66..18c7521 100644
> --- a/fs/cifs/cifsacl.h
> +++ b/fs/cifs/cifsacl.h
> @@ -98,6 +98,4 @@ extern struct key_type cifs_idmap_key_type;
>  extern const struct cred *root_cred;
>  #endif /* KERNEL */
>
> -extern int compare_sids(const struct cifs_sid *, const struct cifs_sid *);
> -
>  #endif /* _CIFSACL_H */
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks correct.

Reviewed-by:  Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
