From: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 15/32] cifs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:39 +0200
Message-ID: <1401480116-1973111-16-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
	john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
	geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

cifs uses multiple time formats for inode timestamps, which will work
at least another 92 years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in cifs. After 2106, users of the old protocol versions
will have to move to the latest version.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
---
 fs/cifs/cache.c     |  6 +++---
 fs/cifs/cifsglob.h  |  6 +++---
 fs/cifs/cifsproto.h |  6 +++---
 fs/cifs/cifssmb.c   |  5 +++--
 fs/cifs/inode.c     |  2 +-
 fs/cifs/netmisc.c   | 15 ++++++++-------
 6 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
index 6c665bf..5343f38 100644
--- a/fs/cifs/cache.c
+++ b/fs/cifs/cache.c
@@ -221,9 +221,9 @@ const struct fscache_cookie_def cifs_fscache_super_index_def = {
  * Auxiliary data attached to CIFS inode within the cache
  */
 struct cifs_fscache_inode_auxdata {
-	struct timespec	last_write_time;
-	struct timespec	last_change_time;
-	u64		eof;
+	struct inode_time	last_write_time;
+	struct inode_time	last_change_time;
+	u64			eof;
 };
 
 static uint16_t cifs_fscache_inode_get_key(const void *cookie_netfs_data,
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index de6aed8..f944c44 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1344,9 +1344,9 @@ struct cifs_fattr {
 	dev_t		cf_rdev;
 	unsigned int	cf_nlink;
 	unsigned int	cf_dtype;
-	struct timespec	cf_atime;
-	struct timespec	cf_mtime;
-	struct timespec	cf_ctime;
+	struct inode_time cf_atime;
+	struct inode_time cf_mtime;
+	struct inode_time cf_ctime;
 };
 
 static inline void free_dfs_info_param(struct dfs_info3_param *param)
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ca7980a..ad476c6 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -122,9 +122,9 @@ extern enum securityEnum select_sectype(struct TCP_Server_Info *server,
 				enum securityEnum requested);
 extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 			  const struct nls_table *nls_cp);
-extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
-extern u64 cifs_UnixTimeToNT(struct timespec);
-extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
+extern struct inode_time cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
+extern u64 cifs_UnixTimeToNT(struct inode_time);
+extern struct inode_time cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 				      int offset);
 extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 extern int cifs_get_writer(struct cifsInodeInfo *cinode);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c3dc52e..4452be7 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -482,7 +482,7 @@ decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
 		 * this requirement.
 		 */
 		int val, seconds, remain, result;
-		struct timespec ts, utc;
+		struct inode_time ts, utc;
 		utc = CURRENT_TIME;
 		ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
 				    rsp->SrvTime.Time, 0);
@@ -3952,7 +3952,8 @@ QInfRetry:
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QueryInfo = %d\n", rc);
 	} else if (data) {
-		struct timespec ts;
+		struct inode_time ts;
+		/* FIXME: 32-bit time? */
 		__u32 time = le32_to_cpu(pSMBr->last_write_time);
 
 		/* decode response */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9ff8df8..30ff02f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -109,7 +109,7 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 	}
 
 	 /* revalidate if mtime or size have changed */
-	if (timespec_equal(&inode->i_mtime, &fattr->cf_mtime) &&
+	if (inode_time_equal(&inode->i_mtime, &fattr->cf_mtime) &&
 	    cifs_i->server_eof == fattr->cf_eof) {
 		cifs_dbg(FYI, "%s: inode %llu is unchanged\n",
 			 __func__, cifs_i->uniqueid);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 6834b9c..40bcbcb 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -918,10 +918,10 @@ smbCalcSize(void *buf)
  * Convert the NT UTC (based 1601-01-01, in hundred nanosecond units)
  * into Unix UTC (based 1970-01-01, in seconds).
  */
-struct timespec
+struct inode_time
 cifs_NTtimeToUnix(__le64 ntutc)
 {
-	struct timespec ts;
+	struct inode_time ts;
 	/* BB what about the timezone? BB */
 
 	/* Subtract the NTFS time offset, then convert to 1s intervals. */
@@ -935,7 +935,7 @@ cifs_NTtimeToUnix(__le64 ntutc)
 
 /* Convert the Unix UTC into NT UTC. */
 u64
-cifs_UnixTimeToNT(struct timespec t)
+cifs_UnixTimeToNT(struct inode_time t)
 {
 	/* Convert to 100ns intervals and then add the NTFS time offset. */
 	return (u64) t.tv_sec * 10000000 + t.tv_nsec/100 + NTFS_TIME_OFFSET;
@@ -945,10 +945,11 @@ static const int total_days_of_prev_months[] = {
 	0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334
 };
 
-struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
+struct inode_time cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 {
-	struct timespec ts;
-	int sec, min, days, month, year;
+	struct inode_time ts;
+	long long sec;
+	int min, days, month, year;
 	u16 date = le16_to_cpu(le_date);
 	u16 time = le16_to_cpu(le_time);
 	SMB_TIME *st = (SMB_TIME *)&time;
@@ -959,7 +960,7 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 	sec = 2 * st->TwoSeconds;
 	min = st->Minutes;
 	if ((sec > 59) || (min > 59))
-		cifs_dbg(VFS, "illegal time min %d sec %d\n", min, sec);
+		cifs_dbg(VFS, "illegal time min %d sec %lld\n", min, sec);
 	sec += (min * 60);
 	sec += 60 * 60 * st->Hours;
 	if (st->Hours > 24)
-- 
1.8.3.2
