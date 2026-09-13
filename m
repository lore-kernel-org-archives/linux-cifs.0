Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606F035F184
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335922; cv=none; b=WDrEunNDBhcIYWsl5x8TcDKy5bWMwCY+ogAyWL8HzaTxfWyu9xTh/jtD5iacfsLIbGz1prlIRL0wJ+NTBb2PFd3O/DTRcsKiabH9OqT/HM2WbIbqp+uvObEDSbEwq8WuiTd++FtuyNz6ebrfXrtRjs6vh5FBoXqpcrxZNPUB/y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335922; c=relaxed/simple;
	bh=6YI8h6wjvuKxqhi5Vpvaei1YLh1uAhAA3Scmkh5bHc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nql3+M9LHlnOr79srn8VC+B8l4SG9DNrltmefepDVbg+FXC5bfbJFsiO0tYcaVLhhShhE3cdek8obj4+WM9aVLGXgvscZxCcXxfZ9M/67/5QXKQ4h4purmIBHLJP9X7AKBgz9M7aEnzOXP80eMqljb2QddFr9sjOFyPsygfNsvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BHb+5hxf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k0mwVWgD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BHb+5hxf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k0mwVWgD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jpwftxGezk2ehpP612fLbl89RJhhsOOqpYM29nPuh0Y=;
	b=BHb+5hxfM2gB3gwXBThYeJDORrTRR3Q46nRfa+8SV2WHNRYZ/2HPvknfl57R4z8akRvDi+
	72Ry/C/CMFj3UIy6UVedMpArjIV+skSlMwUAzxlP5t5Y75LQZnQT9loPsCAUJocnfUnebS
	MGnw7v7WlWw4kqndxUT95EiXl7qb+ww=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-_T2-jwVeNNS0m9BIsTorHg-1; Sun, 13 Sep 2026 17:45:14 -0400
X-MC-Unique: _T2-jwVeNNS0m9BIsTorHg-1
X-Mimecast-MFC-AGG-ID: _T2-jwVeNNS0m9BIsTorHg_1789335914
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530d028f779so28167471cf.2
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335914; x=1789940714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jpwftxGezk2ehpP612fLbl89RJhhsOOqpYM29nPuh0Y=;
        b=k0mwVWgD3G6Z25B7VR2kODuQgiypBh1YuzUs8QOR9XbxVW24RT2XsqBR4+skflWbet
         ZGFapN3pxT+B0HkYjmqmRxnsllNZpjfI1Z2SWcJQf07Go0gWuCqAGhdc0Cu8XIcKar/f
         DzHeu/qQ2xlB/BWsjJPGUXwQQOr2Z+Vn9KchQLU13qb7rElIfoyJwXp7miAn8R0fw/QC
         Pw543ANYEq8QDc2SyBfsHZXWLLM2ME3Z0E4ak/jJ9n5z5JesgCNL4IgSkemVpd3qpQHm
         /HEAHBdUQaNcSYc1wvhieXMZz50WRMXF6wcbasrpNoG9OU86MiLQNNEtI+Zhg/YLwS54
         Z31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335914; x=1789940714;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jpwftxGezk2ehpP612fLbl89RJhhsOOqpYM29nPuh0Y=;
        b=XBiW+XFqJ4sQz91qKlD5IaZqQq+HYJQqTeqkIjYQ3UzWI5LDKeWcDBTk7uel/tnCuW
         4VUu1XzSBK6M74Y7xVFVPV1SPCaSJe/g/rcujjm+2gU1FxFlsOzxEhC9H0GXRiGQi7EU
         noG3lTZVf0YJ5/Ptl+YQ0A3PplMzmG0bid42SXyFMV8QhnETiVkPvTt0hHLq0kSSh9u2
         daZHVx9c7da7FwAQ5XA7QpKtHT0DS+sL6nX4TjS7hlL7FHkNoQrCD8rxE5eCmfQnGOCO
         3rS4I06p3mW82FETdY+t+goAaRb0Y0IrR9ksQRbPT8Fex3f7wFOmIb0rcmTl+fxWZtQR
         Z3GQ==
X-Gm-Message-State: AFuF++mnbHaoJJUMr2XU8QAkZB/7idYxsBaumH1L+dM+lEQbuieQaaRN
	8bRFLRSfnTAwf/LVWyJWomlXl0Ip/2r0GVe1zrM5YHrayAcfim/873jCXM9ZEyqu+vAYsY8uxnB
	BSjo3HPexd5VzdqHD0LON9561LxksHGfqA1skZRjowBsknIXZGRtpJsEtPxWfYCrH8RrXHSwnS4
	exhYjQcO+3Yg+nm6e72imK5dELJpmmHNsEJLYv21r+CHo3Ffg=
X-Gm-Gg: AYBFou0UCaZiQFjwo4Gssb+plqgS/ksWu9UtgKu0MCsudSXuhZ+fbi09I3G2KezVFkt
	qiq7wmQER+6PBbccTZwlNl0AGVO9o6Y/PcED+fjxdnEwOEeThJwAzWlad0JX7H66GND8d1jWX5K
	efxOjmRnvRhoaOrPmL0d5GFO2Q6EulQQ+tQ2k5MtjHHgpNit8sbejuFzsZrGf6cbnvFjwVVoZLR
	/RPYx6eb6EbdnXvawZZQ2EK7uZxGnmVK9muC/ju0VUG5/egtP0CBGFfjT+Mk+W992rn1Tl8eDom
	zKxx3I7wDg6B6SSKsyXXwbCG5Cx5rrEMTmsd3zVPFBwt+CJQPpz9YpC1EqPb0ngLF9XpQljIUfP
	WHbaTbsDnD9Iia8ClAi027cL9LcAyrNPRCVoNFee1kCIRIe95vrIZNF+K04tZyqfa6w==
