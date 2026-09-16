Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3584490C04
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594465; cv=none; b=GyDfhAtDDUYbwZxiMkw0ekORxozMHnvNv13Wkf196cauG+2S9/IgPWGzDGVXHmXQtLEc1H2Iicj4dTGQgFiR0PS704PvCEGnzthZTGiH90IH5Gq5eQX7oAwVzlXwjsI8UnOM7IFYM0Gm7RQzeA12Wo6G3oMwuXBBoGdojh/essM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594465; c=relaxed/simple;
	bh=r9w+50D1COSl4basbYhQOIbAE6Sik5aIMzx99XRPIbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tK6LSKn8oXeulggpJ5rPZoGaiUMycS8K9nOIKnhweQOJKx+L/f0EYjK2g/cra+rjJ19bIybtKGTkWGJkYWWehslCiLC9QwscGimBJVzN5ue7TtByIILA9QGglOfjh0WEo71qdbOuZCvN6qwu7ndgbzVTV2TqhY+qZaSaN6rmn20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zc/D7eQz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FbVvsHbP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zc/D7eQz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FbVvsHbP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ltM2wPa0EpCwglG94d9JqYBNjlebZGASY2FE0n4yZJQ=;
	b=Zc/D7eQzZwZEM+S0A068xrIOr6GZypCQTrzDw1lYaB8FQEE79ANPLg5l58bbOIWToPVYHg
	W2rYqcYqFXExlupQIESGpZC/dgUS8bcYr0So7KUV2zziuZude3OEWIuhTBenlaZg8+cvRz
	YnN20gmLMGebGaHQkpPk2b9jeRL5D9s=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-ioTiQfHTPHe2mLspnIC2ag-1; Wed, 16 Sep 2026 17:34:10 -0400
X-MC-Unique: ioTiQfHTPHe2mLspnIC2ag-1
X-Mimecast-MFC-AGG-ID: ioTiQfHTPHe2mLspnIC2ag_1789594449
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52dcf1bb6e9so2132801cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594449; x=1790199249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ltM2wPa0EpCwglG94d9JqYBNjlebZGASY2FE0n4yZJQ=;
        b=FbVvsHbPA5MEY7+myf0b5kcH8xCdm80hmlkA6ayAIyl1OVr0ts3jmjjcbyQ9U3I76s
         AKK+N6Q0PYcYdz4urFFahypPoYsjrubOCf7YU0pXodCw//llO4VphX0AaTVuvJERB394
         WfEb3+PWYDSepArqyljoDgiEm+0bJqS3XmUGvsaAt6Uo0s9rtfhnO/gbxoNMyPHBluUp
         +vp2aNUwZJs9OP/wTQdQFv5LzpY7iaZdh0KU4q1fxJFV45BN0ngjcqs1jbB+oWQW/UUD
         CDFPQvyaIfwPOpdNf4azI19rSOG0AIZ6xBG1c9r7UUZQUz6/7BAg+SetrU90V4udnDGo
         2iFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594449; x=1790199249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ltM2wPa0EpCwglG94d9JqYBNjlebZGASY2FE0n4yZJQ=;
        b=CgI4QGrJNgZCxqt2LY3RykR/aBDZBODyU971J5tOFr3ltUOgOND+hvfQenZCOki+yU
         VCYXKhH3upuY39uKLShcooQfJiIGWQIb6tWif0yRadulF4neeAakhgJhvXYFpufEC3cD
         E9tTa9mxJPQgTtmipwbyNO3hkbPu4goKSh3agaD8PFKRelV7qNjnNCm5hbDP6zR0ByJK
         ukqJazhUnKW3R6BYOsQrsf4Z/Z+HmHMDMLN9DS7P0XHgzBdTPiuqORioigQhfSVeVsMF
         9fNGAtyEGpf4SLzJwFO8haa8EEAiGCzPxNUrHe9LMoyJM+jFuTLTLQc6vPYx7eBdJ/K8
         pP1w==
X-Gm-Message-State: AFuF++lFfRHs1/6DMZvNCjRzLgbfDZMs50AtmchHR4OvXtkIGNVbg5Av
	rCkmq00qXWepWv2xMc83YYPTm0R9sgSH8kR45TnakjEaTPTffx+LS8p3r+MEY29yzGaXf8Yfb1g
	nD2JLJ3HA+nBhI9bdpKiqpdzbPG/OuloKQ0LpoqCJbPPBSEuB7mWyk5JiXQ8tdB0keFvc3kz0cB
	Nuq3/+UY42XFmenY/biFHKNqpd4HMSLnscsU0At2XflfccKJM=
X-Gm-Gg: AYBFou0iprMhRbf0TdeIzi9wZ8FZDG4P/aODFrPa2bwn5+Hd0wnn7JFxvuFqU4I2Ypm
	ts3sun2LzwcMtPbuzlDtopMFUFZsGQdrk9m54aDXkzzKbtGDcXX07DSV+JQXk2xSB6plJqkMDIi
	RbOfKfOkbxl4bn1khxxvxrw+VrZfxcgFg9IAeKJA1juxOcIyQj6C76ghFcX8oTeJrMB8PBNdQJh
	RO3N90r49/5lxM0F48b9Xq8ai8cTvPzNQj/oD47fpuN29D+FqotbWtXcEzhdfrYovkL6nYMICln
	xnuLbStIC/LXWzTEyybOk7eukFaxqXkYy1bLO9vrN956AoJ2dCojtS48wRc3S95X2tmLNusuFpo
	6RQ7dt4CRnR8sXN6kmGbD80JJmapcHOK+EBSlnwTCdQOOmzYIt5hzIUs6ZhAXP3e6Xw==
