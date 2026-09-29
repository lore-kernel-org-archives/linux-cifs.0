Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976704E9C24
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673499; cv=none; b=QXuxHLCGfEWcUrvKe3TfX128AZ/9mUAisKDZqspAgqFn19VdSaPgaMqGlJ6/OgBT4+1gIuqkhin+FY61HUjQfFQBbBnTGqEZ48K9/a/56C0WzG+X/p/WCbggbts/TK5WZNB0BPH/CajskQJ8oKInF7BD/IBywVF/wcmSsWsygWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673499; c=relaxed/simple;
	bh=5RoJX4J5nsGYQb6NyAy+6GPZ7UnpZs2q8cGxCvpuf7g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=teNaoMXzE9ZzpTXnEreLvIEUBmZ2SR2ayCzi0hBiAaavJ+roGgRFI+2gvRg7zobohyeJK0RpWaerSzVZvelzDDTRyXv5nPW5+0MZBFFRhTzzwNXPLMIHY9UYZ0E0GzvY41CJowx6o66YUVWFhIYiRngglffvJZpAGPAfadI1hMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=FY4pIEYG; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="FY4pIEYG"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffb83bf7aso23655595e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 02:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1790673489; x=1791278289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1rqknybtXWAdOUy55Zql81N3jT1LXS9mSFWzEN58cPE=;
        b=FY4pIEYGASfywMbgG70LpLeAIBAKCClQ+GfGZL5p/zUgxEIIrd2jtFgIuhVvHoD74A
         MyQIHGC6sJ8zaoSUEqiQXU7oucmNHMbJQQM/SzxMmCQhw4CVIQaAtbu+5aUuuXgtd+Gt
         ZLqWiOYBDBx2aLcp4QK+iFsh8Jb4oBe5sjslzaC+mT3p5FOhVOeuC7SN0EdECm7tCATT
         I4TQtsKV0be/eFSlPxlct4VDhKFvy1ZfFXtFsJ77FDeMFV0VhOjB/2DISyLydG9xV2WY
         c5z5ICpM5u47VX1kj/ny+Msdo0lziwcr/oTYRQ44BNc2WmfCte8YDDszcRLZ/jP+ynyx
         fpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673489; x=1791278289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1rqknybtXWAdOUy55Zql81N3jT1LXS9mSFWzEN58cPE=;
        b=duf55H0fz/zEZOh7Se2mjoEVBgxT0pVeyNYYHz4T06P6Iih3g2LhBCNx/ki75VlbHc
         jWgp+ByA5IhUrD27j2ds0CNOaeoW5xP58df9jXfkkxstvAVomfxpxXydC6P4KcaQvEFC
         ZcvpcbBHrRbV+X/izIvey0+x+QxAXLixvxe+0sUWHQrf597Qie8QUnaRVHhADgI5KZXC
         v2W1C8j3D5QDATN+yo37iDcN7yJraKywzo0EoO9KyzudUd3SPR0Kxa36uiRLAwKJQE2R
         oPIKzCLSMpQdaw9QO+2E5xE521IW0GWndVXk3ooobQzL8WR4OYvRi3miz5qSjurw5SVF
         7lTA==
X-Forwarded-Encrypted: i=1; AKwUvBz6jf/PCp3pIf0zeDyR+Z2f8WHA+1qq81HquXqvmwRyq+a64BJCLnAYDnYlLCY+JrQm05bXttZ2Uw7b@vger.kernel.org
X-Gm-Message-State: AFuF++mq0xNIAoIEjOWxKVHSz+RmeHN4LfgUi+t/TWaan26X1l+LSU3e
	oygAcCutnQMihCrQ0SVBPFzItNKCFWrUATVQ+3NQgjNYK2pjLADyeYwZQI7y9ggeliul
