From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: decrease log level of smb2 DFS error
Date: Tue, 21 Nov 2017 21:22:33 +1000
Message-ID: <CAN05THRymsFpZcbXsSQj6=OVd94ZWE1L5a1EQF5-bz8qbG=oFA@mail.gmail.com>
References: <20171121111429.14496-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121111429.14496-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since in 99.999999% times happens just because "it is a real share",
we could optionally change it instead to be wrapped in :

if (rc != <whatever STATUS_NOT_FOUND maps to>)
     cifs_dbg(VFS, log the error message

so that we do not log anything if it is just a normal share
but that we do log something if there is a real error.




On Tue, Nov 21, 2017 at 9:14 PM, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrote:
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 0dafdbae1f8c..59d18a7d550d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1387,7 +1387,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>         } while (rc == -EAGAIN);
>
>         if (rc) {
> -               cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
> +               cifs_dbg(FYI, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
>                 goto out;
>         }
>
> --
> 2.12.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
