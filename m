From: Steve French <smfrench@gmail.com>
Subject: Re: [RFC PATCH cifs] smb3: smb3_fs_type can be static
Date: Thu, 24 May 2018 04:35:26 -0500
Message-ID: <CAH2r5mvUD80Yh57bv0oDvLGfUMipG6CSNN4gHBk_w=g2fyf8SQ@mail.gmail.com>
References: <201805241613.jA5dMoyL%fengguang.wu@intel.com> <20180524085336.GA120833@lkp-ib03>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <stfrench@microsoft.com>, kbuild-all@01.org,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524085336.GA120833@lkp-ib03>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

original patch already updated with the missing "static"

so shouldn't see this warning anymore (also cleaned up a few more warnings)

On Thu, May 24, 2018 at 3:53 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
>
> Fixes: 64a051adf591 ("smb3: add module alias for smb3 to cifs.ko")
> Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
> ---
>  cifsfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 645bb88..f0a68e9 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -900,7 +900,7 @@ struct file_system_type cifs_fs_type = {
>  };
>  MODULE_ALIAS_FS("cifs");
>
> -struct file_system_type smb3_fs_type = {
> +static struct file_system_type smb3_fs_type = {
>         .owner = THIS_MODULE,
>         .name = "smb3",
>         .mount = cifs_do_mount,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
