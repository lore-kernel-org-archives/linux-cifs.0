Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11C4C433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jan 2021 20:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 817AD22D5A
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jan 2021 20:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhAEUXC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jan 2021 15:23:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726512AbhAEUXB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jan 2021 15:23:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609878095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MOxye5B0xRpCyzwF8z9vUvxQiwEx40pS01MW13zeLxA=;
        b=h8Kb6D8ILj/F/7iOB5oBLAyAJes9lJmYg4xi27aXUB3W/u4LIG7wu5MaTiWVVKThz5oDPf
        uG5xI5wiDI2R/VPpp3yuqFLOPzDfnDy0fUm5ECv+pmplQHL59qtn6pYitq3xVkQCqR8M88
        h0ZLA2vKFRRyX31eV/bDbvRqu1NhCxc=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-K4O_pBcRM1a0doHuUO2ZFg-1; Tue, 05 Jan 2021 15:21:33 -0500
X-MC-Unique: K4O_pBcRM1a0doHuUO2ZFg-1
Received: by mail-pf1-f200.google.com with SMTP id 68so292012pfx.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Jan 2021 12:21:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MOxye5B0xRpCyzwF8z9vUvxQiwEx40pS01MW13zeLxA=;
        b=IAruPYN5PigGGJrBEySDTwGYgzgGm4cdlz/KmHLEUo03Ecj9dus8c6p0nig8eFgsOz
         5u+0c5ZwyPqAD9x0ZRiVMajatZJKRjFHpmJOoD47uQ/N8RU5KMQ4BUQlJ14JcWdtkM5c
         J810Mh36au2sYq+CDxd9Y6Q/teK1x2coMDgVsvRu7JJFQkRvO3iWHjbiFvfuLc3UZ81y
         25vOtpM1AIhkqYFqkjxDryDdRXZM8ZxZcUqOPNbif/8X5OR0M0ABFzTtgkCKQCWcZb+M
         agt0HhKL8hL0T8PA9hH+YVqLFH9Z4SnEa/ppzl1JH/ZdK04gYK3iKT1EFvhvZpF1mR58
         jPsA==
X-Gm-Message-State: AOAM531rRfz/ByAcAxEY/j6SZWEtnO4X9cZ7CqmlnyLk4y3+8kygYqgN
        KbNz6SaUhgIXHz0ghcOrO1wQ2z4bDDaah6bKsdxGg1q2aXO9clp5WagWnyphsEoNjEFZ+5VDxew
        M/jW0BJTc9nWWNMIiAsRdpg==
X-Received: by 2002:a17:902:7449:b029:dc:bc:65de with SMTP id e9-20020a1709027449b02900dc00bc65demr825404plt.79.1609878092724;
        Tue, 05 Jan 2021 12:21:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSCA1TziBhfZbpw9kQ4ZJomdu0NlSOVGWB0ZiQQ4WYKC/eOIbFu+WMfWAXp5cnbDbZ8WYVPw==
X-Received: by 2002:a17:902:7449:b029:dc:bc:65de with SMTP id e9-20020a1709027449b02900dc00bc65demr825384plt.79.1609878092509;
        Tue, 05 Jan 2021 12:21:32 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id u189sm225398pfb.51.2021.01.05.12.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 12:21:31 -0800 (PST)
From:   trix@redhat.com
To:     sfrench@samba.org, natechancellor@gmail.com,
        ndesaulniers@google.com, aaptel@suse.com, palcantara@suse.de
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] cifs: check pointer before freeing
Date:   Tue,  5 Jan 2021 12:21:26 -0800
Message-Id: <20210105202126.2879650-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem

dfs_cache.c:591:2: warning: Argument to kfree() is a constant address
  (18446744073709551614), which is not memory allocated by malloc()
        kfree(vi);
        ^~~~~~~~~

In dfs_cache_del_vol() the volume info pointer 'vi' being freed
is the return of a call to find_vol().  The large constant address
is find_vol() returning an error.

Add an error check to dfs_cache_del_vol() similar to the one done
in dfs_cache_update_vol().

Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 fs/cifs/dfs_cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 6ad6ba5f6ebe..0fdb0de7ff86 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1260,7 +1260,8 @@ void dfs_cache_del_vol(const char *fullpath)
 	vi = find_vol(fullpath);
 	spin_unlock(&vol_list_lock);
 
-	kref_put(&vi->refcnt, vol_release);
+	if (!IS_ERR(vi))
+		kref_put(&vi->refcnt, vol_release);
 }
 
 /**
-- 
2.27.0

