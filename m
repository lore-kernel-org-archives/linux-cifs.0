Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645174;
	b=AbRQ3DnPjJ1sOVaW+aj7+8F7XvD4Va3Yz5jWPn7xEe0x4sjVrtEFsGr8azSlA1ZIJX3D
	 pPoa6smIO0qDjbf4NYV2f3Gn4MfNDh02fCiCQX8ILEnu3rqwgetsjWgWgMmA1P7QNUvcG
	 LhYiVRqQEUddyhy1HO8ZxIX9fqtZUUwqXqPIandbyLPNwiHlrRD8+JLW1JIPEKzF5/th1
	 Y0k04Wu06leiHlEATSvM9gj+iBdExNaisQ7BPTxuhlfjNsOXY5hq2FcpDjjJg3QyPu4Jy
	 cKR4s/Otayjh0TG0c2GPAclNdh3Sh9sSe9xv0l+Iyqzirt4AAacRGUtr+TBAenGfPdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645174;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=KZ2+Dd8oVOE7AjmrAqK3Dk+IMG11wdRD7eBWrPY5YrA=;
	b=ukYYdVsE1n8FxO4Pw9Pnoyk8xQZmYf1qsI8SqJ/7GpkrGOUyrDMV2xwifv9vLu1qGvJJ
	 jtFVcKDygZs/NURr/LfPKShUhi3i/5OswBkPEAQ+76DfEwLMr8u2eLnr/leZH4aM6A5TK
	 zEkUNpXu623QTj0f4fOU3Ylz2eHcyOtnmA7ttU0AxP8lP4pi6I1LhPTq4LNyQFlCm5jpK
	 obVXyMMj/KEN8QhO6WqzMbWhMYTdptZnGmXrY4t+ZpJxKZNslCxvHfH/A1ZcbY1KhJfk3
	 FDuzF5kMgG1uqRYfkqGNaGCYM5FYuhDRjyE1ijpI5LQ/CXM1j9h8Th0bTAH8QdYpP2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="P/j93ZzM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2448D606A31E
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 22:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/j93ZzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A833B1F000D0
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 22:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795645173;
	bh=KZ2+Dd8oVOE7AjmrAqK3Dk+IMG11wdRD7eBWrPY5YrA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P/j93ZzMYeMAvN7g/e2bMrT3QSY/sMuKju64YOn81PhuXS/OaUtd9O45J9jFN9Cxr
	 4o13W90nDvnSQucfVekxLve8OIgPcmcWMmluKPWNhQuWohGkqVdsaUJvi9UO3EDh1b
	 hcR9gDHVZbmEeE7iTGxagaCDT8ksc3sDEsLx5ZWZULj4mWWwms9Pk6yqaqjaO0fcXK
	 hJ6GiwonkfrqrhhybaKGnu/fsvmAcl/ePr5GN9m+PhR2rAXkJg6HW0HxUpWNChiEJM
	 GuxkSegFBhbtiH3Du5eahY+2X7hTNOF5ZR69twsvxwMThnYLMXdkVsUIx4cNF/iVx6
	 Mj5V+knBt3Jnw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so1022769766b.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 14:19:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFoshLUENGmlQJrmC2YswLdJWMVJSWnNO18n/zo1MiLMYSFMr3QghZgKHLcF1wqAlUe8nMTXJnhoRyB@vger.kernel.org
X-Gm-Message-State: APuU4Z8wMATz1dCwA9cTnNN4RXONuu5Sbib7DgVawzwMPqYF1hGSnos2
	x6Hj6h7o0J0DlL2PeYKJRJSrG8X8t5xeYl9SU3Vw7x7OyFXnDGvxtrA0vehmPsrZF2zJ9k7qrlD
	PyduZIdDgkLL8q4esFpd2ki0NCUjzCIg=
X-Received: by 2002:a17:907:1c9d:b0:c37:8c7c:a840 with SMTP id
 a640c23a62f3a-c513a80fcb0mr1628460066b.18.1795645172133; Wed, 25 Nov 2026
 14:19:32 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261125133430.1177754-1-icb@fastmail.org>