X-Gm-Gg: AYBFou1QvV29f2rjQFz4glTKSuccFYJtl+Vd2IQNLCto4GFr0WE2wjQFqZKImIVvK3U
	IzFAJab21anGSak6Ghn8JvGuz1jMVFYhW344PXCwGbIuhKQjs9BC6fQg9PoWaN4e1wJnV9YEKwu
	UbSnmnPjsHFGF/duUJyp05omoHinQntg0FKgcsUW0jWJujY13Wt0K43tqt+rV6HpNgkXD0B6C/w
	GrVDId6UYt1ovSVbBIBFSWjvJZ7JczPmQOxU4lyFmKilTg6KYoVz9HciUoMPpkwGQkuiWrysbaH
	xskbpfViQqhk7uJ6UTjcPnMunJPeGVwCP3Rh+vKoMgh81J72zZLTlNennKW4Sj63FaSH/gijXef
	2XczTsPbjZDUWNf+1x/RRFdlPl/1Y59FTc0Lw5q2II9TV9QsbvPec5IP/v8brgfGH1WM7su8/fl
	sHxpyhi0bVRCTrYMvd/AnDqqiJQbYwnT4wjOma8Ya5TXQKYMTSQqIt8pezaQwiS4glnRfwFynC/
	EO32r+xvcNH0WmmOgs3IEy/TSM=
X-Received: by 2002:a05:600c:1906:b0:49f:bd3c:bc25 with SMTP id 5b1f17b1804b1-49fe67107d1mr262080155e9.32.1790673489103;
        Tue, 29 Sep 2026 02:18:09 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af51c57a0sm2155723f8f.15.2026.09.29.02.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 02:18:08 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Jeff Layton <jlayton@kernel.org>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] smb: client: fix OOB and use-after-free infoleaks in SMB1 FIND responses
Date: Tue, 29 Sep 2026 10:16:29 +0100
Message-Id: <20260929091636.2618227-1-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SMB1 client parses TRANS2_FIND_FIRST2 and TRANS2_FIND_NEXT2
responses without checking them against the number of bytes it
received. A malicious or compromised server can make the client read
past the end of a response, and past the end of the cifs_request
buffer holding it, and send what it read back to the server. Both the
out-of-bounds reads and the use-after-free read are information leaks:
the bytes leave the machine in the client's next FindNext request,
from a position the server picks:

 - LastNameOffset, which the client uses to locate the last entry of
   a response, is only checked against CIFSMaxBufSize, never against
   the response that was actually received, so psrch_inf->last_entry
   can be placed past the end of the allocation.
 - cifs_save_resume_key() parses the entry there without a bound. The
   name length comes from the entry itself, and for SMB_FIND_FILE_UNIX
   from a NUL scan of up to PATH_MAX + 1 UTF-16 units. The name is
   recorded as the resume name of the search, and the next
   CIFSFindNext() rejects only a recorded length of PATH_MAX or more
   before copying the name into its request and sending it, so up to
   4 KiB of memory from beyond the response leaves the machine,
   together with the resume key read from the same entry.
 - When the last entry is rejected, and when a search rewind frees
   the buffer without its FindFirst recording a new name, the resume
   name keeps pointing into a buffer that has been released, and the
   next CIFSFindNext() copies it from there.
 - The response parameters (search handle, entry count, end-of-search
   flag, LastNameOffset) and the data area are read at offsets that
   validate_t2() caps at 1024. It bounds the parameter and data
   counts by the byte count of the response, but nothing ties either
   area to the bytes that were received, so one can begin or end past
   them; those reads stay inside the allocation but can return stale
   bytes.

A FindNext response that reports no entries without ending the search
is enough to make the client send the resume name, and each further
response can do the same. Reaching the code needs a malicious or
compromised server, an explicit vers=1.0 mount of it
(CONFIG_CIFS_ALLOW_INSECURE_LEGACY, default y) and a directory listing
on that mount; SMB1 is not negotiated by default. The same code is in
every maintained stable tree.

