From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: don't add dot and dotdot entry by default at
 the start of cifs_readdir
Date: Sun, 4 Jan 2015 00:25:44 -0600
Message-ID: <CADT32eLwaHC5VhGSgW=ftcRR09mJcEDEc3f9ypAeDszjRvASMQ@mail.gmail.com>
References: <001301d00884$cf8e0200$6eaa0600$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001301d00884$cf8e0200$6eaa0600$@samsung.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks reasonable.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Nov 25, 2014 at 1:52 AM, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> Currently, dot and dotdot are added by default at the start of cifs_readdir.
> This works well for the servers which send dot and dotdot entries at the start
> in readdir query response.
>
> For servers which do not send these two entries at the beginning,
> this behavior creates 2 problems.
> 1) adding dot and dotdot increments ctx->pos by 2 hence the valid
>    first 2 entries are missed in readdir output at client side.
> 2) Currently when we encounter dot or dotdot, the entry is simple skipped.
>
> In case of smb2, if some buggy server sends only 1 entry in response per
> cifs_query_dir_next request, and if that entry is happen to be dot OR dotdot,
> getdents call return 0 bytes to user app making it falsely believe that there
> are no more directory entries left.
>
> This patch tries to solve the above issues by processing dot and dotdot entries
> when they are encountered. This will have no effect on servers which already
> sends these 2 entries at the start.
>
> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  2 ++
>  fs/cifs/cifssmb.c  |  4 ++--
>  fs/cifs/readdir.c  | 43 ++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 42 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 6e13911..864ea1a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -987,6 +987,8 @@ struct cifs_search_info {
>         bool emptyDir:1;
>         bool unicode:1;
>         bool smallBuf:1; /* so we know which buf_release function to call */
> +       bool gotdot:1;
> +       bool gotdotdot:1;
>  };
>
>  struct cifs_open_parms {
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index fa13d5e..db49633 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4475,8 +4475,8 @@ findFirstRetry:
>
>                         psrch_inf->entries_in_buffer =
>                                         le16_to_cpu(parms->SearchCount);
> -                       psrch_inf->index_of_last_entry = 2 /* skip . and .. */ +
> -                               psrch_inf->entries_in_buffer;
> +                       psrch_inf->index_of_last_entry =
> +                                       psrch_inf->entries_in_buffer;
>                         lnoff = le16_to_cpu(parms->LastNameOffset);
>                         if (CIFSMaxBufSize < lnoff) {
>                                 cifs_dbg(VFS, "ignoring corrupt resume name\n");
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 8eaf20a..ab0639a 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -698,9 +698,26 @@ static int cifs_filldir(char *find_entry, struct file *file,
>                 return -EINVAL;
>         }
>
> -       /* skip . and .. since we added them first */
> -       if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
> +       if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode) == 1) {
> +               if (file_info->srch_inf.gotdot == true)
> +                       return -EINVAL;
> +               if (!dir_emit_dot(file, ctx)) {
> +                       cifs_dbg(VFS, "Filldir for current dir failed\n");
> +                       return -ENOMEM;
> +               }
> +               file_info->srch_inf.gotdot = true;
> +               return 0;
> +       }
> +       if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode) == 2) {
> +               if (file_info->srch_inf.gotdotdot == true)
> +                       return -EINVAL;
> +               if (!dir_emit_dotdot(file, ctx)) {
> +                       cifs_dbg(VFS, "Filldir for parent dir failed\n");
> +                       return -ENOMEM;
> +               }
> +               file_info->srch_inf.gotdotdot = true;
>                 return 0;
> +       }
>
>         if (file_info->srch_inf.unicode) {
>                 struct nls_table *nlt = cifs_sb->local_nls;
> @@ -786,9 +803,6 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                         goto rddir2_exit;
>         }
>
> -       if (!dir_emit_dots(file, ctx))
> -               goto rddir2_exit;
> -
>         /* 1) If search is active,
>                 is in current search buffer?
>                 if it before then restart search
> @@ -864,6 +878,25 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>         kfree(tmp_buf);
>
>  rddir2_exit:
> +       if (cifsFile->srch_inf.endOfSearch) {
> +               if (cifsFile->srch_inf.gotdot != true) {
> +                       if (!dir_emit_dot(file, ctx)) {
> +                               cifs_dbg(VFS,
> +                                       "Filldir for current dir failed\n");
> +                               rc = -ENOMEM;
> +                       }
> +                       ctx->pos++;
> +               }
> +
> +               if (cifsFile->srch_inf.gotdotdot != true) {
> +                       if (!dir_emit_dotdot(file, ctx)) {
> +                               cifs_dbg(VFS,
> +                                       "Filldir for parent dir failed\n");
> +                               rc = -ENOMEM;
> +                       }
> +                       ctx->pos++;
> +               }
> +       }
>         free_xid(xid);
>         return rc;
>  }
> --
> 1.7.11-rc0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
