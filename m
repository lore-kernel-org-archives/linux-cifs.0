Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AFA443E45
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 15:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512109; cv=none; b=U2R0qImG/vcuvbE5XILrGf2lO/4b19XUJ2ehJkj47+NMyNFTb0mvAfZmU3nm0DQcCTBmO6plvhJej81vCX297g6KdooocIjWzpVsErNVSWnTHtlEHPz2XnRiNXdljHOPICiQxgKlPIWr32DfaPOVXKgz2Gxu3LFcHdJBAvFC4DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512109; c=relaxed/simple;
	bh=7vZlCeFRHRInEy7X+fBp28qYGSxVxLiaEXRwF09RpQg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mXO0zWoK86PO3UaXOpszoo/xj16NOB8kPS3ok9Fgcw9WFj60MxFqIr7CNwtal0sQxyFLEnURe4+dm1iGqYo4v8iBr4mQVy0ZWr60kUsUsm0XuDRhts9j5ghIsqDxoGlQaQ0upcpBK22qBbSsuavMdLLJLDqJWYruQxEZMfl46Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fTqqopFM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ho2ZnJjv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fTqqopFM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ho2ZnJjv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785512107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CuurEr1i4i4AEW4aQIqBJyTZzJI5/1mi//HBwqrA9DQ=;
	b=fTqqopFMFCAxOQlM6snaI08wafZKhbGpx39qS450PVFgJ9Gokxs1uiaHRU6Ub9wPHXlDKV
	AkiQSZY88aRMQ84ci4CWpexF3BVWD0TzY/VtiIcFCJj8Ct2gcZvybrOWM+nB6Nux+8Va2R
	Eo0hu366qqXegm0UNTd79R8BYBkfeIo=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-zq56pn0lMUSDXbZEeXsXDg-1; Fri, 31 Jul 2026 11:35:05 -0400
X-MC-Unique: zq56pn0lMUSDXbZEeXsXDg-1
X-Mimecast-MFC-AGG-ID: zq56pn0lMUSDXbZEeXsXDg_1785512105
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a4a7d0362eso1363997b6e.0
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 08:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785512105; x=1786116905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CuurEr1i4i4AEW4aQIqBJyTZzJI5/1mi//HBwqrA9DQ=;
        b=Ho2ZnJjv6SRypq37xDgEfCiRZAuZKtWjkWAHiNka589Gjz6T1+J1ZEC1NhyNhvBW4X
         UHnB5jL0v/MC13fQ8bZWmRGBdz7ULM/WCEbr7U2R3U/HQovl9ZzwMJhJx2shIX4xa5L+
         Yfevh7zilFu6o+3nwxGYABqYUUhlShTq3khDPD2N3z4TlinzaHNJS386j+mId5eMHDT/
         OSkVDOk6uwAF1IOYxy1Q0M4p+E3VTqE/F5uCoATBPWI91BbTlHrwv2cvw02S0VB8Zhgy
         JwxhGPel/OqjWkUEWzKDjNHOFdkdypqFyssjsNrAZ8M8UlSksdoHbwS58PC5k6C6thRR
         bwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512105; x=1786116905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CuurEr1i4i4AEW4aQIqBJyTZzJI5/1mi//HBwqrA9DQ=;
        b=NB9KgyyJq9U7Ey3oNqet43+NZrECU5V1w9QuNRMlysbahdZFN0gG0KAB1cU1PmWkjq
         chezgw7vXAzG+gkfEhGhhk/0HfjORhw38Wr5Ow1ETwrNgMwaBy3SJwLSnfqgjZNc4umB
         8vWNWhInmzk8eZt2ucOjKntKa185jnXzsOZWcYJP9gOv0qCJs5CULbILaHl8JRdpu76O
         XmGwOq2d3xcC0kyI5JW0FUJrM9UIjSxiQ4VGEwQBVNbf6pznnMtzGa4DdctW0//C4BkC
         xyCgLc8538t+cKezpsGsEc9LglTw0yni9E8S38hs/9dPpnSrPIKX2imvU6tyI/AVQhg+
         TkbA==
X-Gm-Message-State: AOJu0Yym5+3H1vFub080UI88I4BBB584njPtUbMDCWaq0zSqT5fiJxtq
	xKwiYvj1UIUz0KvVU1dn/TDahxUWy4JluL+nJkpBbIQ0WbDsq0tf4Z6/738qOCPtTWTVOsfoBmL
	jW6c/4kfsmoRmnBYfQlXEhYwFP9ueeF2VNEMOmg0AjEEYxptdbRxn1cTigLLMGTsTCbZ+bkoOkp
	g58WENL9hbuqmMttDDNnW7UcIHoiAjFD6MbXxeByP56xtiS7g=
