Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4F3859C6
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770052903; cv=none; b=UnNCwlh3J/nsDr2kcdCqm99hRFRCEtwGTDQeWeXF2qEufpkKazbm1+MDKTfy6iZ3GvTz7zhXccqIOj0Q7LTCpGj24iDMZJftAnn+Np/x8mcqDv2HDyUkLbubCgozaCZhP29ZF9pQ9vaRh4kz7FL9Lv3dEK+f4M43zmBwqHNwRx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770052903; c=relaxed/simple;
	bh=+T4yYuan96WITcT12g1iBBVvfkKYwaE7HMPv4cIyPsU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=iQ7/da3cIkLBJC7w8yQLZxlD3+zyQdjxbjPllgsyMUH4xBUnVpsqH7dOuoSq8Sup24D7Ne7isv4zn05HT7jOvI8kpI5UZoCtIUSyvEgb8p07fJ3mjXVmouucOWE5gkuKnpn4O0uwq3ZNiKnyzLTMvUmcUam9c3ZLx9powmyViJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=1y4lkiqn; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="1y4lkiqn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LZyzCr2HF1PDiwZmPhf566SDPA07jUZ4T2+M65XQwUI=; b=1y4lkiqnbNozRRWcFVNPVeTAtu
	fDtb06Udjknkadael3/MZBgmBhl17nvS02Ksf7KEAeFmpTJfGYFZl1cDatr2DV8sSVL20f1Xwtulh
	TSvQGGraJyydXKDk6mEAuYvJBdFS+JydbxuFad/H53rp4d2H0CVdjVaoKW/z+QoXV8btWkprVTuEP
	UUQLkq1PpxV9CwKWFXTama9qlbMOye604qEd9dw+TnTmvZ5TwiNHIGS60aIDGCcIB4pmhBoZQjnVw
	Ii0Ik0hqNtwZd9TUDAPMiM5yWzbB5ccgOy/sW3SvSWHnSz7X67QNv5GmEwSya+yPngSrt0ditfqUL
	NwVy4ZVw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vmxcK-00000001VZ6-1ff3;
	Mon, 02 Feb 2026 14:21:40 -0300
Message-ID: <1475df6b259c785c9a00e5ea496712fd@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Shyam Prasad N
 <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>, Steve French
 <smfrench@gmail.com>
Subject: Re: Problem with existing SMB client mount code
In-Reply-To: <2463050.1770046784@warthog.procyon.org.uk>
References: <CANT5p=oDUoq0JgTReUazFds5iLc+-gfiwL1iJXbeF-+YReXfSg@mail.gmail.com>
 <2463050.1770046784@warthog.procyon.org.uk>
Date: Mon, 02 Feb 2026 14:21:40 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Howells <dhowells@redhat.com> writes:

> The problem with not sharing the superblock is that you don't share any of the
> caches - not pagecache, not fscache.

Yes, that would be a waste of system resources.  Not to mention that DFS
and multiuser mounts would end up duplicating a lot of connections
because they could no longer share superblocks.

Besides, what about existing users that rely on the following to happen:

mount.cifs //srv/share /mnt/1 -o ${opts}
mount.cifs //srv/share /mnt/1 -o ${opts} -> EBUSY
...
mount.cifs //srv/share /mnt/1 -o ${opts} -> EBUSY

Instead of changing default behavior, what about using 'nosharesock'?
This way you'll guarantee that every mount has an unique superblock, so
your remount usecase will work.
