Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91CD2E7380
	for <linux-cifs@vger.kernel.org>; Thu,  3 Sep 2026 01:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788399229; cv=none; b=jvsrHyjRdLUlcgIQKhgfgKDzSc6giATykY75q2zia3G5OifR1LRrzxIEdn0Mqzzmkdu9JCtPk1ilO9SpsUJKMSOHA41HSCKrf2sTZg1WbPX3SY2gxkkwOrN7+41MUsI4StMwo95yo1HHMeOpg0V673Eqkt0ctdE+ZsaU+GojhNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788399229; c=relaxed/simple;
	bh=BSQQzVNIuupTKWHkDHInQ5UQ2OhS26ABbsbDxBswT/E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pAMG08YZHy2vicsjSE1qd6L3n9QK8mmPU0a82AwNrHJVNLIEqG5TNGYUrQuStMpTUT991pPdQo0q++MWjrxbrXz18ZrroyDGxynfxiGwt5BBiduh//Ttv9owRIInjweXbLYw8utf0cOvXrpiFCNrKboXEP0h7wKdac4nDoYvBCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n+u6506U; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n+u6506U"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-484374f54d0so1101608f8f.3
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 18:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788399226; x=1789004026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EVU2xXIwX74fn3t2r/Vw9dgcDAmgQOJ1XEy2yGBRzGw=;
        b=n+u6506UUZxMIUyB1HWGzkgal3KkYaeRENWHfRqBPMs40eQcTF+IGyg9fkP1LnvAaI
         oAhP7la/IWVzl80GaoApzFYdhYRJywaPb9yQ3RpF42xhUuHrfZwFdpCB8u70fPMbItKS
         sjAuH0u9N0K3wg9KDT5CBLQhZ98CLqWkbGY0rnYWCS5B8Q4ujzbbRfZZVQma3d2PCnnn
         Mu51sPOgYsr1/6/xkJC6R2zTghyOKqscGFn3HwDofLqhpWc3J1RcbpNrXEkL3FUzs2MG
         VW4z9ZpzVmaxXAHftpXKoukyn8Jyky9465DNAjyWm2xC3ih6rjKMN0PtypeICZtBNmYT
         PtlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788399226; x=1789004026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EVU2xXIwX74fn3t2r/Vw9dgcDAmgQOJ1XEy2yGBRzGw=;
        b=EjkkU0vm8yJxwPrqGmE2Ogl/N2L+rxkUiDVviiLkDVDBFLK3/JIQSN7vU63Pqu2pSi
         Se6Epw/K48TeQ4jGsgrSsda7Bx/eSko0ola2fJ+L7icp8aP61hHqE7gHcbQpvNxy73IF
         iD6YH5TM6Kl3BZsOuRUdQpwvI6USiDZsLCtPWC4GdJLbYGmf/uJeHORCAtQ4z6n67ALR
         /XsV40Jgqmoq/fnSvY48+/gq/3EFxto4OQISSmvbhyEGTyp7FVXOq8my4i9wAU6NB4eG
         oHfAghDrEeAe5ShmeiDs5+yfP+zlrDJO7wK4GrlVfuwLBKC32ZgwNcUCCemGRV1fqfA7
         3Jhg==
X-Forwarded-Encrypted: i=1; AKwUvBzvQrz1V0pu+UY0DLL9QvR5V/eTDoeNoLo0doJfGkPIQa3THS7deKb7YzMutqyP77U6xmU4CG/lZPsx@vger.kernel.org
X-Gm-Message-State: AFuF++lI8euIAbLD+LxpFT0Hc7LnbPzNaOAS45kgrwcfHZpvSeIytHFu
	OjyxdqE1Mia9vrLveitfGFET4Ah0QtMvdeNqGVvyeAQn52nVdWutcmtc
