Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818521;
	b=gty5AOnkrh8yuhDvv4/dL6yFCO4fBSRpZtc1suUIEPSd4GYlVEsPJclS5ABVcDgJcnuB
	 rFvtohXqgEpP8xVuNuUDwgINfMwdBp37VO8LjhN+07ggJKTggLTkiesa2GCRotNqi8yO4
	 ksohHGiAyWqv0bUKA54PuoUoY1nEyZWZ8O3955qA2kqa5X5kjY31+b2iMhfPfn2DYV9yA
	 pyjiKMIc8vHxZNj4Ijlih7UPKzSkOm454hmd6cAC6HbnVfioz1nwKGLOgHoyi7nUyvhQL
	 doXy4SYCJ7OnLkmg/w06IBdbEH5p3W/+XMOAeGFaHXwWU7WQp6M3zrwyOEm6doKHrNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818521;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=tPANJmDtmOmTq3O/C8+lC4vPHItwbYvMTa06DRKSDKs=;
	b=ResU5hqOpljcBGCUpe2fQk8zgpFYIeaU4fqerWtlnJY65R2QuagevxnjMjnObjr0k/g0
	 Rjt6yOQD86ihjcoAJuqf1zqJXqhp0IBPUbTLINJVA9DHUe6z8CsRiu6Ewf4s84CmSaK3Q
	 MI8faYZgtJrSf3bvhENDE+jy1pV9ogZKdB2cttuJuC8vl4pXd2zTeJYZjM13es+cPunfT
	 Sj/UAw+z4EhFt2XpRxQAGnNVqw9p/9xJwd19VbfWyAW66Z7KiBD6q4rplubItIcQJuxiZ
	 PNV217O9CTuH+g7Mrgep4zPxgd7M2Pt4BLscuZGpE5rTJ/FrseVwq/uBNY0sJ37cWBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=tlf86Giu;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=s+b89b1l;
	arc=none smtp.remote-ip=202.12.124.157
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74F606A31C
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 22:28:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC74F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=tlf86Giu;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=s+b89b1l
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 270E47A0363
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 17:28:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 27 Nov 2026 17:28:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795818519; x=
	1795904919; bh=tPANJmDtmOmTq3O/C8+lC4vPHItwbYvMTa06DRKSDKs=; b=t
	lf86GiuXnga+3FC1/51zRmEmg4Rsobg/7jzdTD3ktvoUwvpcUJbyBM5I7H0y/niH
	SDs+VdwMWOYE4pRTkVXhfINR3weGyy8AcQJqBCFeO3MFwk+KCXOc/ClJ2aQbpsBm
	blA31R8XMvD1X53rPHVGpFTfGChdxoVOGhvAJg18GMUv4IgISsL+AgjutxekxyOt
	bMk7ycWv1RWVQuzhM+L2XxyW7ZJZQBzuAKk+v4eV0EQCsg9SfAhTDPPrk55CIwau
	aBkf7rKm1z5qlSVeaTlD0KWwV9pVCxkdpy9poYhIAf+BQ7nQWvi6rMrhKE7rSu7U
	E1F5PUgHTM4NCaUAGQuiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795818519; x=1795904919; bh=t
	PANJmDtmOmTq3O/C8+lC4vPHItwbYvMTa06DRKSDKs=; b=s+b89b1lpkfI7sJi7
	S/QSNkEjucxoOxOnThWiqCBTvL6qxeK8MkZf66w5L/PO3S0EVPtdnbdXvwlOBUVO
	e8oDO7yPDlSv6VVhv8yw23okMjGI1pZFUrkiJIoJnf1fgH4BnBAI/yvDSe27VS8+
	KgG1QDY4gk3lhCfdVtYZGojCxyii32B5IcRlpowHQ/fzvxUnklHi/UjlhzlZmQN/
	IHPyaTKpdSXqqC3rkTdMlIKDkIh2ooRw7+jNLnpjuk8lrHzifmZIfN9fQyAP4843
	fIQAUso7yEiIbIZo20O0fBoBU3SmDZPVnh7FJJDlgyyqLh5AdbxfuIYopa0L72oq
	OjheQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795818519; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:hj9XzLqDenVmS0Ar7zZ62iVm+EVwMzqdFpC9vqdMUGRy7bE
	enibfl/m63w0a2cU5tWPmtqoCrz65Xm04fI+ARqGbOWMnJY/RMIoLbY2gBePxhSc
	K1xI1+msjwNakA5kEB0xP1013N8/OsCC2v84SZsqfYGgswD3uGvVo7woM/wXfjKB
	vqWd9+rhCJ3NUww3SfumeJ5Ri8dyGeFpFx7vofEla1uBITcE7p0r++fxEXMMVNqF
	MV8739nf7Z0PtB8ZGKv8c78ycna/hA7guS4bQHRBSrtRG3hCqRIMfub+DpArg6Lg
	wtTQyJNtCAxf3OORvVKnkxV1pDGfk2ByvdmJ+iA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:WMjoMkV4R+X2Pb09AyG81hPeYXd04IAnw8CPXO6kHI0=:q9OrlNUKlZEMTZXJYZaqOkTTgO63HCItOhgLxGsfS44=;