Commit f8cf09a53a0d ("smb: client: bound dirent name against end of
SMB response in cifs_filldir"), in v7.2, bounded the name of the
entries cifs_readdir() emits, after the parse; the resume-key path was
left unbounded and the parse itself still ran before any bound.

The fix is one change conceptually, but as a single patch it is well
over the 100 lines with context that stable-kernel-rules.rst allows,
so stable could not take it. This series splits it into patches that
each fix one thing, build and pass checkpatch on their own, and stay
under that limit.

What each patch fixes, and what to backport:

  1/7 fix use-after-free infoleak via the readdir resume name
      The use-after-free. It comes first so that the patches after it
      cannot widen the window it closes. Also resets resume_key with
      the name and skips the zero-length copy in CIFSFindNext().
      Tagged Cc: stable.
  2/7 fix OOB last_entry pointer from unbounded LastNameOffset
      The out-of-bounds pointer, bounded against the response that
      was received rather than against the declared data area. It
      applies on top of 1/7, whose resets sit in its context and
      which makes the paths this patch sends more responses down
      safe. Also records the search handle before the last entry is
      examined, because the new no-entries case would otherwise lose
      the handle. Cc: stable.
  3/7 fix OOB read of the resume name sent in TRANS2_FIND_NEXT2
      Bounds the entry parse in cifs_fill_dirent() for both callers,
      before anything is read. This is what stops a name from being
      recorded and sent from past the end of the response.
      Tagged Cc: stable.
  4/7 fix OOB read in the SMB_FIND_FILE_UNIX name scan
      Caps the NUL scan at the response end; without it the scan
      still runs several KiB past the allocation. Depends on 3/7 for
      the end of the response. A scan that reaches the end of the
      response without finding a terminator is rejected; a name
      longer than the PATH_MAX cap of the scans is still truncated
      there, as before. Cc: stable.
  5/7 reject FIND data areas that run past the received response
      Hardening rather than memory safety: it stops entries being
      parsed from stale bytes inside the allocation, and bounds the
      data area that the nxt_dir_entry() walk starts from and that
      the two query helpers read their entry from. It rejects with
      -EINVAL, as validate_t2() does, logging with cifs_dbg(), and
      adds no tracepoint, so it applies to trees before 6.19.
      Cc: stable.
  6/7 reject short or out-of-range FIND response parameters
      The parameters are read inside the allocation, but the stale
      search handle among them is sent back to the server. Depends on
      5/7, whose declarations it extends. It returns smb_EIO2() with
      two new smb_eio_traces values; backports before v6.19 need
      -EINVAL instead. Cc: stable.
  7/7 drop the redundant name bounds in cifs_filldir()
      Cleanup of the two post-parse checks that 3/7 made redundant.
      Depends on 3/7. Not for stable.

No patch needs one that follows it, so the series can be cut after any
patch. Patches 1/7 to 4/7 are every out-of-bounds and use-after-free
fix; 5/7 stands on its own; 6/7 can follow where smb_EIO2() exists.
Trees before v7.2 need the adjustments noted in the patches that need
them.

cifs_fill_dirent() is shared with the SMB2 readdir path; 3/7 and 4/7
add checks there that a valid SMB2 response cannot fail, since
smb2_parse_query_directory() already walks its entries against the
end of the response.

Left out on purpose: an entry-size check for cifs_query_path_info()
and cifs_backup_query_path_info(), which still read one whole entry
from a data area that 5/7 bounds only as a whole (those reads stay
inside the allocation); passing the end to posix_info_parse() in
cifs_fill_dirent_posix(), which only SMB3.1.1 POSIX mounts reach,
with entries that num_entries() has already validated; and a lower
bound on ParameterOffset and DataOffset, since reads at a low offset
stay inside the received response.

Each patch builds with W=1 without warnings and passes checkpatch.
The out-of-bounds reads and the use-after-free read were reproduced
against a test server with KASAN enabled, by listing a directory on
an SMB1 mount; the splats are in 1/7, 2/7, 3/7 and 4/7, all taken on
the unpatched tree. The one in 4/7 shows the case the preceding
patches leave open, where the entry starts inside the response and
the scan still leaves the allocation.

The series is based on cifs-next at commit f14572c203d5 ("Merge tag
'cifs-fixes-7.3-rc5' of https://git.manguebit.org/linux"). The files it
touches are identical there and in v7.3-rc4.

Diego Oliva (7):
  smb: client: fix use-after-free infoleak via the readdir resume name
  smb: client: fix OOB last_entry pointer from unbounded LastNameOffset
  smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2
  smb: client: fix OOB read in the SMB_FIND_FILE_UNIX name scan
  smb: client: reject FIND data areas that run past the received
    response
  smb: client: reject short or out-of-range FIND response parameters
  smb: client: drop the redundant name bounds in cifs_filldir()

 fs/smb/client/cifssmb.c | 78 ++++++++++++++++++++++++++++++++++-------
 fs/smb/client/readdir.c | 68 ++++++++++++++++++++++++-----------
 fs/smb/client/trace.h   |  2 ++
 3 files changed, 114 insertions(+), 34 deletions(-)


base-commit: f14572c203d57492e1d4e5d7851a3b143e083b82
-- 
2.39.5

