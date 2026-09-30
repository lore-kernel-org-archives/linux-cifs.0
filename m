Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC3A22D7A9
	for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 00:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790727371; cv=none; b=J8Waut0/22yZHlWUcZ2fuZVuUSMeyxiQcPcnC3HooOL1bDiTXAAbWIOtQJx01uFVCvVSFZSgNhG4tY3OViXqA+X0riYT9L85vPHlLK5BIam9zsKhnH5viuk7OiM3n98UswrCXdClFrVeZ5ZxKcUA7mYdYjRtRr7KvW5nfH1RvmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790727371; c=relaxed/simple;
	bh=z0utDSC05FDwr6CjVgyhIQ7Fa08nu0sk8qyJZ8N5+gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmAvrAXf+BMOAsHqTORLemvP7h1h89f2KFOBBeSiScz1lXw2pe1PwWUXwA7h1rhVpRGRlXirxAXetQBOOnD6+8cSQ4lmx0AYV0gfWD5I29ZsuI+b1cnhWkGuTsRyX8ONDlGAIiY1Y3SFl6bKjwhwV2UbjH/PNcpdnWaGtf31faU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rqV/JHVD; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rqV/JHVD"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34ca54bfc48so140752eec.3
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 17:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790727369; x=1791332169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kHaVwoQqqsaFc44XhEBuGJgq8D6uzQWj5p1fBX2eTGs=;
        b=rqV/JHVD+A8EGPBls340aTZ/yhhSmLkh7TRW1Fi3awhRRL3HVXSkIIodngBv73AGz1
         xclk2B1ooD0S2hJLlenW5NBzPgvvja3SOhUoHR0Rr6l2EC7X7wT9SzhtOeuCbEELZFXq
         ep/d1oyBWc+HmUk3j3qrnEepHV5zcZh8WwwKQBJDnVF5fjaOQ7Nsl3rxEvgYB5oWemJV
         rxIPNAl4DdpuEk0XWG88GiK9+dA/EeJqtHp+ROJfV7796oQuKNHRGqQNqirHF1Ikfz32
         Vw+g85WMCL9amB8ZdDgRCgtB2ikPLeB524JHMFZw2cWoWZCfF1sr0KxJ3qjyxSvZcXjL
         5Z8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790727369; x=1791332169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kHaVwoQqqsaFc44XhEBuGJgq8D6uzQWj5p1fBX2eTGs=;
        b=ymoiYcgswCyu4m+7hsCiQHtcbJOeeg6DJ7j6jsQQr+GFkiS++YjdqhBn6XJTnt2fug
         O+25g3mf8d0oN50VZI9cCHK/8GO89l8Qu57Vky90GM8T8HtynoK3VBhDLSYMPoQH7fUd
         iXj536+bNAQr08/P5pHggHVvmPZ/JE8odCJSDl0uh8Zuci6tco6n+Stkcmdeey32xsIg
         LMRH9GVOtrf6GN6T+YfEiyzwvsnWSF7NOgPBvzDbkRRkClQD2YuAgPap3v89hlF2G4Zr
         QgeGDV16Y3NDIvr3HINZ0KgpT3Y1bMVpiepQRlL+dVU7Ze6kMv9i5Ol22je0UAt1AeoB
         csWw==
X-Gm-Message-State: AFq9FYKqtxVX+FPCDxTPAB/2GUNjb/MkVfWomLbLRd6VTPJQ3tF5F3a3
	drHSEnm7RCs6e/beyjKDkXfq1NOh+5HKHnVPIvHcqoRGwCc/ymNSQnam
