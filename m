From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: Fix NULL pointer dereference of devname
Date: Sun, 3 Feb 2019 09:50:45 -0600
Message-ID: <CAH2r5mt05d3fPVk+PowKK-ktMT8=GiU+81qLeU=g9D6CCzBmKg@mail.gmail.com>
References: <1548676048-19626-1-git-send-email-yotta.liu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Yao Liu <yotta.liu@ucloud.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548676048-19626-1-git-send-email-yotta.liu@ucloud.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Jan 28, 2019 at 5:56 AM Yao Liu <yotta.liu@ucloud.cn> wrote:
>
> There is a NULL pointer dereference of devname in strspn()
>
> The oops looks something like:
>
>   CIFS: Attempting to mount (null)
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>   ...
>   RIP: 0010:strspn+0x0/0x50
>   ...
>   Call Trace:
>    ? cifs_parse_mount_options+0x222/0x1710 [cifs]
>    ? cifs_get_volume_info+0x2f/0x80 [cifs]
>    cifs_setup_volume_info+0x20/0x190 [cifs]
>    cifs_get_volume_info+0x50/0x80 [cifs]
>    cifs_smb3_do_mount+0x59/0x630 [cifs]
>    ? ida_alloc_range+0x34b/0x3d0
>    cifs_do_mount+0x11/0x20 [cifs]
>    mount_fs+0x52/0x170
>    vfs_kern_mount+0x6b/0x170
>    do_mount+0x216/0xdc0
>    ksys_mount+0x83/0xd0
>    __x64_sys_mount+0x25/0x30
>    do_syscall_64+0x65/0x220
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Fix this by adding a NULL check on devname in cifs_parse_devname()
>
> Signed-off-by: Yao Liu <yotta.liu@ucloud.cn>
> ---
>  fs/cifs/connect.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 683310f..39abb18 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1465,6 +1465,11 @@ static int cifs_parse_security_flavors(char *value,
>         const char *delims = "/\\";
>         size_t len;
>
> +       if (unlikely(!devname || !*devname)) {
> +               cifs_dbg(VFS, "Device name not specified.\n");
> +               return -EINVAL;
> +       }
> +
>         /* make sure we have a valid UNC double delimiter prefix */
>         len = strspn(devname, delims);
>         if (len != 2)
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
