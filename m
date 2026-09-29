Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D022CCC5;
	Tue, 29 Sep 2026 02:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649862; cv=none; b=SyCm26GWPOOeYltFmM/ovcuupwmRvsAICrsX+rS3EsxuQTH5fzA90/JqnqErwefGW81x6U4z1yuK2v6lTRdmsWJiadYjoZFp9v3XMiyJQb2KJ1zehpmDLT1GLb6IpWi4qsMfqcZlTjGza9bQFR0gJjKeQaaKpJs03FxSlKrKXVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649862; c=relaxed/simple;
	bh=iBfeqgMRiVxb4oRXFBF5GNVKWjz3mxIOViPtKeJ0HR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OjA0aNI/hiwV51+aLhv0+iQA0fOWdoa7Zlw8rRG0i8PaF5+htj11vjOkkrPcAtwDmys57wQCZHITG2derAK6vr5eFht/Yf2PgJQdr0LaBcUP5RvWsLan0lL/BS/3B2LnLnWa5++3Pk7BobQQvRr8D06H9m5EXxhV6mYatxq/Z+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=jjWdnx63; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rXGcWBPr; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="jjWdnx63";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rXGcWBPr"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 7AB031D00103;
	Mon, 28 Sep 2026 22:44:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 28 Sep 2026 22:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm1; t=1790649860; x=1790736260; bh=zJ+BbXdMcO
	DbkeUgo/YzN3mabbfa28QPHAXLG0M5wF8=; b=jjWdnx63If+rMal3WYxUdV7iD4
	fl50sUbdPGfqWBGQfO/jaB1RFe1OB3MrR7IrG86cOYsH1J56a7snKwbH6/0zRpgK
	87kG2Zn37wVhDSBJbmrk2tIW8TQhjCSWSF1rt325Kh0Ob+WA2bFe9U83qDYX+4Ks
	YCWZlzmUyzrLHG4W43eYM31XVoIqrcUJY7w53YJQY1qKPsK0FZAzsuiCPoqI9bd0
	wGVhBdmRPWm5ozIwKBVoaQsP5UUNq8q1jFxd4Sv95kpX02+4cF+VjePmb/kCk6sW
	DLyw8ciByBfgbOkjlb7F9e2MOSbGavCU6jEDZRihKlTBzmioZjVUB8PwGVVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790649860; x=1790736260; bh=zJ+BbXdMcODbkeUgo/YzN3mabbfa
	28QPHAXLG0M5wF8=; b=rXGcWBPrRIsD0GanN1+pOG0unCsUQvN/LMyHwHMDUi8C
	NNKDcQe+X4b9W7P2LZmK7YFQGz1BheNA5E317ByITZlJj5kWnE7qlC/pgOFlzWke
	cSolIwiBXiZSWb3PXxKnjoIBbaGKyIhd/rIQxY+8hD0SGZhChNmE91UwsbEZlb1S
	kpHpcvUusUvfKHEFgeQsZKytJ1bci21FlT1i6Hu3uCgbJ25hpLWZqZT8gH1SFZSb
	etMXlaHK7eiULolCBlXLZY6e/0Fg4c3I3CIu5efzHuHS15blVNlmz44qAdOGNyQI
	M/fiiwmrc6m/vwPW684RdTKgMrUNAlheTRwAuMYD4w==
X-ME-Sender: <xms:Aya7amzHSDvX9fD2QTX1N2Zjr4hlygqtwkIai1WN-84m8kgblAwieg>
    <xme:Aya7alXyLFHKexUyXXxZrHEgeVnL00uc6YX4gEFWkZzKtps96ZGezadKS2EBwt77M
    K2TtNYuaHTVO441tm5Fb4B628eWJuFB5wjYNdRb3bkM0SLb0Q>