X-Gm-Gg: AYBFou2jqgM2sR1CHafkD3N1KH9i7PuG2AnEHwIwHVGSwaMMWwOVHeeHKZ16cPVINKK
	8RFrWdFXnEgp6W4zw9UmsoSTIdE7UXJYC7Xph9QYL9rn6lUunu2tTA9wKo3Du0s+byGmLROygQt
	txswMgD7U/jyxXuGNPgQPTr5y1Jk8Ncskb9UU/AMOUpQZg7zGztmHOKQN0IWRXrG//iG83MIJCQ
	BryoVhrJBAcR7ORGLb1m8eV5ywDILiesS0iQSBZM57DIhWZS9y7kuSMMGOlB2j9kgp1aY9/4/TQ
	Gp42vxERCpczICxoXkCMEnyhLzBF4rK+RBAuHyQkDkSHz5dpjs1++qFHMlVRRnLkt5XLzFglPl9
	R3aJEKoxhbFW5l8l0JrTfNaIKG7sBeplEKGU+zCtZchSvwRlDQSCdRlk3UhFX4Y5LwmQXwBpSXu
	BnLUd4UKcOwP9czqIKf3eErk4jPIR73nRdWB2N8aX3JbYm5gabP7F8LY9uA5LkCgjzXQ==
X-Received: by 2002:a05:693c:69d3:b0:346:c69f:2ea5 with SMTP id 5a478bee46e88-34c675ce6fdmr1057300eec.26.1790727368971;
        Tue, 29 Sep 2026 17:16:08 -0700 (PDT)
Received: from localhost ([8.219.155.192])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34c378ca8basm1870623eec.9.2026.09.29.17.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 17:16:08 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	stable@vger.kernel.org,
	Dairui Zhang <zhangdairui@gmail.com>
Subject: [PATCH] ksmbd: rework ksmbd_validate_name_reconnect() to use a dentry walk
Date: Wed, 30 Sep 2026 08:16:05 +0800
Message-ID: <20260930001605.1917523-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928052026.1789765-1-zhangdairui@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Namjae,

I went over my v2 patch again and found some problems with it.
Sorry for the issues in my earlier patch. I wrote a more
rigorous version; could you please take a look and let me know
if you see any problems with it?

The string prefix check in v2 rejects legitimate durable
reconnects when the share path contains a symlink, because
d_path() of the fp is resolved while the configured string is
not. The new version replaces the string check with a dentry
walk towards share->vfs_path, and also fixes the older case of
a share exported at "/".

From c8efcc786146a951091588e5fa7e3c754850cb3c Mon Sep 17 00:00:00 2001
From: Dairui Zhang <zhangdairui@gmail.com>
Date: Wed, 30 Sep 2026 03:10:00 +0800
Subject: [PATCH] ksmbd: rework ksmbd_validate_name_reconnect() to use a
 dentry walk

The name check in ksmbd_validate_name_reconnect() compares
d_path() of the durable fp against share->path as strings. The
fp path is resolved, the configured string is not, so when an
intermediate component of the share path is a symlink, a
legitimate reconnect to the same file on the same share is
rejected. Example: /a/link -> /real with the share configured
as /a/link/b: a durable handle for /real/b/foo is rejected.

Replace the string checks with an object-based walk from the
fp's dentry towards share->vfs_path, the same root the open
paths use. Each component is compared against the requested
name from its end, under rename_lock so a concurrent rename
cannot mix snapshots. Mount roots are detected by mnt_root and
crossed with follow_up(), so files in nested mounts (crossmnt)
keep working. Reaching the filesystem root without meeting the
share root means the fp does not belong to the share. The share
root itself only matches an empty name, and an unlinked fp is
rejected explicitly. Each walk is limited to 8192 hops and 16
walk attempts, returning -EAGAIN when a limit is hit.

This also fixes reconnects through a share exported at "/",
where the original code compared "oo" for /foo. With no PATH_MAX
buffer or d_path() left in this function, the out-of-bounds
read fixed by v1/v2 cannot reoccur.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
---
Follow-up to the v2 patch in ksmbd-for-next: the string prefix
check still rejects legitimate reconnects on symlinked share
paths, this rework fixes that and the older root-"/" case.
- v2: https://lore.kernel.org/linux-cifs/20260928052026.1789765-1-zhangdairui@gmail.com/
---
 fs/smb/server/vfs_cache.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+), 27 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -11,6 +11,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/dcache.h>
