Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537424;
	b=KOzopK4oX61JTeNkq9OvbQ3jKbyYLlJEpyxxfKOLsuVplkQsCdb3Q7eDZ3DWJmfv8Cat
	 qSHwPxgVHALWlIRXm+GWSnGxoqdlq4f8f3jxQMmYpdPWkDMPgHFZYV6UBxfxojx7IHbiJ
	 4fHT6+aVjKbU435ampVcTyUEvpSYOtGUQZUe974zOQpjvj7bLp5JGMtYq7Tx5l1hO8aVN
	 0ACe14Xm8Mi3rLnyIJJGTeGxzlHhMLEZOqn4QcsurYfQF/0RST+wJQU6BubkeSBUv8hwl
	 kYcOl1o230bAnjSg5cDe1dnQBVW2Wv/qo0w5dN5V1nwe7rpltcYUDsbxSNlRstnGemg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537424;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WPmX4UvCMFLtso9Zh0jH3OYFL87s/2pZWB+20XqodU8=;
	b=bYGhy9IttgNjQJOP/sr3KZRvn+9ZLuzK24r5dPMcTaMe8JyNpkHJLMIgagjofX57bQOW
	 LiF+/zFGOVsz6D6+oS89aIYd4ypSzl+Ox7d+Kif9suoIwdltalg3FGCHiFPLGwB5iyrle
	 FiIaGyHZnC3GQr90JZiYYImgswF58nItPqdxivdTU1dsAp7aJfNNiQMwPR2zU/dx2I5ce
	 WPt9YjseM2r/bO24XTre/cUT2CiKntJ4HGJW5J54xdWzUtjC/s5wwxgncu8Bx0gdluEP6
	 L73h/OzjNDzVSMSimt9PulTQx7qsrWXObCvw5Ru86Bbf0m9fED0CTxMEovDJdeshQ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b="P3MJs/Gz";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=jAY5XdIg;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEAA606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 16:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FEAA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=P3MJs/Gz;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=jAY5XdIg
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 372CE14002E1
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 11:23:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 24 Nov 2026 11:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795537422; x=1795623822; bh=WPmX4UvCMFLtso9Zh0jH3
	OYFL87s/2pZWB+20XqodU8=; b=P3MJs/GzRp2OlKtmWWuT/yfrsPxySoVZCcLvl
	m91c9bHh2aQqfz9MX67miWl1xgiYUzlqJqjFwp7+qomCRQZ0GzjnqBKCN26fBlgD
	Pbfe5NDCHFW+CmdsEHgKbOzVN5RedKkScs4AhRjK9fi7u5fGIYU3ysFpUuAV9buo
	/kcH+h12wsAJ39HMTGiG6bkE64M8UqNkgYp8SkfzKFaLFJGyj4vOZ7/UBzXHe433
	aUZcenstc1QzsPGw99c3Q4UjXZgD1HFkvuGgC5IBXKk1hC8b496l8evafAtlnXhE
	LrQbRrmdOWE9M/A9QAXv5arScXf0tcYOHm14XCXwodMGswvGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795537422; x=1795623822; bh=WPmX4UvCMFLtso9Zh0jH3OYFL87s/2pZWB+
	20XqodU8=; b=jAY5XdIg1hk2JSA/OpvLg/kob3U1tL4Es7GgIEnjEFBObAWpmsa
	sHNpX5mJUrYqavqwOrV5QNZNqlKLaBuGH5Zvnp5uyTVHfrvue/lldbkEiEs1tScL
	4BCifDWgerjCcUdlE5VarplZN5zd74OUft8Y0OoGBxyhEqLTHWuX3YaSFHY69bRc
	5BaJq1IjVmeTYq+twPBehkVf8mcaofs1joF1YfWy9nP5U6x1m1POe6kObAnN6rJq
	xKWJvSfa+8+5tLpJw8mW9QLqjVzsAsxihB5BQKMMm13UPbETaHAFMwDvDIGLncf3
	hAKkmphAGcEXvJqYsTDZNq9o5c3mH1XCvOg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795537422; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:eOMWvQqVfz/VXvLIX2nffkZmDsy+vJWR3lS7hNA+CSlVBGJ
	B+KIYZAXAaAnnF6+8L5CQYKjrgC6Zm14VPdKUdVkYfGl2gUKBVHv/3oHuW4iOYxx
	7H3X9hFng/Um5BBAwuHU6xTY9DhRrsYfo3tNZOyLqzvoS8jf3drBuDz3WzEsbhR7
	Gzn/a4WGia0dZcZyVWVnF2dfpPQnZp6p76oguLeJR/PBeDl3oedHJKvppyuV/UyJ
	9SW5vDSo7zxKrPEh3aulnEF5jMmj+acgqN5k/dE7QxcTG5z4RWe9VFEZevewLimu
	001phDeres++GN4esYkgxuD6rUWwlqdlBm+vsSQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:5/EtJtskxHGc7/7uzK6Pe3wr/K1pAYJ77HqxNqeSGf8=:S6geYJ2x/SQoPS84h2I/ocgI5TnmVwPOxeJzGq8Yo/k=;
