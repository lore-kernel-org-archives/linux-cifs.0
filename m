Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B472C21F4
	for <linux-cifs@vger.kernel.org>; Sat,  8 Aug 2026 20:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786220958; cv=none; b=Cowrl6fldd2pt/OMzACqUJLH//2RfeJNZz2cAF61LUBLt5rKGHMfMHZ0wzmKmKJRc+ACz6ntn46y6U24OoZ3mNyC7EPcevdBI7VZZLJAjlp7WFtWWt/lbXccOz9yJQnfIeHn3EBqdsjiUKHdH8xvfM2fRVC2Uv27DyMWjrt00xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786220958; c=relaxed/simple;
	bh=vhcmDTY6qjfy8npx7nlxa6iA6oVkAH5PeX6RESA+QD0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uUdB+JgMce75kyvGud4AOTwemuZWzyAFgvoQuVjPjk29lF6Zlgm14zmCzaQ0id4RMseMmcVd2cifzqnRa3PBm8Qk3XUjgGqYGCGF8gn8EDPAZETpHuYXGUmns2GTM5CQqiCYNZb/Y0heG22hAM0VjgMLqKR6xuUt3yi0bEgFSb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bNhI8iXx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Le/9y/Dn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bNhI8iXx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Le/9y/Dn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786220955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5gqj2FEl8T1M1QZUvQzrrya3j74szw2oHrcQLRnufC0=;
	b=bNhI8iXxHxVbVNq+HN3ewOhFIJMYNRlpGF/v1iMEw+NvFpp6sg3KdxQM+Esf/fLnhIHeW6
	mYsdFqcRIeimhgi8tJtw7vKbIAe+PWBgH5ad0WzynAZjJY2p99CQp3QxbkFK5t7LC3cPbn
	Q/18qe+pGii8F9zZQfCFX+RSzpCC62w=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-5hbfVsFkOrmgSzWasO-kcw-1; Sat, 08 Aug 2026 16:29:09 -0400
X-MC-Unique: 5hbfVsFkOrmgSzWasO-kcw-1
X-Mimecast-MFC-AGG-ID: 5hbfVsFkOrmgSzWasO-kcw_1786220948
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c20762d21so8524481cf.0
        for <linux-cifs@vger.kernel.org>; Sat, 08 Aug 2026 13:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786220948; x=1786825748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5gqj2FEl8T1M1QZUvQzrrya3j74szw2oHrcQLRnufC0=;
        b=Le/9y/DnKb2L/9vnc727V3Cu4uYNWic+IweU7agD+eQ0Pb5NPRgUfvQZw1YMPooBdS
         9CAtpPK0MywpgyXRWftQ2ZLgK/mVDl7VZzGPpNFbctEKDfH7ff5RYpN/nQtVcYl64wrR
         qjsFtj9uvqNhx0vWTKcBVQWQTN0gBFDMXtkFrDfUNH2Un6z34Z2muH34wdcF+dgM20wf
         cEYXNi9m70jW8FCx1Uxdyq/gKk1UuWWQifYPcn5er3srcizA8VyCKvYCf/g33EwjlO/N
         V5tqCHfdb/5F7NB3e3DFLKVcC9+uQwWQRtGtSNqKbHXgAT8Se64p/Ig+KzIJYOEZNUpG
         5Lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786220948; x=1786825748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5gqj2FEl8T1M1QZUvQzrrya3j74szw2oHrcQLRnufC0=;
        b=LjKGPvQoaPXIu49AapWb5jVdxXKEyQbi6vZWBeArAcvMeQsLTbDpJjrb40hfLRD2bK
         s6Jx8fWNPhm8W0imFyrg+g5KD0f//gMBTqMn0esnlRAOg+GZQfNKvtp5XCA9oLa9nt6i
         rXR7tFAwZdZUsYKQnErYxRx1i9qar8HQaFNIHgQKSTczgaEgkgFRWJsbMsx6teFuwOsU
         38J4K3xj8hNZByoAHguAoRebmrdOalSUOPC/WO2MSEFEx/I31t1y7Xo0sYjMmObKjYFK
         OmW9Xkha4oe6iaGIr66+gRKMYZPM9SeroXlVTGH13Z/8bmuHXiGtYgKQ7KJezw0JaLA2
         uvZQ==
X-Gm-Message-State: AOJu0YyJxiKog6H/rwGAseYcQVdWwIxcMtHWrW9hNIGCFGkYoO2IzQTj
	FGWLi9PNmKPiJzC1NUtv0b8frRi8lmgcTzkHW0/YvUbBHOaOaVEOvlIPYlf53+3ag2hLMhR0tbw
	AFzPK05Vncmi+d+KD2ue8uENJgOzNNwOvkYFE2RBHGNyFA8QuUW8GRLe7NyPd6sL0jEaVb3Ttkj
	+yOiQnrACmGJSORE1DpBfl4BlGIcrPGrZyJTzhlj82HtUJAK4=
X-Gm-Gg: AR+sD10q/IlJlWFpCDVjWULxLQ57Ueua+FLZ9trvRYv10QQGy2fv0TfYEtvf9Oj+GqA
	Jeimu7RpxidQaGR1DILzWtpEM0vkCcwza4SUQpVP4SlyAPJQyjwJbf9ndB34uYbj/yO7Clm2bVR
	t3C5wWoFWaxSfqzPA34JLDRWECyDAw2s3sB9cubtP/oTj3DMA2856ITpG037iT//iNl69QwaoPE
	fKjSQpjUsz4rEiMlnvDMNmXXIMm8GR4+ejeSW+j0G2Z/YgrDDgVOt2BhzcOAcr8wSn7Ib93VaT8
	QEwajN8uSXpgLbX+9NHTw1X9lOXm/iWaM4RhqRUElwoeTX3RtCJ0SNhm+Pz9BW9ePLMk98nBWtF
	icMFjx3cRiPSCRblRHpDrpwtCLvlBex7cah0l9quUqweqgQcjGFjEXDCCt2EkKAkhHQ==
X-Received: by 2002:a05:622a:1ba3:b0:51c:1d67:379 with SMTP id d75a77b69052e-52d18fd354cmr131481821cf.23.1786220948391;
        Sat, 08 Aug 2026 13:29:08 -0700 (PDT)
X-Received: by 2002:a05:622a:1ba3:b0:51c:1d67:379 with SMTP id d75a77b69052e-52d18fd354cmr131481401cf.23.1786220947843;
        Sat, 08 Aug 2026 13:29:07 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a91b4a6csm36961106d6.15.2026.08.08.13.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 13:29:06 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH] cifs: fix clearing stats for fastest execution of each smb2 command
Date: Sat,  8 Aug 2026 15:29:03 -0500
Message-ID: <20260808202903.172277-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code to clear the 'fastest_cmd' statistics has a typo that
repeatedly clears the stat for cmd 0, rather than iterating
through each cmd.  Fix the typo (0->i).

Fixes: 433b8dd7672be ("SMB3: Track total time spent on roundtrips for each SMB3 command")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifs_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 4ed4f55a0bb7..3761d3ad6088 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -754,7 +754,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 				atomic_set(&server->smb2slowcmd[i], 0);
 				server->time_per_cmd[i] = 0;
 				server->slowest_cmd[i] = 0;
-				server->fastest_cmd[0] = 0;
+				server->fastest_cmd[i] = 0;
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-- 
2.55.0

