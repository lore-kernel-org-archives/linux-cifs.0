From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][cifs-next] cifs: set oparms.create_options rather than
 or'ing in CREATE_OPEN_BACKUP_INTENT
Date: Wed, 5 Jul 2017 20:02:22 -0500
Message-ID: <CAH2r5mvDn+YnFiag3oeakjkBj3dnYxXPRrhN=p9NiDXrDY4nnQ@mail.gmail.com>
References: <20170705124734.12816-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        kernel-janitors <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705124734.12816-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

good catch - merged into cifs-2.6.git for-next

On Wed, Jul 5, 2017 at 7:47 AM, Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>
> Currently oparms.create_options is uninitialized and the code is logically
> or'ing in CREATE_OPEN_BACKUP_INTENT onto a garbage value of
> oparms.create_options from the stack.  Fix this by just setting the value
> rather than or'ing in the setting.
>
> Detected by CoverityScan, CID#1447220 ("Unitialized scale value")
>
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 941c40b7a870..c805b7619083 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1339,7 +1339,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
>         xid = get_xid();
>
>         if (backup_cred(cifs_sb))
> -               oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
> +               oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
>         else
>                 oparms.create_options = 0;
>
> --
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
