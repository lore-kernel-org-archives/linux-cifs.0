Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613680;
	b=LK/aq9IXZsq39iM5T954oENlniycP7pU7jm5OThwMqv2WQ5EGGPNz7FiCIQVwWe0U9hD
	 FfqR5SW9XsvOHiP4zM/wSLLdO+H0Q1JUxW4Cb9VvUYrg/BzLjDm6+w9zefacQe4q02212
	 uXBHSfkhWrbmh+2AGEvmIeK9ELN+1uEl6w7UnlYP214Y4u3Yad6IUpEI1fejhY8VXsqaz
	 oHOtqbaFv4tHpb9PBebXH8H4VHPgIHUc/jEJmDzCdmZ1AC8/4QvX43P3G0peCL2texywa
	 tvo1lBuat3Cqf+MvCsga2IqLege5mIBa0X1Lfn72ZS85MZrltiEQEn25Bf17lyJPQGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613680;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SkuUEALjbrIYbCusjHIuGST1/HrwSxuk1eRcpKlNN6M=;
	b=JSRQZ7Kw8wS+Uqr8mphBHoAIKCWpGpBTJ6cQaXKWageEql+LtskRlUJWIQGU6hL4OgWr
	 hGIozgZDLQAVeV8fX6floru4guLXYoCkdl7SiUWjjsDpykpSBLOp2/PxLFftrxIurB7wW
	 fc9wMBW/afkauGi+njOUIUHwHjPEYpSWhmNMAIxxVsjnEWO3X9mRDRVvxM1imCRNMFNwr
	 gcUZWHsyZuEj41sf44cssL2AlBXAhD4/gBI1fR+dtKUtd45O29EgFzqDj8uGn3icflBxW
	 eybomFsnnunaPX8yZ8klEcVLA4Uf4MN+ojuD8qTJnavwFnFt1DEFMFCEPc5yqO1Fp1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=M3ltkpoG;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=O0TE4Km0;
	arc=none smtp.remote-ip=202.12.124.151
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDBE606A323
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 13:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDDBE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=M3ltkpoG;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=O0TE4Km0
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id E85A61D00522
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 08:34:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 25 Nov 2026 08:34:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795613678; x=1795700078; bh=SkuUEALjbrIYbCusjHIuG
	ST1/HrwSxuk1eRcpKlNN6M=; b=M3ltkpoG0dAq0hg1Iwo/1FzqUur1TIGoUVMju
	sfZXwhwH/ficAkvkMtyWIOhlgh2cLvmQH5J1bU+O5mDdiuqGgMD6x6hHoOdtRr/o
	EW46xPgXUFtzWlE4JEN7Etk14WwK1ae8Xhlfa+oNdRnAAE6y+RtXf2Nxtm0VcbYC
	OAYUf7JnCyuoUTV8XnWRJbt6EkjWekDQ/d21KORST/rA2Z/T56glIK9V67AB1866
	5qOl/XodPn8dAjGNAaKrmPTNGL+/puUykWpJ89EvmWiQIVyEVCXLzqojf94bfFLa
	KZHEqW9Smvg5/D9iaxB/NkbXr5KHtPwlga/Xe3BjB6aE95JjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795613678; x=1795700078; bh=SkuUEALjbrIYbCusjHIuGST1/HrwSxuk1eR
	cpKlNN6M=; b=O0TE4Km0DV6vjwPXre5NrlA1RMjX+bF7x3zLRXdyD/0t34izhDP
	ybeU+HrDAjxQU/+8LbBb/+nlqV2xy+VpokO5N+HGluDaJzg4SiHn9qCpRs2CVPPl
	k7YWnklq6ujPxZlbSD3zvFJ/sT5xIUL2dOkfz4zKseLe9xcwPZbxtMN5oZlGeZ8t
	cKYjg6hdFDMEeli/yEVLp6u1159hG9tdBOYSoWpDWSGHSc/zIXQnR9NzYWUuWxQG
	TEJYF9DvXeSqZna9v5rS/5iUjd8MTRK4WvhOYSqCRVE/5RKhPEEItJKjPrynNDMn
	4RfXsaxCzJC6kHoNPTixlOzLb46UFLgI/NQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795613678; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:RbZgvOydd4547YfjQrd8kZri1NU+8IIgJog7dzEH8/lj24X
	098aM2NaVhyqEy8HwfCt1Ec11Bda6lL0kM17tRik9AODnwATA/FTaz8PTHkbA9I6
	fmMRyCn3mTkUNieTtvyc8Vg+luAVWEDeSesQ7LIAq7N9c+aEUx/x+0Lo0hmQ4Puj
	I5cHDWmtTmS7GgfbS19FqEu0gb798AEtMdnK5RhK/E0t5uPZNQm0fgZ7FWkjuiBb
	OhO4x8PZbUcU1szACdxUuM98zeoDkdNoWpNi0zG9DJopQrS9z2S2Ns8v/7Wtqw09
	f9ZKbU0P+jNfmcIjS8L/hSJlslTUcVAt2b3CFXw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:oQlWRtD405kru+OGPATYj2tCk/rMI4HVXz2dwUyJYio=:rgC9KHIr82sLl9l6zYVqTX+odcBJqbQOCp5JoxqQN6w=;
