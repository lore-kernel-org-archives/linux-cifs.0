Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D01E314B9F
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295627; cv=none; b=s3/wTZ7lsSzePYdIkuB+2wcU04da2CyLa4eDwCHnx/wXsWvicKtNgZxGs2XLHmwieBmBaIrhKIfzeCBHOsoPtd1TrXKhTJIm2JNtvAz1gJEvPb2swUdXbwlaQLJHe7Oaor/XEZNCidLPb9Q2XtG/N2g8Z/IRjkLTwcnUSKl++WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295627; c=relaxed/simple;
	bh=hd4J6K/aOC7x/x1Bb9CUr+zBK6BUG/c1mmflO6rZ+cY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AL84/1/6h9mflLa7kO9pq/tXK2bvczSq/pN/Q+9XZgFlDWbAJmkuJt6Vekltd2/Yd230ezvLx767RiSecIAGSBiW/LlnVzT8hTjQwXfg3soJeF5oDkTLI+7/2XxqUMoq9UT2kH1YhdsmzzhitMi9WTyXv6zmu0CiwCYajkA2Luo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P/UCirDJ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P/UCirDJ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso1759386f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 08:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758295623; x=1758900423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3YDT0SFyvGXs6foqo1DWsdqNH+X49sfPbDQQoide3fI=;
        b=P/UCirDJiNVdSmRfpsxDS2+gq2RGbpnhxoUvsZyOvcMg1/wb9q3EvZQx7WOyJmkdnE
         9SOQVRANgq7AMiXDm4kE9lDc/l6ApLvj6s8IJHMstziDhST9Y6KNoRKENgqzRrjnxiv/
         myDD3veuL+e/O8Ia4RQevt/rS+7C3YFDk5CKvkiXS7SUXxko7gaZXeMEPgrUuAq7KHJ8
         8wQlTh+D9jH46Gz/uXdY/+krGsepM/oTjVnHUjFhbgDp8h0NY9SI0VcBB5y6UDhxWb1I
         Y3H7dSw1ezFKNa9R9uDOt4NfEsECTzqjfb6O0bZB0+4KODmwdYYkghmycSw1ywluHg6Q
         H3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758295623; x=1758900423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3YDT0SFyvGXs6foqo1DWsdqNH+X49sfPbDQQoide3fI=;
        b=BZ7BWJGpGM+YDwYYnQZuWyiNZh3vQN0GKGRGhJS7MpHqyUsIegV+Ux2hZ4RfEAjjvT
         oaKRz5iDoiITHEhzij6NZ4DE5wzLMNufbzH0x3kHFeoVdnrv7IMzyAgEbh70JRyyfZKc
         m48Op72ut2FLT5biSD2NiVGmwWReSBY2UAR7iiu29o5N+2rDzFkG/YRjPvU3B9HWxJlf
         MOMALpi3jKMQvZlEH5W7VOqlWyGFLIsqhfUHMALJ6XWSW/+gskdZFl6s4H3v4E9t83Er
         Ol5EyxoOj174vUZOScQWN/E0Us9MSzrfE/vORa2FUiZ7M4wRS69NRQL+z9275KV03gPb
         HxEg==
X-Forwarded-Encrypted: i=1; AJvYcCWiaTQU4o3z8BhbJmbfVhJNK6Qpo0l6NbQlJRaJu+m86blU6j5ScAIACM/keThA1ypZKy5fz1T66xC0@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+TW16QoV6lRrEipuJrufb6H9e3CpRoMehzm9EytZMh+ZtjcPv
	xZcIG7ERBCTPAvh/47Orp5BBTu+0T/ElDXPuMyaa+umrFDT8HZI2NogrzC7RhTKdLi7ngVDF5lC
	c5ANi
X-Gm-Gg: ASbGncvP6jfZzRnF1C3k+PtmQyf6ahXlZ1IhB8xXjlqL8BzWSpNKovbGOdtLr76Qe7p
	B1/vYByuPQnpzd2xzmQvl7zvp4G/hrf4UyqhbSjJmT4Y8u6GIaT1GN+bpBLVN3luz9Cs+13PX6w
	sw8janVl3qebYf7pTFUnCvDghe22gaguYoG4Uo+n3eUcFvWoswd5nJSCyiBAg42DDlj22WNJ4H5
	dAAV7VQnkJtI/55hFbGkfitOOq7YwmF2ORpNu6G1hOHzedeYCij+PtHiJvMPikfLqaDN4VsyiVO
	vRLvQt4WelneetuBJ+BKER9siLaJ74opD8O6T8u1+EJNkcxNMaM7sHbbLEd3LI8G+xCZPqS5Kr4
	5aam6QetLE7IJ
