Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9446240245
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jan 2025 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736781950; cv=none; b=r8fJonV0ENDNo2TnY1eCoUNVQKMaWQvlMKt45TvmZLV7AEMAtvfGVaUQduynAbWsxSs8VslrgE3gOnPlj1vMZnVpaAJzb7hiHcPlO4uaZOVARf/2Ygr+tuoWKhsZjo5PX2P/G6mBb0vBeClUFrdFCeCWVrqNEzE5y9UUP+7+7Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736781950; c=relaxed/simple;
	bh=VXtxyboEYML7VBPDRO9k1EtoJ+qjBEW2LPlp3e2+bp8=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=YFsUNmXrSnFdf9TCYkOkYGcHvmY+ibaz77obv8KIULuGBfzeC519WB7ws2uGCeMndbETjlWcmVtS5SW0V2v7E3tc2PvYJU2nXtxUD4JfVoo3PAtTOzkeB1HwkmxmeDh3Pz6yafIf+BSAOgk9VDaUMprrmpMq/geDeBifCnd5XUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=cCVWNbIA; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="cCVWNbIA"
Message-ID: <eed163634d34c59bdfe3071c782276c2@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1736781941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4Vg5x2aNwXcwg+LoaXIGhLgG91XtOp4jBewbSp4cok=;
	b=cCVWNbIAO1JQJqdvOqRMUw+o8eA77UbRaiRyawqAmOL/5F66B16MeW1W4M15ZE+owm8AZr
	QuQyYBmTCx6sBhpknAbOn/tmn/B7oQUCfsgdCRr+b0o9TSaX84RgoLRkMQetL0HLRcJlUh
	pH9YH3HGkWTs6aH5jVj6FC5nK5y8AZDij1XrRwzYGIEZGQrk3fg8Y65afka+uP6+H8Ftx5
	rZ4BkJeJk04Wtv8DtNkt8ZCIcS/Q/Hh2+rnpNOYHCUgz1aTiRGNyWPVCilVIPpmEsMECUb
	gYkREOnS/QGmVBkezeXRXHLC/JK9+FwSrGjPxCvvLOFgUsMXAYEJ0/cbNkpahA==
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>, Steve French
 <smfrench@gmail.com>, Bharath SM <bharathsm.hsk@gmail.com>, CIFS
 <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Al Viro
 <viro@zeniv.linux.org.uk>
Subject: Re: Negative dentries on Linux SMB filesystems
In-Reply-To: <CANT5p=o-1V2ea-+Lj+M0h4=syXyJYu73JU3F0dXij=KVwWUTOw@mail.gmail.com>
References: <CANT5p=o-1V2ea-+Lj+M0h4=syXyJYu73JU3F0dXij=KVwWUTOw@mail.gmail.com>
Date: Mon, 13 Jan 2025 12:25:37 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Shyam Prasad N <nspmangalore@gmail.com> writes:

> Ideally, negative dentries should allow a filename lookup to happen
> entirely from the dentry cache if the lookup had happened once
> already. But I noticed that the SMB client goes to the server every
> time we do a stat of a file that does not exist.

This is a network filesystem.  If the last lookup ended up with a
negative dentry in dcache, that doesn't mean the file won't exist the
next time we look it up again.  The file could have been created by a
different client, so we need to query it on server.

> I investigated this more and it looks like vfs_getattr does make use
> of negative dentry, but the revalidate always comes to
> cifs_d_revalidate even for negative dentries. And we do not have the
> code necessary to deal with it.

I think we do.  Check the places where we return 0 from
cifs_d_revalidate(), meaning that the dentry will need to be looked up
again and hopefully instantiated (e.g. file was created on server).

> We do use d_really_is_positive before we do the dentry validation, but
> it looks like that comes to us as success, even in case of
> non-existent dentries. Is this expected?

I don't think so.

Al, am I missing someting?