X-ME-Sender: <xms:7eMGa3rZa7dFfMRNAheTCizWE-XU4kEFxnrPSxEC7gjfNRp1nCRJ4Q>
    <xme:7eMGa1V2OD6loEWJv5sZUp8Q-Z05JL-luIGjt58efUqsGADsmOx8tpwBXlIOzgQZa
    dz2HCm2FxMUixI8p9lt7nwUS7KqhQmOw88RoHEFU-6_n4KBV94ensg>
X-ME-Received: <xmr:7eMGa-Aaek0OaCa3LKVYGKK8aSFxJQgqCJDEsz-BfQclYOrjJkosn_ybjstcU004>
X-ME-Proxy-Cause: dmFkZTEZD6DckhnHZBqsq7kF22GaiWrfroToxxCsW2uhi6LtvaZ/1Dp89W763TltAa/SC/
    mA7pSB8pZMA/NqjsJtyBjlXgYBvNe+xfwSTUbPH4uKlLQFxqxpG6H9RQA7qPPjMsDefCFW
    53YQP6goGskOrU54Bv3N2YwsXmHNYS7RCZYMkRhuPbwd2vUG9CCgeHelgR63Y5TUKUAD59
    Y4Vu6PLiYH4BM5+C2OZx3m5YE7FNscmYYKqAlXN1Ft/3t1ICzSUydI5taDbJ6Seb/Ij3Wi
    bmPIJT/nHiQPaIfV7fP5tvhntl4jARhUPOIF+nyowl1L9cs1N0mKTwdT9Mhu4TrfRAi7iB
    8efH/DDQYXfJWR37ZXvZnz+1fMzeNz+jmiRglX3JmC1Mjlw/7oRQh+PUZT+BEvWzXKK05s
    b5KpYboqmTaWWmU7l6mHhH4icrbt0WLhL6STqqyAdY4SvM+ZIisSbuAn8XPeESeItfs46Q
    4yT/m19oCDsOMlPIebulWwi+B0pk/ckn9SVQK8enLR0xaM4+gOIGwBeCZbYNpyOIMb3fPm
    DOlDjiO1CxZfmkinE9EcAbkLCLobDEzkgfzDWrVIY1Zhlm6qdfvp6Iet6i1VVEsNDF9Ewm
    wQHxO5n1DpGx6CUKvv5LVsJwZbxlYwA67wXT7cwY5XpYvEStka1qrN0Ync6w
X-ME-Proxy: <xmx:7eMGax0hkJthxs2WmKZ1SU2S2fXD1JKDcs2a_Qk5wc2zTxjVI5tmAw>
    <xmx:7eMGa432T83NSOcBMXr1UifJsuRaOF70eIgPsaJEqKcr07cuQcaSLQ>
    <xmx:7eMGa-DGumFs5UP0hl5vbs3628ZNodALSMRU-iQR4WJiMc1tcVZlSQ>
    <xmx:7eMGa_5jvA-g5vAjLCIQfYc3eLihMDtTv8MgsTkUX6IwiMNenc-iqw>
    <xmx:7uMGayZ_BerR4GepSEuY_ShYc2Laku6SaK_LPIZGjrCPvKzsckhPOfIV>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 08:34:36 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH v2 0/2] ksmbd: decode and encode security descriptors in one place
Date: Wed, 25 Nov 2026 07:34:28 -0600
Message-ID: <20261125133430.1177754-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd reads and writes NT security descriptors (SDs) in five places:
QUERY_INFO, CREATE, inheritance, SET_INFO, and the access check. Each
walks the raw bytes with its own bounds checks, and those walks in
smbacl.c have needed a long run of fixes. This series replaces them with
one decoder and one encoder, so the bounds are checked in one place and
the callers handle no SD bytes.