+#include <linux/namei.h>
 
 #include "glob.h"
 #include "vfs_cache.h"
@@ -1701,38 +1702,98 @@
 int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 				  struct ksmbd_file *fp, char *name)
 {
-	char *pathname, *ab_pathname;
+	const struct path *root = &share->vfs_path;
+	struct path cur;
+	const char *p, *end;
+	unsigned int seq, attempts = 0, hops;
 	int ret = 0;
 
-	pathname = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
-	if (!pathname)
-		return -EACCES;
-
-	ab_pathname = d_path(&fp->filp->f_path, pathname, PATH_MAX);
-	if (IS_ERR(ab_pathname)) {
-		kfree(pathname);
-		return -EACCES;
-	}
-
-	if (name) {
-		size_t len = strlen(ab_pathname);
-
-		if (len == share->path_sz && !strncmp(ab_pathname, share->path, len)) {
-			/* the durable fp is the share root itself */
-			if (name[0])
+	if (!name)
+		return 0;
+	if (name[0] == '/' || d_unlinked(fp->filp->f_path.dentry))
+		return -EINVAL;
+
+	for (;;) {
+		if (++attempts > 16)
+			return -EAGAIN;
+		ret = 0;
+		p = name;
+		end = name + strlen(name);
+		cur = fp->filp->f_path;
+		path_get(&cur);
+		seq = read_seqbegin(&rename_lock);
+		hops = 0;
+		for (;;) {
+			const char *comp;
+			size_t clen;
+			struct dentry *parent;
+
+			/* Bound the walk so mount/rename storms cannot spin forever. */
+			if (++hops > 8192) {
+				ret = -EAGAIN;
+				break;
+			}
+
+			if (cur.dentry == root->dentry &&
+			    cur.mnt == root->mnt) {
+				/* the share root itself only matches an empty name */
+				if (end != p)
+					ret = -EINVAL;
+				break;
+			}
+
+			if (cur.dentry == cur.mnt->mnt_root) {
+				/*
+				 * Mount root: hop into the parent mount and
+				 * let its mountpoint supply the component.
+				 * Mount topology can change mid-walk
+				 * (mount_lock is not available here), but
+				 * racing that needs local mount privileges.
+				 */
+				if (!follow_up(&cur)) {
+					ret = -EINVAL;
+					break;
+				}
+				continue;
+			}
+
+			for (comp = end; comp > p && comp[-1] != '/'; comp--)
+				;
+			clen = end - comp;
+			if (!clen) {
+				/* name exhausted while the fp is deeper, or empty component */
 				ret = -EINVAL;
-		} else if (len <= share->path_sz ||
-			   strncmp(ab_pathname, share->path, share->path_sz) ||
-			   ab_pathname[share->path_sz] != '/' ||
-			   strcmp(&ab_pathname[share->path_sz + 1], name)) {
-			ret = -EINVAL;
-		}
-		if (ret)
-			ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
-	}
+				break;
+			}
 
-	kfree(pathname);
+			spin_lock(&cur.dentry->d_lock);
+			if (cur.dentry->d_name.len != clen ||
+			    memcmp(cur.dentry->d_name.name, comp, clen))
+				ret = -EINVAL;
+			spin_unlock(&cur.dentry->d_lock);
+			if (ret)
+				break;
+
+			parent = dget_parent(cur.dentry);
+			if (parent == cur.dentry) {
+				/* escaped the mount without reaching the share root */
+				dput(parent);
+				ret = -EINVAL;
+				break;
+			}
+			dput(cur.dentry);
+			cur.dentry = parent;
 
+			end = comp;
+			if (end > p && end[-1] == '/')
+				end--;
+		}
+		path_put(&cur);
+		if (!read_seqretry(&rename_lock, seq))
+			break;
+	}
+	if (ret)
+		ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
 	return ret;
 }
 
-- 
2.53.0
