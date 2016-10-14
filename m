From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] Add new mount option to set owner uid and gid from
 special sids in acl
Date: Fri, 14 Oct 2016 12:09:40 -0700
Message-ID: <CAKywueRCGEn35ttc5z-5cJ_jVBd1a93HDzDwc35RbWt3pkETzw@mail.gmail.com>
References: <1476457807-22055-1-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476457807-22055-1-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-10-14 8:10 GMT-07:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Add "idsfromsid" mount option to indicate to cifs.ko that it should
> try to retrieve the uid and gid owner fields from special sids in the
> ACL if present.  This first patch just adds the parsing for the mount
> option.
>
> Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> Reviewed-by:  Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifs_fs_sb.h | 1 +
>  fs/cifs/cifsfs.c     | 2 ++
>  fs/cifs/cifsglob.h   | 1 +
>  fs/cifs/connect.c    | 8 +++++++-
>  4 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 1418daa..07ed81c 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -49,6 +49,7 @@
>  #define CIFS_MOUNT_USE_PREFIX_PATH 0x1000000 /* make subpath with unaccessible
>                                               * root mountable
>                                               */
> +#define CIFS_MOUNT_UID_FROM_ACL 0x2000000 /* try to get UID via special SID */
>
>  struct cifs_sb_info {
>         struct rb_root tlink_tree;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f963c88..15261ba 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -469,6 +469,8 @@ static void cifs_i_callback(struct rcu_head *head)
>                 seq_puts(s, ",posixpaths");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)
>                 seq_puts(s, ",setuids");
> +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
> +               seq_puts(s, ",idsfromsid");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
>                 seq_puts(s, ",serverino");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 0c828d3..1f17f6b 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -478,6 +478,7 @@ struct smb_vol {
>         bool retry:1;
>         bool intr:1;
>         bool setuids:1;
> +       bool setuidfromacl:1;
>         bool override_uid:1;
>         bool override_gid:1;
>         bool dynperm:1;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 657369d..aab5227 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -75,7 +75,7 @@ enum {
>         Opt_noposixpaths, Opt_nounix,
>         Opt_nocase,
>         Opt_brl, Opt_nobrl,
> -       Opt_forcemandatorylock, Opt_setuids,
> +       Opt_forcemandatorylock, Opt_setuidfromacl, Opt_setuids,
>         Opt_nosetuids, Opt_dynperm, Opt_nodynperm,
>         Opt_nohard, Opt_nosoft,
>         Opt_nointr, Opt_intr,
> @@ -147,6 +147,7 @@ enum {
>         { Opt_forcemandatorylock, "forcemand" },
>         { Opt_setuids, "setuids" },
>         { Opt_nosetuids, "nosetuids" },
> +       { Opt_setuidfromacl, "idsfromsid" },
>         { Opt_dynperm, "dynperm" },
>         { Opt_nodynperm, "nodynperm" },
>         { Opt_nohard, "nohard" },
> @@ -1376,6 +1377,9 @@ static int cifs_parse_security_flavors(char *value,
>                 case Opt_nosetuids:
>                         vol->setuids = 0;
>                         break;
> +               case Opt_setuidfromacl:
> +                       vol->setuidfromacl = 1;
> +                       break;
>                 case Opt_dynperm:
>                         vol->dynperm = true;
>                         break;
> @@ -3279,6 +3283,8 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
>         if (pvolume_info->setuids)
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SET_UID;
> +       if (pvolume_info->setuidfromacl)
> +               cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UID_FROM_ACL;
>         if (pvolume_info->server_ino)
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SERVER_INUM;
>         if (pvolume_info->remap)
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky
