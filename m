Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2015312807
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758339; cv=none; b=lsTbkz1pwlw24xRBH1PO6v/gebhHiMK6Dzj7Q4ZcSyKws7OvEC7Z+GeHFT4EU9z2Inw7h/SLUoJhuLQU97c0z3ruSoaEnBnTaTOaKV0M3vG6sw2YvJGz+nLfZGRAVEM46w6UcVqoyxjB3n7nnCadAxa4ekI1tKu6Q8B3rULRp/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758339; c=relaxed/simple;
	bh=0ewtYPGbEfCig1MIT7YMKgVnUT0dsYToJVF5lModmfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SOa/xRwsB8DqwSSeXX1fCDw0/zbXQoRreGQDcdrNlTOezLv9H+FxONBwxsqL0jspaOQtVGIkiDHKw+ky8dW5HIAOMfavhPlVLGrLOTY4Il2GQXE0ORWAk5blRzl/7JcRIp3JhMZFsXUDdpVX0eUswmUvMg7LzM8iwc1ap4B7Nnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GPi42GaU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MduoLcPX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPi42GaU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MduoLcPX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0TSmF71sZt5zvC/XaDbhrAyqdNJqPHNKw5vLfFTH3ZE=;
	b=GPi42GaUyJ88sowvHG/67OWpH6/cJAThTWuo/5NDZzA2pyd2uRwoODpV4bpgQxmHQxBLuu
	wQAxOCzPzAWBLt/DCmgTrWBCm74QgBr1vMYpxpMDTKUpDY4rRAj1eSvs/iP7/FWdus85kQ
	JAM30bdkjc2yK5iN60YA+4SLKS83vqM=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-QCaY0j4OP0qpRN-1Um709w-1; Wed, 26 Aug 2026 11:32:12 -0400
X-MC-Unique: QCaY0j4OP0qpRN-1Um709w-1
X-Mimecast-MFC-AGG-ID: QCaY0j4OP0qpRN-1Um709w_1787758332
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66ce3040ea9so2941251d50.2
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758332; x=1788363132; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0TSmF71sZt5zvC/XaDbhrAyqdNJqPHNKw5vLfFTH3ZE=;
        b=MduoLcPXftm/GitWaUdkC9IxfU9slEAVThDYZMKTEA4ip6Iyu5/FCZCqB/UphnYwLy
         QQb8HkPtJ0BHWVhW9q3x0EpQS0Z6qKt8S2qeXp15G0Knvk7flY5JIosxUVr5eMei+EMV
         svSGPRC3mv5eQmXjLhSizy8SM7lPAdNhhX4q/EWJ5efNhv5p28Y8z7xm7jd3g/Po2AIn
         55kI/O2IQ9C1VDvZndYokT0o4KdkICEnXpmnV+SGTr5N+McO0DDlWyPJXwfBfAe/8WuW
         RFM2H+ho50Cq5gvqQsiuxwsno/uDLvMHNhjECkSp8UTvLxEiJDownAkgs3KmYTHi8uFC
         ZH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758332; x=1788363132;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0TSmF71sZt5zvC/XaDbhrAyqdNJqPHNKw5vLfFTH3ZE=;
        b=OE8UTtsMkgqAuZSqx6H25sMsF1XbtbEtGbA9RqvsTY6xQVvLJPcZBG+5jkT5zaaeZi
         uRO9V3RpluQQds7Dk1gUCTSMRCK2T322ZHDRwxDnBs2OwPhZqWxwyjNLcxOatD5DK1ek
         Pr/wncNnRq98ly6Wup1gOUH5IPtJnhy4WIsYo9BiR6kMuNJREklDcEWoGFXitcFyUcJ+
         DTk6iU0PASRwu9Q2uEQ/mxbS8zoH8MRCtPH4y6Tn4HsNCKH0rt6Kz8mEbmOWzb+aXCO5
         IMtx0ziGTqpDPmF5x+vPhKUc4xX81J84X+q/VVbPn3lXWObVHzRx0fQrQXl4rDmj5jmB
         UbQw==
X-Gm-Message-State: AFuF++nidZPxUY8v0F9ZHr407DEWGWf1E15Vuq07GIMaaXp7ZKEV5hwt
	/fG+Agt40iNiTyeOaXQXe9HLUMEWrOJVhBvQGHRdbGUuQjqanx0ST9Kyq1PoP1AgkjUE76xPYzu
	8FV5keogUwBHI5P71KXfiErYBRtIMNVEXHtEofXwEXhUmA41dTD/QuEAZ6jBG9zEj2Yevz0IkYH
	Pu/CjqbqwMGRXy15VLTbD4vk4Yc4/4wGTEteglpoL5oKteLkU=
