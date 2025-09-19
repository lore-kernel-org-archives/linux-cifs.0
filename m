Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530AF31A541
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295875; cv=none; b=LnsOafSVx7a6JJ+wlAmMwTv3Mjfjcli3XRDnaAye0R65LK2xwqiDRXiEwrYTc43WmyWefiPXjgZeD0e52dkTSn1veja2HGbHJfCopXWzAiHFOlyDz1la6Vbn9NTYI7SKj1HKy1YtvLm9gDabl/+yp2knezjGZrydt2rsq5poWp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295875; c=relaxed/simple;
	bh=0P0T6Q21s+WoA4iOwk9gMkvi0E/WXaNmrrqoT35MHRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+ZiWQz3aKZzKRkTA/im7QfTvM6NaUygE0lLfikzHTGutK5zt6a7tuX4evU803BHYQdcAHDgp69pKbdrNto+13QZYO1S0B/Y1hAYYdfCZbb/P4YwYrVcjutWlyTCQJT3wqmC5jv+VAGI+oJ2qqcrVH/dXU9yC6Sgx0+N87h2zpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TAx1Ss9Y; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TAx1Ss9Y"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso17703995e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 08:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758295871; x=1758900671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDrd/86WD36xOXabJcoY1JMHbLpzxx4JL3Buq/x9QCo=;
        b=TAx1Ss9YIJWRYFvKpcgty3uwyxP1sOhsPlYK1Bhu6xmlP22ICs9oFruGJXu/7rGRPO
         YiLst9fKCyBKYokm7JOCeJlEslKgSDuW4MffEl49rG+8kn0BA6MgKQCuctJSQTbsx63A
         ymbVnEBeKjw7ea3FttX9gnnAX3ocUimMP6EP28yZMFj09u2Th8XLVgFDh30JXOA3WXd6
         TrNUVgDAYZhMi+LJkGUMX1Pldkjs3NPIrx7RG9D7lIgndg76oxbsuAeu+UKgjNNG04v0
         gHmnnNaHZD5I99rG+xJHUNTYM0lrLr6PFe6xPwnfY1Os9gG1L472WI6MU1OEZM2OZco9
         EbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758295871; x=1758900671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDrd/86WD36xOXabJcoY1JMHbLpzxx4JL3Buq/x9QCo=;
        b=NxXVAUWz1YLAWeUJQ1HZe9tMUCqtUEeuLCagJVaJlPeIcXGx9qI1XaCPOV8A3K/ZUr
         HBW7jCVHUreUaJ9cPnCDNt9IRF0pLIfP+8zHjmbF31N6ztPlV37zviT3OgdTr8kIlRv1
         7APsQWuC++6/jPtFrYAOm+aDDE1hHxPVoxldE/ChCurCDOTpR19mb2b9m0aEsJeABesN
         oLZPWWqbFkapSaR1r1kc72EbAH3tsz06jVxwwE3HEKaK6Q8NtEVt50AYGXBAcMAnVSRc
         PBlG6b2WP/awY6+i1eygevoCAqHJbt9tjnOD3ieIXtAFV7KN4CizG7TNKUzgiB5YktNJ
         bghw==
X-Forwarded-Encrypted: i=1; AJvYcCU3fNjtfZqmhjP324ejWkKRHKqMA9kl4vn15R+QxRl24QqjLTgIiUKJl1+0f1u8jl09gmcLBvo1qaov@vger.kernel.org
X-Gm-Message-State: AOJu0YxnfT1Os0AUS1csMoZYB9fDw1PYXvZKLKVqVzKLxxKO8v9WIXp5
	BCdWRXfE1SNL+91eRUhB0y+OrJ+FoLsnVhuEb7YUgXtK8Rfgp5caB56pC/6biRybR5oSfN4udSC
	0X/qS