X-ME-Sender: <xms:FgQKazMNTfTpJAJHaksZIp-MBNegD3moFpPnktNdMsQyZMLe7-9EXw>
    <xme:FgQKaxqyH5vrZFtFxIVA8k6uaAPyVVOTHvT2EBTRx25nyxTj1zSxgtl06taB1tdLJ
    Mr-0-yD-_3_tK9tEaPqAgdzBJDPCdtoBBb_xYfuOvIfi4IyVn_k9VA5>
X-ME-Received: <xmr:FgQKa8GLPYuV1O6VH4cH02tU9Hg9wueU790aVW4Alj8cvudlkPdPvI-a3O5EJinQ>
X-ME-Proxy-Cause: dmFkZTE4BlLF5c7CcvWc+LvNJ4Pydr49WF+ngSDCia2JkWER6ku2RPIqxZqOfRKU1iDMrk
    BYE0MPx0u2IhwcZZw6FxrEEN8k/AcoOkoUnsM078k6JnDPKgrnrUhnvJwnvQDd25jA3d7x
    lRtxHwsyzouHzYvlUZ2gKeKk7V7/s8v9vV1RgZGp2uIGYaZpcU0qV/kuUVgwwSXVtDMWLi
    H5ueVhdKbJvWcPrhjpjrNhMKz6Q5moe9PULHHdEB3653qqZ/FtQJt2BOs7HaluZQKMLinL
    c+LGpcUkgZFM9zIjixFCAEwpgYLMf4zIUywaouV2zxT9/5U+8Mwu2ARpAeTm2CdG4fXrnq
    msvyyS7+5AnSMx9bhOcD2Xjf0qUjaruyHUx3EiJBpL4pqZzTkR8NEUvbxqop/Ko+3p3QGM
    f9WJPA4YHPZwt7goZFL6NQaWetUMdEITdy2qxPdALb3+6Ht7QTRfJ41r97+i7rHo0Tx96G
    w3FKE7xmFHTn6f/+y0roynA7alwRH50NkovFFGSDNEMTYRnqjnn8qZwLHB/3BQ/IYRHVKG
    yvdipfpOQk9EG4FtMSDZwh2LQ6Y5SNavbNL1iTTQnUBR2Hs0Q+SBk5BPmkoeevO5BIbHzx
    sknb34jhMgictLRTIeU333EfVJHUI5KQR3KXhZxSoCQKEx/IiF9kls1EpiZg
X-ME-Proxy: <xmx:FgQKa-pWnaxchA-MDX4z96q0-IKw3Vj01xQkND6P1jKgm9Qqn3I7CQ>
    <xmx:FgQKa9YMQk0uYApGCtww3T52X7i5SgU-IDbGN5YCS8PPtFTsjiNE8w>
    <xmx:FgQKa_XZHzUEZtK7sBfjdZRsSV0-Blh7_kIvNxThctfO9BNKP0Evkg>
    <xmx:FgQKa-9hRq5Xvs2ygs7kS_DBnnUgiXSMMTgn_8eS35pyFBr11wmB6w>
    <xmx:FwQKa-tU9R6rROVsAeaVCLU-mPhwTRljfDvLgbeT5QOC5K9Q9DKu81Pu>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Nov 2026 17:28:37 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [RFC] ksmbd: rework the DACL access check?
