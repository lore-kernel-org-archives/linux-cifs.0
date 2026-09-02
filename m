Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02636D9F9
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788373704; cv=none; b=dsEaOo5FkAom+lhcDl2gZbl0tvx+s9sDyBa5FxKzNOPTkeQxn4nxPGPTQO5/BWydqHQYqVVFGHxI3q6fLonxBAcpcWLIU4GlRdFc4owH+iJJoDmA1F7ihoO2jXF+ax3Wkb/rinojAdCh6CzqkWaON1lYAasqLDk0ODAiJ9DUs04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788373704; c=relaxed/simple;
	bh=IoD8kxRSKBVmpHH9Yga6lz2dzGvZpGp7jqYOG/7TR1s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m7d44aYqDOmL66oiDflPyGUs+d5IXApkT1oi024RcLftCqsAf7elZo7EypFmRcUS0BXWP9WLNNNZynmVZT++6eyr1O1vtiA29aXux64jhTndITcZHugbmdscUi9flLn8t0iCvl7O8lNhpouVRwik1qcohUWTk57FbkSAivyrqnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p1ARZDsA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p1ARZDsA"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49b9320423cso14469935e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 11:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788373701; x=1788978501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5XR27vgN5nJ/lgsOm3NqnEQEtuojTb2G48lFGrn17tw=;
        b=p1ARZDsAE1KZAvr9IyAGs028f0GWghab2sjeK0vZfDibUPZweloLt6RTQO/7pVK8pI
         SKYBBHxs9QNi2Nfc1lpUXPHnVTglt+dqq4/GQELiT5CYguw6APmgxAXHRhzrVdDJ768l
         fjWx3Og8SStLnXQzBOZ2W/TtcB/KLeqgWYFIMww55OEOI2fH2B3+khzwe0HUFBz4jxA9
         PjMwVf0kEqYkDs/pcs4Q5AygS4UCOdRRX/Hc9jibskOny9kHZsKHD5uOWas0GOYKMuW0
         +q+khibAsjRX3QuIMC5eLZ3gNJQQlQTvxhVwxX4kJCZfNziuss5aIQ6ndoIweVYuPv/S
         JBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788373701; x=1788978501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5XR27vgN5nJ/lgsOm3NqnEQEtuojTb2G48lFGrn17tw=;
        b=GNCQ3g5R4DevTMsvLTQ/6/eL35OCagXOAp/7BB6CQlVjGHU9lHWPjtMuUoiko6GqCB
         7oTsOFwwmVqLJx/6V13cHk8AG5FQdbO6lIOlX4i0J4EsL+zOUVf+Jm/FHcsUWcuM7GhS
         w7X9RiJKPhMeEZnJiPytGLLQ/2da+BUgVfIoXPIq0LexXhb42ucP/rNcjg2yZgtguHKI
         Ki//hm49F0AnZObq4RnxB3yMOEpmZV0Ie9CrP6tmkSC7ovL3XNyVtoEMMy/RF4rMuXHa
         TpaRSZuRPzI5Z2u76bHvOzGwlfeDPywKhh/w5ntynuOnBq6iRyjpUzkPe8HtM0tKqWyw
         o47w==
X-Forwarded-Encrypted: i=1; AKwUvBxjzeClkxNvV1Z2iFH2CXfkUoU7Pu52cqEvPtVNZZNw+UasPJUVVI9BWweH3bYmYJP1NGvNdlld6Maa@vger.kernel.org
X-Gm-Message-State: AFuF++ksjJhNfoxKxftZQAEp8Pbf/9JK9xkJYnlzgQmeYJBb1Umv0u3L
	FjXlzzCZUvVFq5E/LkOu2A0ZLgVb9QO6fAMBq63Bvpm2uOm3xY5/7HYh
