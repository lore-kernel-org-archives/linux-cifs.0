Return-Path: <SRS0=Ax8g=T4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E81C04AB3
	for <linux-cifs@archiver.kernel.org>; Tue, 28 May 2019 01:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEA4B2075E
	for <linux-cifs@archiver.kernel.org>; Tue, 28 May 2019 01:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONA1eRsU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfE1BNK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 May 2019 21:13:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36737 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfE1BNK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 May 2019 21:13:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id d21so7606158plr.3;
        Mon, 27 May 2019 18:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=kJoaVY4+Sc4R80CmlMM5gY/c+co5CrzbP+Oe/Lgmn0o=;
        b=ONA1eRsUHXpj3191QHoHKIlANLkvzRTLYH+rGr/P7qjuk2bPvZwdzvRHR43GVF8sF3
         2pfz69hp0iffZFDkTQ3/dZ7ZZmXucnjabmjSDYhnPM/fJ9WGit178nG7uBg+AuYfjZ+i
         c/rZVn8eY2iOLlCmUCPiOBJdEIphrvmwX+6AtMbLB+x6y88k6UvqdmQVbJIY1JWfnaJg
         cYiB96znUKHzqpVQG59Aw/OUY9huW5oC5brPrA7WCwXH3zrNgUtEikID30zcw7FtjzrK
         6nIhBbIPZE/W2wUQGZZV6WI4mxPs9j53BYFTS4kueL6Lyp5zsW/HZ8y0qKOHL70J4VV/
         /wUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=kJoaVY4+Sc4R80CmlMM5gY/c+co5CrzbP+Oe/Lgmn0o=;
        b=nFQSmq24/8XAOZ8U0B20S4m3SUpi7cx1ZKJ8rcEKeixOOBOYFne2FP7U0YDD3jaaDl
         4lsB6CuX2qPMtnucPXIk3HS0S5JuNYjYHs3MiNn5sev09wdbEL6k3I9kq9/3ITL8aEGn
         sSDGtlmrd20SLst0u268REdmShOkokCm8+QpsAN83e77z512+WLXCepVAmkV8AxLlLvB
         A6rLQlN0xBVhiO62ghdg27HPyP5pVsAu9yEJChggdL6qWVSaA6+eYpeW4Wks/4YZxw2i
         COfDi/Xwbop4jrNJRYe2zfUjh1Ny72+VdVQlcp3SK+Wt+NomvGf1YHkFvmFMq5XNciPw
         FVzA==
X-Gm-Message-State: APjAAAU8DYu5wtQ9hIheph/GcEcC3Mqji+1kw9Ob4sBqcykpYjRV5NYf
        2stEq6+J4V38yx/Hicn6xes=
X-Google-Smtp-Source: APXvYqys/OQsg7fmKmg0hntv7kPN8os/T/gFBreaIDUbivdlpUp0VsSjEVePxMvAtohMwwgq6JxbQQ==
X-Received: by 2002:a17:902:4381:: with SMTP id j1mr30770425pld.286.1559005989583;
        Mon, 27 May 2019 18:13:09 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id 80sm6841049pfv.38.2019.05.27.18.13.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 18:13:08 -0700 (PDT)
Date:   Tue, 28 May 2019 09:12:39 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dfs_cache: fix a wrong use of kfree in flush_cache_ent()
Message-ID: <20190528011239.GA12886@zhanggen-UX430UQ>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In flush_cache_ent(), 'ce->ce_path' is allocated by kstrdup_const().
It should be freed by kfree_const(), rather than kfree().

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
---
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 85dc89d..e3e1c13 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -132,7 +132,7 @@ static inline void flush_cache_ent(struct dfs_cache_entry *ce)
 		return;
 
 	hlist_del_init_rcu(&ce->ce_hlist);
-	kfree(ce->ce_path);
+	kfree_const(ce->ce_path);
 	free_tgts(ce);
 	dfs_cache_count--;
 	call_rcu(&ce->ce_rcu, free_cache_entry);
@@ -422,7 +422,7 @@ alloc_cache_entry(const char *path, const struct dfs_info3_param *refs,
 
 	rc = copy_ref_data(refs, numrefs, ce, NULL);
 	if (rc) {
-		kfree(ce->ce_path);
+		kfree_const(ce->ce_path);
 		kmem_cache_free(dfs_cache_slab, ce);
 		ce = ERR_PTR(rc);
 	}
---
