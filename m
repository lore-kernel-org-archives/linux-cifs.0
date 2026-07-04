Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D6A2EEE86;
	Sat,  4 Jul 2026 23:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783208636; cv=none; b=VyUo86fNnERPi8twznrPYJ4ifHXdGKjnySi+1uMagDAga4pgeSy589nRHgbz/SIuQysLd2oR6UtSv8O5NeKJcRWRZj5C2NHxjbEmsOn34DRqubi45klayqyPplr58CQGRRxxOVE4VPfKU6agy9FXyrdchK/fzvvjXzDFiGK2EqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783208636; c=relaxed/simple;
	bh=Cz9GMaBTT+3angHa5xJUuGEVTHFOvP1jVsH/p+l3Xz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zc6UqQB7F7eXiMz3YOPdPJoR4hiLhXv+myG6LGeqpLuDJs1fa8ftWI7LoeNNf0BG252DN54fv+4IR4wfRBPUsCgDPFw9gOYYaW53sS38xA07w/XUzrUo2CuG/wgtygi/ZxeVcHxIs3vT3XfMl44ZiUCJ4Xm2froUJLZ+SoEM8us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=KHBEWVxb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CBN/UVCa; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="KHBEWVxb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CBN/UVCa"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2E8181400086;
	Sat,  4 Jul 2026 19:43:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sat, 04 Jul 2026 19:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm2; t=1783208632; x=1783295032; bh=bIa83KNGK2
	+cMyR4lba0xKrugtFAbp8OBxmHyG/83U8=; b=KHBEWVxb8PFOwlXRyfwgwy8vKs
	3NvXGOvgVW/kX1KyTus5pjMoWNxFSCr3lJpLP28vrSARdNBp3QEp4PgWGZdT0qJa
	FH+D6Ij6wGJ68xUp5CidP40qxN18wGLX5CoHDp2benria9MxKM9gPK9idtVSVIlV
	GdETNwxVWaXAEbPRh+MmREYD2iWAknaKJt+YhmdAEDO2pUJ9euFd5vJ9zTVFHPRD
	ECYvE/KVpjOynz/hJsyQtitNdOE6Nixt+6OE1z0v3ad/D4PMYTNuRLZz0NwhCFV3
	DTw+wIWHlqsTXJKCMKveTgjnJV8vyWQbhqYeBFmREGurasUn9bnCV/QOPzAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1783208632; x=1783295032; bh=bIa83KNGK2+cMyR4lba0xKrugtFA
	bp8OBxmHyG/83U8=; b=CBN/UVCagjeB5L7TU1ak2meODCRyjFAXmqUNF3RzJmeR
	jaG8KSgH65ZeYrbpupQRgJkujxLGhee+DdWQb+xN4fI37mExv48Bh7Zjvrw84C/W
	Mf3+lpuX4UVjbJPjdboKnRx+2wt2PPJZOpErs9Wv/CTU+t0Yl17qlM+jboBDUQ/7
	LxIkwcf2SlDF2PAME5/RL3caz4CeIt5y0t9bxrcLn1nqCN0uptO0xszl1Y7INBDQ
	j4WWg7nbWV39j28GEOYOLq1qmKERVXlToxlkvQwD0pWFqdjLIHgdvQKEHhB5RKVs
	cmd90aGWO/GW9bMlZSvkRt8lYSPtQVpxbEXOyLk/uw==
X-ME-Sender: <xms:t5pJaoPaiX9IQx4VWhhKYns9dPvC95p-yhzdAuXu7_V6TVG68l5tGw>
    <xme:t5pJagfmaLjZGIFN179-rivqTnondYRvuGq-JsYkLz6xKibjw18gf3nL9YbBQmCte
    rMOa85ETtfuXHnZlk7Au7drmwUmV7WGQUTi1W4NfXr4qTRyML8>
