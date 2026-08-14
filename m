Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F832DA757
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 02:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786675459; cv=none; b=qY/xVru1bm5QBISq/BFf5T96hvsrZowCRvW1XoNQp1zhYOfAsjGNsxh7R58yDR7JQbseihR6OHl9zjFpQeO0omQNHkEO7lVtIVqerYaOBQ58nPmKZnlQEocqa82vbJRYUyGmJb8Vo5gImOA/tENTQ22qXALw/jzBNtpjwpc3QIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786675459; c=relaxed/simple;
	bh=n2Hq8Qw/WyoSfKqI5tO0lz/pSHwD5iX1zXgpX/cA85M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iW/PvK6qYtasEDPIAQ8NrvhxP/TecTrN576hmaZaHseS46vogQOxtr40p/ZOssSdMiGTvjaPLHyJTohYCYe73SoTAVCpi5aDSfvki6NlYvDG5S+7/oL45XkCZiIs8IGJDe1Rido8+nKg/4G9BDxioWJmenTq/78Ianso3NrKiyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qg+diuGk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBcdsmqx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qg+diuGk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBcdsmqx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786675456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dq8mEF+OrUoko46VFAIvTBegRG6SP8wzcvTRXHUVvaY=;
	b=Qg+diuGksTtSsgok1be9jA3XnJfHA1Fiu+OD/gTVymf8dOrQCb3Go9InsBWSEudo2SMCFs
	BQptL9fdHKZ22dKk2ix6jSUaIB3FKQVAAQKM+d4D4VdxEkLn/Xk68zrtPAEFPQPRqeuqJP
	QrJdMppN4PajIOqr5VKhFSg+1geDYNk=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-xb2HtYnAPhiY7zePrxyCDg-1; Thu, 13 Aug 2026 22:44:14 -0400
X-MC-Unique: xb2HtYnAPhiY7zePrxyCDg-1
X-Mimecast-MFC-AGG-ID: xb2HtYnAPhiY7zePrxyCDg_1786675454
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7ee50225cc7so730322a34.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 19:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786675454; x=1787280254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dq8mEF+OrUoko46VFAIvTBegRG6SP8wzcvTRXHUVvaY=;
        b=XBcdsmqxo2MB6w0BxaZ+ZNJbjwJhw+S7LHtl1PIGPX0CClu/5M3QiE+olS6g2z6tnZ
         0Uzvk6xZ35WuXgZbcg4+VbDDCJT9VSZYhuBjjctD8maodeX7REz15tfRWbXHAJ7nW0cv
         je74to3P3Ausc229R++POzi2Hg3sRZtyACvyOYk3BcSoAJP/ASw9xXndZ6jmg/PKgZhB
         NZw6opRMmC5t5x3Vk88j8OhbZ5fQ1fjqcO22VzlOM7qhUWixTbPx6DmBtFYuVDrugdeL
         CjUYznj++MmIIWDgXXqgD6IpXWzYdsKiSvXNO0YA95KHi8Lsc/M7QLTZ/93nk2vSLbjE
         C9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786675454; x=1787280254;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dq8mEF+OrUoko46VFAIvTBegRG6SP8wzcvTRXHUVvaY=;
        b=IgoO/kC5GFSk18NC2V4jJqyMUw3wojewN7t9vCF8bA1agzAKJs2VXgQo2Yrvy63UvD
         4vCwpPrjSHRlA31/gFAx2Vdj1lnNnFLB47xzxGP/cNSBf/oQLAysG+VXCuSNTTwr3EnX
         bC9fN6h/UYfUEppbbrg9KfD6KloI0fF3g36q/eVayROAG5k6t9FXAyCRa8iLLPFnFWUg
         3vOFS5AfKnDruAV4SBV6UYei1tyrR5CnfG3qI/9UvfU2N9fAEJ9RdJxscY2Kvgl2Y11X
         RWepbrodVi92HALJjjtbnuLxLdul0gYRiTOJkMDaLeMwky/npX5SMpmGpPxPP2OE3XJK
         hfGw==
X-Gm-Message-State: AOJu0Yx634Fpq9unXujSfOC3OeoGe3cR3+2lxc+bnZCMeJb4U00slucZ
	+VREM5qNzBgmxwYQnu7dwtJOsAoexqJ5L7q0L44xdRYsrx53pBzHqa6XlWY+L5+3GMqaNpOpHOK
	Y9ORfGzR2rteWO9EfphhTqWgb8FF2iQ7/W03gOvYuzuWVh/2fwT2WqnA3CaGdNReNRjdD/Sn60A
	dbG29QInoMCO/GEUO5v2EvKM8fJDWCTbQjGG+KKBcwXsBMb64=
X-Gm-Gg: AR+sD12QysXA6R/So7pl2KGUjFvU4Fw2Yz2D/oMZb6m4oSpdlyUlkx7Jf4K6ySAi6kk
	PcFYOdwASZX0G8q9tNjs6hRsJIRCPzVWID27JQ9Dz5zdu0jf8OL/+a2fMGUBALH7mGBtVzB69jZ
	IRr3p+uN++1CFuNJZJvBgimhCbscf9CJWI9Fi20ezi1DdrpsSwVK3EZFulOf4gpcAj46TVUUcyw
	YYw/QGbU4Xphzi7Z6Csijf6n5NzVj4zICw/5Xbqg6uPJm1qwLG7FFXmdd6nVxf3M/C7Zd4ZHPf2
	dcu7/xv+3pMObAQHRISauj0AXPCn3inU521lkKrbHzRohc7+FNdjW2UjprItjCW+REkF+ODhvq3
	cJm4h0FzbG+iXiq4mSskuwRvM2C1qVbbqpDmgwAINHF19F/v1lRgzZJm5oHzQbZvsQg==
