Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C033FCB0C
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785273286; cv=none; b=KRftE/5Su9QuUN8wAgaVxLkMJW8tscUeo7XH6kK3c/6oRZH6eOAlZlc2fjCQh1Fs/gyzW45swrDY3B/De/tNAOWAzuMgnU0Z79XlVMMDgY8xpVJE3D2apJqDNSrGOq+yAZdKUWnwZaSYPLz8Ac0DYfox8VUKQUcSRdBYifKEmlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785273286; c=relaxed/simple;
	bh=DqAqRnbUNlTORrhBs/lWNFctAiTZF4VUpHwYY6un5rU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cInpUwz7lCS+BvN/X7f7WQUL9lxvIseoBpPiXTC8whrPZvZq26ZYjy6A+wXNVgz9AdoYdMIMSO2srLozp+7zk7LR5LW71u8+aylW1lePiyN83GfvrHXbbJAQmGvTSPFeKjXMPPdfXwtRd9Wvhv5iRSrc+YxPvofqhtazoA8MZgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WMJDBRT4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kmf3mQH2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WMJDBRT4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kmf3mQH2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785273284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JW6UwkCOTxl1ZHt6YtPnR1cDJEXYWIjbKtaRS2hmp1w=;
	b=WMJDBRT4tztvnyzFWTA7PjaTgD78ORVbRX1IPbdkzddvSaFo/hujkMADI6Xa5GNan8K7G0
	YfKTC2wMXvs1n0oRGKDTgJy9dQvB9E8UBgk87obQOKy90XOHjYRolXKnSvjroiP1wKU349
	RIGSxHvWNlws9mEnP7WWpOYQBL0D+w4=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-2h8SEn3aNiafJjfdHV2IpA-1; Tue, 28 Jul 2026 17:14:42 -0400
X-MC-Unique: 2h8SEn3aNiafJjfdHV2IpA-1
X-Mimecast-MFC-AGG-ID: 2h8SEn3aNiafJjfdHV2IpA_1785273282
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-495b0cf250dso143376b6e.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 14:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785273282; x=1785878082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JW6UwkCOTxl1ZHt6YtPnR1cDJEXYWIjbKtaRS2hmp1w=;
        b=Kmf3mQH2gAY3eYl2onLQM0XKoH7VyZmZGjBlblmmJ+1n4iF1GcMDrZnuPBUhPPn5ZW
         Mhark88kY4wU97hwuAVDEAvsEQ4+X9kJWJkYNkAWZZr4JIxlaEEHcWjerEBOK6KkWaJ1
         GuJOFLUoXFIxpFae8dMiyvxbSZesfWoNJ8E33Qc2g1hYB2+vGLox06UXN65/xIeBhECT
         kk7TzbXuEhhPHUODYs5m2ZQm1CGgXasnOZpovBzLiBSPpb47rcylvXBU2Th5jgD5AHRh
         BzydKqk80yMbhpyolxqY346ban8iNzSqZbzb8b7S4Lyna5GFhKtsFzFBPaHZOG11Fxgc
         5FAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785273282; x=1785878082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JW6UwkCOTxl1ZHt6YtPnR1cDJEXYWIjbKtaRS2hmp1w=;
        b=lUb/5jYzrsRUuIGfmsxoPK/2YOVeofDl/J3OzOcKcfsFbVjNqW85Mf0h23tCq6TUGi
         r6giWqw4OjLQ1eu5S/ti+HF7bzfWJgosSHzCDdqwUPOuCEtCZ5xaWhaDG7jMkUCS7jnp
         0vPQKynQC57b5fcPipxC8Lxsam53G2nRPp4sF13x0v/6VwjCuguTkrzAWZNQenVw3MOp
         OscmdT9NCDHE9jcRxQ4pVNxHlbKfEBSQ8KJdHrzVbDE9c8+epxM6zSSYG8bxI2Zzd6wv
         o6CZtLBsAv9apsfaSX99Ch7yXD7vrud0iPew/2R91k9k1bRXjogmHant0YFJF/XzVL2p
         LNgw==