Date: Fri, 27 Nov 2026 16:28:29 -0600
Message-ID: <20261127222829.1664817-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd9NSCsBsX3diAiKez1zE221+pZ62X+fcQZRxYx2xmwCvA@mail.gmail.com>
References: <CAKYAXd9NSCsBsX3diAiKez1zE221+pZ62X+fcQZRxYx2xmwCvA@mail.gmail.com>
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

On Thu, Nov 26, 2026 at 3:04 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
> I agree. Please verify that the relevant ACLs-related smbtorture tests
> pass after implementation.

Thanks, I will.

Before I send the series, I would like to agree on its rules. There is
one formula, from my first mail. A table defines its last term, and a
few rules sit outside the table. Three questions for you are at the
end.

The formula

	granted = (DACL rights | parent rights) & filesystem rights

Every access decision uses it.

DACL rights are what one ordered walk of the file's stored DACL grants.
A file with no stored DACL, or with a stale one, has every DACL right,
so the filesystem alone decides. If the stored security descriptor
cannot be read, the request fails.

Parent rights are the two rights that a parent directory can give
(MS-FSA 2.1.5.1.2.1). They are DELETE if the parent's DACL grants
FILE_DELETE_CHILD, and FILE_READ_ATTRIBUTES if it grants
FILE_LIST_DIRECTORY. A parent with no stored DACL gives both. A parent
whose security descriptor cannot be read gives neither, and the share
root has no parent.

Filesystem rights are what the Linux permissions allow, the POSIX
rights of my first mail. The table defines them.

The table

Each row is one right of FILE_ALL_ACCESS, and each column is a kind of
object. A cell says what the filesystem must allow the caller before
the right is granted.

  right                  file        directory     named stream
  FILE_READ_DATA         r           rx, list      r on base
  FILE_WRITE_DATA        w           wx, add file  rw on base
  FILE_APPEND_DATA       w           wx, add dir   rw on base
  FILE_READ_EA           r           r             r on base
  FILE_WRITE_EA          w           w             w on base
  FILE_EXECUTE           rx          x, traverse   rx on base
  FILE_DELETE_CHILD      w           wx            w on base
  FILE_READ_ATTRIBUTES   none        none          none
  FILE_WRITE_ATTRIBUTES  w           w             w on base
  DELETE                 wx parent   wx parent     w on base
  READ_CONTROL           none        none          none
  WRITE_DAC              owner       owner         owner
  WRITE_OWNER            owner       owner         owner
  SYNCHRONIZE            none        none          none

  r, w, x     Read, write, and execute or search permission on the
              object itself, as the kernel would give it to the caller.
              A read-only filesystem, an immutable file, and an LSM
              count too.
  list        What FILE_READ_DATA is called on a directory
              (FILE_LIST_DIRECTORY). Likewise add file (FILE_ADD_FILE),
              add dir (FILE_ADD_SUBDIRECTORY), and traverse
              (FILE_TRAVERSE).
  on base     Checked on the stream's base file.
  wx parent   What the kernel asks before it removes an entry. That is
              w and x on the directory that holds the object, the
              sticky rule, and no immutable or append-only flag. The
              share root has no such directory, so DELETE is not
              granted on it.
  owner       The caller owns the object or has CAP_FOWNER. A change
              of owner or group through SET_INFO is still subject to
              the kernel's own rules.
  none        No filesystem check at open.

A request is checked as a whole. The permissions that its rights need
are combined into one check on each object, because a POSIX ACL grants
a request only if one entry holds all of it.

The table is only for the access check. It is not the mapping between
a DACL and the mode that QUERY_INFO and SET_INFO use.

Most cells follow from what the operation behind the right does. These
are the ones that need a reason.

- FILE_EXECUTE on a file needs r as well as x. A handle with
  FILE_EXECUTE can read the file over SMB, so it needs r, and x makes
  the right mean what the mode says.
- Listing a directory needs x as well as r, because a listing returns
  information about each entry, and that needs search permission. A
  caller with r and no x is refused when it opens the directory.
- FILE_WRITE_EA needs w on a directory as on a file, because EAs are
  stored as user extended attributes. In a sticky directory the kernel
  also requires ownership to write one, which the table does not cover.
- FILE_WRITE_ATTRIBUTES needs w, so that a caller cannot change the DOS
  attributes of a file it cannot write.
