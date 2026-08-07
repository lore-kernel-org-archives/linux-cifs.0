Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B241F272E6D
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 02:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786070526; cv=none; b=Q7CoSJBEhF9k6eDbleh7RRb8r1+dOOnEc46uAVzDLgbNWksu0JfnHt9GkkM9Gs3KR5qUdCorXwgaNngEKG4uVx7oPc476F5ymYTBr78ovTYzEXnGsmATuKKFe7bgIIjjxu0p0J/pEBsUuB4SO7R5UbYULrEknD7fkniMQNB419Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786070526; c=relaxed/simple;
	bh=YRDgiNcNyeZKegfyQ4gc5p1zkXfcWqtbsERKjmSZSrg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=U9eeZXhhRB9XEZ8eT9XBlgJPYka55oxZStVebP9+9+PESDIUBVaNDRLsWiYzI4jpWm2RD+uAoTbZVZdmdVYyK4QFGC6KK11ynpD2htz7N4QEy4zxXfJhpGsJePHaIDeuI77rHmswk+KfYd+yH1gxC+OwSiKJe6Uiu61BPWIqUXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fiG4uAoT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZcPj00iy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiG4uAoT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZcPj00iy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786070523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G1kiUVQNvrUNp4oISMJ1Z/iUQdm09U4ERIEKmh6o2sA=;
	b=fiG4uAoTIsXT/tgta0lxuKprcbY1xfuLXsimjBS2nWhUgGC88U7FohyEm5jDUFrA8H0hpU
	8zB1SqepDV+oKEbXYFy14S+oGeN/H/ZKpY/gAr65B9hGGVFSipw7jDY2UkzTsKs0KonJNp
	ph0ygt7XRsfoaCptGmuwZWXrAwJlq6Q=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-vkSqVU1FP3O9RehhEt2-bQ-1; Thu, 06 Aug 2026 22:42:02 -0400
X-MC-Unique: vkSqVU1FP3O9RehhEt2-bQ-1
X-Mimecast-MFC-AGG-ID: vkSqVU1FP3O9RehhEt2-bQ_1786070521
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7eb650e79adso2606965a34.3
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 19:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786070521; x=1786675321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G1kiUVQNvrUNp4oISMJ1Z/iUQdm09U4ERIEKmh6o2sA=;
        b=ZcPj00iym3Pd6XdIr32Nq5wiwTrU00j9Eg7gbLi34gIFjVqPfg+hvWnYY/uqwywsbe
         ndSUvUhQa/PQ6VEyBgTi2/4+d+B12nQCHIbVVFTABbO5MBWfXYK4pqfOP0bzk3b7kMG2
         zcCYQsJZBkdIzRBnjDOl4OvokdJnU+Xq1kRMoxRxwGnE9q4UnwzgEXPGuVUhaXFFo+kc
         sKu39Kyo6Jix+VebD2hR9xs7ECQgxOwlH9C9iqBNi7kxvhYPb68n1lsT50v3HDM0bd1U
         86EywTciLW6qyYj07DDy/pmlnKlpzuM20BA4SG7IOWqpBLIDZUQYymTDr8C9olvIJSub
         1bHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786070521; x=1786675321;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G1kiUVQNvrUNp4oISMJ1Z/iUQdm09U4ERIEKmh6o2sA=;
        b=B00uz3QtLzGsM+9fKV+yYCCMSgmOcrp+4mmz+rW/aPYWfsEcR/5NcJgpM3SIvkLMG5
         4Sirbo1hjH5JbQAZ9wD3wwfiUMJkevLmDdgHGzVXFiiPXCY6gOLZ5qOwBlEh02dCNkZe
         TzA8cmBYgX4axqZ1hQ7DXQ3WZs5WdbUEEa3cDtyK/vRGw9PMUXiiAmwVYmKRzPEa+NiC
         lCCYDKZFRkWtoNGPtP+Fg7I57tzybmn+M4K/QYlyStnu3O2ihuzNfGWfj1+kbRGZXAUf
         mLEtCZaJh+O3MjnQPDFtZ4mRYCT7bEpyUhncrld4+4P0qwZ5ThFQGRonw0e6/WoYgcDD
         3Xbg==
