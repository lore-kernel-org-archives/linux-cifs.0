Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACC2372054
	for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 18:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779735028; cv=none; b=BYNg8j4YdMmYKsizOErYiAg9zBpENjdO1J26WSgh7aJi/jyY+e9q3mxCT6adImUY+NLp0jIQxmV1BhNZkoYVZp9WnO5YW+TdwX6klbfTf9pN/ZEWOMKJg80Z3Ed3kHKArG/xTld/h9sMCuFcwLx+MfY54nrbg9ES0+hZ0pcgHZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779735028; c=relaxed/simple;
	bh=Y3ybVX2dQKYLUWOIc6XvnN0erGN/AeHWdv/okRDtJBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=unUYgMYq4DtEhosqcNXUWeqUFHnEtIwIi6VjHgSN3y+b+Fq/ZWkB+AHbKhRqktZfAqME8XzcNy4MKBuwtqcqMw+ggvIH90qbAX99d6ZfQAhRKKDKmvLI+L+Rn1pwF+TtJcAeCzpEmwtsbJws6CROs2L2MPxqK3t2uMSpW+i4fxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=APOX6F4r; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="APOX6F4r"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a8dc2606a0so10070003e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 11:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735025; x=1780339825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i72p6+J8Nd74UOvAShmopJMeW02oOXWL6DoKK8+9p/0=;
        b=APOX6F4r7eDi+jVMRKdfw162TIEJ5EN/s/1eAyca1e93m7fGKop7mDGBPBlhD1z0eo
         FkCoj63evUCYtVw1yx+jg0kRCDJVnzONk0v2ojmblHzRJwXiTcMHuPb1+/UKChz7ShBH
         UpsZ+3rDjQeCsb94vkgeNkmGvCDLOa8y9dWPvEtQL8+rxzh9S8nPfCDJJeOldKURtIng
         ixZ/QQRmKmzR8tufg6wlL/55FY7WczPOL1aYtTn6Z5N0C10cujwgojXQuLd7qjHScOUD
         N/YA8Z5x0is+Akv4UVhtluSm37nbJQ0tLwkXGdb1kG+LHzqjPVEIYIJiCEDHMUgOFTWF
         7Log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735025; x=1780339825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i72p6+J8Nd74UOvAShmopJMeW02oOXWL6DoKK8+9p/0=;
        b=dX2V2tPEuQ0Q9KNsL0+1W+tzfchefFJxrc5hZi8c5zxJlrWKuKUvbUsbFL5Ue3n/uX
         5G88mGXqx9RBc70+9SSCR18i247238TpvRWcHKw6AhX5ivBWk1oFo9aLcvMMEZw5aPw/
         OFtIvrx8Xrp5y07i1bz5Hdzv6rdbKZsbc8hhMwYIur8uBxYvxfun41Y2ha8qNiW/OMXZ
         3AfaBPGh7HdHXT9pvSd0E4RupiIMWdZkKmtsuzuYV/ycA8ti1120nNzQxlF/Pf4V8Pha
         /7+x3vEiMw2jHFFXPqVZs8Xxh50vOGF8k0TQ0syal6oypxxOIfTR3bRYtlJtOHGgcPem
         OEYg==
X-Forwarded-Encrypted: i=1; AFNElJ+1GIyhDO/8G3lAJ7CcVeeLP27DFnWwtn+78RFQxafY2Md3VXOpznEvPUyPaRI45E7sRzuwuvQCa5fL@vger.kernel.org
X-Gm-Message-State: AOJu0YyfU2CulI0kxUH3VY89YjRoAMLVV1NtarR/uFV0IqvylQ8WVLRd
	QgRADQD9QDc461Ya1hclzs58av86ftu+9bLdota+GqNs0BoM/IoOofYB