X-Gm-Gg: AYBFou0+B0MMARdA1qLqRV2Cf14Iooj7GKlwICJu+LMUp80byYbdAfm5mV4e8eirpCd
	7lVKCyKoZRsHwqYf0XpLZ0NQPmLjJ/uz2B+ELMzERi8bBGpT1NRCuHtj6lY3hsux4wDGWeZnLHV
	/2uZjl0ypko0yA3cndD2OeWuDos1Qxshb+YzJRRc6FR6buOpqcl2hT4hlApDT8xa1fHtbXpgdRC
	fUErs735wrUIaG8Yn4sLAYcxoySiZ+TlB1awC7Qh/5DLsKJ2TPcF4YikaBwZ7c+FT2RVGqi2j5c
	00pKp2VDrW2ilaot1m2/vu0nX1+zzvPu/XqjzkJ2QHLjf2J6uomExogxT0khmLbyaHBtwkCgs7f
	lZeKLTOcvyji6IdFjXFEThSKW4DZPENFZQFuxUGS8LKZMNQVDHN2gkVXlAvLCo+nc48u3m8mAuv
	rYI72+VCaeiamkxLyDmEDZEaorLq0PZD79wTHiSJvhOwTKle+yBUoVO8To/ZEMkqw2Id/m/iNa3
	jYHqZ/HcJ5MkIhx9Ps6VC+bKE7ZK+FmHnbgGORNHcEX4qw4vgjHNyLnrm9eCdFe+Q163xax+mz+
	MAPvHAX1ZpIcBrAOsf1qJUm4rwDeUz97UljuSJ4v1G9mwn8dr4TLnjvWvDT31HCUwQduz30=
X-Received: by 2002:a05:6000:4813:b0:485:81b9:4e79 with SMTP id ffacd0b85a97d-48581b9523dmr1775697f8f.7.1788399225660;
        Wed, 02 Sep 2026 18:33:45 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a1c2-c401-11b2-c123-0d12-6c0f.310.pool.telefonica.de. [2a02:3100:a1c2:c401:11b2:c123:d12:6c0f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448eea5b4sm10241187f8f.27.2026.09.02.18.33.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Sep 2026 18:33:44 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Paulo Alcantara <pc@manguebit.org>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] super: make iterate_supers_type() deletion-safe
Date: Thu,  3 Sep 2026 03:33:36 +0200
Message-Id: <20260903013336.92081-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iterate_supers_type() drops sb_lock while invoking the callback and keeps
only a passive reference to the current superblock. That reference keeps
the object allocated, but does not keep its s_instances node linked.

After the callback releases s_umount, final teardown can unlink the current
s_instances node. The iterator then advances through a reinitialized node.
With the current hlist it stops without visiting the remaining superblocks.
The unlink moved from generic_shutdown_super() to kill_super_notify(), but
the cursor lifetime has been unsafe since the helper was introduced.

The CIFS DFS lookup can consequently miss a matching superblock and return
-EINVAL.

Walk the global superblock list in reverse and filter it by filesystem
type. A passive reference keeps its s_list node linked, and reverse
traversal preserves newest-first visitation. Superblocks removed from
fs_supers remain on the global list, but teardown marks them SB_DYING
before unlinking them, so the existing filter excludes them.

This broadens the scan from superblocks of one type to all superblocks.
The only in-tree caller is the CIFS DFS lookup, so the broader scan is
limited to that path.

Fixes: 43e15cdbefea ("new helper: iterate_supers_type()")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Testing: x86_64 QEMU deterministic KUnit A/B using the actual CIFS lookup
callback over temporary VFS superblocks. Baseline skipped the surviving
match after teardown of the preceding nonmatch and returned -EINVAL. With
only this patch applied, the same test passed.

A real Samba DFS server and the kernel CIFS client were then run in the
same QEMU guest over loopback. Baseline and patch-only kernels both followed
the referrals and completed 20 reconnects while two workers repeatedly
mounted and unmounted independent CIFS superblocks. The patch-only run
successfully mounted, read from, and unmounted CIFS shares 95 times. Kprobes
recorded 110 DFS lookup calls and 60 iterate_supers_type() calls. There were
no unmount failures, kernel warnings, oopses, or sanitizer reports. The
natural network stress did not hit the narrow race on baseline.

Stable is requested because concurrent DFS automount teardown can make a
reconnect lookup miss a live matching superblock.

Backport note: before dc3216b14160 ("super: ensure valid info"), the
s_instances unlink is in generic_shutdown_super(). Before 3ec9800c2d33
("super: convert s_count to refcount_t s_passive"), the passive reference is
named s_count.

 fs/super.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 05e4431730387..c8accd144bad2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1026,11 +1026,18 @@ void iterate_supers_type(struct file_system_type *type,
 	struct super_block *sb, *p = NULL;
 
 	spin_lock(&sb_lock);
-	hlist_for_each_entry(sb, &type->fs_supers, s_instances) {
+	/*
+	 * The passive reference keeps the s_list cursor valid while sb_lock
+	 * is dropped. Entries are added at the tail. Walk backwards to retain
+	 * newest-first visitation.
+	 */
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
 		bool locked;
 
 		if (super_flags(sb, SB_DYING))
 			continue;
+		if (sb->s_type != type)
+			continue;
 
 		if (!refcount_inc_not_zero(&sb->s_passive))
 			continue;
-- 
2.53.0
