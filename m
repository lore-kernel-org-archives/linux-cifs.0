From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: ceph, cifs, nfs, fuse: boolean and / or confusion
Date: Mon, 12 Dec 2011 15:28:56 -0800
Message-ID: <20111212152856.871a8301.akpm@linux-foundation.org>
References: <4EE688FC.8090606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EE688FC.8090606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 13 Dec 2011 00:06:36 +0100
roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> The test not SEEK_CUR or not SEEK_SET always evaluates to true
> 
> Signed-off-by: Roel Kluin <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/ceph/file.c   |    2 +-
>  fs/cifs/cifsfs.c |    2 +-
>  fs/fuse/file.c   |    2 +-
>  fs/nfs/file.c    |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index ce549d3..4d61a66 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -797,7 +797,7 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int origin)
>  
>  	mutex_lock(&inode->i_mutex);
>  	__ceph_do_pending_vmtruncate(inode);
> -	if (origin != SEEK_CUR || origin != SEEK_SET) {
> +	if (origin != SEEK_CUR && origin != SEEK_SET) {
>  		ret = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE);
>  		if (ret < 0) {
>  			offset = ret;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8f1fe32..f8351c2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -703,7 +703,7 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
>  	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
>  	 * the cached file length
>  	 */
> -	if (origin != SEEK_SET || origin != SEEK_CUR) {
> +	if (origin != SEEK_SET && origin != SEEK_CUR) {
>  		int rc;
>  		struct inode *inode = file->f_path.dentry->d_inode;
>  
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 594f07a..19029e9 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1556,7 +1556,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
>  	struct inode *inode = file->f_path.dentry->d_inode;
>  
>  	mutex_lock(&inode->i_mutex);
> -	if (origin != SEEK_CUR || origin != SEEK_SET) {
> +	if (origin != SEEK_CUR && origin != SEEK_SET) {
>  		retval = fuse_update_attributes(inode, NULL, file, NULL);
>  		if (retval)
>  			goto exit;
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index eca56d4..606ef0f 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -147,7 +147,7 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
>  	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
>  	 * the cached file length
>  	 */
> -	if (origin != SEEK_SET || origin != SEEK_CUR) {
> +	if (origin != SEEK_SET && origin != SEEK_CUR) {
>  		struct inode *inode = filp->f_mapping->host;
>  
>  		int retval = nfs_revalidate_file_size(inode, filp);

This fix will cause changed runtime behaviour, such as NFS no longer
running nfs_revalidate_file_size() for all seek modes.

So I think it should be reviewed, tested and merged by the various fs
maintainers.  Splitting it into four patches would help that process,
but they could independently treat it as a bug report, too.

Meanwhile, I'll put this in my tree so I can keep an eye on people ;)
