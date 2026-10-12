Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBE14A5C43
	for <linux-cifs@vger.kernel.org>; Mon, 12 Oct 2026 19:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832381; cv=none; b=W06bBeOJ1nxiLs0zEAtOwvoY/dQD6Y0c5JGoeRh6CN8ZOrnZweaGKeHmQFVbTDGUfoK89XeG+tyfuG+SD7b4XJ8apv45s3JGiDKMKZqRHC+7kJOzO3TpUMecB3bhpARK9mv97kh7og2i5GSXyS2w2WwdiwHI68ciRvd/hOhfjuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832381; c=relaxed/simple;
	bh=Vmee7MXnwkoo2I4ZVE7vFh76h2ZIAq9AX1YxjXTcBdY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Q79Y8btlc88G8KKU69rgpg4Lge72DbvqwStlxbtRYkfolM6mjLfDxus9Krh5VYacvByVogquN3mjYfgZ6sspu4gt0FdKykIeNn6xwHI3Juf6h00UQFFMtIW9/omkr3wE4EEZpwq/zPLcNlyjS2D1brsFK/FHExMqQVFc+BUBj5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=mWTTdxst; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="mWTTdxst"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=JrQNlir/2s2tXMZYGGGP8mc9Uk5Na/tDysS6UvK6GnI=; b=mWTTdxst1xK0JpL0BS1m7/0f0v
	VwpjgkChXhONPmeLh9wlFGtmgkfBm4yHwXmnGAR79S8Lo8irxy4a3/14HbLlBWivGXOWuektU09DJ
	aHVrTaiYHzcYnQq3nJUkc7qo0AMt2M9G2Ipbbxo5fXzWq+yyn0zcrn8qiJErg9BHJozyVvWuhDyNY
	cBhm9+nltYva4s6n88/c1sesj4aWfZSmsYSqfrzm40ItVWvLOw7Z73sZ0tnGaGYkKN9EDis8ex34J
	ZYMXzvd/vQIi4QbUgsYtKfAoxTBm41vQb3g6hnCsOdIex8ueYPem34afnDWdqEHEEP9Eb2GTtrcoq
	362pkNEA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xGLS3-00000003Trx-3XlP;
	Mon, 12 Oct 2026 16:12:47 -0300
Message-ID: <a921bdd206f0a651e2dda9d9e3ef5429@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: =?utf-8?B?5pif5rW35piU5raf?= <starcyrene@qq.com>,
 linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 samba-technical@lists.samba.org, =?utf-8?B?5pif5rW35piU5raf?=
 <starcyrene@qq.com>
Subject: Re: [PATCH] smb: client: add "noautomount" mount option to skip
 junction submounts
In-Reply-To: <tencent_B5ED8BAE1AA8B048FF6EBB8AD35DBF004306@qq.com>
References: <tencent_B5ED8BAE1AA8B048FF6EBB8AD35DBF004306@qq.com>
Date: Mon, 12 Oct 2026 16:12:47 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

=E6=98=9F=E6=B5=B7=E6=98=94=E6=B6=9F <starcyrene@qq.com> writes:

> None of the existing options turn this off: "nodfs" only skips DFS
> referral resolution (these junction submounts are not DFS), and
> "reparse=3D" selects the format used when creating new reparse points,
> not how existing ones are traversed.
>
> Add a "noautomount" mount option.  When set, CIFS_FATTR_JUNCTION inodes
> are not marked S_AUTOMOUNT, so junctions stay regular directories and
> the SMB server resolves the reparse target on access - which Windows
> does transparently for normal path traversal.  The default is off, so
> behavior without the option is completely unchanged.  Note that the
> option also disables automounting of DFS referrals, so it should not be
> used on DFS mounts.

Instead of introducing a new mount option, can't you use 'noserverino'
to handle such cases?  That is, if you mount the share with
'noserverino' mount option and the client finds a directory with a
name-surrogate reparse point that it can't handle, then neither create
fake attrs nor make them as automounts.

The original intent of marking those as automounts was to prevent inode
collisions when accessing files from those directories and then leaving
the parent mount still trusting inode numbers from the server, as way to
keep hardlinks working on the parent mount.
