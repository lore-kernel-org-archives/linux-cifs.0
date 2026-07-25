Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DF73093D8
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 21:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785013492; cv=none; b=UuUZYyfNGEJPcIx9L6MPCFzaySNddiq7KE4FkYJUYMpGu8lY3kUIQf97BcBjiCUDXqMVMLqX4w05dX8F4SOgfQ8IaS2aLDDQMd+QNtfpf+4UBanewbMWoRRBPWxozHedb3CnoEeA9su3hElc5ziq3f6LRA0cZYXN2M7gS1mgnLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785013492; c=relaxed/simple;
	bh=H5VyCp8iiX4IVq4dhnEZduRcVI6yJ7KxArP9t8h21Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VIb2s2wpnogPvk4Xor51NDfrTvYTXBBq6lfbOpHANcmFjaO+hxXaXCKA48Yml5mX+qNB8sczt8TTI6bu5yQBBMesqI6MFh4rqGItJ2//yP1Yn+jWHTkK2Fo5JRa/lYrUmkpJ5yvZuePT93FfNYJAueHTBG+8KJ6hKLij2D/1R3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HKldkizG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7UN7v0p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HKldkizG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7UN7v0p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785013489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uuZLFCpft3kD1D/f2ZvV2yaA3KOX7XLR88S5PlQHPyk=;
	b=HKldkizGbg5hqI49rj5xQfTTSJAQVKF1+7NmxQxWvVz2qkfrzALVz7ocDPK+Anc/y8acC8
	eKaXaCpH+fozq14yuJuEtSsTesEBdDtIjNJUv0vd0oeJRd15WKLGCFnL1g+DI4CNYfCVaV
	1ce8M3/Lt0UDhpAC0labqp1d1tR3/Us=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-Ga3ylOrINQubr22OyMDZ9A-1; Sat, 25 Jul 2026 17:04:48 -0400
X-MC-Unique: Ga3ylOrINQubr22OyMDZ9A-1
X-Mimecast-MFC-AGG-ID: Ga3ylOrINQubr22OyMDZ9A_1785013488
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a46e8eec4bso309689b6e.1
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 14:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785013487; x=1785618287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uuZLFCpft3kD1D/f2ZvV2yaA3KOX7XLR88S5PlQHPyk=;
        b=Y7UN7v0pH+50YXrMeDPmrDnGNN5lweOVw+tp2f55AxfU2t+mpbCmv4adHCM7Sc3ZZ8
         F4+22O8FIi5Ki7JTQvXHjS+m1FoAGABw0midMsceVE2KuPPnupsaYDVU0RG6JnglpTVF
         QQ/Wil9NbNYxYJ0gE/k+fv+df/PlkBvauu48JfzBVxf02gKbofMc5qeNuWkRdAa/nWbz
         P5vUTAHrLfPHqVH8XGnldzy2nDzI/p4Jok8X52XUUNyHDrc/+X+9i0M0Ts/EPOi49Dc+
         QpECjpuMQq50bxe6Vo9Sap04rdsxmOG7z9BC3BdkqQbCXaXIu+Q0Plt8GItBZ5kaQlsx
         vUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785013487; x=1785618287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uuZLFCpft3kD1D/f2ZvV2yaA3KOX7XLR88S5PlQHPyk=;
        b=jAoHKCTotGSYxwLlCYnuZYyiWRqwYwds9G8rENkgt1/6Ds8ETfimcvpjYUbyOSfy9h
         1whd/68lhlOc6q+nsaHkzF9E7g3VEfjOaTIgA5NxNB8KqDDiLxvhfOlquvX6gGYSXI8a
         kp21lDonDcoiLYOONfhaUB3KE4JZwzCCy/gqUTXzFRyKKqSpCA2VtqOU71Kpy+o/dW8C
         KoRv/aIvwB2XJ4CsnKFkNxoioF8m7Qn//Gaj6GmO6pMRJn6EvP31jRPsC+zsjSmU9HBh
         We/Hqw63INBKyNUb46yqR87RYrlACh1mPIDRwU2nfpARuQ1yry0uCLs0ZGE+gE7Xkf9C
         FeLA==
