From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: guard against entries being deleted from open
 file list
Date: Mon, 18 Apr 2011 10:50:25 -0400
Message-ID: <20110418105025.2b62fa69@corrin.poochiereds.net>
References: <1303134275-12587-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303134275-12587-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Apr 2011 08:44:35 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> It is possible that a close can occur while a file is
> being reopened which can result in list entry deleted
> from the list and an oops.
> Use list_for_each_entry_safe instead.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/file.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index faf5952..aa29167 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1056,7 +1056,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
>  struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
>  					bool fsuid_only)
>  {
> -	struct cifsFileInfo *open_file;
> +	struct cifsFileInfo *open_file, *tmpf;
>  	struct cifs_sb_info *cifs_sb;
>  	bool any_available = false;
>  	int rc;
> @@ -1079,7 +1079,8 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
>  
>  	spin_lock(&cifs_file_list_lock);
>  refind_writable:
> -	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
> +	list_for_each_entry_safe(open_file, tmpf, &cifs_inode->openFileList,
> +									flist) {
>  		if (!any_available && open_file->pid != current->tgid)
>  			continue;
>  		if (fsuid_only && open_file->uid != current_fsuid())

I don't think this is a real fix for this problem, and may cause other
issues. list_for_each_entry_safe is only protects you when you are
iterating over a list (usually while holding a lock) and removing those
entries. The *_safe part makes it ok to remove the entry that you're
currently dealing with from the list.

Now, that can happen if you find an entry, do a cifsFileInfo_get, drop
the spinlock and then calling cifsFileInfo_put and putting the last
reference afterward. Here's the problem though -- once you drop the
spinlock, there's nothing that says that the next entry in the list is
necessarily still valid once you move to that entry.

What if the entry *after* the one that you're currently dealing with is
removed from the list while you're iterating over it? This patch will
cause an oops in that situation now when it didn't before. So, I think
this patch will probably just trade one set of problems for another.

I think the real fix is overhauling how all of the reopen_file stuff
works, but fixing it looks anything but straightforward.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