X-Gm-Gg: ASbGncsNiiRAj3p82GZcJblQD6Tm8GsJSI+MGXqq8iKCgfaEnpX27qj0MUpf11S6R5t
	CfX6eLQBfclse3KNRcbgvLv1DlxKKuKZY55Igy/owJ7DrH9426oTd+0SDf/Afil6YdyhuM1gccW
	JdhnxfE6NhowTjkevF8RoHoybK1+gD+kI7S/+8uKTu+NBESJ1lU0GRrYU0MFhRlHg4X2voQWkmB
	zt6dNzWwQxeVqHxZlIHW5+ottAlz6E1gCQmW+lLkNTS+gfqL5j6RlJub4sU88FPM+QGTCYx8gQ8
	Dj2NI75FqGOHgU5EZyIBkBJEnQy8laI1q0fLSSD6QTeBj+ANTnSzJ15iCcT1vTJh85JdItN7zJu
	XTClH6z5pHCc1
X-Google-Smtp-Source: AGHT+IGc7DEl2RLvGd4f2YssCx2sSe/duTHpxCmMDYHenY1iTZ+lxfdT3kZaaNdtgstuHlr7kqQpkQ==
X-Received: by 2002:a5d:64e7:0:b0:3ec:75c0:9cf5 with SMTP id ffacd0b85a97d-3ee8585f665mr2492125f8f.47.1758295871382;
        Fri, 19 Sep 2025 08:31:11 -0700 (PDT)
Received: from precision ([2804:14c:658f:8614::1cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ecc735627sm5129683a91.1.2025.09.19.08.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:31:10 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 6/6] smb: client: remove unused fid_lock
Date: Fri, 19 Sep 2025 12:24:40 -0300
Message-ID: <20250919152441.228774-6-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919152441.228774-1-henrique.carvalho@suse.com>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fid_lock in struct cached_fid does not currently provide any real
synchronization. Previously, it had the intention to prevent a double
release of the dentry, but every change to cfid->dentry is already
protected either by cfid_list_lock (while the entry is in the list) or
happens after the cfid has been removed (so no other thread should find
it).

Since there is no scenario in which fid_lock prevents any race, it is
vestigial and can be removed along with its associated
spin_lock()/spin_unlock() calls.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 17 +++--------------
 fs/smb/client/cached_dir.h |  1 -
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 22b1c5dd4913..eba7ce047b63 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -527,10 +527,9 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 				spin_unlock(&cifs_sb->tlink_tree_lock);
 				goto done;
 			}
-			spin_lock(&cfid->fid_lock);
+
 			tmp_list->dentry = cfid->dentry;
 			cfid->dentry = NULL;
-			spin_unlock(&cfid->fid_lock);
 
 			list_add_tail(&tmp_list->entry, &entry);
 		}
@@ -613,14 +612,9 @@ static void cached_dir_put_work(struct work_struct *work)
 {
 	struct cached_fid *cfid = container_of(work, struct cached_fid,
 					       put_work);
-	struct dentry *dentry;
-
-	spin_lock(&cfid->fid_lock);
-	dentry = cfid->dentry;
+	dput(cfid->dentry);
 	cfid->dentry = NULL;
-	spin_unlock(&cfid->fid_lock);
 
-	dput(dentry);
 	queue_work(serverclose_wq, &cfid->close_work);
 }
 
@@ -678,7 +672,6 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
-	spin_lock_init(&cfid->fid_lock);
 	kref_init(&cfid->refcount);
 	return cfid;
 }
@@ -730,7 +723,6 @@ static void cfids_laundromat_worker(struct work_struct *work)
 {
 	struct cached_fids *cfids;
 	struct cached_fid *cfid, *q;
-	struct dentry *dentry;
 	LIST_HEAD(entry);
 
 	cfids = container_of(work, struct cached_fids, laundromat_work.work);
@@ -757,12 +749,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 
-		spin_lock(&cfid->fid_lock);
-		dentry = cfid->dentry;
+		dput(cfid->dentry);
 		cfid->dentry = NULL;
-		spin_unlock(&cfid->fid_lock);
 
-		dput(dentry);
 		if (cfid->is_open) {
 			spin_lock(&cifs_tcp_ses_lock);
 			++cfid->tcon->tc_count;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index aa12382b4249..f4bdb8b28ffa 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -41,7 +41,6 @@ struct cached_fid {
 	unsigned long last_access_time; /* jiffies of when last accessed */
 	struct kref refcount;
 	struct cifs_fid fid;
-	spinlock_t fid_lock;
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
 	struct work_struct put_work;
-- 
2.50.1