X-Gm-Gg: AYBFou0KKa+5/FyhMZMJKgyZbvSHXfSlOrhPQYX8J9LmM5OzKTRQ+52Wmt6aVAkVCt7
	zs9eZtL3UJPU80bOkfEHHapd5209GewHCQRq9XLG4RMQ16XibwNJCuCozktQRCJWOrA2rGO488B
	5bgEW/EzHB1jWJVD3IsK8Z4r5omdBQpdWlWygnzakgchizO4mELJ4EC9INrvrmVtRQw6KrXFDal
	3F6EVRj5LkmNaV56HtC71WWLdGu0TER9pQeiGf9RnfLThqy3lVxdMz9bKNZLA+wDb82kl+oR80s
	Q0GLhV4TvXfyDNxAT8QwOT5a1tvcO7Av4hSJkVeBrvsUKBeLJjtdz12SDx/XONM531YxKMVNzbN
	GvCju2IB0ayqepXHoOO+XFZJw4XFfgz6w/y2uODhzUJQTS2/rhcJzcfrdFzvbVIfoVj1a/p34gQ
	llndFnhNKgI/eodnWOfPPZlQmw+m4C2QqnL1zkB0vdhjCH24K8CiOmCoBN+wnCwovh+aTlkT+Yr
	SlTKJWcslVWku6MFbLYZkbdxD3bmp6uRE3V61faNsGKH5Q/0KwX3lvbbqtJ/2MISqguawEEQsOk
	YEmaSyldBUpk/qJJ0aqzZBdF9D3Iwoaw+DZMwYkaJc9WWlZdX2UrgzmxOcu+Pf86yg==
X-Received: by 2002:a05:600c:83c8:b0:49c:d52e:d0ea with SMTP id 5b1f17b1804b1-49ce581779dmr132214455e9.4.1788373700879;
        Wed, 02 Sep 2026 11:28:20 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a1c2-c401-11b2-c123-0d12-6c0f.310.pool.telefonica.de. [2a02:3100:a1c2:c401:11b2:c123:d12:6c0f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5dea34sm10208755e9.10.2026.09.02.11.28.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Sep 2026 11:28:19 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: pin DFS superblock in iterator callback
Date: Wed,  2 Sep 2026 20:28:14 +0200
Message-Id: <20260902182814.25700-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tcon_super_cb() stores a raw superblock pointer, but __cifs_get_super()
takes its active reference only after iterate_supers_type() has dropped
s_umount and its passive reference. Concurrent DFS automount expiry can
therefore free the superblock before cifs_sb_active() uses it.

A deterministic KASAN test reproduces the race as:

  BUG: KASAN: slab-use-after-free in cifs_sb_active+0x77/0x80

The same test passes with this change applied.

Take the active reference in the callback while iterate_supers_type()
still holds s_umount shared. cifs_put_tcp_super() remains the matching
release.

Fixes: bacd704a95ad ("cifs: handle prefix paths in reconnect")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Testing: x86_64 QEMU KASAN A/B with deterministic KUnit synchronization
around the lifetime gap and real VFS superblock allocation/teardown.
Baseline reports a slab-use-after-free in cifs_sb_active(); fixed passes.

 fs/smb/client/misc.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 46e1382e8e04b..d4db3f91a91fa 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -891,8 +891,14 @@ static void tcon_super_cb(struct super_block *sb, void *arg)
 	     t1->ses->dfs_root_ses == t2->ses->dfs_root_ses) &&
 	    t1->ses->server == t2->ses->server &&
 	    t2->origin_fullpath &&
-	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath))
+	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath)) {
+		/*
+		 * Take the active reference while iterate_supers_type() still
+		 * holds s_umount shared.
+		 */
+		cifs_sb_active(sb);
 		sd->sb = sb;
+	}
 	spin_unlock(&t2->tc_lock);
 }
 
@@ -909,15 +915,8 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
 
 	for (; *fs_type; fs_type++) {
 		iterate_supers_type(*fs_type, f, &sd);
-		if (sd.sb) {
-			/*
-			 * Grab an active reference in order to prevent automounts (DFS links)
-			 * of expiring and then freeing up our cifs superblock pointer while
-			 * we're doing failover.
-			 */
-			cifs_sb_active(sd.sb);
+		if (sd.sb)
 			return sd.sb;
-		}
 	}
 	pr_warn_once("%s: could not find dfs superblock\n", __func__);
 	return ERR_PTR(-EINVAL);
-- 
2.53.0
