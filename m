From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add MF-Symlinks support for SMB 2.0
Date: Tue, 12 Jul 2016 07:14:37 -0500
Message-ID: <CAH2r5mu0tLqhAhZ2Ke=VdzxGJ4WMmjzgVOVLLPtt5R6W_90S7w@mail.gmail.com>
References: <1468252400-6814-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468252400-6814-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Mon, Jul 11, 2016 at 10:53 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> We should be able to use the same helper functions used for SMB 2.1 and
> later versions.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 3525ed7..527d1ac 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1515,6 +1515,8 @@ struct smb_version_operations smb20_operations = {
>         .rename = smb2_rename_path,
>         .create_hardlink = smb2_create_hardlink,
>         .query_symlink = smb2_query_symlink,
> +       .query_mf_symlink = smb3_query_mf_symlink,
> +       .create_mf_symlink = smb3_create_mf_symlink,
>         .open = smb2_open_file,
>         .set_fid = smb2_set_fid,
>         .close = smb2_close_file,
> --
> 2.5.5
>



-- 
Thanks,

Steve
