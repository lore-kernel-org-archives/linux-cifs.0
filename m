From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: manual merge of the workqueues tree with the cifs tree
Date: Fri, 23 Jul 2010 14:46:08 +1000
Message-ID: <20100723144608.435f7e40.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
fs/cifs/file.c between commit 7d4716ba25ecc032d83ec4fa231edfcef8e17b62
("cifs: FS-Cache page management") from the cifs tree and commit
9b646972467fb5fdc677f9e4251875db20bdbb64 ("cifs: use workqueue instead of
slow-work") from the workqueues tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

diff --cc fs/cifs/file.c
index fa04a00d,e767bfa..0000000
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@@ -2291,24 -2295,7 +2291,23 @@@ out
  	return rc;
  }
  
 +static int cifs_release_page(struct page *page, gfp_t gfp)
 +{
 +	if (PagePrivate(page))
 +		return 0;
 +
 +	return cifs_fscache_release_page(page, gfp);
 +}
 +
 +static void cifs_invalidate_page(struct page *page, unsigned long offset)
 +{
 +	struct cifsInodeInfo *cifsi = CIFS_I(page->mapping->host);
 +
 +	if (offset == 0)
 +		cifs_fscache_invalidate_page(page, &cifsi->vfs_inode);
 +}
 +
- static void
- cifs_oplock_break(struct slow_work *work)
+ void cifs_oplock_break(struct work_struct *work)
  {
  	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
  						  oplock_break);