X-Gm-Message-State: AOJu0Yw4aRzd25GAJhQ7tWXpVxav3YpZwPMDBaG9+Huwbdw2W3a9iLil
	AeLCyfCNvAy+mta4ASITQBuuETHjC7rzkWNMJN3M3Sa79bZagVirRhgC890wAzcgTb0Y7t3CuFs
	gPFFMuyGS2c0ev/GOq3NXmZ5VOnke409VKWVL62c8Yd+pmr7857XXkwRSvaDw5EB89b0zs7hgz/
	UK+Rew+cGli5UR3n4GKrrsmRmRBVntj0T0g67Tij5kMDfoAPE=
X-Gm-Gg: AR+sD10Kl8jV7cNaJdqNSKKuXv2OtNoRwOngrVf8j0EcAeOX/Uzk/QNQrZb96FUF6WL
	5Uxx235qxz1a9mMdbPOXsm3wEdlsVWKLK1iN6PcMkS2dMjqfZ2OZMWMHh5jXotrO+rcWblpWf+9
	jm9Yi5hMrn39cq6TpmKv7+RH9lb7Khf/WqGZcMAnfel8XzavjkDcTpytzyhCWLtMF+qzXqzd8F+
	IcSJuEjLS99LCwkHdzKBro91aQ8aTZupWt0vUWuU5Wg0M4YpXoNJhXJY+QmFThQzeWmppolio+E
	DCetTaXF6UU0rVI+Zj1QJ1FGwKUQ62JnGTlsXLMKMhSlN+LQwBoVrdudYg73VbqibR1C5Teh5N5
	exQPQ5j6cUDPwROGChdmZI3fHL9Lsn2tsltuT4cwWWfPXVlqBa+b70bO6GC9mI9KALA==
X-Received: by 2002:a05:6830:398c:b0:7ee:41ca:e7b0 with SMTP id 46e09a7af769-7f34df0d626mr4214708a34.14.1786070521537;
        Thu, 06 Aug 2026 19:42:01 -0700 (PDT)
X-Received: by 2002:a05:6830:398c:b0:7ee:41ca:e7b0 with SMTP id 46e09a7af769-7f34df0d626mr4214682a34.14.1786070521035;
        Thu, 06 Aug 2026 19:42:01 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b563887sm356182a34.3.2026.08.06.19.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 19:42:00 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	pc@manguebit.org
Subject: [PATCH v2 0/3] cifs: three size-management bug fixes
Date: Thu,  6 Aug 2026 21:41:55 -0500
Message-ID: <20260807024158.3707995-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches fix three independent bugs in cifs file size and handle
management.

Patch 1 fixes a use-after-free in cifs_file_set_size(): when the
handle-based set_file_size() call fails and falls through to the
path-based fallback, tcon is reused from the cifsFileInfo that was
already released by cifsFileInfo_put().  If that put drops the last
reference on a tlink that has been removed from the tlink tree, the
subsequent set_path_size() call is a use-after-free.

Patch 2 fixes a premature i_size update in cifs_do_truncate(): when
no cached writable handle is available, the server truncation happens
implicitly via the O_TRUNC flag in the following cifs_open() request,
but the current code sets i_size to 0 locally beforehand.  If the
subsequent open fails, other processes sharing the inode observe a
spuriously zero-sized file.

Patch 3 fixes a loff_t underflow in cifs_remap_file_range() when
len == 0 and off >= i_size.  The computed length is negative, which
corrupts downstream arithmetic and sends a huge ByteCount in the
FSCTL_DUPLICATE_EXTENTS_TO_FILE request.

Patches 1 and 2 fix regressions introduced by commit 110fee6b9bb5
("smb: client: fix missing timestamp updates with O_TRUNC").

v2: rebased

Frank Sorenson (3):
  cifs: clear tcon after cifsFileInfo_put() in cifs_file_set_size()
  cifs: don't update i_size in cifs_do_truncate() without a cached
    handle
  cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0

 fs/smb/client/cifsfs.c |  7 ++++++-
 fs/smb/client/file.c   | 17 +++++++++++++----
 fs/smb/client/inode.c  |  1 +
 3 files changed, 20 insertions(+), 5 deletions(-)

-- 
2.55.0

