Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AFD46F48C
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784678163; cv=none; b=l7QIIfDJSh9CkG+AnNKH5nP2GcopzdIpNBOvNsa3ImstojhrLxcNq4vUdZrkJZ7yy0vGjpFoxqLOjf27nr0pgTdEzeujbLPhJHZfLPQU0cnUWF7vmtZQRQagTIKatagvaqKrbkTXADMm5/TgX7lmiVNfZnjKAdp/cW6j9tU7feY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784678163; c=relaxed/simple;
	bh=BWPU5k2THfigj/rEn4t2cfskp2EcWPIjrMhy1uBrtYs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeyI/UEElFddXQp5WTLLyDU/8pqyYGlZggUYtiyzsoU/rHp62L9cInLjnTiHBiXf9ex3n1taQmg8SB/TgzZcX9MS/ZPZYqj0MFvB3v2LrSYw3IcY3f3C56L7CuPc6R6B4akFjlp8abEKM9FqMphY+Dgib/myLSUcVKSDKEwOhj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G1qUOES+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WSApOGfu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G1qUOES+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WSApOGfu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784678160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nc6ibgZ2gvbfHs/hm6ZWWcEMFHqtXngjq5eiGt5aRbQ=;
	b=G1qUOES+dq+jwpgU5SI5vy2F0Ndgdb2RqnOq8iOyY6EGuijztzBWCy1tBKuq2lCsfDG8vi
	KsN7DpYBzOPF9lxoD2k0sD0o0nId+x8g80rvJQ6EcF1IZpVb28A2j/XuniezO6ufF/WJkR
	gd/Y1SzoOMopsowEqr5SFaLFAOlNhQM=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-sfQSvEN9M5uw-wVPz7IMeA-1; Tue, 21 Jul 2026 19:55:59 -0400
X-MC-Unique: sfQSvEN9M5uw-wVPz7IMeA-1
X-Mimecast-MFC-AGG-ID: sfQSvEN9M5uw-wVPz7IMeA_1784678159
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e7624e584dso13181291a34.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 16:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784678159; x=1785282959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Nc6ibgZ2gvbfHs/hm6ZWWcEMFHqtXngjq5eiGt5aRbQ=;
        b=WSApOGfuAZWSWFaHGwpfo71F2Chp420sLc7JfkrnaCsvIZ7TV6Tyu+GhmOuvWMfJ8L
         QvjW+yFXc1t7ceOm4A6alVpmIuLWxWFDVcdFV56q0j31L/w+tvBau4Z8sxHoilFOf0Qe
         t0CB8KDyV4xhxlTxRmL1kxeQQqzN4R/id/f+QlVmXezYwCQYJf6cWzH5anGncVvkVie5
         +RHgfd4ttdb4Yp9c5JueF6KmNMdo5scbnS+584IKl0io3RONvYZSJ2PhnN8FR0oZ+ihf
         NKVhkeMk4aof3uQQk0JrKWgvtWMetTzgTYWGYwwFj6N0ZS7OtfSQkBd02ifogaNsTtY5
         U+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784678159; x=1785282959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Nc6ibgZ2gvbfHs/hm6ZWWcEMFHqtXngjq5eiGt5aRbQ=;
        b=oDeJS2xyC8Mg5FZPXdKilzepxisLu/bdj6yxUAiMlTHCm5TuDBy6M229VH8CpaYVx7
         2/S3ZYJySjDgknSgpGMfnrzGB4fP/8o3Ep+qr73VYgtWvEO7PwEqTUrLe0aBLE+J5dqS
         V58MECGbnrYyIZBn8N9EUAr+i0g+/u3Nthe9KbVlRGEIA9/eV7Ny6C4fTUqfeEdVLo/J
         8zeonlWozp0Rs/grlMPUbZ77yi6g9ULKMRzeHpvt218uLFt6fme1ObUahOhB/q6moR9/
         5ANInRzegxGo5BrCl6joVW/W7UWUF+uyBbG4b/rffJ3PmeuWE0RlTzJmf1L+6MaW9S4h
         W/Ig==
X-Gm-Message-State: AOJu0YzG8ab2GboCvyjM+qNF1/1gRiZKxJbHN1gbBTqbzsKyLWC1Tswh
	JqgBzIlFFtOGK+wJyxRHKywlOqUDVxQO8wC2ojeiCbdbx91XSrmOAoWm4RbalriT/I5bwJoIpib
	nIQEzqesw6X85WC6J0d3YULUS+VE08sQ2/mj64pV4/oGJ0Xa7ogHtj/ZViQSeldyRviUqAIXXTH
	2A+3DRE8qgosP62AorGgARUK86tcgOTQOvAt4hdLd1D42jm08=
