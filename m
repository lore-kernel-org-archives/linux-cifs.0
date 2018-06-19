From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] cifs: use 64-bit timestamps for fscache
Date: Tue, 19 Jun 2018 17:27:59 +0200
Message-ID: <20180619153255.3634720-2-arnd@arndb.de>
References: <20180619153255.3634720-1-arnd@arndb.de>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        David Howells <dhowells@redhat.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619153255.3634720-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

In the fscache, we just need the timestamps as cookies to check for
changes, so we don't really care about the overflow, but it's better
to stop using the deprecated timespec so we don't have to go through
explicit conversion functions.

To avoid comparing uninitialized padding values that are copied
while assigning the timespec values, this rearranges the members of
cifs_fscache_inode_auxdata to avoid padding, and assigns them
individually.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cifs/cache.c   |  6 ++++--
 fs/cifs/fscache.c | 12 ++++++++----
 fs/cifs/fscache.h |  8 +++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
index e1553d1e0e50..b7420e605b28 100644
--- a/fs/cifs/cache.c
+++ b/fs/cifs/cache.c
@@ -128,8 +128,10 @@ fscache_checkaux cifs_fscache_inode_check_aux(void *cookie_netfs_data,
 
 	memset(&auxdata, 0, sizeof(auxdata));
 	auxdata.eof = cifsi->server_eof;
-	auxdata.last_write_time = timespec64_to_timespec(cifsi->vfs_inode.i_mtime);
-	auxdata.last_change_time = timespec64_to_timespec(cifsi->vfs_inode.i_ctime);
+	auxdata.last_write_time_sec = cifsi->vfs_inode.i_mtime.tv_sec;
+	auxdata.last_change_time_sec = cifsi->vfs_inode.i_ctime.tv_sec;
+	auxdata.last_write_time_nsec = cifsi->vfs_inode.i_mtime.tv_nsec;
+	auxdata.last_change_time_nsec = cifsi->vfs_inode.i_ctime.tv_nsec;
 
 	if (memcmp(data, &auxdata, datalen) != 0)
 		return FSCACHE_CHECKAUX_OBSOLETE;
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 85145a763021..ea6ace9c2417 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -129,8 +129,10 @@ static void cifs_fscache_acquire_inode_cookie(struct cifsInodeInfo *cifsi,
 
 	memset(&auxdata, 0, sizeof(auxdata));
 	auxdata.eof = cifsi->server_eof;
-	auxdata.last_write_time = timespec64_to_timespec(cifsi->vfs_inode.i_mtime);
-	auxdata.last_change_time = timespec64_to_timespec(cifsi->vfs_inode.i_ctime);
+	auxdata.last_write_time_sec = cifsi->vfs_inode.i_mtime.tv_sec;
+	auxdata.last_change_time_sec = cifsi->vfs_inode.i_ctime.tv_sec;
+	auxdata.last_write_time_nsec = cifsi->vfs_inode.i_mtime.tv_nsec;
+	auxdata.last_change_time_nsec = cifsi->vfs_inode.i_ctime.tv_nsec;
 
 	cifsi->fscache =
 		fscache_acquire_cookie(tcon->fscache,
@@ -166,8 +168,10 @@ void cifs_fscache_release_inode_cookie(struct inode *inode)
 	if (cifsi->fscache) {
 		memset(&auxdata, 0, sizeof(auxdata));
 		auxdata.eof = cifsi->server_eof;
-		auxdata.last_write_time = timespec64_to_timespec(cifsi->vfs_inode.i_mtime);
-		auxdata.last_change_time = timespec64_to_timespec(cifsi->vfs_inode.i_ctime);
+		auxdata.last_write_time_sec = cifsi->vfs_inode.i_mtime.tv_sec;
+		auxdata.last_change_time_sec = cifsi->vfs_inode.i_ctime.tv_sec;
+		auxdata.last_write_time_nsec = cifsi->vfs_inode.i_mtime.tv_nsec;
+		auxdata.last_change_time_nsec = cifsi->vfs_inode.i_ctime.tv_nsec;
 
 		cifs_dbg(FYI, "%s: (0x%p)\n", __func__, cifsi->fscache);
 		fscache_relinquish_cookie(cifsi->fscache, &auxdata, false);
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index c7e3ac251e16..8c0862e41306 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -31,9 +31,11 @@
  * Auxiliary data attached to CIFS inode within the cache
  */
 struct cifs_fscache_inode_auxdata {
-	struct timespec	last_write_time;
-	struct timespec	last_change_time;
-	u64		eof;
+	u64 last_write_time_sec;
+	u64 last_change_time_sec;
+	u32 last_write_time_nsec;
+	u32 last_change_time_nsec;
+	u64 eof;
 };
 
 /*
-- 
2.9.0
