From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix df output for users with quota limits
Date: Wed, 23 Aug 2017 14:42:42 -0500
Message-ID: <CAH2r5mvzG5byf6VSGBtJhi+86gRWjZRbKxT7uQZ4z4Bs_YJtdg@mail.gmail.com>
References: <20170803073903.31575-1-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170803073903.31575-1-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next and added cc: stable

On Thu, Aug 3, 2017 at 2:39 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The df for a SMB2 share triggers a GetInfo call for
> FS_FULL_SIZE_INFORMATION. The values returned are used to populate
> struct statfs.
>
> The problem is that none of the information returned by the call
> contains the total blocks available on the filesystem. Instead we use
> the blocks available to the user ie. quota limitation when filling out
> statfs.f_blocks. The information returned does contain Actual free units
> on the filesystem and is used to populate statfs.f_bfree. For users with
> quota enabled, it can lead to situations where the total free space
> reported is more than the total blocks on the system ending up with df
> reports like the following
>
>  # df -h /mnt/a
> Filesystem         Size  Used Avail Use% Mounted on
> //192.168.22.10/a  2.5G -2.3G  2.5G    - /mnt/a
>
> To fix this problem, we instead populate both statfs.f_bfree with the
> same value as statfs.f_bavail ie. CallerAvailableAllocationUnits. This
> is similar to what is done already in the code for cifs and df now
> reports the quota information for the user used to mount the share.
>
>  # df --si /mnt/a
> Filesystem         Size  Used Avail Use% Mounted on
> //192.168.22.10/a  2.7G  101M  2.6G   4% /mnt/a
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pierguido Lambri <plambri-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5fb2fc2..97edb4d3 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3219,8 +3219,8 @@ copy_fs_info_to_kstatfs(struct smb2_fs_full_size_info *pfs_inf,
>         kst->f_bsize = le32_to_cpu(pfs_inf->BytesPerSector) *
>                           le32_to_cpu(pfs_inf->SectorsPerAllocationUnit);
>         kst->f_blocks = le64_to_cpu(pfs_inf->TotalAllocationUnits);
> -       kst->f_bfree  = le64_to_cpu(pfs_inf->ActualAvailableAllocationUnits);
> -       kst->f_bavail = le64_to_cpu(pfs_inf->CallerAvailableAllocationUnits);
> +       kst->f_bfree  = kst->f_bavail =
> +                       le64_to_cpu(pfs_inf->CallerAvailableAllocationUnits);
>         return;
>  }
>
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
