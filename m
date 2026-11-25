Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795603758;
	b=IZPjbmNBJxpCsbD1pQYXXY4mtgXbrdCr3z+CVQdnJWWKXFDMgA0G1qdDih/vU2etjL1J
	 90h/whx2bNwbjsb4YEC4+p/e14dIubVpoE0pPUnafFil1DDAXj99z/III71nPS0VebcAp
	 ZNadZwM92r/Y7Ni5tjvg6GMXV1d9bzwxftjAERVXLHGOs+/IixR7zwZh4ae8y5XtDwOf7
	 K6naeepeT8HIebZBM3YiO1nkrrVIk+PQSkA6q74JbYQRYSBBt3//AoEk/aWV7rmVy6Nh4
	 LsntQwuo4GN6hKyQi2ZtUPQQYFvOTofq7BCIn3GWdG/K6zgyti9IVrAG5Hnh00VgNww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795603758;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jwhDmbkEnqAYgPih35sFF6PgtzAuGQbaxdcECiZ/v6w=;
	b=ILNgqZz0owpZBSo3gZ5F/Z0/ssHGYKkUVh+WapAs7qxxBi5hHdhNHGSQy/bbGKxG1Imy
	 QYCRX5i6zllfkvxBN39FbDFohA7vsUwWH9vU+kcrj2IigEXWQugc8SZcL18TQ12E4lLu7
	 sItP625+PZU3SEKh48gUyv3cC36/D3S3HEDAG1dhWr2fBMoKBFtWfHL5hQLzT1+5CNt/V
	 yb8lqOrROa32h9jeZffWtqxPsKGkfNlMXQ4aatoc7/f13wFRPz0DreATNg6weFIAm7K7O
	 uCSX4YRQa5Bop6C3CSct9mklUcOPo3YqU4IscvHhHGgfdH6aXnfatLjhYxnDI7JxSRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNprz5NE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689DE606A31E
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 10:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNprz5NE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F003A1F000D1
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795603758;
	bh=jwhDmbkEnqAYgPih35sFF6PgtzAuGQbaxdcECiZ/v6w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hNprz5NE5CVY6pAlCM2rBMLLlgN0pL6Hq7aGrQgSNAv3coT/zKpXr5OKC67GUINSA
	 FaC4j0BI3cN8L+TPlHRPngVPKjl59C3B/62vmh4/xH3qu8EC5UJFy0Nda/dOLfNJM8
	 Qjo0Z08RYzOwVmiS4yxgvZN0Qf8OsoC6Iqa0+K0G00VA8DBipqjkkwLGXrf60CZY6t
	 j+PNssXICSS6kUBvnsgJulHVFt+3HLuajZ/RtkuCZ1PrmwH5N+chM4KKBQ5OUisfu4
	 dKluviPl/2yxLm92H1ADjtiPz5LqUqJip+IwCUkFk584srvfrs4mov8VIjHiW5pxBN
	 63bWtEdsioX0w==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c50cc7540b7so788129966b.0
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 02:49:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGS43NDX9ErBT2E3f2I+cV3JKhiL9YmLu3AuKDnAxV6uiqoHbhm/xma2FrtnO10d3CFrvUUBQHcha4L@vger.kernel.org
X-Gm-Message-State: APuU4Z8f3TZChdz2Ge3VbfjZIZ2DXskuhYZT0g87thfXaLDMYot00wlL
	qv5NYRtPObKiWsS9xUmFbnQWUvMnztu3FXy1NaX/nfqLpYuL2uw2uZNtl0f8o4NXTz4swJlMCV5
	5kIvG92/VW1g9IFKk9swZE0G3w8WcGZU=
X-Received: by 2002:a17:907:7403:b0:c51:36d6:d96d with SMTP id
 a640c23a62f3a-c513a39efcemr1086694866b.4.1795603756522; Wed, 25 Nov 2026
 02:49:16 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124162331.895789-1-icb@fastmail.org>