Patch 1 adds the decoder and the encoder with their KUnit suite, and
nothing calls them yet. ksmbd_sd_decode() validates a whole
self-relative SD and returns a struct ksmbd_sd in a single allocation.
The struct is plain data that the callers read directly, and every
pointer in it points at bytes the decoder has checked. ksmbd_sd_encode()
checks a struct that a caller filled in and writes the SD to a buffer it
allocates.

Patch 2 is the cutover of the existing code to the new codec. The
functions in smbacl.c keep their names and their logic, and only the
code that read or wrote the bytes of an SD is replaced. The decisions
the callers make are meant to stay as they are. A decision changes only
where the decoder reads an SD differently from the walk it replaces, or
refuses one the walk accepted. Other changes to those decisions are left
for later patches.

The earlier proposal [1] left the access check, smb_check_perm_dacl(),
as it is. This series converts it with the others, because the loader
of the stored SD now returns a decoded SD.

Changes since the RFC
=====================

v1 was an RFC [2]. Thanks to Namjae for the review of it. The second
and third changes follow his answers.

- Rebased onto ksmbd-for-next b0bd2fe7715f. Patch 2 stopped applying
  when commit 3cfe35e0d26c ("smb/server: fix little-endian values in
  diagnostic messages") changed a debug line in parse_sec_desc() that
  the patch removes.
- A malformed owner or group SID no longer makes a stored SD malformed.
  The decoder leaves that SID out, as it does a malformed SACL, and
  ksmbd uses the DACL. An SD from a client with such a SID is still
  refused. The flag sacl_dropped is now part_dropped.
- CREATE succeeds when the SD built for the new file is too large to
  store. The file then has no stored SD.
- The codec and its tests stay in one patch.

Changes in behavior
===================

The message of patch 2 lists the changes, and the rules the decoder
enforces are the sd_malformed() calls in patch 1, each reached by a
KUnit case. The changes below are the ones I would like feedback on.

A malformed SD from a client is refused whole. A stored SD is refused
whole if its header or its DACL is malformed, and a malformed owner SID,
group SID, or SACL is left out of it. The walks have no common notion of
a malformed SD. Some malformed SDs are refused by no walk today. Some
are refused on one path and read on another. Some are cut short at the
bad ACE, and the ACEs before it are still used. The decoder refuses an
SD that breaks a structural rule of MS-DTYP. Most of the rules are
bounds. The rules below go further. Each item says what the series
refuses and what the walks do with it today.

1. The decoder refuses an ACL if it cannot read all AceCount ACEs
   within AclSize. Today SET_INFO and inheritance refuse a count above
   (AclSize - 8) / 18, and otherwise each walk uses the ACEs it can
   read. Using the ACEs that fit would enforce a part of an ACL.
2. The decoder accepts Revision 1 for an SD and for a SID, and
   AclRevision 2 or 4 for an ACL. It refuses any other value. Today no
   walk refuses another value, and the SD is stored and used. The
   revision says which layout follows.
3. MS-DTYP 2.4.4.1 requires AceSize to be a multiple of 4, and the
   decoder refuses an AceSize that is not. Today no walk checks it, and
   each steps by AceSize to the next ACE.
4. The decoder refuses an ACE type that MS-DTYP gives no layout. These
   are 0x03, 0x04, 0x08, 0x0E, 0x10, and anything above 0x13. Today
   every ACE is read as a plain ACE with its SID at byte 8, so an ACE
   of these types is stored, returned, and inherited. Without a layout
   the decoder cannot say where the SID is. This is stricter than
   MS-DTYP 2.4.5, which lists 0x03 and 0x08 among the types an ACL can
   hold.
5. In an object ACE, two bits of the Flags say which GUIDs come before
   the SID. The decoder refuses any other bit. Today the walks read the
   Flags as the start of the SID, and SET_INFO stores the ACE if those
   bytes pass for a SID.
6. The decoder refuses a nonzero OffsetDacl in a stored SD without
   DACL_PRESENT. Today QUERY_INFO, inheritance, and the access check
   use the DACL at that offset. SET_INFO already refuses this from a
   client. The two fields disagree about whether the SD has a DACL.

Not everything that MS-DTYP forbids is refused, for example a SACL ACE
type in a DACL. Two things are let through for a reason. An SD without
SELF_RELATIVE is read as self-relative, since ksmbd has stored SDs with
the bit clear. A malformed owner SID, group SID, or SACL in a stored SD
is left out so that the DACL remains usable. An SD from a client with
any of the three malformed makes SET_INFO or the CREATE context fail.

A refused SD is handled as follows.

7. From a client, in SET_INFO or a CREATE context, parse_sec_desc()
   returns -EINVAL, as it does for the SDs it refuses today. Nothing is
   mapped and nothing is stored. The file that a CREATE made stays, as
   it does today when the SD is refused.
8. QUERY_INFO of a malformed stored SD fails with
   STATUS_INVALID_SECURITY_DESCR. Today the reply holds the ACEs ahead
   of the malformed one, or a NULL DACL if the header of the DACL is
   malformed. An open that runs the access check is denied first
   (change 9). So this is what a handle that was open already gets, or
   one opened with FILE_DELETE_ON_CLOSE, for which smb2_open() does not
   call smb_check_perm_dacl().
9. The access check denies every request against a malformed stored SD.
   Today it decides on the ACEs ahead of the malformed one, and it
   makes no check if the header of the DACL is malformed. A DACL that
   cannot be read whole cannot be enforced, and the part that was not
   read may hold its deny ACEs. The same check hides such a file from a
   directory listing on a share with hide unreadable set. The cost is
   that such a file cannot be repaired through an open that runs the
   check, since WRITE_DAC is denied as well. A handle that already has
   WRITE_DAC can still set a new SD.
10. Inheritance does not inherit from a parent whose stored SD is
    malformed. The new file gets the SD built from its inode, as when
    the parent has none. Today that happens for some of these SDs, and
    for others the file inherits the ACEs ahead of the malformed one.
    A parent whose stored SD has only a malformed owner or group SID is
    inherited from, and the stored SD of the new file is without that
    SID. Today inheritance refuses such a parent if the SID is out of
    bounds or has more than 15 sub-authorities.

A stored SD can be malformed because a client sent a malformed SD to a
ksmbd that stored it unchecked, or because the SD inside the xattr was
damaged. ksmbd has also written two kinds of malformed SD itself, both
when a file inherited from its parent. I have found no others. In the
first kind, the parent had an inheritable object ACE, and inheritance
wrote that ACE without its GUIDs. The DACL of such an SD is malformed,
so the access check denies.

In the second kind, the DACL is intact. Before commit 4616bbc5389a
("ksmbd: build an inherited security descriptor with its own offsets"),
inheritance wrote the child's SD at the parent's offsets. If the parent
stored its DACL before its owner and group, and the child's DACL came
out larger than the parent's, the larger DACL overwrote the child's
owner or group. In v1 the overwritten SID made the access check deny.
In v2 the decoder leaves that SID out and the check uses the DACL.

One change is not about malformed SDs.

11. A DACL that would pass 65535 bytes fails with -E2BIG, and
    QUERY_INFO returns STATUS_INSUFFICIENT_RESOURCES. Today the POSIX
    ACL entries that do not fit are left out. build_sec_desc() fails
    with -ENOMEM if an allocation fails while the POSIX ACL entries are
    mapped. Today the rest of that POSIX ACL is left out. A DACL cut
    short reads as the whole DACL, to a client and to the access check.
    An inherited DACL that is too large is handled as it is today, and
    the new file gets the SD built from its inode. Inherited ACEs now
    keep their data, so a child DACL can pass the limit where it did
    not before.

    A default ACL too large for a DACL takes about 1800 named users for
    a file and about 700 for a directory. CREATE under such a default
    ACL succeeds, and the new file or directory has no stored SD. The
    POSIX ACL it inherited is in place. In v1 the CREATE failed after
    it had made the file.

Tests
=====

Tested on ksmbd-for-next b0bd2fe7715f. Every test below was run again
for v2.
- Each patch builds with W=1 and no warnings (GCC 14, x86_64 with
  KASAN), and sparse reports nothing in fs/smb/server. With both
  patches applied, fs/smb/server and its tests also build for 32-bit
  x86 with GCC 14 and clang 22, W=1 and no warnings.
- KUnit under UML passes at each patch with GCC 14 and with clang 22,
  which enforces __counted_by. With both patches that is ksmbd-smbacl
  5 of 5 and ksmbd_secdesc 6 of 6, 38 cases with their parameters.
  Patch 2 adds the fifth ksmbd-smbacl case.
- The same KUnit suites pass under qemu on 32-bit x86 (GCC 14), on
  x86_64 with KMSAN (clang 22), on big-endian s390 (clang 22), and on
  32-bit big-endian PowerPC (clang 22).
- checkpatch --strict reports nothing but the note about MAINTAINERS
  for the new files.
- smbtorture smb2.acls, smb2.setinfo, smb2.getinfo, smb2.create,
  smb2.sdread, smb2.maximum_allowed, smb2.winattr,
  smb2.delete-on-close-perms, smb2.dosmode, and smb2.rename give the
  same results before and after the series, on a KASAN kernel booted
  with kasan_multi_shot. The one exception is mkdir-dup in smb2.create,
  which is a race. It passed 19 of 60 runs on the base and 24 of 60
  with the series. There is no KASAN report or warning, and the kernel
  stays untainted.
- Scripts that query, set, and inherit SDs of many shapes over SMB were
  run before and after the series. Every QUERY_INFO reply is the same
  but for an inherited callback ACE, which keeps its application data.
  One SET_INFO that was accepted is now refused. Its object ACE has an
  undefined bit in its Flags. The stored SDs differ in their bytes,
  since each is now the one the encoder writes.
- I damaged two stored SDs by hand. I raised the AceCount of the first
  by one and cut the second short inside its header. The base uses the
  first SD and treats the second as missing. With the series, an open
  that runs the access check is denied for either file, and ksmbd logs
  a warning. QUERY_INFO returns STATUS_INVALID_SECURITY_DESCR on a
  handle opened before the damage and on a handle opened with
  FILE_DELETE_ON_CLOSE. SET_INFO on the handle opened before the damage
  repairs the file.
- I changed the revision of the owner SID in the stored SD of a file
  and of a directory, and did the same with the group SID. Every open
  and every QUERY_INFO reply is the same as before the change, with the
  series and on the base. A file created in the directory inherits its
  DACL. With the series, the stored SD of that file is without the SID.
- On a tmpfs, under a directory whose default ACL names 1900 users,
  CREATE succeeds with the series. The new file has its POSIX ACL and
  no stored SD.
- With slab allocations under the decoder and the encoder made to fail
  one time in five (failslab), smb2.acls, smb2.create, smb2.setinfo,
  smb2.getinfo, and the scripts leave no KASAN report, no warning, and
  nothing for kmemleak.
- Out of tree, the converted functions of smbacl.c were run in
  userspace under ASan and UBSan against upstream's functions compiled
  verbatim. That was about 1.1 million comparisons over generated and
  hand-written SDs for the QUERY_INFO reply, SET_INFO, and inheritance.
  Every difference from upstream is one the series lists. The
  QUERY_INFO comparisons do not cover a stored SD that the decoder
  refuses. That refusal is in smb2pdu.c and no reply is built.

The 32-bit, KMSAN, and big-endian runs are of the KUnit suites only. A
live server was tested on x86_64 alone.

The proposal mentioned CBMC proofs of the decoder and the encoder. They
were run on an earlier revision of the codec and not since it changed,
so the series makes no claim from them.

This series was developed with LLM assistance.

[1] https://lore.kernel.org/linux-cifs/20261104010725.50071-1-icb@fastmail.org/
[2] https://lore.kernel.org/linux-cifs/20261124162331.895789-1-icb@fastmail.org/

Ian Bridges (2):
  ksmbd: add a security descriptor decoder and encoder
  ksmbd: use the security descriptor codec in callers

 fs/smb/server/Makefile              |    2 +-
 fs/smb/server/secdesc.c             |  783 ++++++++++++++++++++
 fs/smb/server/secdesc.h             |   66 ++
 fs/smb/server/smb2pdu.c             |   96 ++-
 fs/smb/server/smbacl.c              | 1021 ++++++++-------------------
 fs/smb/server/smbacl.h              |   11 +-
 fs/smb/server/tests/Makefile        |    3 +
 fs/smb/server/tests/secdesc_kunit.c |  899 +++++++++++++++++++++++
 fs/smb/server/tests/smbacl_kunit.c  |   42 ++
 fs/smb/server/vfs.c                 |   50 +-
 fs/smb/server/vfs.h                 |   10 +-
 11 files changed, 2154 insertions(+), 829 deletions(-)
 create mode 100644 fs/smb/server/secdesc.c
 create mode 100644 fs/smb/server/secdesc.h
 create mode 100644 fs/smb/server/tests/secdesc_kunit.c


base-commit: b0bd2fe7715f01d1796fca4bf7d22f7bbbe392ec
-- 
2.47.3