X-Gm-Message-State: AOJu0Yxm00y86CEbE/aMvFfarcFf0TjhXOku5Ihc46iEiU88nV/kgE5F
	EX20s/0VeYfI9SbPrP7IpmpJDjNN2ltZ4jRvQxacPS6ZVNnZzP1Cra6DenrFYo0nEfttxaIfkqk
	hTF0iDEj8J+/0TRyQm3x9ErZeFjS/nMG5+pWR+xOYPPulRDdL/Pr6Ne+UqLalh0WViI2c/JFgfZ
	Ej2uTSEtBzFiA3gMl6a9/ThVa7i5vU2oupMFx+bj9xxi9n9SRDNA==
X-Gm-Gg: AR+sD10xm/jLK3wAZsxf9tC/c9xVRP4Uz/U+GmPEvPZrKtDa2qFqn+jjWJrhZVGmEcE
	pkkTg0n79u4LyzogTtmxM7zenmyvI/He4CZWfiM9TZNAQytQF0IQ9p7slDdoRbHOH76MlL6yj56
	eOesvCSg4TyB9L70qDtWZPim3tN51OlsA8R70fsHOj/BIXOL5NwnLYH8qIM7qWyYQwMpmjPQMXk
	lpht8hAjgS9zpbQm2BOHsV33QUwG7NndfdIfXA+Z5teBkgiBQTIY8tDFh2kEaIb3QJYwQgcsabT
	rhP0dtxmfDr2NppBRuvqzamE7I5DmD9/ErBKTLHSJgOQ/uOwMlDX2FxWlA0cJcPRI2hzGrGay6s
	tiDQedLMQ3qFxNiEHdH2+a8D5yA/cYQOcmUkZ4RDiD7LhgX+IQyG+fNUhacek
X-Received: by 2002:a05:6808:1983:b0:490:b586:1459 with SMTP id 5614622812f47-4ab69eeebddmr3538716b6e.2.1785013487515;
        Sat, 25 Jul 2026 14:04:47 -0700 (PDT)
X-Received: by 2002:a05:6808:1983:b0:490:b586:1459 with SMTP id 5614622812f47-4ab69eeebddmr3538666b6e.2.1785013486948;
        Sat, 25 Jul 2026 14:04:46 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ab5d917dcasm3012306b6e.16.2026.07.25.14.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 14:04:46 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com
Cc: stable@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH v2] cifs: add fscache_resize_cookie() to cifs_setsize()
Date: Sat, 25 Jul 2026 21:04:44 +0000
Message-ID: <20260725210444.2997236-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several code paths update the VFS inode size by calling
netfs_resize_file() and cifs_setsize(), but omit the corresponding
fscache_resize_cookie() call, leaving the fscache cookie out of sync
with the actual file size:

  - cifs_file_set_size() in inode.c: server-side truncation via setattr
  - cifs_do_truncate() in file.c: truncates to zero on O_TRUNC open
  - smb2_duplicate_extents() in smb2ops.c: file clone extending EOF
  - smb3_simple_falloc() in smb2ops.c: two branches that extend EOF
    via write-range and SMB2_set_eof respectively

Since every caller of cifs_setsize() must resize the fscache cookie,
add the call to cifs_setsize() itself, consistent with how
truncate_pagecache() is already consolidated there.

Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")
Fixes: 93a43155127f ("cifs: Fix missing set of remote_i_size")
Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Fixes: 7a06d3b816d7 ("smb/client: emulate small EOF-extending mode 0 fallocate ranges")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
---
 fs/smb/client/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 808085eb0cdc..0afff761aab9 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3059,6 +3059,7 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
+	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
 }
 
 int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
-- 
2.55.0