X-Gm-Gg: AR+sD11HebVfRfQkqB+22j0iiAi9VEf6mv2q5iP/n/bMEN3sUZguLLvS20Yn2vyQp7c
	u90G6+/dSurQ+ZJ4MOTbvY/VO3VaTVa3gZgsK6fpRcDzuwyP5SuA3JDcAGmXspSDPoRQyBq+022
	3b1R1uZGx1kdrP8IhpZWp3RI72PQ/fZugoQ1l0zevmfVqxbJodPXJ3ZECVhXzNtflG5ovVWmh8B
	kagP2v35ZTsZlDKBg0FpeYQ7Pgb+jz2Atqvi+LYSg3WDL+LZPi9B7gJTFjtVKVDjGaa4m84mAQ/
	66/E/CLrDpJ5+2TqdTOgtp44dWTmUMZVAzm19vabfnNPLWxvSjSiIxeTJOfIuaQLgizFMf4gt5+
	zaiaYy3m3povqF8zRCDMY//+ELfGxJX6pDqFHDTZSmjpBDrqKXoOdKpJNiD7K0vJ03Q==
X-Received: by 2002:a05:690e:1c0a:b0:66d:28f9:3b55 with SMTP id 956f58d0204a3-66d28f93c6emr1938909d50.38.1787758332054;
        Wed, 26 Aug 2026 08:32:12 -0700 (PDT)
X-Received: by 2002:a05:690e:1c0a:b0:66d:28f9:3b55 with SMTP id 956f58d0204a3-66d28f93c6emr1938809d50.38.1787758330575;
        Wed, 26 Aug 2026 08:32:10 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:10 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org
Subject: [PATCH v3 00/11] smb: client: fix OOB reads and UAFs in SMB2/3 receive paths
Date: Wed, 26 Aug 2026 10:31:36 -0500
Message-ID: <20260826153147.4112943-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series fixes eleven bounds-checking defects in the SMB2/3 client,
all reachable from a malicious or compromised server.

Patches 1-3 address the compound encrypted frame processing path:

Patch 1 fixes four interacting bugs in receive_encrypted_standard():
a missing lower bound on NextCommand, an off-by-one upper bound that
admitted trailing slices too small for an SMB2 header (producing a
write-after-free via next_buffer aliasing server->bigbuf), a stale
next_buffer pointer not cleared before goto one_more, and use of the
pre-decryption pdu_length instead of the plaintext extent for bounds
checking.

Patch 2 adds smb2_min_pdu_len[], a per-command table of minimum response
struct sizes, and uses it in smb2_check_message() to reject responses
too short for smb2_get_data_area_len() to safely read command-specific
struct fields.

Patch 3 fixes server->total_read tracking in receive_encrypted_standard()
so that smb2_check_message() sees the actual per-sub-PDU size rather than
the full remaining compound tail.  Without this, a rogue server can craft
a compound frame where any non-last sub-PDU is shorter than its declared
fixed struct, bypassing the guards added in patch 2.

The remaining patches fix lower-bound gaps and OOB reads in DFS referral
parsing, EA list traversal, posix SID bounds, change-notify offset,
snapshot enumeration, and SMB1 reparse point validation.

Note on overlap with a concurrent series: Zihan Xi's
[PATCH v2 0/2] "smb: client: fix create context out-of-bounds reads"
(Message-ID: <cover.1787486936.git.zihanx@nebusec.ai>) touches
smb2_parse_contexts() and parse_posix_ctxt() independently.  Patch 11
here addresses the same function (smb2_parse_contexts()) but focuses on
complementary issues that their series does not cover: NameOffset
validation (lower and upper bounds) and gating all three handler
dispatches on a non-zero DataLength to prevent zero-DataLength contexts
from exercising parse_lease_buf, parse_query_id_ctxt, or parse_posix_ctxt.
Their per-context cc_len bounding and lease/QFid minimum-length checks
are not duplicated here.  parse_posix_ctxt() DataLength validation is
omitted from this series entirely since their patch 2/2 addresses it.


v3 changes:
 - respin entire series

v2 changes:
 - patch 6: reject next_entry_offset values that leave fewer than
   sizeof(*src) bytes remaining after advancing.

Frank Sorenson (11):
  smb: client: fix NextCommand bounds and aliasing UAF in
    receive_encrypted_standard()
  smb: client: validate PDU length before smb2_get_data_area_len()
    struct access
  smb: client: fix server->total_read not tracking sub-PDU size in
    receive_encrypted_standard()
  smb: client: fix missing lower-bound check on DFS referral string
    offsets
  smb: client: fix missing lower-bound on Next field in
    parse_server_interfaces()
  smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
  smb: client: fix missing iov bounds check in parse_posix_sids()
  smb: client: fix underflow in is_valid_oplock_break() notify offset
    check
  smb: client: fix potential OOB read in smb3_enum_snapshots()
  smb: client: fix incomplete bounds check on reparse buffer in
    cifs_query_reparse_point()
  smb: client: fix NameOffset and Next field validation in
    smb2_parse_contexts()

 fs/smb/client/cifssmb.c   |  2 +-
 fs/smb/client/misc.c      | 12 +++++++--
 fs/smb/client/smb1misc.c  |  3 ++-
 fs/smb/client/smb2inode.c | 11 ++++++++
 fs/smb/client/smb2misc.c  | 53 +++++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb2ops.c   | 51 +++++++++++++++++++++++++++----------
 fs/smb/client/smb2pdu.c   | 11 ++++----
 fs/smb/client/trace.h     |  1 +
 8 files changed, 122 insertions(+), 22 deletions(-)

-- 
2.55.0