X-Received: by 2002:a05:6830:2693:b0:7e6:e1d2:3bd0 with SMTP id 46e09a7af769-7f3de5b3b98mr2153041a34.10.1786675454045;
        Thu, 13 Aug 2026 19:44:14 -0700 (PDT)
X-Received: by 2002:a05:6830:2693:b0:7e6:e1d2:3bd0 with SMTP id 46e09a7af769-7f3de5b3b98mr2153008a34.10.1786675453432;
        Thu, 13 Aug 2026 19:44:13 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3c9a0d87esm3631582a34.11.2026.08.13.19.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 19:44:12 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	pc@manguebit.org
Subject: [RFC PATCH 0/1] smb: client: tighten validate_t2() offset bounds against actual buffer size
Date: Thu, 13 Aug 2026 21:44:09 -0500
Message-ID: <20260814024410.2455764-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

The accompanying patch tightens bounds checking in validate_t2(), the
central validator called before all 21 SMB1 TRANSACT2 response sites.
I'm posting it as an RFC to request review of design choices and the
approach.

Background
----------

validate_t2() currently rejects ParameterOffset and DataOffset only when
they exceed 1024.  The actual allocated buffer size is
CIFSMaxBufSize + MAX_CIFS_HDR_SIZE (~16468 bytes), so a server can supply
an offset in [1025, 16468] and have callers dereference typed structs from
uninitialized pool memory.

cifs_buf_get() clears only the first 207 bytes of each pool buffer on
allocation; bytes beyond that retain stale data from prior uses.  A
response with DataOffset=15000, DataCount=0, BCC=40 produces a 94-byte
received frame: 15000 + 0 <= 16468 passes the individual guard, yet the
dereference lands far into the stale region.  Raising the individual bound
alone does not close this window; a joint offset+count check against the
actual received frame extent is needed.

Approach
--------

Rather than adding ad-hoc bounds checks at each of the 21 call sites,
the patch extends validate_t2() with two new parameters — min_param_size
and min_data_size — that let callers declare the minimum struct size they
need to read.  validate_t2() verifies that the respective offset clears
the fixed T2 response header and that offset + struct size fits within
frame_end.  Centralizing this in validate_t2() keeps the validation
auditable in one place rather than scattered across 21 call sites.

Design choice 1: frame_end as the joint bound
---------------------------------------------

frame_end is computed as:

    frame_end = sizeof(struct smb_hdr) + 2 * WordCount + sizeof(__le16) + BCC

This matches smbCalcSize() in smb1misc.c exactly.  checkSMB() validates
consistency between the RFC1001 length prefix and WordCount + BCC before
validate_t2() is reached, so frame_end reflects the number of bytes
actually received and is not purely server-controlled.

Note: struct smb_hdr opens with Protocol[4] at offset 0 — the RFC1001
length prefix is stripped by the receive path before the pool buffer is
filled, so no subtraction from sizeof(struct smb_hdr) is needed.  This is
confirmed by smbCalcSize() using sizeof(struct smb_hdr) with no adjustment.

All joint offset+count checks use frame_end.  The individual offset guards
retain CIFSMaxBufSize + MAX_CIFS_HDR_SIZE as a buffer-overflow backstop.

A secondary benefit: the raised individual bound creates a new overflow
vector — DataOffset=202 and DataCount=16387 each pass the bound separately
but 202 + 16387 = 16589 overflows the 16588-byte buffer.  The frame_end
joint check catches this too.

Design choice 2: lnoff <= DataCount (not lnoff <= frame_end)
------------------------------------------------------------

CIFSFindFirst and CIFSFindNext use LastNameOffset (lnoff) as an offset
within the data area.  Rather than exporting frame_end from validate_t2()
or recomputing it at the call site, the patch bounds lnoff against
DataCount.  Since validate_t2() has already verified
data_off + DataCount <= frame_end, this transitively ensures
data_off + lnoff <= frame_end.  It is also semantically correct:
LastNameOffset is an offset within the declared data area, not an
arbitrary buffer offset.

Design choice 3: CIFSSMBPosixLock small-buffer exception
---------------------------------------------------------

CIFSSMBPosixLock receives into a small buffer (MAX_CIFS_SMALL_BUFFER_SIZE
= 448 bytes).  Passing a non-zero min_data_size to validate_t2() would be
wrong: validate_t2()'s large-buffer upper bound of ~16468 bytes would
accept data_offset values that overflow the 448-byte allocation.

The patch passes (0, 0) to validate_t2() for the buffer-overflow backstop
only, and follows with a per-call tight check:

    if (data_offset < SMB_T2_MIN_OFFSET ||
        data_offset + sizeof(struct cifs_posix_lock) > MAX_CIFS_SMALL_BUFFER_SIZE)

This is the only call site with this exception; all other T2 callers use
the standard large buffer.

---

I welcome any feedback on these design choices, or on the patch in
general.

Frank Sorenson (1):
  smb: client: tighten validate_t2() offset bounds against actual buffer
    size

 fs/smb/client/cifssmb.c | 133 +++++++++++++++++++++++++++++-----------
 1 file changed, 97 insertions(+), 36 deletions(-)

-- 
2.55.0