X-ME-Sender: <xms:DLoFaxUoijWBqVe6g63OPy_iXs__7aHf-bQn8gLDXthbvGoogegTZA>
    <xme:DLoFa1Qwowx3fcXwTd-gG0G2RONPGngnaPcBmFf3zD83zbbQ3lWv23r_ennXogK_8
    3Po6V2ethW2bIWhd4T70A5r7n7xe2l8XTYJ89ZTPJDzQaCyrVORjGwQ5Q>
X-ME-Received: <xmr:DLoFa3NmGq2CSRJN8D8Kgrh4Bc7N0Xb45vup6zfng2tWYnq36x3UYCw1F3hKssU3>
X-ME-Proxy-Cause: dmFkZTGFeqZ8GWqH5tDQqluvG15k5Bn49VDZVt8tz0EDdsaMg7y2FJY/LiLEotyZUlFDgo
    ZHiLqM7p18Jmqs75B4Pog6saK6KbRn6aALsJoRJHvPTfMKErDKJTGpEhuuXuRGwpuLmNHt
    RLMtRIwoM+UzwCFFrqZ3OQ967tuPhMI4qzPvyx9TyByDoWdY69YErGr/sxG7hFxYnxSTCk
    hVJiz3gXdyR55u1PACI2bjN8NPu/7ECegjDXKUFl3VIz5ykvwR2pTmvVJaLNIb5fmYsW6n
    fWFbE6ZdoXB7kE4JrUC81gfdBDIVHUpxKbwXOIQEmj+G0vyXA80d1P3oF4Uha0EoOV1fqh
    haDY9rxjR3PhRTUEeLbtwmp1w4O/3c5hgRXIFwQOC361exJLbGxy5Xk3Nin/neHw1vzJKT
    pO0pqlun0CywGxnT/fvCtZDt0ID5ILGmUYfO5Zpp0KGQYAK/wVeTvWfa0Ip93C/8vA0sXE
    RprO6r/U2TedsQjbjuowaX102qCXyUknXG6y1Nn1bPjYaSYHBDWfVrnwAJ4/XqHaXmzo6e
    OunHf8E3MTCD3XEoxdW2Pemw4g+R+R4wKgQERkc9fsZ2Pk8ULDrF1cpHfYbni/7YzxlS2E
    a2NJ213IL+fK/kdMCBQNiB93oFEsTXi8Mfi6wgf3rVIJvI0j/p/4NnFXknCw
X-ME-Proxy: <xmx:DLoFa7RgOnweo2UxxkbyUerdevWadp_EQSs7dA3T0_Wmu_umy0TfWw>
    <xmx:DLoFa9izIvxMUoUrfimznfW5EM5x1Z0ui3IGF4vHvoSmb6qKI9yqwQ>
    <xmx:DLoFa8_BqjKfk_SlQOadriCOy4YihDgaVhxUlrwVt8E6kQiujoY8jQ>
    <xmx:DLoFa8H1sDeHLGhR7KRCa-r_muLn5S-0RqxK3YvOhK-ew5BCOU4Efg>
    <xmx:DroFaxzssDZhFMyvXzkrKYasrhdDedNjzWjzyrk5PBaRQPjZzxBLQr0f>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Nov 2026 11:23:39 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [RFC PATCH 0/2] ksmbd: decode and encode security descriptors in one place
Date: Tue, 24 Nov 2026 10:23:29 -0600
Message-ID: <20261124162331.895789-1-icb@fastmail.org>
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

If you would rather have the codec and its tests as separate patches, I
can split patch 1.

Changes in behavior
===================

The message of patch 2 lists the changes, and the rules the decoder
enforces are the sd_malformed() calls in patch 1, each reached by a
KUnit case. The changes below are the ones I would like feedback on.
Changes 9 and 11 come with questions.

