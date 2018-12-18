From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] cifs: check kzalloc return
Date: Tue, 18 Dec 2018 09:33:58 -0800
Message-ID: <4db484684a6e9b096c7fdf57673fd208d1c4005a.camel@perches.com>
References: <1545150439-26055-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>,
        Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545150439-26055-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 2018-12-18 at 17:27 +0100, Nicholas Mc Guire wrote:
> kzalloc can return NULL so a check is needed. While there is a
> check for ret_buf there is no check for the allocation of
> ret_buf->crfid.fid - this check is thus added. Both call-sites
> of tconInfoAlloc() check for NULL return of tconInfoAlloc()
> so returning NULL on failure of kzalloc() here seems appropriate.
> As the kzalloc() is the only thing here that can fail it is
> moved to the beginning so as not to initialize other resources
> on failure of kzalloc.
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
> ---
> 
> Problem located with an experimental coccinelle script
> 
> While at it make checkpatch happy by using *ret_buf->crfid.fid
> rather than struct cifs_fid.
> 
> Patch was compile tested with: x86_64_defconfig + CIFS=m
> (with some unrelated smatch warnings and some pending cocci fixes)
> 
> Patch is against v4.20-rc7 (localversion-next is next-20181218)
[]
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
[]
> @@ -113,6 +113,13 @@ tconInfoAlloc(void)
>  	struct cifs_tcon *ret_buf;
>  	ret_buf = kzalloc(sizeof(struct cifs_tcon), GFP_KERNEL);
>  	if (ret_buf) {
> +		ret_buf->crfid.fid = kzalloc(sizeof(*ret_buf->crfid.fid),
> +					     GFP_KERNEL);
> +		if (!ret_buf->crfid.fid) {
> +			kfree(ret_buf);
> +			return NULL;
> +		}
> +
>  		atomic_inc(&tconInfoAllocCount);
>  		ret_buf->tidStatus = CifsNew;
>  		++ret_buf->tc_count;
> @@ -120,8 +127,6 @@ tconInfoAlloc(void)
>  		INIT_LIST_HEAD(&ret_buf->tcon_list);
>  		spin_lock_init(&ret_buf->open_file_lock);
>  		mutex_init(&ret_buf->crfid.fid_mutex);
> -		ret_buf->crfid.fid = kzalloc(sizeof(struct cifs_fid),
> -					     GFP_KERNEL);
>  		spin_lock_init(&ret_buf->stat_lock);
>  		atomic_set(&ret_buf->num_local_opens, 0);
>  		atomic_set(&ret_buf->num_remote_opens, 0);

Perhaps use a more common style by returning early on the
first possible failure too so the block can be unindented.

Maybe as a separate cleanup patch.
---
 fs/cifs/misc.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 113980dba4d8..bee203055b30 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -111,21 +111,27 @@ struct cifs_tcon *
 tconInfoAlloc(void)
 {
 	struct cifs_tcon *ret_buf;
-	ret_buf = kzalloc(sizeof(struct cifs_tcon), GFP_KERNEL);
-	if (ret_buf) {
-		atomic_inc(&tconInfoAllocCount);
-		ret_buf->tidStatus = CifsNew;
-		++ret_buf->tc_count;
-		INIT_LIST_HEAD(&ret_buf->openFileList);
-		INIT_LIST_HEAD(&ret_buf->tcon_list);
-		spin_lock_init(&ret_buf->open_file_lock);
-		mutex_init(&ret_buf->crfid.fid_mutex);
-		ret_buf->crfid.fid = kzalloc(sizeof(struct cifs_fid),
-					     GFP_KERNEL);
-		spin_lock_init(&ret_buf->stat_lock);
-		atomic_set(&ret_buf->num_local_opens, 0);
-		atomic_set(&ret_buf->num_remote_opens, 0);
+
+	ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
+	if (!ret_buf)
+		return NULL;
+	ret_buf->crfid.fid = kzalloc(sizeof(*ret_buf->crfid.fid), GFP_KERNEL);
+	if (!ret_buf->crfid.fid) {
+		kfree(ret_buf);
+		return NULL;
 	}
+
+	atomic_inc(&tconInfoAllocCount);
+	ret_buf->tidStatus = CifsNew;
+	++ret_buf->tc_count;
+	INIT_LIST_HEAD(&ret_buf->openFileList);
+	INIT_LIST_HEAD(&ret_buf->tcon_list);
+	spin_lock_init(&ret_buf->open_file_lock);
+	mutex_init(&ret_buf->crfid.fid_mutex);
+	spin_lock_init(&ret_buf->stat_lock);
+	atomic_set(&ret_buf->num_local_opens, 0);
+	atomic_set(&ret_buf->num_remote_opens, 0);
+
 	return ret_buf;
 }
 