X-Gm-Gg: Acq92OGXQqOaukS/BryobKfWdLfhKeR0p0vKRXCJ/eRuhFbQ3a0hAv/MveQS0wBCfJ4
	MdAZLrvdWilNjX2IYgRw1f9CTVdHS3VvEcwGxew8bQFZhlVouzgKUQoruY1tdaVOjmylQnH6rIt
	dxYvJU+e15KCCv9XeUquSXN1ea+WnLL/VyuYGFtcMwztm2DT5Tc3DCpFdsk1J7gs00yy+XWDM46
	EkeLW+U4TyJN0LSWqOAy1jWJZEL2GVI/F91FTo3mSgb3KDfU+VKCCID2ok3IiYC48IOThSM0zE9
	YMgjsFYJXqb0AqI+MIGqntu8NxL9hAyjY4BdntJNZzTs+d6a1up/4SUNNpZuo4dz4Yb29DSaeoB
	v1S63bWPoQ0Jni7ZcwWtYT6EuIaB27HQfrmKo+rUIFQinsEVSELoSjtj2N/eVAJyzGFTIQgjQR8
	wmovH54GRLwdJ8koE+Zc/SESPPytCdPhRYnEafLl3lRU841CniF0omTIoocQ==
X-Received: by 2002:a05:6512:3ca7:b0:5a8:9909:50b1 with SMTP id 2adb3069b0e04-5aa3233bd67mr4634683e87.10.1779735024843;
        Mon, 25 May 2026 11:50:24 -0700 (PDT)
Received: from COFEDISH-PC (l37-195-210-6.novotelecom.ru. [37.195.210.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa32cf2bd4sm2811856e87.60.2026.05.25.11.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 11:50:23 -0700 (PDT)
From: Aleksandr Golovnya <cofedish@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: release ksmbd_inode ref via ksmbd_inode_put on lookup paths
Date: Tue, 26 May 2026 01:50:18 +0700
Message-ID: <20260525185018.1206-1-cofedish@gmail.com>
X-Mailer: git-send-email 2.52.0.windows.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_query_inode_status() and ksmbd_lookup_fd_inode() both take a
reference on a ksmbd_inode via __ksmbd_inode_lookup() (which performs
atomic_inc_not_zero()) and later release it using a bare
atomic_dec(&ci->m_count).  Unlike ksmbd_inode_put(), a bare
atomic_dec() does not check whether the reference count has reached
zero, so if the caller happens to drop the last reference, the
ksmbd_inode is leaked: it stays in the global inode hash table with
m_count == 0, future __ksmbd_inode_lookup() calls reject it via
atomic_inc_not_zero(), and ksmbd_inode_free() is never invoked.

The race is:

    T1: __ksmbd_inode_lookup()    -> atomic_inc_not_zero(): m_count = 2
    T2: ksmbd_inode_put()         -> atomic_dec_and_test():  m_count = 1
                                                            (not freed)
    T1: atomic_dec(&ci->m_count)                          ->  m_count = 0
        return                                            (LEAK)

In ksmbd_lookup_fd_inode() the matched-fp path (which now also uses
ksmbd_inode_put()) cannot currently reach m_count == 0 because the
matched ksmbd_file holds its own reference on ci, but converting it to
the proper API keeps the three call sites consistent and avoids
future regressions if the locking changes.

Because ksmbd_inode_put() may free the ksmbd_inode if this drops the
last reference, the call must happen after up_read(&ci->m_lock) on the
two affected paths in ksmbd_lookup_fd_inode().  On the no-match path
this is a pure reordering; on the matched path ksmbd_fp_get() is
moved above the unlock so that the returned ksmbd_file is pinned
before the inode reference is released.

Signed-off-by: Aleksandr Golovnya <cofedish@gmail.com>
---
 fs/smb/server/vfs_cache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 5a232d9..4d2d33d 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -217,7 +217,7 @@ int ksmbd_query_inode_status(struct dentry *dentry)
 		ret = KSMBD_INODE_STATUS_OK;
 	up_read(&ci->m_lock);
 
-	atomic_dec(&ci->m_count);
+	ksmbd_inode_put(ci);
 	return ret;
 }
 
@@ -719,14 +719,14 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	down_read(&ci->m_lock);
 	list_for_each_entry(lfp, &ci->m_fp_list, node) {
 		if (inode == file_inode(lfp->filp)) {
-			atomic_dec(&ci->m_count);
 			lfp = ksmbd_fp_get(lfp);
 			up_read(&ci->m_lock);
+			ksmbd_inode_put(ci);
 			return lfp;
 		}
 	}
-	atomic_dec(&ci->m_count);
 	up_read(&ci->m_lock);
+	ksmbd_inode_put(ci);
 	return NULL;
 }
 
-- 
2.54.0