X-ME-Received: <xmr:Aya7ai9kVWpDEwDrJgOU6epE1WMqldh6PyC4OmF1VLPhKBXToz5xoNzICfmTPBI3QPXVWv3O3KdXlmHI_2VNBglykwUqlI8>
X-ME-Proxy-Cause: dmFkZTFFDn7pMCMiHwdfZshCBKQv2bOXMi0SXm0bspVjujJaKUMK7dLCygyMUfHAGTZiH7
    M2MNkFhEIYI3KYqMcPadvxp8qvZt7MmXtAN4Cm+M+XHwRhaEGVtQSNdG41C4XTGSv1ld93
    es7ppJExLsCEJtCH5uaoZCAoR2A2f8I7wC0+rkw+y6sTreQfBeC+e6JrV7fwLdIVUSihXX
    /dQZhOcVMjBo4/zrNP/0N1Xqma1yxGWk1ZHdDytdQZqrfMnkH+fpo+IKbuNzm8t4HTLYKg
    4UCUSETIFILqQo7WUfXAV4anfcO2H9XX7oVByL1UfcK+K+uNuPFLJEbOeHs59oxcpxIsGm
    /Vj1G7Rvr4RufbsacgmWk7taEL/UwTBARa1Ey0bsVb0Hd08btO5dHrMk6GBSM2ah0Jm02R
    4151mTLNc9eSnXRgynjwL6WwsarfmIbE4BXJet2dFoAxYk9K0vRWunCdAkS60B8E+d8Gc0
    NCO1M+YCMEi05TC5EkCdJ8xsROrn2L2hc0yyd/E/zmTujaOkdUBosf3oUq/X/62Sgsub2H
    Nqtc7GR5O1S18uflyu2IYNdJlGV7OtSo68AzOMt1L1s1bzYV43WA6VJlEixCjBvcU3erxg
    uXLbRu0Xri+pAvZPRtbvpem6nQsB4Sx6WINyqtONeQrv0Xel4sKtwjczGCXA
X-ME-Proxy: <xmx:Aya7aotZtPQw4aASxpyUdHf0AMwdItpqLtl2vxCIj-m_jOERc4q8bw>
    <xmx:Aya7ai1rIeM3TJyvbyNjGn-YdSFPTJ-j6Bdl6hHvRfQTMLE8-Z-1jQ>
    <xmx:Aya7atQgc1GvuL5hY2QX1COjAKhKh0ahQNZYIhXXd8qyQmrpFhM_cQ>
    <xmx:Aya7amc0bsJ3TK5uq2S9gLAbaeNfw8T-xTzQm36_qo3f6fAQG6NJoQ>
    <xmx:BCa7akicj4G63Ir0-TWWsQbvaECLCYVm4W2vA1dwaabbdToTLyVMt3hQ>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 22:44:16 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] smb/client(cifs): prepare for VFS locking changes.
Date: Tue, 29 Sep 2026 12:40:00 +1000
Message-ID: <20260929024352.1433257-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous version of this series had a couple of problems reported by sashiko,
both in 2/3.
1/ an error from cifs_lookup() wasn't handled properly - it should be fatal
2/ The d_is_positive() tested the wrong dentry.

Original intro message below.
Thanks,
NeilBrown


I am working on changes to directory locking.  The medium term goal is
to lift d_alloc_parallel() locking above i_rwsem, so d_alloc_paralle()
can be run unlocked, and consequently cannot be called when ->i_rwsem is
held.

The requires:
 1/ that d_alloc_parallel() not be called while i_rwsem is held.  cifs
    does this in a couple of places.  A new interface d_alloc_trylock()
    is now available and can be used instead.

 2/ a dentry must not be d_drop()ed while an operation is ongoing, as an
    unlocked d_alloc_parallel() would then be able to create a new
    dentry with the same name.  In particular d_rehash() must be phased
    out as it won't be safe.  This particularly affects the mechanism to
    block lookups/revalidates while an unlink/rename is happening.  The
    mechanism is changed to use one similar to how NFS addresses this
    needed, though using the new LOOKUP_PRIVATE flag.

The patches depend on patches recently added to the vfs tree.  I would
prefer these land in that tree too with an Acked-by or similar from cifs
maintainers.

Thanks,
NeilBrown

 [PATCH v2 1/3] smb/client: don't unhash and rehash to prevent new
 [PATCH v2 2/3] smb/client: use d_alloc_trylock in
 [PATCH v2 3/3] smb/client: Use d_alloc_trylock() in
