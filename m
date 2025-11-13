Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B730F244186
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763057507; cv=none; b=MqRD3SyZYfMnW39EjtNrrOskB7PNWbS+WulWGnHONdyWi14FC/122tzNXhEQw9ZjcBF10BoaKrqEY2rZoFCYdLqSECuhcf7j28LXK3tFup0QXfZb+PJEcWmrrPTxA4qUexzoIzBqkMfQX5+uBUOMpf61VNs5wWp0MqwG5PG2e78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763057507; c=relaxed/simple;
	bh=5wVGMJRELp2bI3vIppa2AzdyZSpGowUVd3TuUEGFjOA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=INUIiqxiaVrss0+NYZoTCEV2En55Ui2CABitjeRln5JoiW8Tgfn5RD6pf4SMCXgIe4NwVOc29tuonVTMAAUt49nxNF7+1NqtaP6HUo/dXHjuALH5y1VUZWFJyLVeUPB1dBxbCUjvJf/+0e9mog0D4s86Tzi3GsOVvo9sDXqAgxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aKVbwIR3; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aKVbwIR3"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477619f8ae5so8947695e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 10:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763057503; x=1763662303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0IkxD0vSQAhaZuvFynp1EoTFlLCBWfn8clNDCKcC0g8=;
        b=aKVbwIR3vApuxuIFJ4KVazG0nzlWvgawzLXV9R9bgF3V9KH7c8f3HFaNJjoAracOFp
         FgUAhNj2xHin/8UQjqRMm4ga6rUpD6MxlLOTDcVSRbyrLQPRgTWAtoTmK7j5YOODvRVE
         fKxZJO1wzs9iq5qheMK94TvscYdkB+5VH5bz12EchzUfeHa57h6PBgAh6EGfDj7bjmBt
         J+iqosy45+l+d1Mb3UiDJrEWoyuxKxNcWs02bojs+FGN6djSE3zFSp8yd8+CNAWG7k4r
         L34i1duXha7ncJPeylQO/CqRSxriUGiVoDRmo0DYq5u6Kzp/Nxrv54piVAuz16NVeDd2
         5S5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763057503; x=1763662303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IkxD0vSQAhaZuvFynp1EoTFlLCBWfn8clNDCKcC0g8=;
        b=QYfpKGHU+LUFN3OeADmC6uEJu6VirkZYWlJD+oZXCsGSz0lX+wsq/eTnlSCRdH0fQX
         +H8aermoAcjEx2YPfA26IBrR7S/bmDoMXJ2sVlO+xxs7EqhDd0FHmte8WBx52tEV7EqP
         mBaIKBzIe3VslYo/WApz0rkAGg+gybGvzulEG89D/orh9eOadJuvRQl1+637GHcIr4NL
         HqtC3NUbboxWvXWgf1EVN+3I0QRQEg470XKhRYLhYpphjmPB/esljQExS/GV91Zrb5RU
         1TFuruLyi8eznRlqJbNNrdi2SZhQOHQF27dsgTa6l63uu0WPVY3DgW7jWhLG5wKbrTq0
         6IXg==
X-Forwarded-Encrypted: i=1; AJvYcCUVCUaEU8p5RhLIIyvJhvRPmnC+LVLaJr1EsJ3gRzG7ViSTn0LroDDNKHwYrCHyoH0cTWMMI3i0UXrY@vger.kernel.org
X-Gm-Message-State: AOJu0YzI+Pe8Xmn2ERvyWfHiGbn41Lz066hDvVvaroyBSgb19Xho5H9E
	RaHC8xqK2yCZm6gq3ue03G2K37oFbdKvSTIQNgA0zCI9jxaCd/C9e1PsMsNClUm6Wno=
