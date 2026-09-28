Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC391DF27F;
	Mon, 28 Sep 2026 01:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558909; cv=none; b=hk0lA039q/I++ek8O0wS5B5i0pRsuwPzJOboZrZBPt+FdHtM4bKLH8NsGSw3GF9CUWoJ+s0Jo6ZNmfLUqpCk1ruC00om+ZjdoRNlQ2jXFDqBQB6gOyncOgpK4J5z+kJ83ok9StwQXqUBBSjpfsNxl50EddQRU/fiNylpPM84V9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558909; c=relaxed/simple;
	bh=R8RBlNUvLAj/c5OCvCzqGGtecvvLitr4+VxtS8J9N1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ol3j+av1FKaipsBAuFvZrujAccbo/GM6QVrPJxesz5A7viXPd0OoSocMt4g4wb+UD4bYxtMnRL0wFnMeRnCOzXFKLhkk4dotnWfjE01EtKeMicJAGHPVfxxrsKI3ZxiT4uxvSWKG+cAJSkh0+kDeXdAz8/M2qh9W0oVqVwu1diY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=GdbhlefF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Qa01+y6y; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="GdbhlefF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Qa01+y6y"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 909E11D00058;
	Sun, 27 Sep 2026 21:28:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Sun, 27 Sep 2026 21:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm1; t=1790558906; x=1790645306; bh=tRF7stuLVU
	S3TqZU86djFQ/qvgcJq/YMszLuELntmdY=; b=GdbhlefFtPS4ov/JBjz5V/YnlB
	dzm8TF3madyh25nIw3ewtucUmI25K/BBezqURnNM+F4QTppBw7c8Q5ElUohAAA6E
	VN5tZi8rmce6Jg6McBIkBbBWM2e2sSvBcp7sTh/5GZKYCIttffZYpKpvML4/wIRr
	YdPhT8MZOZUbsEmFpcn6CiwRhdCvceFHFGURKZnE8ume9KQVVU6NU8xSXno87K+3
	Pwuj7+ziTcuxXi5Dp8pj/JHB/n4bL/oSGJMbW9+KJPyJX5RMoF6hj9g9kvz1RUvC
	nWdxVoWeILJ9m0TpLXODpd0hz7WPMxtWouZJtTvECmh8XSC55ogb9ovm9BQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790558906; x=1790645306; bh=tRF7stuLVUS3TqZU86djFQ/qvgcJ
	q/YMszLuELntmdY=; b=Qa01+y6y3xOZTsJCYOGpB1a+KZ0oGxrw8weoM48oD9m7
	oZgZW9up5e+0qQj1D1ljOgCXTKeBJqX6WaJoG0y6Nqw3x1yIyHU1o+HtaPjz+hZb
	6P11w7arGUnFE4M1BD+q9O1LGRGC4QYehJwGXOtVABAREEjv4W0sfcNoelW4L6CR
	ltsF2BH8/GadqiL4yYVVu1S+dc5iGnbtdAuXTW9hbYYlSVejj65GRvqkl34Amskp
	PmjgsGug8rT4fOtL7zJSI+zIV7QATlqg851KFr1L3AqNwIDIc2m54l6hH4ImyKOO
	1Moh8tSBe4I1sNYYcXCxIEmM80Hh+qIHCOHOlZH2aQ==
X-ME-Sender: <xms:ucK5ainM7o6GyzeZIHziEnRag2zqH-Hbl-qBGRIEcOPpqyfLJ-9J5g>
    <xme:ucK5as7EWlsFXnYvIm4-a0LWgr9mzki0h3dB33P2xabxn3kOn6m1cDT0PpiaM9QEt
    8kbZ9lCfLyvHlsFEjUJpYHPBm-mQrSHCVjPUPlD74Urd9F_RcI>
X-ME-Received: <xmr:ucK5arS3fOAjLt-PF-lRMphTTBz28i7U4Cx3ERItZbMQTmCFvo69EllRLKMNXvig4yqolGxZ6GSbFP89kABVS28dE9iDXNo>
X-ME-Proxy-Cause: dmFkZTGzEJMs6zAqs6Fj5qeFWXmQuIzC/y16oMmAdIWv9OrGzXve4mbhNIpkQtRzg+hlOB
    PA/BqTKfxLLInwCdfXQIFfnhPgDrd4T5ppb3j1crlSVcX0q5rQdA+RmGvCy6rRXdwLzgEc
    BhGeSaPcn5Z7Di7bjRcdQnnSPhL4nspWSQ4VyMVdtmEvNd59BzcL2B0x/3a0oR1mqjj86f
    RDneIrIY0K9glx7X21JbIZZjAc0YjQmUnuCNCZEB/WsJ71t+WCkgR2nTkGaazoMRdCIyuH
    E1nR5IZVbW+k45Y8ozRy1YHoFs5wMahRcKoX71KvLY1OtX25WpwYRmwvJQPqRtTTzjUHKy
    +T1iMrxw7lcmuUoi2XlBNNvU/TtMSQ6Wxvc1+YqV6+XlV9ieTdiwm/92AlB+Ofk5IAoXmY
    KKA0pD6eaQ+yg9+Qejrlm1GCU1E4fpw+fqMzp00UaiNn+ftNIE2dxL1H1qK0agJMcecSZI
    MvYZAcuwu2f4pxLX+9utkxIAlX6PDNCnMuYEPlxITINi3tcWGXP9wTI39hy/MMsJ2CY6m0
    dLQ+u1ni6hH99iwI1TVSGw++y6qkntyi0f213KK/1om3oQBSslLGYpJTQS657vx65k57Tu
    AHEUthnMwbzXvNxOQpCc4opRAjshkQBHgRIAKVfdULQ9lZBFxlcl/5L2Cfnw
X-ME-Proxy: <xmx:ucK5aixnGO0Sb4I8ACQBnj3HEUAAXtt84UdtO6bL79mSpBpBritIqg>
    <xmx:ucK5arreZbirmfLkOYFsg4KLnJiRnNmG30gLhcRVDi3Vikfwsrv4LQ>
    <xmx:ucK5at0BZWsLri1iL69LqKv_t9RVt49CMEN54YXIo1gkOgY3SH1N2g>
    <xmx:ucK5ajwb5WC702PfWxtd2V7Waq9YpjGjKMDyx5oO1RB8FOaEjnNR1g>
    <xmx:usK5avnba2La3d6AHBC3GxDKLmdXB55Ya1tTtcoeZi2119Wii3OP1O6s>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Sep 2026 21:28:23 -0400 (EDT)
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
Subject: [PATCH 0/3] smb/client(cifs): prepare for locking changes.
Date: Mon, 28 Sep 2026 11:25:01 +1000
Message-ID: <20260928012812.2890035-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

 [PATCH 1/3] smb/client: don't unhash and rehash to prevent new opens.
 [PATCH 2/3] smb/client: use d_alloc_trylock in cifs_silly_fullpath()
 [PATCH 3/3] smb/client: Use d_alloc_trylock() in cifs_prime_dcache()
