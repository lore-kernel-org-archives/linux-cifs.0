From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix off-by-one bug in build_unc_path_to_root
Date: Fri, 31 May 2013 16:47:27 -0500
Message-ID: <CAH2r5msVR5ZtvJXkHy79JBguccfMGyLvyw-FKv9fNmP2b3g9Sw@mail.gmail.com>
References: <1370008818-9427-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcus.moeller-OI3hZJvNYWs@public.gmane.org,
	ken.fallon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370008818-9427-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-3.10 (and also in for-3.11 tree)

(also updated for 3.11 and equivalently for-next with another patch
"cifs: remove the cifs_ses->flags field" and continuing to work
through your large auth update patch series)

On Fri, May 31, 2013 at 9:00 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> commit 839db3d10a (cifs: fix up handling of prefixpath= option) changed
> the code such that the vol->prepath no longer contained a leading
> delimiter and then fixed up the places that accessed that field to
> account for that change.
>
> One spot in build_unc_path_to_root was missed however. When doing the
> pointer addition on pos, that patch failed to account for the fact that
> we had already incremented "pos" by one when adding the length of the
> prepath. This caused a buffer overrun by one byte.
>
> This patch fixes the problem by correcting the handling of "pos".
>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.8+
> Reported-by: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>
> Reported-by: Ken Fallon <ken.fallon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5b97e56..e3bc39b 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3279,8 +3279,8 @@ build_unc_path_to_root(const struct smb_vol *vol,
>         pos = full_path + unc_len;
>
>         if (pplen) {
> -               *pos++ = CIFS_DIR_SEP(cifs_sb);
> -               strncpy(pos, vol->prepath, pplen);
> +               *pos = CIFS_DIR_SEP(cifs_sb);
> +               strncpy(pos + 1, vol->prepath, pplen);
>                 pos += pplen;
>         }
>
> --
> 1.8.1.4
>



-- 
Thanks,

Steve
