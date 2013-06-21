From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: using strlcpy instead of strncpy
Date: Fri, 21 Jun 2013 12:38:51 -0500
Message-ID: <CAH2r5mtVdwcWk0-sCsNk3nMQpUeB3_gQnQ2ZvUq6HO7AaOo4DQ@mail.gmail.com>
References: <51C2DFD6.5070202@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C2DFD6.5070202-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I actually prefer his change.   He potentially fixes a bug changing
these two of six places where it is used and the other four places
MAX_TREE_SIZE is used are clear enough either way.

On Thu, Jun 20, 2013 at 5:56 AM, Zhao Hongjiang
<zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> for NUL terminated string, need alway set '\0' in the end.
>
> Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |    2 +-
>  fs/cifs/smb2pdu.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index e3bc39b..2ea78a3 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3738,7 +3738,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>                 }
>                 bcc_ptr += length + 1;
>                 bytes_left -= (length + 1);
> -               strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
> +               strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
>
>                 /* mostly informational -- no need to fail on error here */
>                 kfree(tcon->nativeFileSystem);
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 2b95ce2..99bf768 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -792,7 +792,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>         tcon->tidStatus = CifsGood;
>         tcon->need_reconnect = false;
>         tcon->tid = rsp->hdr.TreeId;
> -       strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
> +       strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
>
>         if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
>             ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Thanks,

Steve
