From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: don't dereference smb_file_target before null check
Date: Thu, 1 Nov 2018 09:34:03 -0500
Message-ID: <CAH2r5mvCPzdmVMMLXY+87stsPXky-GKtJVRuUanyVsGriYKjWw@mail.gmail.com>
References: <20181101131430.28901-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101131430.28901-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next
On Thu, Nov 1, 2018 at 8:14 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a null check on dst_file->private data which suggests
> it can be potentially null. However, before this check, pointer
> smb_file_target is derived from dst_file->private and dereferenced
> in the call to tlink_tcon, hence there is a potential null pointer
> deference.
>
> Fix this by assigning smb_file_target and target_tcon after the
> null pointer sanity checks.
>
> Detected by CoverityScan, CID#1475302 ("Dereference before null check")
>
> Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/cifsfs.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index e46af70153c0..db83938809a5 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1003,8 +1003,8 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
>         struct inode *src_inode = file_inode(src_file);
>         struct inode *target_inode = file_inode(dst_file);
>         struct cifsFileInfo *smb_file_src = src_file->private_data;
> -       struct cifsFileInfo *smb_file_target = dst_file->private_data;
> -       struct cifs_tcon *target_tcon = tlink_tcon(smb_file_target->tlink);
> +       struct cifsFileInfo *smb_file_target;
> +       struct cifs_tcon *target_tcon;
>         unsigned int xid;
>         int rc;
>
> @@ -1021,6 +1021,9 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
>                 goto out;
>         }
>
> +       smb_file_target = dst_file->private_data;
> +       target_tcon = tlink_tcon(smb_file_target->tlink);
> +
>         /*
>          * Note: cifs case is easier than btrfs since server responsible for
>          * checks for proper open modes and file type and if it wants
> --
> 2.19.1
>


-- 
Thanks,

Steve
