From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] cifs: use timespec64 internally
Date: Tue, 19 Jun 2018 17:27:58 +0200
Message-ID: <20180619153255.3634720-1-arnd@arndb.de>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        Long Li <longli@microsoft.com>,
        Kees Cook <keescook@chromium.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

In cifs, the timestamps are stored in memory in the cifs_fattr structure,
which uses the deprecated 'timespec' structure. Now that the VFS code
has moved on to 'timespec64', the next step is to change over the fattr
as well.

This also makes 32-bit and 64-bit systems behave the same way, and
no longer overflow the 32-bit time_t in year 2038.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cifs/cifsencrypt.c |  4 ++--
 fs/cifs/cifsglob.h    |  6 +++---
 fs/cifs/cifsproto.h   |  6 +++---
 fs/cifs/cifssmb.c     | 12 ++++++------
 fs/cifs/inode.c       | 34 ++++++++++++++++------------------
 fs/cifs/netmisc.c     | 19 ++++++++++---------
 6 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index ee2a8ec70056..b4672eafc5bf 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -452,7 +452,7 @@ find_timestamp(struct cifs_ses *ses)
 	unsigned char *blobptr;
 	unsigned char *blobend;
 	struct ntlmssp2_name *attrptr;
-	struct timespec ts;
+	struct timespec64 ts;
 
 	if (!ses->auth_key.len || !ses->auth_key.response)
 		return 0;
@@ -477,7 +477,7 @@ find_timestamp(struct cifs_ses *ses)
 		blobptr += attrsize; /* advance attr value */
 	}
 
-	ktime_get_real_ts(&ts);
+	ktime_get_real_ts64(&ts);
 	return cpu_to_le64(cifs_UnixTimeToNT(ts));
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bd78da59a4fd..0543187fe707 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1543,9 +1543,9 @@ struct cifs_fattr {
 	dev_t		cf_rdev;
 	unsigned int	cf_nlink;
 	unsigned int	cf_dtype;
-	struct timespec	cf_atime;
-	struct timespec	cf_mtime;
-	struct timespec	cf_ctime;
+	struct timespec64 cf_atime;
+	struct timespec64 cf_mtime;
+	struct timespec64 cf_ctime;
 };
 
 static inline void free_dfs_info_param(struct dfs_info3_param *param)
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 03018be17283..e23eec5372df 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -142,9 +142,9 @@ extern enum securityEnum select_sectype(struct TCP_Server_Info *server,
 				enum securityEnum requested);
 extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 			  const struct nls_table *nls_cp);
-extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
-extern u64 cifs_UnixTimeToNT(struct timespec);
-extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
+extern struct timespec64 cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
+extern u64 cifs_UnixTimeToNT(struct timespec64);
+extern struct timespec64 cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 				      int offset);
 extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 extern int cifs_get_writer(struct cifsInodeInfo *cinode);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d352da325de3..82bf41265eca 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -502,13 +502,13 @@ decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
 		 * this requirement.
 		 */
 		int val, seconds, remain, result;
-		struct timespec ts;
-		unsigned long utc = ktime_get_real_seconds();
+		struct timespec64 ts;
+		time64_t utc = ktime_get_real_seconds();
 		ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
 				    rsp->SrvTime.Time, 0);
-		cifs_dbg(FYI, "SrvTime %d sec since 1970 (utc: %d) diff: %d\n",
-			 (int)ts.tv_sec, (int)utc,
-			 (int)(utc - ts.tv_sec));
+		cifs_dbg(FYI, "SrvTime %lld sec since 1970 (utc: %lld) diff: %lld\n",
+			 ts.tv_sec, utc,
+			 utc - ts.tv_sec);
 		val = (int)(utc - ts.tv_sec);
 		seconds = abs(val);
 		result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
@@ -4076,7 +4076,7 @@ SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QueryInfo = %d\n", rc);
 	} else if (data) {
-		struct timespec ts;
+		struct timespec64 ts;
 		__u32 time = le32_to_cpu(pSMBr->last_write_time);
 
 		/* decode response */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a2cfb33e85c1..f6abf18ca492 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -95,7 +95,6 @@ static void
 cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
-	struct timespec ts;
 
 	cifs_dbg(FYI, "%s: revalidating inode %llu\n",
 		 __func__, cifs_i->uniqueid);
@@ -114,8 +113,7 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 	}
 
 	 /* revalidate if mtime or size have changed */
