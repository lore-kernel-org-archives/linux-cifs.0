Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C2F448CF6;
	Thu, 15 Oct 2026 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094074; cv=none; b=uk2nPmgNy4RDWYxbWApZq+BvevxMtTUZOYJDdF3p/dxkds7R39bZ9OgNhLlGN/0oDVV6P1WzL76AZXqX0CsnehAUR2IdOveZNKLx44TvNZCuCxX5jkYyLj35LIJkeH8jv0fGbMNrJtOL33JvmPcbxMV/QtTD70fDOngdL6rwee8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094074; c=relaxed/simple;
	bh=+8ApG/KOPylKq8Xuqz8fDeFvoSprr1JeH+SYdrEUUIk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=K8GDB1Bs6tECNoV4GHA3xOToQPbMZw4xZuWx0rdJe6+zM0LHLIYYFlL2VYRWgOIpIyU1VicNhtR2Q6DJw71E+o5iMn+8AU3V1SwPurR2oLV2qS/WEDIUQoWSPmnkPlf19QeXcVnIXG2E9nwJYWKeUERKuZwV9/hHYNfHvZJjDV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=z7GiBAcd; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="z7GiBAcd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rdy/USckRDiUHpHcTww7JstIS2jFG+fr0IFeLGZ67ig=; b=z7GiBAcdIWvU6PuqZh5+wIVsMk
	mufEkYK43tc8JjQGhYsBdgq4nKlFJ+Ia2lS5W0o3qXT7f8IkE0mZiuX+LNsIZgu/vqOFQCLSCpfT5
	E1VOK7VPxQ37IthaFhhWsZhzw2R/PTsyiOca8JBU26E7NyucyR6ZUOGJpWY1JkHxy96lhVFdaUtwX
	fMYAXv6MR1INzkRKZL0PWMECc0PhaR8YjNrZe3Vn99Tt3Swpvr8bIvKXFKz+YegnhTojTXMjEECc6
	TgSEPUYSOMcAoerhxKZLMZ6+JLss3CIYsB0W2c1KDSLoQG6SEq6lVQULZE1BAh3bKe9uMrC7A6Qwq
	BvHSz2lA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xHRX3-00000003jVA-45TR;
	Thu, 15 Oct 2026 16:54:29 -0300
Message-ID: <441cd931c56cb539eb099bf6d976cc59@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Paul Aurich <paul@darkrain42.org>, linux-cifs@vger.kernel.org,
 stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, Sasha Levin
 <sashal@kernel.org>, regressions@lists.linux.dev
Subject: Re: [REGRESSION] smb: client: batch SRV_COPYCHUNK entries to cut
 round trips - 6.12.y EIO above 12 MiB with SMB3 encryption
In-Reply-To: <atEn9dyqsyI3SNaP@redcloak.home.arpa>
References: <atEn9dyqsyI3SNaP@redcloak.home.arpa>
Date: Thu, 15 Oct 2026 16:54:29 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thanks for the report.

Paul Aurich <paul@darkrain42.org> writes:

> In stable 6.12.y releases, a copy_file_range request exceeding 12 MiB on an
> encrypted SMB3 mount fails with EIO and a WARN_ON_ONCE() splat in
> SMB2_ioctl_init:
>
>      # cp /mnt/otters/13mib.bin /mnt/otters/output.bin
>      cp: error copying '/mnt/otters/13mib.bin' to '/mnt/otters/output.bin':
>      Input/output error
>
> Works in 6.12.110.  Fails in 6.12.111 through 6.12.113 (latest).  Via
> bisection, introduced by 8d103b285359 ("smb: client: batch SRV_COPYCHUNK
> entries to cut round trips").

Does it work if you backport the other 3 missing commits?