X-Received: by 2002:ac8:59cf:0:b0:531:215a:4e with SMTP id d75a77b69052e-5328d0092b7mr18725921cf.31.1789594449501;
        Wed, 16 Sep 2026 14:34:09 -0700 (PDT)
X-Received: by 2002:ac8:59cf:0:b0:531:215a:4e with SMTP id d75a77b69052e-5328d0092b7mr18725451cf.31.1789594448985;
        Wed, 16 Sep 2026 14:34:08 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:08 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Subject: [PATCH v5 0/9] smb: client: fix OOB reads and UAFs in SMB2/3 receive paths
Date: Wed, 16 Sep 2026 16:33:51 -0500
Message-ID: <20260916213406.1496960-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes nine bounds-checking defects in the SMB2/3 client,
all of which are reachable from a malicious or compromised server.

Patches 1-3 address the compound encrypted frame processing path:

Patch 1 fixes multiple pointer lifecycle and bounds-checking issues
in receive_encrypted_standard(), including a stale next_buffer pointer
that causes a UAF on error paths, and an integer overflow that allows
malformed trailing slices to bypass length checks.

Patch 2 replaces has_smb2_data_area[] with a table of per-command
minimum-response struct sizes, used to reject responses too short for
smb2_get_data_area_len() to safely read command-specific struct fields.

Patch 3 fixes server->total_read tracking so that smb2_check_message()
validates against the actual per-sub-PDU size, rather than the full
remaining compound tail. Without this, a truncated non-last sub-PDU
could bypass the guards added in patch 2.

Note for stable: although patch 3 carries a Fixes: tag and Cc: stable,
I am not sure whether patch 2 should, since it is hardening rather
than a fix for a specific regression.

The remaining patches fix lower-bound gaps and OOB reads in DFS referral
parsing, server interface list traversal, EA list traversal, posix SID
bounds, snapshot enumeration, and SMB1 reparse point validation.

The create-context patch carried through v3 as patch 11 has been dropped
from this series. Zihan Xi's recent series:

  [PATCH v4 0/6] smb: client: fix create context out-of-bounds reads
  https://lore.kernel.org/r/cover.1789478666.git.zihanx@nebusec.ai

covers the same defects, arrives with a PoC, and fixes
parse_query_id_ctxt() in a better way. Rather than post two
overlapping/competing fixes, I will help with reviewing and improving
that series instead. If it stalls, I'll re-post my version.

Testing compared cifs-next (7.3-rc2+) with and without this patchset:

samba - v3.1.1, v3.1.1+sign, v3.1.1+seal, v2.1, v2.1+sign, v1:
  - no new failures attributable to this series.
  - found netfs bug causing generic/759 with signing to fail
    (resolved by David Howells--now succeeds).

Windows Server 2022 - v3.1.1, v3.1.1+sign, v3.1.1+seal,
  v3.1.1+multichannel:
  - no failures.

v5 changes:
 - patch 2: replace the true/false indication of has_smb2_data_area[]
   with smb2_min_pdu_len[], which indicates both presence of a data
   area, and the size of it, if present
 - patch 8: dropped; the new check could never be true

v4 changes:
 https://lore.kernel.org/linux-cifs/20260913214510.3071370-1-sorenson@redhat.com
 - patch 2: dropped the smb2_check_min_pdu_len_table() BUILD_BUG_ON helper.
 - dropped patch 11
     ("smb: client: fix OOB reads in smb2_parse_contexts()")
   in favor of Zihan Xi's series, as described above.
 - patch 9: corrected a bogus Fixes: tag. Explained bound choice of
   sizeof(struct smb_snapshot_array) vs the 16-byte MIN_SNAPSHOT_ARRAY_SIZE
   of MS-SMB2 3.3.5.15.1.
 - testing details: 7.2+ with samba & Windows Server 2022
 - commit subjects and messages tightened throughout.

v3 changes:
 https://lore.kernel.org/linux-cifs/20260826153147.4112943-1-sorenson@redhat.com
 - respin entire series

v2 changes:
 - patch 6: reject next_entry_offset values that leave fewer than
   sizeof(*src) bytes remaining after advancing.

Frank Sorenson (9):
  smb: client: fix next_buffer UAF and NextCommand bounds in compound
    PDUs
  smb: client: validate minimum PDU size before smb2_get_data_area_len()
  smb: client: fix server->total_read for compound encrypted PDUs
  smb: client: fix missing lower-bound check on DFS referral string
    offsets
  smb: client: reject short Next offsets in parse_server_interfaces()
  smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
  smb: client: fix missing iov bounds check in parse_posix_sids()
  smb: client: fix potential OOB read in smb3_enum_snapshots()
  smb: client: fix reparse buffer bounds in cifs_query_reparse_point()

 fs/smb/client/cifssmb.c   |  2 +-
 fs/smb/client/misc.c      | 12 +++++--
 fs/smb/client/smb2inode.c | 11 +++++++
 fs/smb/client/smb2misc.c  | 69 +++++++++++++++++++++++----------------
 fs/smb/client/smb2ops.c   | 51 +++++++++++++++++++++--------
 fs/smb/client/trace.h     |  1 +
 6 files changed, 102 insertions(+), 44 deletions(-)

-- 
2.55.0

