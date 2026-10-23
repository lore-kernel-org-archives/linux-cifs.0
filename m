Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792713835;
	b=JB5zfn2vGd0W6qjFturh9E4u0HRiMtvI46naLY5Ot59iIQC1Mv0Dt2nEkp6wZEg0Eu/z
	 LRun1AH4aNMKyBXmZSeyksc+7tdmI6lOunlRuUBQWW8iXPVQNfleWcOrrKPmhYtkRkb8Z
	 EfAUfTwqwrf0iVC8+1G6dpt6ufaarxkBQIojqZOWhQw97JbY2VTapuhc5hmxX8GF2vmWt
	 8pIK1drosKtDWiCvONYtIqi/lb1SI4JQtsULpfFv9NyTLOpIKSuITAaAf808+zhtFX0y5
	 2xt4iukm2sCCXNVOrHQwhplCzx/trh9ghxfXrnyNaE/f8hTNfjSa7Lx/jtjIS8Y9Xxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792713835;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=PgOX6+3fyrgar922il1kaMeJq+lo7U+V9zKoZGSv4+U=;
	b=hDoLIqhD4+FG9BMFowv339UzKfkUgMU4wNSNysQZEIi1WTg9zLplOg38hnYevPJdwwRs
	 T/tocTsHE8jAJ611AqTYY1/FJG+7EOcNJkTAnHdU+l+mE8zJTHeFWsQb+MQyc7Au9Pu/E
	 PAspg6BaYHdWILXFai87rS8CrOSdIzQbbutL94RRlhO+WX5fjVYyb7ewNHf55w+W4xepF
	 pgjXb6fpMKkCEwVhY3XKOcNcJLkfHFZMGYgv7vSa9Vjv6PBGtVRXU+4u0rSyGHoIZ+AZy
	 deVwMoYkNcpoluSUKpOmZe3e7+mRX37Je9pLHxyTKU7ubK3oEXI8ERNBgY+IqtLvRCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=KGHKA+oJ;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8047A606A31A;
	Fri, 23 Oct 2026 00:03:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8047A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=KGHKA+oJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PgOX6+3fyrgar922il1kaMeJq+lo7U+V9zKoZGSv4+U=; b=KGHKA+oJKKKEOeDPxFnuKbatgU
	DF9d0efZvLo56kdY56KAtft6r/pGGvDhA6GBsGbIaxo1VCQI4giE4tkXqkjJZYrTtjIQclhO2hxH6
	hnGmtzHbdqoP99zSr6NyUu2rE31JV2MgFQ8Y4mYyR+rNUTt8KrvovC9h61m8uKNLSI7wwVxF7VySZ
	HOMupJwn1F8DocCjMi0sAp5ntWpbqDbgzRyT1xQeQYNoLVgHwFQXNRyDVIOM2ylYyE2XN2szMgCIX
	H2/szBIp0uHsT/jcChlzUhLhM8sfyUk9I2SRoYYljMpIqBqmRLCK0yZ8OOXhZxJRuHZdNibSRIedz
	phJ1aXAw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xK2lF-000000002sS-3rki;
	Thu, 22 Oct 2026 21:03:53 -0300
Message-ID: <1d601486a9c3fa0045306a1cd031cf8a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: NeilBrown <neil@brown.name>, Namjae Jeon <linkinjeon@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] smb/client(cifs): prepare for VFS locking changes.
In-Reply-To: <20260929024352.1433257-1-neilb@ownmail.net>
References: <20260929024352.1433257-1-neilb@ownmail.net>
Date: Thu, 22 Oct 2026 21:03:53 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

NeilBrown <neilb@ownmail.net> writes:

> The previous version of this series had a couple of problems reported by sashiko,
> both in 2/3.
> 1/ an error from cifs_lookup() wasn't handled properly - it should be fatal
> 2/ The d_is_positive() tested the wrong dentry.
>
> Original intro message below.
> Thanks,
> NeilBrown
>
>
> I am working on changes to directory locking.  The medium term goal is
> to lift d_alloc_parallel() locking above i_rwsem, so d_alloc_paralle()
> can be run unlocked, and consequently cannot be called when ->i_rwsem is
> held.
>
> The requires:
>  1/ that d_alloc_parallel() not be called while i_rwsem is held.  cifs
>     does this in a couple of places.  A new interface d_alloc_trylock()
>     is now available and can be used instead.
>
>  2/ a dentry must not be d_drop()ed while an operation is ongoing, as an
>     unlocked d_alloc_parallel() would then be able to create a new
>     dentry with the same name.  In particular d_rehash() must be phased
>     out as it won't be safe.  This particularly affects the mechanism to
>     block lookups/revalidates while an unlink/rename is happening.  The
>     mechanism is changed to use one similar to how NFS addresses this
>     needed, though using the new LOOKUP_PRIVATE flag.
>
> The patches depend on patches recently added to the vfs tree.  I would
> prefer these land in that tree too with an Acked-by or similar from cifs
> maintainers.
> ...

LGTM.  Thanks Neil.

Acked-by: Paulo Alcantara <pc@manguebit.org>

Christian, feel free take it through vfs tree.