X-Google-Smtp-Source: AGHT+IHbAGmANSsHn2fdx8F3gQm2w4a8yZG/XaoG4F8IjUDx/h422vRTEBUtdC5SkPtdv+yEqR6qbA==
X-Received: by 2002:a05:6000:24c4:b0:3e8:e7a6:e5b5 with SMTP id ffacd0b85a97d-3edd43bbb3bmr7149663f8f.11.1758295623398;
        Fri, 19 Sep 2025 08:27:03 -0700 (PDT)
Received: from precision ([2804:14c:658f:8614::1cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ecc735627sm5129683a91.1.2025.09.19.08.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:27:02 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 1/6] smb: client: ensure open_cached_dir_by_dentry() only returns valid cfid
Date: Fri, 19 Sep 2025 12:24:35 -0300
Message-ID: <20250919152441.228774-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

open_cached_dir_by_dentry() was exposing an invalid cached directory to
callers. The validity check outside the function was exclusively based
on cfid->time.

Add validity check before returning success and introduce
is_valid_cached_dir() helper for consistent checks across the code.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 9 +++++----
 fs/smb/client/cached_dir.h | 6 ++++++
 fs/smb/client/dir.c        | 2 +-
 fs/smb/client/inode.c      | 2 +-
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b69daeb1301b..63dc9add4f13 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -36,9 +36,8 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			 * fully cached or it may be in the process of
 			 * being deleted due to a lease break.
 			 */
-			if (!cfid->time || !cfid->has_lease) {
+			if (!is_valid_cached_dir(cfid))
 				return NULL;
-			}
 			kref_get(&cfid->refcount);
 			return cfid;
 		}
@@ -194,7 +193,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 * Otherwise, it is either a new entry or laundromat worker removed it
 	 * from @cfids->entries.  Caller will put last reference if the latter.
 	 */
-	if (cfid->has_lease && cfid->time) {
+	if (is_valid_cached_dir(cfid)) {
 		cfid->last_access_time = jiffies;
 		spin_unlock(&cfids->cfid_list_lock);
 		*ret_cfid = cfid;
@@ -233,7 +232,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
 				if (parent_cfid->dentry == dentry->d_parent) {
 					cifs_dbg(FYI, "found a parent cached file handle\n");
-					if (parent_cfid->has_lease && parent_cfid->time) {
+					if (is_valid_cached_dir(parent_cfid)) {
 						lease_flags
 							|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
 						memcpy(pfid->parent_lease_key,
@@ -420,6 +419,8 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		if (dentry && cfid->dentry == dentry) {
+			if (!is_valid_cached_dir(cfid))
+				break;
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 46b5a2fdf15b..aa12382b4249 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -64,6 +64,12 @@ struct cached_fids {
 	struct delayed_work laundromat_work;
 };
 
+static inline bool
+is_valid_cached_dir(struct cached_fid *cfid)
+{
+	return cfid->time && cfid->has_lease;
+}
+
 extern struct cached_fids *init_cached_dirs(void);
 extern void free_cached_dirs(struct cached_fids *cfids);
 extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 5223edf6d11a..56c59b67ecc2 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -322,7 +322,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
 			if (parent_cfid->dentry == direntry->d_parent) {
 				cifs_dbg(FYI, "found a parent cached file handle\n");
-				if (parent_cfid->has_lease && parent_cfid->time) {
+				if (is_valid_cached_dir(parent_cfid)) {
 					lease_flags
 						|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
 					memcpy(fid->parent_lease_key,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index fe453a4b3dc8..9c8b8bd20edd 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2639,7 +2639,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 		return true;
 
 	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
-		if (cfid->time && cifs_i->time > cfid->time) {
+		if (cifs_i->time > cfid->time) {
 			close_cached_dir(cfid);
 			return false;
 		}
-- 
2.50.1