A malformed SD is refused whole on every path. The walks have no common
notion of a malformed SD. Some malformed SDs are refused by no walk
today. Some are refused on one path and read on another. Some are cut
short at the bad ACE, and the ACEs before it are still used. The decoder
refuses an SD that breaks a structural rule of MS-DTYP. Most of the
rules are bounds. The rules below go further. Each item says what the
series refuses and what the walks do with it today.

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
the bit clear. A malformed SACL in a stored SD is dropped so that the
DACL remains usable. A malformed SACL sent by a client makes SET_INFO or
the CREATE context fail.

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
   makes no check if the header of the DACL is malformed. An SD that
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

A stored SD can be malformed because a client sent a malformed SD to a
ksmbd that stored it unchecked, or because the SD inside the xattr was
damaged. ksmbd has also written two kinds of malformed SD itself, both
when a file inherited from its parent. I have found no others. In the
first kind, the parent had an inheritable object ACE, and inheritance
wrote that ACE without its GUIDs.

The second kind matters most. Before commit 4616bbc5389a ("ksmbd: build
an inherited security descriptor with its own offsets"), inheritance
wrote the child's SD at the parent's offsets. If the parent stored its
DACL before its owner and group, and the child's DACL came out larger
than the parent's, the larger DACL overwrote the child's owner or group.
The DACL itself is intact, and no client made the SD malformed. Today
the access check uses that DACL. With this series the overwritten SID
makes the check deny, WRITE_DAC included.

That leads to two questions about change 9. When only the owner or the
group of a stored SD is malformed, should ksmbd refuse the SD, or drop
that SID as it drops a malformed SACL and use the DACL? When the DACL of
a stored SD cannot be read, should the access check deny, or treat it as
an empty DACL so that the owner keeps READ_CONTROL and WRITE_DAC to
repair the file?

One change is not about malformed SDs.

11. A DACL that would pass 65535 bytes fails with -E2BIG. Today the
    POSIX ACL entries that do not fit are left out. build_sec_desc()
    fails with -ENOMEM if an allocation fails while the POSIX ACL
    entries are mapped. Today the rest of that POSIX ACL is left out. A
    DACL cut short reads as the whole DACL, to a client and to the
    access check. An inherited DACL that is too large is handled as it
    is today, and the new file gets the SD built from its inode.
    Inherited ACEs now keep their data, so a child DACL can pass the
    limit where it did not before.

    A default ACL too large for a DACL takes about 1800 named users for
    a file and about 700 for a directory. CREATE then returns
    STATUS_UNEXPECTED_IO_ERROR after it has created the file or
    directory. A retry with FILE_CREATE gets
    STATUS_OBJECT_NAME_COLLISION. A retry that may open the existing
    file succeeds, and the file has no stored SD.

    Should CREATE succeed without storing the SD, or should ksmbd
    remove the new file or directory before it returns the error?

Tests
=====

Tested on ksmbd-for-next 7ad8d77b6a35.
- Each patch builds with W=1 and no warnings (GCC 14, x86_64 with
  KASAN), and sparse reports nothing in fs/smb/server. With both
  patches applied, fs/smb/server and its tests also build for 32-bit
  x86 with GCC 14 and clang 22, W=1 and no warnings.
- KUnit under UML passes at each patch with GCC 14 and with clang 22,
  which enforces __counted_by. With both patches that is ksmbd-smbacl
  5 of 5 and ksmbd_secdesc 6 of 6, 37 cases with their parameters.
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
  with kasan_multi_shot. There is no KASAN report or warning, and the
  kernel stays untainted.
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

Ian Bridges (2):
  ksmbd: add a security descriptor decoder and encoder
  ksmbd: use the security descriptor codec in callers

 fs/smb/server/Makefile              |    2 +-
 fs/smb/server/secdesc.c             |  775 ++++++++++++++++++++
 fs/smb/server/secdesc.h             |   66 ++
 fs/smb/server/smb2pdu.c             |   79 +--
 fs/smb/server/smbacl.c              | 1021 ++++++++-------------------
 fs/smb/server/smbacl.h              |   11 +-
 fs/smb/server/tests/Makefile        |    3 +
 fs/smb/server/tests/secdesc_kunit.c |  879 +++++++++++++++++++++++
 fs/smb/server/tests/smbacl_kunit.c  |   42 ++
 fs/smb/server/vfs.c                 |   50 +-
 fs/smb/server/vfs.h                 |   10 +-
 11 files changed, 2116 insertions(+), 822 deletions(-)
 create mode 100644 fs/smb/server/secdesc.c
 create mode 100644 fs/smb/server/secdesc.h
 create mode 100644 fs/smb/server/tests/secdesc_kunit.c


base-commit: 7ad8d77b6a3590b1fb2922664f66c318c0bb9e48
-- 
2.47.3