In-Reply-To: <20261125133430.1177754-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 26 Nov 2026 07:19:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9kvWX353=KQJ_HX_JNLvZpuS1F+JAE=adU-rS_xfu2Gw@mail.gmail.com>
X-Gm-Features: Aa3M54qKYbDc4ESkg0R5S441zwV6c4JUy7AjJSn8gD6eqfMwulJyZ-j-iB7hWag
Message-ID: <CAKYAXd9kvWX353=KQJ_HX_JNLvZpuS1F+JAE=adU-rS_xfu2Gw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ksmbd: decode and encode security descriptors in
 one place
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 10:34=E2=80=AFPM Ian Bridges <icb@fastmail.org> wro=
te:
>
> ksmbd reads and writes NT security descriptors (SDs) in five places:
> QUERY_INFO, CREATE, inheritance, SET_INFO, and the access check. Each
> walks the raw bytes with its own bounds checks, and those walks in
> smbacl.c have needed a long run of fixes. This series replaces them with
> one decoder and one encoder, so the bounds are checked in one place and
> the callers handle no SD bytes.
>
> Patch 1 adds the decoder and the encoder with their KUnit suite, and
> nothing calls them yet. ksmbd_sd_decode() validates a whole
> self-relative SD and returns a struct ksmbd_sd in a single allocation.
> The struct is plain data that the callers read directly, and every
> pointer in it points at bytes the decoder has checked. ksmbd_sd_encode()
> checks a struct that a caller filled in and writes the SD to a buffer it
> allocates.
>
> Patch 2 is the cutover of the existing code to the new codec. The
> functions in smbacl.c keep their names and their logic, and only the
> code that read or wrote the bytes of an SD is replaced. The decisions
> the callers make are meant to stay as they are. A decision changes only
> where the decoder reads an SD differently from the walk it replaces, or
> refuses one the walk accepted. Other changes to those decisions are left
> for later patches.
>
> The earlier proposal [1] left the access check, smb_check_perm_dacl(),
> as it is. This series converts it with the others, because the loader
> of the stored SD now returns a decoded SD.
>
> Changes since the RFC
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> v1 was an RFC [2]. Thanks to Namjae for the review of it. The second
> and third changes follow his answers.
>
> - Rebased onto ksmbd-for-next b0bd2fe7715f. Patch 2 stopped applying
>   when commit 3cfe35e0d26c ("smb/server: fix little-endian values in
>   diagnostic messages") changed a debug line in parse_sec_desc() that
>   the patch removes.
> - A malformed owner or group SID no longer makes a stored SD malformed.
>   The decoder leaves that SID out, as it does a malformed SACL, and
>   ksmbd uses the DACL. An SD from a client with such a SID is still
>   refused. The flag sacl_dropped is now part_dropped.
> - CREATE succeeds when the SD built for the new file is too large to
>   store. The file then has no stored SD.
> - The codec and its tests stay in one patch.
>
> Changes in behavior
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The message of patch 2 lists the changes, and the rules the decoder
> enforces are the sd_malformed() calls in patch 1, each reached by a
> KUnit case. The changes below are the ones I would like feedback on.
>
> A malformed SD from a client is refused whole. A stored SD is refused
> whole if its header or its DACL is malformed, and a malformed owner SID,
> group SID, or SACL is left out of it. The walks have no common notion of
> a malformed SD. Some malformed SDs are refused by no walk today. Some
> are refused on one path and read on another. Some are cut short at the
> bad ACE, and the ACEs before it are still used. The decoder refuses an
> SD that breaks a structural rule of MS-DTYP. Most of the rules are
> bounds. The rules below go further. Each item says what the series
> refuses and what the walks do with it today.
>
> 1. The decoder refuses an ACL if it cannot read all AceCount ACEs
>    within AclSize. Today SET_INFO and inheritance refuse a count above
>    (AclSize - 8) / 18, and otherwise each walk uses the ACEs it can
>    read. Using the ACEs that fit would enforce a part of an ACL.
> 2. The decoder accepts Revision 1 for an SD and for a SID, and
>    AclRevision 2 or 4 for an ACL. It refuses any other value. Today no
>    walk refuses another value, and the SD is stored and used. The
>    revision says which layout follows.
> 3. MS-DTYP 2.4.4.1 requires AceSize to be a multiple of 4, and the
>    decoder refuses an AceSize that is not. Today no walk checks it, and
>    each steps by AceSize to the next ACE.
> 4. The decoder refuses an ACE type that MS-DTYP gives no layout. These
>    are 0x03, 0x04, 0x08, 0x0E, 0x10, and anything above 0x13. Today
>    every ACE is read as a plain ACE with its SID at byte 8, so an ACE
>    of these types is stored, returned, and inherited. Without a layout
>    the decoder cannot say where the SID is. This is stricter than
>    MS-DTYP 2.4.5, which lists 0x03 and 0x08 among the types an ACL can
>    hold.
> 5. In an object ACE, two bits of the Flags say which GUIDs come before
>    the SID. The decoder refuses any other bit. Today the walks read the
>    Flags as the start of the SID, and SET_INFO stores the ACE if those
>    bytes pass for a SID.
> 6. The decoder refuses a nonzero OffsetDacl in a stored SD without
>    DACL_PRESENT. Today QUERY_INFO, inheritance, and the access check
>    use the DACL at that offset. SET_INFO already refuses this from a
>    client. The two fields disagree about whether the SD has a DACL.
>
> Not everything that MS-DTYP forbids is refused, for example a SACL ACE
> type in a DACL. Two things are let through for a reason. An SD without
> SELF_RELATIVE is read as self-relative, since ksmbd has stored SDs with
> the bit clear. A malformed owner SID, group SID, or SACL in a stored SD
> is left out so that the DACL remains usable. An SD from a client with
> any of the three malformed makes SET_INFO or the CREATE context fail.
>
> A refused SD is handled as follows.
>
> 7. From a client, in SET_INFO or a CREATE context, parse_sec_desc()
>    returns -EINVAL, as it does for the SDs it refuses today. Nothing is
>    mapped and nothing is stored. The file that a CREATE made stays, as
>    it does today when the SD is refused.
> 8. QUERY_INFO of a malformed stored SD fails with
>    STATUS_INVALID_SECURITY_DESCR. Today the reply holds the ACEs ahead
>    of the malformed one, or a NULL DACL if the header of the DACL is
>    malformed. An open that runs the access check is denied first
>    (change 9). So this is what a handle that was open already gets, or
>    one opened with FILE_DELETE_ON_CLOSE, for which smb2_open() does not
>    call smb_check_perm_dacl().
> 9. The access check denies every request against a malformed stored SD.
>    Today it decides on the ACEs ahead of the malformed one, and it
>    makes no check if the header of the DACL is malformed. A DACL that
>    cannot be read whole cannot be enforced, and the part that was not
>    read may hold its deny ACEs. The same check hides such a file from a
>    directory listing on a share with hide unreadable set. The cost is
>    that such a file cannot be repaired through an open that runs the
>    check, since WRITE_DAC is denied as well. A handle that already has
>    WRITE_DAC can still set a new SD.
> 10. Inheritance does not inherit from a parent whose stored SD is
>     malformed. The new file gets the SD built from its inode, as when
>     the parent has none. Today that happens for some of these SDs, and
>     for others the file inherits the ACEs ahead of the malformed one.
>     A parent whose stored SD has only a malformed owner or group SID is
>     inherited from, and the stored SD of the new file is without that
>     SID. Today inheritance refuses such a parent if the SID is out of
>     bounds or has more than 15 sub-authorities.
>
> A stored SD can be malformed because a client sent a malformed SD to a
> ksmbd that stored it unchecked, or because the SD inside the xattr was
> damaged. ksmbd has also written two kinds of malformed SD itself, both
> when a file inherited from its parent. I have found no others. In the
> first kind, the parent had an inheritable object ACE, and inheritance
> wrote that ACE without its GUIDs. The DACL of such an SD is malformed,
> so the access check denies.
>
> In the second kind, the DACL is intact. Before commit 4616bbc5389a
> ("ksmbd: build an inherited security descriptor with its own offsets"),
> inheritance wrote the child's SD at the parent's offsets. If the parent
> stored its DACL before its owner and group, and the child's DACL came
> out larger than the parent's, the larger DACL overwrote the child's
> owner or group. In v1 the overwritten SID made the access check deny.
> In v2 the decoder leaves that SID out and the check uses the DACL.
>
> One change is not about malformed SDs.
>
> 11. A DACL that would pass 65535 bytes fails with -E2BIG, and
>     QUERY_INFO returns STATUS_INSUFFICIENT_RESOURCES. Today the POSIX
>     ACL entries that do not fit are left out. build_sec_desc() fails
>     with -ENOMEM if an allocation fails while the POSIX ACL entries are
>     mapped. Today the rest of that POSIX ACL is left out. A DACL cut
>     short reads as the whole DACL, to a client and to the access check.
>     An inherited DACL that is too large is handled as it is today, and
>     the new file gets the SD built from its inode. Inherited ACEs now
>     keep their data, so a child DACL can pass the limit where it did
>     not before.
>
>     A default ACL too large for a DACL takes about 1800 named users for
>     a file and about 700 for a directory. CREATE under such a default
>     ACL succeeds, and the new file or directory has no stored SD. The
>     POSIX ACL it inherited is in place. In v1 the CREATE failed after
>     it had made the file.
>
> Tests
> =3D=3D=3D=3D=3D
>
> Tested on ksmbd-for-next b0bd2fe7715f. Every test below was run again
> for v2.
> - Each patch builds with W=3D1 and no warnings (GCC 14, x86_64 with
>   KASAN), and sparse reports nothing in fs/smb/server. With both
>   patches applied, fs/smb/server and its tests also build for 32-bit
>   x86 with GCC 14 and clang 22, W=3D1 and no warnings.
> - KUnit under UML passes at each patch with GCC 14 and with clang 22,
>   which enforces __counted_by. With both patches that is ksmbd-smbacl
>   5 of 5 and ksmbd_secdesc 6 of 6, 38 cases with their parameters.
>   Patch 2 adds the fifth ksmbd-smbacl case.
> - The same KUnit suites pass under qemu on 32-bit x86 (GCC 14), on
>   x86_64 with KMSAN (clang 22), on big-endian s390 (clang 22), and on
>   32-bit big-endian PowerPC (clang 22).
> - checkpatch --strict reports nothing but the note about MAINTAINERS
>   for the new files.
> - smbtorture smb2.acls, smb2.setinfo, smb2.getinfo, smb2.create,
>   smb2.sdread, smb2.maximum_allowed, smb2.winattr,
>   smb2.delete-on-close-perms, smb2.dosmode, and smb2.rename give the
>   same results before and after the series, on a KASAN kernel booted
>   with kasan_multi_shot. The one exception is mkdir-dup in smb2.create,
>   which is a race. It passed 19 of 60 runs on the base and 24 of 60
>   with the series. There is no KASAN report or warning, and the kernel
>   stays untainted.
> - Scripts that query, set, and inherit SDs of many shapes over SMB were
>   run before and after the series. Every QUERY_INFO reply is the same
>   but for an inherited callback ACE, which keeps its application data.
>   One SET_INFO that was accepted is now refused. Its object ACE has an
>   undefined bit in its Flags. The stored SDs differ in their bytes,
>   since each is now the one the encoder writes.
> - I damaged two stored SDs by hand. I raised the AceCount of the first
>   by one and cut the second short inside its header. The base uses the
>   first SD and treats the second as missing. With the series, an open
>   that runs the access check is denied for either file, and ksmbd logs
>   a warning. QUERY_INFO returns STATUS_INVALID_SECURITY_DESCR on a
>   handle opened before the damage and on a handle opened with
>   FILE_DELETE_ON_CLOSE. SET_INFO on the handle opened before the damage
>   repairs the file.
> - I changed the revision of the owner SID in the stored SD of a file
>   and of a directory, and did the same with the group SID. Every open
>   and every QUERY_INFO reply is the same as before the change, with the
>   series and on the base. A file created in the directory inherits its
>   DACL. With the series, the stored SD of that file is without the SID.
> - On a tmpfs, under a directory whose default ACL names 1900 users,
>   CREATE succeeds with the series. The new file has its POSIX ACL and
>   no stored SD.
> - With slab allocations under the decoder and the encoder made to fail
>   one time in five (failslab), smb2.acls, smb2.create, smb2.setinfo,
>   smb2.getinfo, and the scripts leave no KASAN report, no warning, and
>   nothing for kmemleak.
> - Out of tree, the converted functions of smbacl.c were run in
>   userspace under ASan and UBSan against upstream's functions compiled
>   verbatim. That was about 1.1 million comparisons over generated and
>   hand-written SDs for the QUERY_INFO reply, SET_INFO, and inheritance.
>   Every difference from upstream is one the series lists. The
>   QUERY_INFO comparisons do not cover a stored SD that the decoder
>   refuses. That refusal is in smb2pdu.c and no reply is built.
>
> The 32-bit, KMSAN, and big-endian runs are of the KUnit suites only. A
> live server was tested on x86_64 alone.
>
> The proposal mentioned CBMC proofs of the decoder and the encoder. They
> were run on an earlier revision of the codec and not since it changed,
> so the series makes no claim from them.
>
> This series was developed with LLM assistance.
>
> [1] https://lore.kernel.org/linux-cifs/20261104010725.50071-1-icb@fastmai=
l.org/
> [2] https://lore.kernel.org/linux-cifs/20261124162331.895789-1-icb@fastma=
il.org/
>
> Ian Bridges (2):
>   ksmbd: add a security descriptor decoder and encoder
>   ksmbd: use the security descriptor codec in callers
Applied them to #ksmbd-for-next.
Thanks!