X-Gm-Gg: AfdE7cl++cVh83u2zPluyfCunQNMMXnW8q/DYSabjIb4sNzfcpa+us3cZiuUzbwV3YE
	E/WA87lWzt85YbWU1syoMhA8C1gSwBF9OEzVObUfrU9gCrfj7yOlJg9rQ7vMpja18PghXcE9+9i
	GNCYd3MNMj9XytMW7uHvZkpdzJHcArsHpI1VmRLSfE3bpy0BJzfiIIfMRWaZOCAHX5Z4YQZW2ge
	PjS6eqWPS7Tq8ooYlrMw6vThoxZTepaAMLWbgC29e77PqB2BxdQVmXxRNd06xrnNeakeV1WHcD5
	2d6AeK0XniqASuTMnVq2R6cb8lkN4NpLeMKYa3DDzyX/wzzRFewC0TOE4OTnzfmjR8ffq8LwgkX
	Xp833yoQciA6OgP0sG4V/wcvnLtFvVCvqj/wX12584z73N0/BX8VhugDKLf7u
X-Received: by 2002:a05:6820:80b:b0:6a3:d4a:50d2 with SMTP id 006d021491bc7-6a536abb51emr9540786eaf.56.1784678158708;
        Tue, 21 Jul 2026 16:55:58 -0700 (PDT)
X-Received: by 2002:a05:6820:80b:b0:6a3:d4a:50d2 with SMTP id 006d021491bc7-6a536abb51emr9540777eaf.56.1784678158127;
        Tue, 21 Jul 2026 16:55:58 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-457673e1f1fsm731805fac.9.2026.07.21.16.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 16:55:56 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH v4 2/2] cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths
Date: Tue, 21 Jul 2026 18:55:52 -0500
Message-ID: <20260721235552.1839780-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721235552.1839780-1-sorenson@redhat.com>
References: <20260721235552.1839780-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In cifs_close_deferred_file(), cifs_close_all_deferred_files(), and
cifs_close_deferred_file_under_dentry(), when a pending deferred close
is cancelled via cancel_delayed_work(), the subsequent kmalloc_obj() to
add the file to the local processing list may fail under memory pressure.
The loop breaks immediately, but the cancelled work is no longer pending
(it would have called _cifsFileInfo_put()), and the cfile is never added
to file_head for processing.  The cifsFileInfo reference and the open
server handle both leak.

Fix by saving the cfile that failed allocation in a local variable,
breaking as before, and calling _cifsFileInfo_put() on it after
releasing the lock.  Any files later in the iteration are unaffected
since their deferred work is still pending and will fire normally.

Fixes: e3fc065682eb ("cifs: Deferred close performance improvements")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -497,7 +497,7 @@
 void
 cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
-	struct cifsFileInfo *cfile = NULL;
+	struct cifsFileInfo *cfile = NULL, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	LIST_HEAD(file_head);
 
@@ -514,8 +514,10 @@
 
 				tmp_list = kmalloc_obj(struct file_list,
 						       GFP_ATOMIC);
-				if (tmp_list == NULL)
+				if (tmp_list == NULL) {
+					failed_cfile = cfile;
 					break;
+				}
 				tmp_list->cfile = cfile;
 				list_add_tail(&tmp_list->list, &file_head);
 			}
@@ -523,6 +525,15 @@
 	}
 	spin_unlock(&cifs_inode->open_file_lock);
 
+	if (failed_cfile) {
+		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(failed_cfile, false, false);
+	}
+
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		struct cifsFileInfo *cfile = tmp_list->cfile;
 
@@ -540,7 +551,7 @@
 void
 cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	LIST_HEAD(file_head);
 
@@ -554,8 +565,10 @@
 
 				tmp_list = kmalloc_obj(struct file_list,
 						       GFP_ATOMIC);
-				if (tmp_list == NULL)
+				if (tmp_list == NULL) {
+					failed_cfile = cfile;
 					break;
+				}
 				tmp_list->cfile = cfile;
 				list_add_tail(&tmp_list->list, &file_head);
 			}
@@ -563,6 +576,15 @@
 	}
 	spin_unlock(&tcon->open_file_lock);
 
+	if (failed_cfile) {
+		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(failed_cfile, true, false);
+	}
+
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		struct cifsFileInfo *cfile = tmp_list->cfile;
 
@@ -618,7 +640,7 @@
 					   struct dentry *dentry)
 {
 	struct file_list *tmp_list, *tmp_next_list;
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	LIST_HEAD(file_head);
 
 	spin_lock(&tcon->open_file_lock);
@@ -631,14 +653,25 @@
 			spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 			tmp_list = kmalloc_obj(struct file_list, GFP_ATOMIC);
-			if (tmp_list == NULL)
+			if (tmp_list == NULL) {
+				failed_cfile = cfile;
 				break;
+			}
 			tmp_list->cfile = cfile;
 			list_add_tail(&tmp_list->list, &file_head);
 		}
 	}
 	spin_unlock(&tcon->open_file_lock);
 
+	if (failed_cfile) {
+		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(failed_cfile, true, false);
+	}
+
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		struct cifsFileInfo *cfile = tmp_list->cfile;
 

---
2.55.0

