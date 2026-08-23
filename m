Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579E81BD9C9
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511516; cv=none; b=uL4WfrwG0t8eiSyMNhf812Iltl9hEQU35rKl5iwh+ayKEQMVRvqvVeawAHl2/+wqpNu+DfNhwwxQ6aOKMx3UUNc5cJfXd4iJsShilphPXDVSzruP8gn7XUk+Gbl3+eUsbYM3GvGovFGGVn8GHODi8SGlYeBY9dakYNnVyVyJd2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511516; c=relaxed/simple;
	bh=DnK0gIzL/z/yUdeScVmrwUWvLJ22ZTqo4Z2g9Hrkn+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=npPkP0NPLiIDBKHvDJ0r9tDbdsXvGoqiat9+27TigNx9+QDUIcMti8pRNK0+hywRFQSa//kQNP1HAKNVZnYC6nOXOiNfOZQF9eXFxOoTvBnhZwjwqnNethp0lVNw02F3POzk2maZauR37CBQr1CT6mBAqGC1aw86ThwVtQMBByI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hCX0Na2P; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYkmfe/E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hCX0Na2P";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYkmfe/E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+cokJN3qKCJCUI7AikdkXX4c5WhNLfVl379htSsVc2I=;
	b=hCX0Na2P2AydOR1QyOrhM1KOtlmZ1njeXrMcMayNsU2xGcyhQdwuNB+XJ9CO8SVlA7NZwK
	kMM1dIdFzp4IU4YUFB1XLsQDw7ZMVsCiEc6K0qv6ewZQ6NMLAmFhUgO3OcJMhQR0iHcO3w
	OD6NlKuog3gR4WFXQM2xY+43W4tJDkY=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-uFbZvD3XM4-HMItkx10yOQ-1; Sun, 23 Aug 2026 14:58:31 -0400
X-MC-Unique: uFbZvD3XM4-HMItkx10yOQ-1
X-Mimecast-MFC-AGG-ID: uFbZvD3XM4-HMItkx10yOQ_1787511511
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9fdc2870fso2115784a34.2
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511511; x=1788116311; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cokJN3qKCJCUI7AikdkXX4c5WhNLfVl379htSsVc2I=;
        b=IYkmfe/EHxIXzGtGv684EbWbhRdHrY9ThyAyhjvrTigtIF9x/z9TYZNW4y8mBT6vcc
         XEL+Y0FyudNMJPlJIwnYFXSOxAO7b7g6zmdfQmEGEV0FA1uUfYpeoLFG3k4YmzDhzLd0
         ixVqt5taXrFho5wBzt59zf0QIR4UirSUMEAqDCJNtq2azwRkSp7qrhaU+tEhl+ulDE87
         hWACyhchwpQgsntu0NhjzF7yjI6ypM5Uy3z4PInKCdyiil8I8sTMwDBpFuL8SqkC30LG
         uKWYRCj13mi7UB9n0vpTf4ud+tXtrtBzVd3pP3S40i9zN/kfpqBiDcnY+lXoOUj8tIG7
         5emQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511511; x=1788116311;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+cokJN3qKCJCUI7AikdkXX4c5WhNLfVl379htSsVc2I=;
        b=nK9vCBvrcsxOz/gWMidrhEYrBEX3PLlpZdX8JvccDveC6R3V73rPmHElCPZvCJgXyN
         v1OqQ6kzg2JZiCDGPzMVf9gfQp2GzkyAUlzZmj8t/w+hnL5R5Qa2yr4AsxrgozJqiqv/
         CWh7BCO17/tbLIfY1+gEuitlIemuoWbrT0165+FYv8EQEIq+PucSn94fYWCcExFIcKCK
         PS9iLAgTMOzXjsi5uIQpivcBJcHusMF7ksnjU0kqOf1u1imCcsCS44B0fiArSe8zxqST
         5gdwwjbd4I7zKbhzK0WmxMTj8zBFOJ6TjtkPSFowSOi8IE0lJcyl6TO+3qZrX7WqU0UD
         54yw==
X-Gm-Message-State: AFuF++n6BJ+17r1O0yrz25+cX6o2i6Ne356guJ3pFSJXeBVCJyFcPAgT
	zpkWS8/4dgmt5SqpXwuTdJEFU9LPbArSr4NfKfcLC6exSijZOYLTt6wkvx4I5BgPjEaNlIR3RHr
	i3aggqi0wy+0qV1U9UJXdwbEK6XeSbHgaksi/+gSHi+xbdQc04GYaUfCFHNqgqNVx2CHDhOCepZ
	EDlxosNlnsZu3hdkTKkpxAAnjQ3SjjpPGTQMPDX+0mlWfj7vQ=
X-Gm-Gg: AR+sD1344Kv3v2EtKAAQ3z6nKkAB+wrTgcYQvXa8lLmqMJ/E9C/IpKGdtv0jzubXifY
	EN3+cRzidEbYkPZqNpYfzMfIh+3h6CyPU809MnI7BAxhuem+hS+7tRFsE9Z3D188Yat9IdP893o
	p4PEjXJPD7AxTPiYQYHtWHOsXyNWKU/QKRgEke8oFpyUhJAMD6Cvh9hxvPuFTbh3b5LvqwsQpcq
	L/HYLaelPKV6wmO6RN+qYULHM44RDaCIOhwoSkpsNBqNvfHUWIXcb2axHUac0ydKNe8YAH94r78
	sg2DXrZEo3YiFLEjKD5EJeB9NJjj10jaPeTy1acXqlw6/47pHXsp4mw7CO/m3kY6m8NDvfEEgcl
	P3/JltbgdOUFqNcXbngSpaWewiuz02nDxwy2IBocLd9vEPCFBRGw8QE3qz/8pvt6oAg==
X-Received: by 2002:a05:6820:2bc9:b0:6a3:7ad3:e728 with SMTP id 006d021491bc7-6b16b4122a3mr8491895eaf.28.1787511510948;
        Sun, 23 Aug 2026 11:58:30 -0700 (PDT)
X-Received: by 2002:a05:6820:2bc9:b0:6a3:7ad3:e728 with SMTP id 006d021491bc7-6b16b4122a3mr8491871eaf.28.1787511510468;
        Sun, 23 Aug 2026 11:58:30 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:29 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org
Subject: [PATCH 00/11] smb: client: fix OOB reads and UAFs in SMB2/3 receive paths
Date: Sun, 23 Aug 2026 13:57:56 -0500
Message-ID: <20260823185807.3115901-1-sorenson@redhat.com>
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
 fs/smb/client/smb2ops.c   | 45 +++++++++++++++++++++++----------
 fs/smb/client/smb2pdu.c   | 11 ++++----
 fs/smb/client/trace.h     |  1 +
 8 files changed, 116 insertions(+), 22 deletions(-)

-- 
2.55.0