X-Gm-Message-State: AOJu0Yyb9LhaTzeO+sYGM7UvCQ942FVJn5AFI40HxZbD4pfv1eKMceVK
	Aq/t2JjnICQgXN75uauR6DmfcjbMul3DXOpJp3LTa6IRz4/onGCaWS3zqH2lE1q1OjsV2UMMHBy
	lIbwwutkQGK9D78VRrlOM9q+/Gz18nBlufvW7DkHDjDB6GbgllhWxCzJ/0H+v+Zi4bcA4zEGRGP
	K8/TByervBHZOjQNCNBXU8c9J8TkXAkwyOkI66cSMSDUzykY0=
X-Gm-Gg: AR+sD12TeLZqab4SlKAYL/yxY7QAf2bVeq2LorH2xUJ0dqdcAW3NnpZ4nvqOuVXAyJp
	BM7UXovqeWC8QpgJGRC5i1RiYHE2CJpjFjZH4OrzjZHUwTR4FtQL04SDuyH9Na4tMvyhY4qDuJ9
	ozprj2ipBD7BopjIVHGJAD36T1ilPwm6OaiKgixxZ29q8KD+NTdhgjSQlXtE2v4YGnyJVU6eokj
	0ee2URVYPsFh+/fexSWMyF0KpKwpaq3CL72sPAcIqrE4DyjxenuOWRVz9RraPW0apQ5/VGiOTe7
	CfPiLYUhUjey4QjDTPWbCiJqdObQk2JY1mgnC+KT9lj7Yo9WKthtx1gKKuSQGLC1KWE0RTrLvEn
	X3n4qQxLFzmsClNugcplBBEOx+ebxJV6JmTBKUjyRxun89vojiYzwV4EOuIU+
X-Received: by 2002:a05:6808:3190:b0:495:eb86:6e8f with SMTP id 5614622812f47-4ad5b878bb7mr2215277b6e.14.1785273281925;
        Tue, 28 Jul 2026 14:14:41 -0700 (PDT)
X-Received: by 2002:a05:6808:3190:b0:495:eb86:6e8f with SMTP id 5614622812f47-4ad5b878bb7mr2215256b6e.14.1785273281235;
        Tue, 28 Jul 2026 14:14:41 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ad6ed2dedasm231357b6e.7.2026.07.28.14.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:14:40 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 0/3] cifs: follow-on fixes and cleanup after fscache_resize_cookie() consolidation
Date: Tue, 28 Jul 2026 16:14:35 -0500
Message-ID: <20260728211438.3859107-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit fa724e235cfd ("cifs: add fscache_resize_cookie() to
cifs_setsize()") consolidated fscache cookie resizing into cifs_setsize(),
two paths needed follow-on fixes and two dead-code blocks became removable.

Patch 1 fixes cifs_do_truncate() (O_TRUNC via cifs_open()).  The fscache
cookie is still quiescent at that point--fscache_use_cookie() is called
later in the same function--so fscache_begin_operation() returns failure
and fscache_resize_cookie() is a null operation.  The correct fix is
cifs_invalidate_cache(), which works on quiescent cookies: it
unconditionally increments inval_counter and sets
FSCACHE_COOKIE_NO_DATA_TO_READ, preventing stale cached data from being
served once the cookie is later activated.

Patches 2 and 3 remove dead code.  Patch 2 removes a caller-side
truncate_setsize() + fscache_resize_cookie() block from
cifs_remap_file_range() that became redundant once smb2_duplicate_extents()
started performing the full size update via cifs_setsize() under the
i_rwsem held by lock_two_nondirectories().  Patch 3 removes equivalent
dead blocks from cifs_setattr_unix() and cifs_setattr_nounix(): since
cifs_file_set_size() calls cifs_setsize() on success, i_size always equals
attrs->ia_size on the success path, making the subsequent size-inequality
blocks unreachable.

Frank Sorenson (3):
  cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
  cifs: remove redundant size-update block in cifs_remap_file_range()
  cifs: remove dead size-update blocks in cifs_setattr_unix/nounix

 fs/smb/client/cifsfs.c |  6 +-----
 fs/smb/client/file.c   |  1 +
 fs/smb/client/inode.c  | 14 --------------
 3 files changed, 2 insertions(+), 19 deletions(-)

-- 
2.55.0