-	ts = timespec64_to_timespec(inode->i_mtime);
-	if (timespec_equal(&ts, &fattr->cf_mtime) &&
+	if (timespec64_equal(&inode->i_mtime, &fattr->cf_mtime) &&
 	    cifs_i->server_eof == fattr->cf_eof) {
 		cifs_dbg(FYI, "%s: inode %llu is unchanged\n",
 			 __func__, cifs_i->uniqueid);
@@ -164,9 +162,9 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 	cifs_revalidate_cache(inode, fattr);
 
 	spin_lock(&inode->i_lock);
-	inode->i_atime = timespec_to_timespec64(fattr->cf_atime);
-	inode->i_mtime = timespec_to_timespec64(fattr->cf_mtime);
-	inode->i_ctime = timespec_to_timespec64(fattr->cf_ctime);
+	inode->i_atime = fattr->cf_atime;
+	inode->i_mtime = fattr->cf_mtime;
+	inode->i_ctime = fattr->cf_ctime;
 	inode->i_rdev = fattr->cf_rdev;
 	cifs_nlink_fattr_to_inode(inode, fattr);
 	inode->i_uid = fattr->cf_uid;
@@ -327,8 +325,8 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 	fattr->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
 	fattr->cf_uid = cifs_sb->mnt_uid;
 	fattr->cf_gid = cifs_sb->mnt_gid;
-	ktime_get_real_ts(&fattr->cf_mtime);
-	fattr->cf_mtime = timespec_trunc(fattr->cf_mtime, sb->s_time_gran);
+	ktime_get_real_ts64(&fattr->cf_mtime);
+	fattr->cf_mtime = timespec64_trunc(fattr->cf_mtime, sb->s_time_gran);
 	fattr->cf_atime = fattr->cf_ctime = fattr->cf_mtime;
 	fattr->cf_nlink = 2;
 	fattr->cf_flags |= CIFS_FATTR_DFS_REFERRAL;
@@ -604,8 +602,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 	if (info->LastAccessTime)
 		fattr->cf_atime = cifs_NTtimeToUnix(info->LastAccessTime);
 	else {
-		ktime_get_real_ts(&fattr->cf_atime);
-		fattr->cf_atime = timespec_trunc(fattr->cf_atime, sb->s_time_gran);
+		ktime_get_real_ts64(&fattr->cf_atime);
+		fattr->cf_atime = timespec64_trunc(fattr->cf_atime, sb->s_time_gran);
 	}
 
 	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
@@ -1125,14 +1123,14 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 	if (attrs->ia_valid & ATTR_ATIME) {
 		set_time = true;
 		info_buf.LastAccessTime =
-			cpu_to_le64(cifs_UnixTimeToNT(timespec64_to_timespec(attrs->ia_atime)));
+			cpu_to_le64(cifs_UnixTimeToNT(attrs->ia_atime));
 	} else
 		info_buf.LastAccessTime = 0;
 
 	if (attrs->ia_valid & ATTR_MTIME) {
 		set_time = true;
 		info_buf.LastWriteTime =
-		    cpu_to_le64(cifs_UnixTimeToNT(timespec64_to_timespec(attrs->ia_mtime)));
+		    cpu_to_le64(cifs_UnixTimeToNT(attrs->ia_mtime));
 	} else
 		info_buf.LastWriteTime = 0;
 
@@ -1145,7 +1143,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 	if (set_time && (attrs->ia_valid & ATTR_CTIME)) {
 		cifs_dbg(FYI, "CIFS - CTIME changed\n");
 		info_buf.ChangeTime =
-		    cpu_to_le64(cifs_UnixTimeToNT(timespec64_to_timespec(attrs->ia_ctime)));
+		    cpu_to_le64(cifs_UnixTimeToNT(attrs->ia_ctime));
 	} else
 		info_buf.ChangeTime = 0;
 
@@ -2071,8 +2069,8 @@ int cifs_getattr(const struct path *path, struct kstat *stat,
 	/* old CIFS Unix Extensions doesn't return create time */
 	if (CIFS_I(inode)->createtime) {
 		stat->result_mask |= STATX_BTIME;
-		stat->btime = timespec_to_timespec64(
-		      cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->createtime)));
+		stat->btime =
+		      cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->createtime));
 	}
 
 	stat->attributes_mask |= (STATX_ATTR_COMPRESSED | STATX_ATTR_ENCRYPTED);
