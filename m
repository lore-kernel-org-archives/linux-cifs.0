From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: fix spelling mistake, EACCESS -> EACCES
Date: Fri, 26 Oct 2018 13:50:54 -0500
Message-ID: <CAH2r5mtPEj04VutE44Dwdk+UtRM0PuT6_teMrOU44XCk3CirQA@mail.gmail.com>
References: <20181026180721.5040-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181026180721.5040-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next
On Fri, Oct 26, 2018 at 1:10 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Trivial fix to a spelling mistake of the error access name EACCESS,
> rename to EACCES
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/file.c  | 2 +-
>  fs/cifs/inode.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 84477e995246..6894d071850a 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1003,7 +1003,7 @@ cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
>   * Set the byte-range lock (mandatory style). Returns:
>   * 1) 0, if we set the lock and don't need to request to the server;
>   * 2) 1, if no locks prevent us but we need to request to the server;
> - * 3) -EACCESS, if there is a lock that prevents us and wait is false.
> + * 3) -EACCES, if there is a lock that prevents us and wait is false.
>   */
>  static int
>  cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 0945d40030eb..3685e2c25205 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1305,8 +1305,8 @@ cifs_drop_nlink(struct inode *inode)
>  /*
>   * If d_inode(dentry) is null (usually meaning the cached dentry
>   * is a negative dentry) then we would attempt a standard SMB delete, but
> - * if that fails we can not attempt the fall back mechanisms on EACCESS
> - * but will return the EACCESS to the caller. Note that the VFS does not call
> + * if that fails we can not attempt the fall back mechanisms on EACCES
> + * but will return the EACCES to the caller. Note that the VFS does not call
>   * unlink on negative dentries currently.
>   */
>  int cifs_unlink(struct inode *dir, struct dentry *dentry)
> --
> 2.19.1
>


-- 
Thanks,

Steve