X-Gm-Gg: ASbGncsx4EUw1bJ7uQZO4CbOLDusci2luSTVmslm4kWYVjA9nIphQiS/xF/ybpgxKow
	HrOIILPkmpJH7ubBW7PNt22apLhKwlzAihJb1K2JalmBbErqV8wgkLPZLeoh3g0s55E4y/Yymdj
	tsdswZTm1HR3Ps9RlsScfnoIn7n09lya0aqE6y4/LBIy2Y3sBl08OOqM/pqTF8MHDfWTLtKrz7+
	thlMuf8o7sequ5riEl73SR00fPzYRPBcvB3koL7z+I1uj4LoEzS0tW8iymDhPC7ZXgRUi8xLQxh
	S7rumedzTvkUVD0p3YiBc4ohJkUn4Wai/o/DnO2nznWV06rsQ6VF63S/LFcDF4W2Krj5JbiRBCu
	U3W6TdIcq1QkPS6J5dX5CBVXCzvmrIsEZCHrU7yl2n15w8K8rv3P+RPZBNFfMJaxoMRncf7phCf
	pjEcXlJF+jYwqVoy0=
X-Google-Smtp-Source: AGHT+IFJyVN0v49SrinpOlfW3tsEHYJSly1S60pIBYUvxXGH3NUEuwWFIcBrnSYQPqF2roZ3wWHgDQ==
X-Received: by 2002:a05:6000:144c:b0:42b:39ee:2889 with SMTP id ffacd0b85a97d-42b59374c26mr278840f8f.48.1763057502928;
        Thu, 13 Nov 2025 10:11:42 -0800 (PST)
Received: from precision ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a49dad0aefsm960679eec.3.2025.11.13.10.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 10:11:42 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH] smb: client: introduce close_cached_dir_locked()
Date: Thu, 13 Nov 2025 15:09:13 -0300
Message-ID: <20251113180913.3487809-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace close_cached_dir() calls under cfid_list_lock with a new
close_cached_dir_locked() variant that uses kref_put() instead of
kref_put_lock() to avoid recursive locking when dropping references.

While the existing code works if the refcount >= 2 invariant holds,
this area has proven error-prone. Make deadlocks impossible and WARN
on invariant violations.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 41 +++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 018055fd2cdb..e3ea6fe7edb4 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -16,6 +16,7 @@ static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
+static void close_cached_dir_locked(struct cached_fid *cfid);
 
 struct cached_dir_dentry {
 	struct list_head entry;
@@ -388,7 +389,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
-			close_cached_dir(cfid);
+			close_cached_dir_locked(cfid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
 
@@ -480,18 +481,52 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		close_cached_dir(cfid);
+		close_cached_dir_locked(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	close_cached_dir(cfid);
 }
 
-
+/**
+ * close_cached_dir - drop a reference of a cached dir
+ *
+ * The release function will be called with cfid_list_lock held to remove the
+ * cached dirs from the list before any other thread can take another @cfid
+ * ref. Must not be called with cfid_list_lock held; use
+ * close_cached_dir_locked() called instead.
+ *
+ * @cfid: cached dir
+ */
 void close_cached_dir(struct cached_fid *cfid)
 {
+	lockdep_assert_not_held(&cfid->cfids->cfid_list_lock);
 	kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
 }
 
+/**
+ * close_cached_dir_locked - put a reference of a cached dir with
+ * cfid_list_lock held
+ *
+ * Calling close_cached_dir() with cfid_list_lock held has the potential effect
+ * of causing a deadlock if the invariant of refcount >= 2 is false.
+ *
+ * This function is used in paths that hold cfid_list_lock and expect at least
+ * two references. If that invariant is violated, WARNs and returns without
+ * dropping a reference; the final put must still go through
+ * close_cached_dir().
+ *
+ * @cfid: cached dir
+ */
+static void close_cached_dir_locked(struct cached_fid *cfid)
+{
+	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+
+	if (WARN_ON(kref_read(&cfid->refcount) < 2))
+		return;
+
+	kref_put(&cfid->refcount, smb2_close_cached_fid);
+}
+
 /*
  * Called from cifs_kill_sb when we unmount a share
  */
-- 
2.50.1

