From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Unset CIFS_MOUNT_POSIX_PATHS flag when following
 dfs mounts
Date: Mon, 29 Jun 2015 12:25:33 -0500
Message-ID: <CAH2r5mvQ_wx5fXL53jEFQxaiHXEoJO6LJBmZFRCsSrObD3t9OQ@mail.gmail.com>
References: <1434468977-25651-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434468977-25651-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

Let me know if any other patches that you want to review ASAP for merge=
 window.

On Tue, Jun 16, 2015 at 10:36 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> In a dfs setup where the client transitions from a server which suppo=
rts
> posix paths to a server which doesn't support posix paths, the flag
> CIFS_MOUNT_POSIX_PATHS is not reset. This leads to the wrong director=
y
> separator being used causing smb commands to fail.
>
> Consider the following case where a dfs share on a samba server point=
s
> to a share on windows smb server.
>  # mount -t cifs -o .. //vm140-31/dfsroot/testwin/
>  # ls -l /mnt; touch /mnt/a
>  total 0
>  touch: cannot touch =E2=80=98/mnt/a=E2=80=99: No such file or direct=
ory
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8383d5e..a59370b 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3461,6 +3461,8 @@ try_mount_again:
>                 else if (ses)
>                         cifs_put_smb_ses(ses);
>
> +               cifs_sb->mnt_cifs_flags &=3D ~CIFS_MOUNT_POSIX_PATHS;
> +
>                 free_xid(xid);
>         }
>  #endif
> --
> 2.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