- FILE_DELETE_CHILD has no operation on a file or a stream. It needs w
  there, so that it goes with the write rights.
- The named stream column differs from the file column because a stream
  is stored as an extended attribute of its base file. Writing a stream
  needs r as well as w, because a write reads the stream first.
  Deleting it needs w on the base file and nothing from the directory,
  because it removes the attribute.

One consequence is worth stating. FILE_ALL_ACCESS and GENERIC_ALL hold
every right in the table, so an explicit request for either needs r, w,
and x on the file, ownership, and wx on the parent.

Rules outside the table

A named stream has no security descriptor of its own. It uses the DACL
of its base file, and its parent rights come from the base file's
directory (MS-FSA 2.1.5.1 and 2.1.5.1.2.1). Opening a stream that
exists also needs r on the base file, since the stream is read from it.

A data file with FILE_ATTRIBUTE_READONLY refuses an explicit request
for FILE_WRITE_DATA or FILE_APPEND_DATA, and MAXIMUM_ALLOWED does not
add those two rights or FILE_DELETE_CHILD (MS-FSA 2.1.5.1.2.1). A
read-only filesystem needs no rule of its own, since the kernel already
refuses w there.

A read-only share is share access, not a read-only volume. MS-SMB2
3.3.5.9 checks a request against the access the share allows, and Samba
removes FILE_WRITE_DATA, FILE_APPEND_DATA, FILE_WRITE_EA,
FILE_WRITE_ATTRIBUTES, and FILE_DELETE_CHILD from that access on a
read-only share. I propose the same. An explicit request for any of
them fails with STATUS_ACCESS_DENIED at open, and MAXIMUM_ALLOWED does
not add them, or DELETE.

A request with MAXIMUM_ALLOWED must be granted every right that it
names. The other rights are added only while the filesystem permits the
combined request, in the order read, write, execute, ownership, and
DELETE. So a bare MAXIMUM_ALLOWED keeps read when read and write cannot
be held together. The open fails if it ends with no rights. The maximal
access reply reports what a bare MAXIMUM_ALLOWED request would get.

The formula is applied to the rights that a request needs, and those
are not always the rights that it names.

- An open of an existing file needs every right it asks for, with or
  without delete-on-close. ACCESS_SYSTEM_SECURITY and undefined bits
  are refused, since no rule grants them.
- An overwrite also needs FILE_WRITE_DATA, and a supersede DELETE. On
  the unnamed stream both also need FILE_WRITE_EA and
  FILE_WRITE_ATTRIBUTES (MS-FSA 2.1.5.1.2). An overwrite of a read-only
  file is therefore refused. The handle keeps only the rights that the
  client asked for.
- Creating a named stream on an existing file needs FILE_WRITE_DATA
  (same section).
- A new file gets the rights it asked for, or every right for
  MAXIMUM_ALLOWED (MS-FSA 2.1.5.1.1).
- Creating, renaming, or linking needs FILE_ADD_FILE or
  FILE_ADD_SUBDIRECTORY on the target directory (MS-FSA 2.1.5.1.1,
  2.1.5.15.12, and 2.1.5.15.7).
- A rename that replaces a file needs DELETE on that file, from the
  file's own DACL or from FILE_DELETE_CHILD on its directory. The file
  must not be a directory or read-only (MS-FSA 2.1.5.15.12). MS-FSA
  sets no rule for a link that replaces a file, and I would apply the
  same checks.
- A listing with hide unreadable applies the formula to each entry,
  and an app instance takeover applies it to the open it replaces.
  Both ask for read rights.

An operation on an open handle still checks the rights that the handle
was granted. That does not change.

Questions

1. Are the table and the rules outside it acceptable?

2. MS-FSA applies the MAXIMUM_ALLOWED half of the read-only file rule
   to a directory too. I propose to leave directories out, because an
   explicit request for the same rights on a read-only directory is
   still granted, in MS-FSA as well. Should the rule cover them?

3. For MAXIMUM_ALLOWED with GENERIC_EXECUTE on a regular file, ksmbd
   lets the full set of read rights stand in for FILE_EXECUTE. Under
   the formula the DACL must grant FILE_EXECUTE. smbtorture's
   smb2.maximum_allowed.maximum_allowed expects the existing behavior,
   so it would fail. Do you want ksmbd to keep the existing behavior
   here?

Thanks,
Ian
