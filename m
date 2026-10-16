Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD095B5AB;
	Fri, 16 Oct 2026 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159711; cv=none; b=qh4KB7NzNFjot4IUYWeHePuG62t/e1tr7l4qtFp0JojhgNOoMA6i3nCGTRoGbqgyoJivJUW/Be6xB28Arn2ADhAHTooJbPuHMB4Ly1tW4QJoFQuJbrFBgJ8AR46Akbq4lOMILAHaDbZx8MGPoUM2t6ee945kGW/jxzYe8uuNneE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159711; c=relaxed/simple;
	bh=pgmlANoo4PHwXDRcZvar1fCXwIi7mclSi6zj3yGX9Ec=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=f2uj9bCqPpUkjejt8iYwVzIbR5NYlNeSnd1njNKiahiKfrkFioGHWek4zRFFw6LyGDRkaKjN3oW1v9Tb/6hpBCwjJyB/S0SJUBI7su0bBagec+sZ7T0YUD6cadwspW5f5eP7qYdsOwVI74Z4UnIGN9pqknVAKBZYzcjU8f1P1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=RiCph5Ad; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="RiCph5Ad"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uX4fIb/uSUYNnsP+YLqWHZFcIPv0mWtTQ8iI6IvR0GE=; b=RiCph5Adu7tzCwUtI3bRX4VACz
	Uf7R1VQq787+1BAXpNuThUN+BOU/k4HVWmP19RExJS98qzkfsHRNhDe3ZBfgsvUg3ggyWQYogig+u
	h6tGYACXLg/RaqdmwPELSfVCtyjAZuS1XaDwj6bZzCY2dusX9GApsWk2ADhRtv8Qlz58MXTQqk8DW
	FUVMZxkWe0EkgkFV6dOTHK9xZqZIs+D621iXrDU3cr3YEcDNkODLMwAhO2ywC1aUUuUrLdBA8Fsu0
	VE91cncpLNogcigC9fm0DKdi02/hMlK6d3ZJfLuuSni4EqBevG00c0r55AviT2S/ygAJXaVPNI2OD
	4Z+cCvgg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xHibd-00000003nIN-0MsN;
	Fri, 16 Oct 2026 11:08:21 -0300
Message-ID: <437553f9978afec2dc14363fdfedab5f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Paul Aurich <paul@darkrain42.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Cc: linux-cifs@vger.kernel.org, stable@vger.kernel.org, Namjae Jeon
 <linkinjeon@kernel.org>, Henrique Carvalho <henrique.carvalho@suse.com>,
 Sasha Levin <sashal@kernel.org>, regressions@lists.linux.dev
Subject: Re: [REGRESSION] smb: client: batch SRV_COPYCHUNK entries to cut
 round trips - 6.12.y EIO above 12 MiB with SMB3 encryption
In-Reply-To: <atFFiAr9gbs9jXZA@redcloak.home.arpa>
References: <atEn9dyqsyI3SNaP@redcloak.home.arpa>
 <441cd931c56cb539eb099bf6d976cc59@manguebit.org>
 <atFFiAr9gbs9jXZA@redcloak.home.arpa>
Date: Fri, 16 Oct 2026 11:08:20 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paul Aurich <paul@darkrain42.org> writes:

> On 2026-10-15 16:54:29 -0300, Paulo Alcantara wrote:
>>Thanks for the report.
>>
>>Paul Aurich <paul@darkrain42.org> writes:
>>
>>> In stable 6.12.y releases, a copy_file_range request exceeding 12 MiB on an
>>> encrypted SMB3 mount fails with EIO and a WARN_ON_ONCE() splat in
>>> SMB2_ioctl_init:
>>>
>>>      # cp /mnt/otters/13mib.bin /mnt/otters/output.bin
>>>      cp: error copying '/mnt/otters/13mib.bin' to '/mnt/otters/output.bin':
>>>      Input/output error
>>>
>>> Works in 6.12.110.  Fails in 6.12.111 through 6.12.113 (latest).  Via
>>> bisection, introduced by 8d103b285359 ("smb: client: batch SRV_COPYCHUNK
>>> entries to cut round trips").
>>
>>Does it work if you backport the other 3 missing commits?
>
> Yes.  With v6.12.113 + bc925c1216f0 + 9f544d26b15b + 90f7c100d2dd, 'cp' and 
> the Python reproducer work.  (Tested with both a 13 MiB file and a 250 MiB 
> file)

Thanks for testing it!

Greg,

Could you please backport the following to v6.12.y

	bc925c1216f0 ("smb: client: improve compound padding in encryption")
	9f544d26b15b ("smb: client: get rid of bounds check in SMB2_ioctl_init()")
	90f7c100d2dd ("smb: client: fix compound alignment with encryption")

Thanks.
