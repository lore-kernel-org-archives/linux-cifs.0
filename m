From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use sensible file nlink values if unprovided
Date: Thu, 4 Jul 2013 14:43:23 -0500
Message-ID: <CAH2r5mtyaufgrOssd872OZzq32TQ8fyprE82aK8FV7MbxceU7g@mail.gmail.com>
References: <1372961186-19213-1-git-send-email-ddiss@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372961186-19213-1-git-send-email-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I merged an equivalent but slightly smaller version of your patch into
cifs-2.6.git (see below) and added stable since we should not be
returning nlink of 0.  Let me know if any objections.

[CIFS] use sensible file nlink values if unprovided

    Certain servers may not set the NumberOfLinks field in query file/path
    info responses. In such a case, cifs_inode_needs_reval() assumes that
    all regular files are hardlinks and triggers revalidation, leading to
    excessive and unnecessary network traffic.

    This change hardcodes cf_nlink (and subsequently i_nlink) when not
    returned by the server, similar to what already occurs in cifs_mkdir().

    Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
    Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 20efd81..449b6cf 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -558,6 +558,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr,
FILE_ALL_INFO *info,
                        fattr->cf_mode &= ~(S_IWUGO);

                fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
+               if (fattr->cf_nlink < 1) {
+                       cifs_dbg(1, "replacing bogus file nlink value %u\n",
+                               fattr->cf_nlink);
+                       fattr->cf_nlink = 1;
+               }
        }

        fattr->cf_uid = cifs_sb->mnt_uid;


On Thu, Jul 4, 2013 at 1:06 PM, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote:
> Certain servers may not set the NumberOfLinks field in query file/path
> info responses. In such a case, cifs_inode_needs_reval() assumes that
> all regular files are hardlinks and triggers revalidation, leading to
> excessive and unnecessary network traffic.
>
> This change hardcodes cf_nlink (and subsequently i_nlink) when not
> returned by the server, similar to what already occurs in cifs_mkdir().
>
> Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/inode.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 6f37228..8c48027 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -532,6 +532,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>         fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
>         fattr->cf_createtime = le64_to_cpu(info->CreationTime);
>
> +       fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
> +
>         if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>                 fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
>                 fattr->cf_dtype = DT_DIR;
> @@ -542,9 +544,13 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>                 /* clear write bits if ATTR_READONLY is set */
>                 if (fattr->cf_cifsattrs & ATTR_READONLY)
>                         fattr->cf_mode &= ~(S_IWUGO);
> -       }
>
> -       fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
> +               if (fattr->cf_nlink < 1) {
> +                       cFYI(1, "replacing bogus file nlink value %u",
> +                               fattr->cf_nlink);
> +                       fattr->cf_nlink = 1;
> +               }
> +       }
>
>         fattr->cf_uid = cifs_sb->mnt_uid;
>         fattr->cf_gid = cifs_sb->mnt_gid;
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