In-Reply-To: <20261124162331.895789-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 25 Nov 2026 19:49:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_H9fwPKQBO-uLMZnQZA4Sg=dM7we0vgxTOJ0ex=i9JCw@mail.gmail.com>
X-Gm-Features: Aa3M54ogizKlAXuipOrZ52kVPLUpn3_loDl4z4PNvXKbL_V8blH0opLjZzr90Og
Message-ID: <CAKYAXd_H9fwPKQBO-uLMZnQZA4Sg=dM7we0vgxTOJ0ex=i9JCw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] ksmbd: decode and encode security descriptors in
 one place
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 1:23=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
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
> If you would rather have the codec and its tests as separate patches, I
> can split patch 1.
Keeping the codec and its KUnit tests in the same patch is fine with me.

>
> Changes in behavior
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The message of patch 2 lists the changes, and the rules the decoder
> enforces are the sd_malformed() calls in patch 1, each reached by a
> KUnit case. The changes below are the ones I would like feedback on.
> Changes 9 and 11 come with questions.
>
> A malformed SD is refused whole on every path. The walks have no common
> notion of a malformed SD. Some malformed SDs are refused by no walk
> today. Some are refused on one path and read on another. Some are cut
> short at the bad ACE, and the ACEs before it are still used. The decoder
> refuses an SD that breaks a structural rule of MS-DTYP. Most of the
> rules are bounds. The rules below go further. Each item says what the
> series refuses and what the walks do with it today.
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
> the bit clear. A malformed SACL in a stored SD is dropped so that the
> DACL remains usable. A malformed SACL sent by a client makes SET_INFO or
> the CREATE context fail.
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
>    makes no check if the header of the DACL is malformed. An SD that
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
>
> A stored SD can be malformed because a client sent a malformed SD to a
> ksmbd that stored it unchecked, or because the SD inside the xattr was
> damaged. ksmbd has also written two kinds of malformed SD itself, both
> when a file inherited from its parent. I have found no others. In the
> first kind, the parent had an inheritable object ACE, and inheritance
> wrote that ACE without its GUIDs.
>
> The second kind matters most. Before commit 4616bbc5389a ("ksmbd: build
> an inherited security descriptor with its own offsets"), inheritance
> wrote the child's SD at the parent's offsets. If the parent stored its
> DACL before its owner and group, and the child's DACL came out larger
> than the parent's, the larger DACL overwrote the child's owner or group.
> The DACL itself is intact, and no client made the SD malformed. Today
> the access check uses that DACL. With this series the overwritten SID
> makes the check deny, WRITE_DAC included.
>
> That leads to two questions about change 9. When only the owner or the
> group of a stored SD is malformed, should ksmbd refuse the SD, or drop
> that SID as it drops a malformed SACL and use the DACL? When the DACL of
> a stored SD cannot be read, should the access check deny, or treat it as
> an empty DACL so that the owner keeps READ_CONTROL and WRITE_DAC to
> repair the file?
if only the owner or group SID is malformed, I=E2=80=99d ignore that SID an=
d
use the valid DACL. If the DACL itself is unreadable, I=E2=80=99d deny acce=
ss.
It could contain an OWNER RIGHTS ACE that limits the owner=E2=80=99s implic=
it
rights.

>
> One change is not about malformed SDs.
>
> 11. A DACL that would pass 65535 bytes fails with -E2BIG. Today the
>     POSIX ACL entries that do not fit are left out. build_sec_desc()
>     fails with -ENOMEM if an allocation fails while the POSIX ACL
>     entries are mapped. Today the rest of that POSIX ACL is left out. A
>     DACL cut short reads as the whole DACL, to a client and to the
>     access check. An inherited DACL that is too large is handled as it
>     is today, and the new file gets the SD built from its inode.
>     Inherited ACEs now keep their data, so a child DACL can pass the
>     limit where it did not before.
>
>     A default ACL too large for a DACL takes about 1800 named users for
>     a file and about 700 for a directory. CREATE then returns
>     STATUS_UNEXPECTED_IO_ERROR after it has created the file or
>     directory. A retry with FILE_CREATE gets
>     STATUS_OBJECT_NAME_COLLISION. A retry that may open the existing
>     file succeeds, and the file has no stored SD.
>
>     Should CREATE succeed without storing the SD, or should ksmbd
>     remove the new file or directory before it returns the error?
I=E2=80=99d let CREATE succeed without storing the generated SD, since the
inherited POSIX ACL is already in place.

BTW, I cannot apply patch 2/2 to the current ksmbd-for-next. Can you fix it=
?
Thanks.