X-Received: by 2002:a05:622a:1341:b0:530:efea:7a55 with SMTP id d75a77b69052e-530efea8f78mr120064771cf.4.1789335914155;
        Sun, 13 Sep 2026 14:45:14 -0700 (PDT)
X-Received: by 2002:a05:622a:1341:b0:530:efea:7a55 with SMTP id d75a77b69052e-530efea8f78mr120063791cf.4.1789335913452;
        Sun, 13 Sep 2026 14:45:13 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:12 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Subject: [PATCH v4 00/10] smb: client: fix OOB reads and UAFs in SMB2/3 receive paths
Date: Sun, 13 Sep 2026 16:44:58 -0500
Message-ID: <20260913214510.3071370-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes ten bounds-checking defects in the SMB2/3 client,
all of which are reachable from a malicious or compromised server.

Patches 1-3 address the compound encrypted frame processing path:

Patch 1 fixes multiple pointer lifecycle and bounds-checking issues
in receive_encrypted_standard(), including a stale next_buffer pointer
that causes a UAF on error paths, and an integer overflow that allows
malformed trailing slices to bypass length checks.

Patch 2 adds a table of per-command minimum-response struct sizes,
used to reject responses too short for smb2_get_data_area_len() to
safely read command-specific struct fields.

Patch 3 fixes server->total_read tracking so that smb2_check_message()
validates against the actual per-sub-PDU size, rather than the full
remaining compound tail. Without this, a truncated non-last sub-PDU
could bypass the guards added in patch 2.

Note for stable: although patch 3 carries a Fixes: tag and Cc: stable,
I am not sure whether patch 2 should, since it adds a new table rather
than being a true fix. They are complementary: patch 3 supplies the
correct per-sub-PDU length that patch 2's guard consumes. Patch 3 is
safe on its own, but its computed length will not be checked against
the per-command minimum unless patch 2 is included as well.

The remaining patches fix lower-bound gaps and OOB reads in DFS referral
parsing, server interface list traversal, EA list traversal, posix SID
bounds, change-notify offset, snapshot enumeration, and SMB1 reparse
point validation.

The create-context patch carried through v3 as patch 11 has been dropped
from this series. Zihan Xi's recent series:

  [PATCH v3 0/2] smb: client: fix create context out-of-bounds reads
  https://lore.kernel.org/r/cover.1788516372.git.zihanx@nebusec.ai

covers the same defects, arrives with a PoC, and fixes
parse_query_id_ctxt() in a better way. Rather than post two
overlapping/competing fixes, I will help with reviewing and improving
that series instead. If it stalls, I'll re-post my version.

Testing compared cifs-next (7.2+) with and without this patchset:

samba - v3.1.1, v3.1.1+sign, v3.1.1+seal, v2.1, v2.1+sign, v1:
  - no new failures attributable to this series.
  - found netfs bug causing generic/759 with signing to fail
    (resolved by David Howells--now succeeds).

Windows Server 2022 - v3.1.1, v3.1.1+sign, v3.1.1+seal,
  v3.1.1+multichannel:
  - no failures.

v4 changes:
 - patch 2: dropped the smb2_check_min_pdu_len_table() BUILD_BUG_ON helper.
 - dropped patch 11 ("smb: client: fix OOB reads in smb2_parse_contexts()")
   in favor of Zihan Xi's series, as described above.
 - patch 9: corrected a bogus Fixes: tag. Explained bound choice of
   sizeof(struct smb_snapshot_array) vs the 16-byte MIN_SNAPSHOT_ARRAY_SIZE
   of MS-SMB2 3.3.5.15.1.
 - testing details
 - commit subjects and messages tightened throughout.

v3 changes:
 https://lore.kernel.org/linux-cifs/20260826153147.4112943-1-sorenson@redhat.com
 - respin entire series

v2 changes:
 - patch 6: reject next_entry_offset values that leave fewer than
   sizeof(*src) bytes remaining after advancing.

Frank Sorenson (10):
  smb: client: fix next_buffer UAF and NextCommand bounds in compound
    PDUs
  smb: client: validate minimum PDU size before smb2_get_data_area_len()
  smb: client: fix server->total_read for compound encrypted PDUs
  smb: client: fix missing lower-bound check on DFS referral string
    offsets
  smb: client: reject short Next offsets in parse_server_interfaces()
  smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
  smb: client: fix missing iov bounds check in parse_posix_sids()
  smb: client: fix underflow in is_valid_oplock_break() notify offset
    check
  smb: client: fix potential OOB read in smb3_enum_snapshots()
  smb: client: fix reparse buffer bounds in cifs_query_reparse_point()

 fs/smb/client/cifssmb.c   |  2 +-
 fs/smb/client/misc.c      | 12 +++++++--
 fs/smb/client/smb1misc.c  |  3 ++-
 fs/smb/client/smb2inode.c | 11 +++++++++
 fs/smb/client/smb2misc.c  | 40 ++++++++++++++++++++++++++++++
 fs/smb/client/smb2ops.c   | 51 +++++++++++++++++++++++++++++----------
 fs/smb/client/trace.h     |  1 +
 7 files changed, 103 insertions(+), 17 deletions(-)

-- 
2.55.0