X-ME-Received: <xmr:t5pJavX33Rgd_0QN4M-4uTvDBUDJvjpHMu9s_jRPLRfCP43-TAHWpSVjboqbBlN4cohf7Jaka-2AI8YQbrw1DlFDfBk-1sk>
X-ME-Proxy-Cause: dmFkZTEiFYXAF8MMRt+wGxeVdwv2cA5ptFq2SEFZgvS6SRbcbsuJ/HcgsLShluvM72XdtS
    B56hHfp655zQSmMCjyCY2iYsq+WKRmzXCkQBzGYsW+kYxmZtxb5Q2/wD0565WOt4ZFo7HL
    KJ+FFw7Ehw0qMf2An8a2U0fGJ0z3eLkq+p9kQYc7mh862rbqaL350CeqRfwcH97hxmK29h
    soBZOfoDt0AKXgaPCgbU8ZavJX0+eVHbPl1WU1bjpKd+Z8PPNt6bni/F/nBbYy38mXnq6s
    4j26CW4S7K8TaoVHnlth0HRwmpK/pVpR//zpkymcurU52zY0/oM5cn0z8Se30firgkjhD8
    mOq16ft2fbKIPDnSiNjHcuBhLwUitx99nOu+k+W4H5RyNnKyOCIpY5w3cBZMjInqAr52mV
    UZAya3YjGozqq797WtUfE2UGOOpTHPH6x0Br5ll1ijIXC2bi/3zpg3iJGmL86N3bV23CzC
    69ziPQhzdaWfR/YcWKhON39Ry3PBgzVSI5wXWMvQ2pEn0ERkXxJJqGbDAz9tT2rQLlHVpB
    6moJHicJ/gj5bH4NJA6yfN7EVhPA7fCvHsdo6V+zyTAwThs2GD11PBEPwFxDj3QjyHrF0J
    dUpiCC/qbLnzCH74syYAp2bfKTTjNV/xDJ0daIvTOsziYyiAGqLhIJZghnJA
X-ME-Proxy: <xmx:t5pJaggLIRO-UTk8sAUn438eCuP3ZZ8Xs3kbbcfvBc-jopgEOsiItA>
    <xmx:t5pJam8qlEaKiemRdx-z0gBT8-G9-oK7VytZ9B5ZxnuKAQr2vFsx0w>
    <xmx:t5pJaqYM-4JBDqemHJ_Fi5GFvl1FJJYPYQX8fQEW2uxPV7vjzU8woQ>
    <xmx:t5pJal3hDDiMkHwGbjnYzVWnqj_qpd2Us6ENG_TdzjT0l4NejDBkXA>
    <xmx:uJpJarWtfot5csn9sri9R9Uww4NeRefpY095Sp00ZhCDzhGi31o43OZA>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 4 Jul 2026 19:43:50 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/2] afs: avoid unhash/rehash
Date: Sun,  5 Jul 2026 09:31:40 +1000
Message-ID: <20260704234339.377234-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs (like nfs and afs) needs to block "open" requests while
processing an unlink or rename because if the target is to be unlinked
on the server, then the open must fail or create a new file, which needs
to wait for the unlink to complete.

It does this by unhashing the dentry and later rehashing it.  This will
cause problems for proposed changes to locking which will lock the
dentry rather than the parent directory.  Unhashing will effectively
unlock the name.

The second patch here addresses this by using ->d_fsdata to mark a
dentry as being busy in unlink/rename and waiting in d_revalidate for
that mark to be removed.  This is the same approach that NFS has used
for a while.

Note that I think there are still possible races which I haven't tried
to fix.  Because cifs_open() constructs a full path name to send to the
server, it could construct and use that name *after* the rename has
happened on the server, but *before* d_move() has recorded the new name
in the dcache.  Then it would try to open a name that no longer exists.
I think that could be fixed by locking the file inode in cifs_open()
before calling build_path_from_dentry(), and holding the lock until the
last usage of full_path.  This would ensure no unlink or rename were
happening at the same time.

The first patch frees up ->d_fsdata which is currently otherwise used.
It is being used for a purpose that ->d_time is more suitable for, so
the first patch switches to use d_time.

10 years ago cifs *did* use ->d_time but was changed to use ->d_fsdata
by Miklos with no justification (a00be0e31f8d).  Miklos: do you have any
memory of why that was done?

Thanks,
NeilBrown

 [PATCH v2 1/2] smb/client: use d_time to store a timestamp in dentry,
 [PATCH v2 2/2] smb/client: don't unhashed and rehash to prevent new