@@ -2278,17 +2276,17 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		args->gid = INVALID_GID; /* no change */
 
 	if (attrs->ia_valid & ATTR_ATIME)
-		args->atime = cifs_UnixTimeToNT(timespec64_to_timespec(attrs->ia_atime));
+		args->atime = cifs_UnixTimeToNT(attrs->ia_atime);
 	else
 		args->atime = NO_CHANGE_64;
 
 	if (attrs->ia_valid & ATTR_MTIME)
-		args->mtime = cifs_UnixTimeToNT(timespec64_to_timespec(attrs->ia_mtime));
+		args->mtime = cifs_UnixTimeToNT(attrs->ia_mtime);
 	else
 		args->mtime = NO_CHANGE_64;
 
 	if (attrs->ia_valid & ATTR_CTIME)
-		args->ctime = cifs_UnixTimeToNT(timespec64_to_timespec(attrs->ia_ctime));
+		args->ctime = cifs_UnixTimeToNT(attrs->ia_ctime);
 	else
 		args->ctime = NO_CHANGE_64;
 
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index d7ad0dfe4e68..fdd908e4a26b 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -918,10 +918,10 @@ smbCalcSize(void *buf, struct TCP_Server_Info *server)
  * Convert the NT UTC (based 1601-01-01, in hundred nanosecond units)
  * into Unix UTC (based 1970-01-01, in seconds).
  */
-struct timespec
+struct timespec64
 cifs_NTtimeToUnix(__le64 ntutc)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	/* BB what about the timezone? BB */
 
 	/* Subtract the NTFS time offset, then convert to 1s intervals. */
@@ -935,12 +935,12 @@ cifs_NTtimeToUnix(__le64 ntutc)
 	 */
 	if (t < 0) {
 		abs_t = -t;
-		ts.tv_nsec = (long)(do_div(abs_t, 10000000) * 100);
+		ts.tv_nsec = (time64_t)(do_div(abs_t, 10000000) * 100);
 		ts.tv_nsec = -ts.tv_nsec;
 		ts.tv_sec = -abs_t;
 	} else {
 		abs_t = t;
-		ts.tv_nsec = (long)do_div(abs_t, 10000000) * 100;
+		ts.tv_nsec = (time64_t)do_div(abs_t, 10000000) * 100;
 		ts.tv_sec = abs_t;
 	}
 
@@ -949,7 +949,7 @@ cifs_NTtimeToUnix(__le64 ntutc)
 
 /* Convert the Unix UTC into NT UTC. */
 u64
-cifs_UnixTimeToNT(struct timespec t)
+cifs_UnixTimeToNT(struct timespec64 t)
 {
 	/* Convert to 100ns intervals and then add the NTFS time offset. */
 	return (u64) t.tv_sec * 10000000 + t.tv_nsec/100 + NTFS_TIME_OFFSET;
@@ -959,10 +959,11 @@ static const int total_days_of_prev_months[] = {
 	0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334
 };
 
-struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
+struct timespec64 cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 {
-	struct timespec ts;
-	int sec, min, days, month, year;
+	struct timespec64 ts;
+	time64_t sec;
+	int min, days, month, year;
 	u16 date = le16_to_cpu(le_date);
 	u16 time = le16_to_cpu(le_time);
 	SMB_TIME *st = (SMB_TIME *)&time;
@@ -973,7 +974,7 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 	sec = 2 * st->TwoSeconds;
 	min = st->Minutes;
 	if ((sec > 59) || (min > 59))
-		cifs_dbg(VFS, "illegal time min %d sec %d\n", min, sec);
+		cifs_dbg(VFS, "illegal time min %d sec %lld\n", min, sec);
 	sec += (min * 60);
 	sec += 60 * 60 * st->Hours;
 	if (st->Hours > 24)
-- 
2.9.0