X-Gm-Gg: AR+sD1103ULNP7o+0bclwgTPojTODbvtFGVWnhk5SM36sy6q3Mn3J4HzUaaEdsCjs/J
	ftuLdIfS3pF+XUGh166cdNhy4qXo6/NRW4ZHRSKhy+Jih251RyUduffk9KpWsTapRM15opbbnaV
	YkBv4pgK2fsFv4dKm6YWsPQXyR+s7RKz8gwDJrD3yz0GoIMwiLx7BnkKlPjQwUuRRVpbn8Z3Bfp
	zqVnZ5etzxPHEIHaF6NNphOdjJz4+DsLURuqn2TEcDIFXe8ye7odx3jIBQMbObrVgp9thB13B1e
	Bk0aSR7HyWuf+pnrH3gZyGdtSblLJJH3wPILT1wUYjM76byzS0e1HvLUGhVyApgy2zvkX7XQeY1
	VJb2vDbhh8+X1sOCA8G3EkmNQQ/ZhoHda2lteX2hTdcZS0HdmFpwgLSmVpANB
X-Received: by 2002:a05:6808:2443:b0:4a4:adaf:5576 with SMTP id 5614622812f47-4af5df7c2fcmr693638b6e.4.1785512104643;
        Fri, 31 Jul 2026 08:35:04 -0700 (PDT)
X-Received: by 2002:a05:6808:2443:b0:4a4:adaf:5576 with SMTP id 5614622812f47-4af5df7c2fcmr693582b6e.4.1785512104130;
        Fri, 31 Jul 2026 08:35:04 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4af58ce144esm855813b6e.1.2026.07.31.08.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:35:02 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Subject: [PATCH v2 0/4] cifs: follow-on fixes after fscache_resize_cookie() consolidation
Date: Fri, 31 Jul 2026 10:34:56 -0500
Message-ID: <20260731153500.660569-1-sorenson@redhat.com>
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
two further fixes are needed and two dead-code blocks became removable.

Patch 1 fixes cifs_do_truncate() (O_TRUNC via cifs_open()).  That path
runs without i_rwsem, so it cannot use the locked resize path.
cifs_invalidate_cache() is the correct alternative: it works without the
lock and ensures stale cached data is not served once the cookie is later
activated.

Patch 2 addresses a race identified during review: cifs_setsize() calls
fscache_resize_cookie() without i_rwsem, but another concurrent open may
already have the cookie active (IS_CACHING set), making fscache_resize_cookie()
a real operation requiring the lock.  The fix strips fscache_resize_cookie()
from cifs_setsize() and introduces cifs_resize_file_locked(), which
temporarily activates the cookie with fscache_use_cookie(), performs the
resize under i_rwsem, then deactivates it.  Callers that already hold
i_rwsem (cifs_file_set_size, smb2_duplicate_extents, smb3_simple_falloc)
switch to the wrapper; cifs_do_truncate() continues to use cifs_setsize()
followed by cifs_invalidate_cache() as established in patch 1.

Patches 3 and 4 remove dead code.  Patch 3 removes a caller-side
truncate_setsize() + fscache_resize_cookie() block from
cifs_remap_file_range() that became redundant once smb2_duplicate_extents()
started performing the full size update via cifs_setsize() under the
i_rwsem held by lock_two_nondirectories().  Patch 4 removes equivalent
dead blocks from cifs_setattr_unix() and cifs_setattr_nounix(): since
cifs_file_set_size() calls cifs_setsize() on success, i_size always equals
attrs->ia_size on the success path, making the subsequent size-inequality
blocks unreachable.

v2:
  - Added patch 2 (cifs_resize_file_locked): based on review feedback
    (Huiwen He) that the fscache cookie is not guaranteed to be quiescent
    in cifs_do_truncate() - another concurrent open may already have it
    active.  The fix strips fscache_resize_cookie() from cifs_setsize() and
    adds a locked wrapper for callers that hold i_rwsem.
  - Patch 1 commit message updated: the original rationale (cookie is
    always quiescent in cifs_do_truncate) was incorrect; the correct reason
    is that i_rwsem cannot be held in that path.
  - Patches 2-3 from v1 renumbered to 3-4 to place fixes before cleanups.
  - Patches 3-4: add Reviewed-by from Huiwen He; otherwise unchanged from v1.
  - All patches: add Reviewed-by from Paulo Alcantara.

Frank Sorenson (4):
  cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
  cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie()
    under i_rwsem
  cifs: remove redundant size-update block in cifs_remap_file_range()
  cifs: remove dead size-update blocks in cifs_setattr_unix/nounix

 fs/smb/client/cifsfs.c  |  6 +-----
 fs/smb/client/cifsfs.h  |  1 +
 fs/smb/client/file.c    |  1 +
 fs/smb/client/inode.c   | 41 ++++++++++++++++++++++-------------------
 fs/smb/client/smb2ops.c |  9 +++------
 5 files changed, 28 insertions(+), 30 deletions(-)

-- 
2.55.0

