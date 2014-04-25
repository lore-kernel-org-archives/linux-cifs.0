From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/4] cifs: fix potential races in cifs_revalidate_mapping
Date: Thu, 24 Apr 2014 22:48:47 -0500
Message-ID: <CAH2r5mtOfVvofBD3HC4YpS-0h=gBny2DgBwEKxPCP6-=A4jp3g@mail.gmail.com>
References: <1396288209-27328-1-git-send-email-jlayton@redhat.com> <1396288209-27328-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396288209-27328-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Various minor whitespace errors on this - do you want to respin it or
want me to fix it up?

On Mon, Mar 31, 2014 at 12:50 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The handling of the CIFS_INO_INVALID_MAPPING flag is racy. It's possible
> for two tasks to attempt to revalidate the mapping at the same time. The
> first sees that CIFS_INO_INVALID_MAPPING is set. It clears the flag and
> then calls invalidate_inode_pages2 to start shooting down the pagecache.
>
> While that's going on, another task checks the flag and sees that it's
> clear. It then ends up trusting the pagecache to satisfy a read when it
> shouldn't.
>
> Fix this by adding a bitlock to ensure that the clearing of the flag is
> atomic with respect to the actual cache invalidation. Also, move the
> other existing users of cifs_invalidate_mapping to use a new
> cifs_zap_mapping() function that just sets the INVALID_MAPPING bit and
> then uses the standard codepath to handle the invalidation.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.h   |  1 +
>  fs/cifs/cifsglob.h |  1 +
>  fs/cifs/file.c     | 12 ++++++------
>  fs/cifs/inode.c    | 50 +++++++++++++++++++++++++++++++++++++++++---------
>  4 files changed, 49 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 40d5a4df1e38..b7cf9ee7654b 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -68,6 +68,7 @@ extern int cifs_revalidate_file(struct file *filp);
>  extern int cifs_revalidate_dentry(struct dentry *);
>  extern int cifs_invalidate_mapping(struct inode *inode);
>  extern int cifs_revalidate_mapping(struct inode *inode);
> +extern int cifs_zap_mapping(struct inode *inode);
>  extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
>  extern int cifs_setattr(struct dentry *, struct iattr *);
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 0d4a1039ac27..84cd4447cc31 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1111,6 +1111,7 @@ struct cifsInodeInfo {
>         __u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
>         unsigned int oplock;            /* oplock/lease level we have */
>         unsigned int epoch;             /* used to track lease state changes */
> +#define CIFS_INO_LOCK                  (0)
>  #define CIFS_INO_DELETE_PENDING                (1)
>  #define CIFS_INO_INVALID_MAPPING       (2)
>         unsigned long flags;            /* flags field */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 784b17d510fc..ccca61803f0a 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -335,7 +335,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>         spin_unlock(&cifs_file_list_lock);
>
>         if (fid->purge_cache)
> -               cifs_invalidate_mapping(inode);
> +               cifs_zap_mapping(inode);
>
>         file->private_data = cfile;
>         return cfile;
> @@ -1529,7 +1529,7 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
>                  */
>                 if (!CIFS_CACHE_WRITE(CIFS_I(inode)) &&
>                                         CIFS_CACHE_READ(CIFS_I(inode))) {
> -                       cifs_invalidate_mapping(inode);
> +                       cifs_zap_mapping(inode);
>                         cifs_dbg(FYI, "Set no oplock for inode=%p due to mand locks\n",
>                                  inode);
>                         CIFS_I(inode)->oplock = 0;
> @@ -2218,7 +2218,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
>                  file->f_path.dentry->d_name.name, datasync);
>
>         if (!CIFS_CACHE_READ(CIFS_I(inode))) {
> -               rc = cifs_invalidate_mapping(inode);
> +               rc = cifs_zap_mapping(inode);
>                 if (rc) {
>                         cifs_dbg(FYI, "rc: %d during invalidate phase\n", rc);
>                         rc = 0; /* don't care about it in fsync */
> @@ -2628,7 +2628,7 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>                  * request comes - break it on the client to prevent reading
>                  * an old data.
>                  */
> -               cifs_invalidate_mapping(inode);
> +               cifs_zap_mapping(inode);
>                 cifs_dbg(FYI, "Set no oplock for inode=%p after a write operation\n",
>                          inode);
>                 cinode->oplock = 0;
> @@ -3125,7 +3125,7 @@ int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
>         xid = get_xid();
>
>         if (!CIFS_CACHE_READ(CIFS_I(inode))) {
> -               rc = cifs_invalidate_mapping(inode);
> +               rc = cifs_zap_mapping(inode);
>                 if (rc)
>                         return rc;
>         }
> @@ -3669,7 +3669,7 @@ void cifs_oplock_break(struct work_struct *work)
>                 if (!CIFS_CACHE_READ(cinode)) {
>                         rc = filemap_fdatawait(inode->i_mapping);
>                         mapping_set_error(inode->i_mapping, rc);
> -                       cifs_invalidate_mapping(inode);
> +                       cifs_zap_mapping(inode);
>                 }
>                 cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
>         }
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 39b76bac196d..b840930f6271 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -22,6 +22,7 @@
>  #include <linux/stat.h>
>  #include <linux/slab.h>
>  #include <linux/pagemap.h>
> +#include <linux/freezer.h>
>  #include <asm/div64.h>
>  #include "cifsfs.h"
>  #include "cifspdu.h"
> @@ -1762,29 +1763,60 @@ int
>  cifs_invalidate_mapping(struct inode *inode)
>  {
>         int rc = 0;
> -       struct cifsInodeInfo *cifs_i = CIFS_I(inode);
> -
> -       clear_bit(CIFS_INO_INVALID_MAPPING, &cifs_i->flags);
>
>         if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
>                 rc = invalidate_inode_pages2(inode->i_mapping);
> -               if (rc) {
> +               if (rc)
>                         cifs_dbg(VFS, "%s: could not invalidate inode %p\n",
>                                  __func__, inode);
> -                       set_bit(CIFS_INO_INVALID_MAPPING, &cifs_i->flags);
> -               }
>         }
>
>         cifs_fscache_reset_inode_cookie(inode);
>         return rc;
>  }
>
> +/**
> + * cifs_wait_bit_killable - helper for functions that are sleeping on bit locks
> + * @word: long word containing the bit lock
> + */
> +static int
> +cifs_wait_bit_killable(void *word)
> +{
> +       if (fatal_signal_pending(current))
> +               return -ERESTARTSYS;
> +       freezable_schedule_unsafe();
> +       return 0;
> +}
> +
>  int
>  cifs_revalidate_mapping(struct inode *inode)
>  {
> -       if (test_bit(CIFS_INODE_INVALID_MAPPING, &CIFS_I(inode)->flags));
> -               return cifs_invalidate_mapping(inode);
> -       return 0;
> +       int rc;
> +       unsigned long *flags = &CIFS_I(inode)->flags;
> +
> +       rc = wait_on_bit_lock(flags, CIFS_INO_LOCK, cifs_wait_bit_killable,
> +                               TASK_KILLABLE);
> +       if (rc)
> +               return rc;
> +
> +       if (test_and_clear_bit(CIFS_INO_INVALID_MAPPING, flags)) {
> +               rc = cifs_invalidate_mapping(inode);
> +               if (rc)
> +                       set_bit(CIFS_INO_INVALID_MAPPING, flags);
> +       }
> +
> +        clear_bit_unlock(CIFS_INO_LOCK, flags);
> +        smp_mb__after_clear_bit();
> +        wake_up_bit(flags, CIFS_INO_LOCK);
> +
> +       return rc;
> +}
> +
> +int
> +cifs_zap_mapping(struct inode *inode)
> +{
> +       set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags);
> +       return cifs_revalidate_mapping(inode);
>  }
>
>  int cifs_revalidate_file_attr(struct file *filp)
> --
> 1.9.0
>



-- 
Thanks,

Steve
