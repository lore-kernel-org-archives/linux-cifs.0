Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DC79460
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 01:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787880774; cv=none; b=rIgxHnOe0GASEku48Mu1zFeQIRwo8Jn3ikPMb9uQA9Ax4WBoGb5/fSs8Oh/9E7kk0NQMIp9a5HGNVDd2ou2HlyjP7xvq21K6K012dyBzOSnhGV+2ko70jL+y/jmZPIA296eO2iHL6cswWd8YWQH7WkJM7w9OsnlSbmaDt57+6nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787880774; c=relaxed/simple;
	bh=bCOICbDVrNUdl4hRNVUQCUHsOoe8uxys1cELPpJ0tak=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=LGSHaYHOvjQUa9oOr/UzpPvT206sfOc9dBgctuR3B08iJiHXKRJLSHdGVirzqdneo//+pUBlnmHf/Sz3iy/+yHfck/cEyZ/pNCf1AH4gHnupA4uifCVa6CmEHaKwGFA9B2kXdr3b1z7UVTnbDj4NEeBKOmHxmFS2p0HCz+cFqMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=pbLds/LC; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="pbLds/LC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OPa2/HmYKGq3nsUMJEaV3eeLrCUG/WWjd4aQa/rFcjw=; b=pbLds/LC4zXbdBb2K43nQ033dI
	gOaOGEeMlWIzt9n/z7IOb9m1zcSeho67seC57IRrRXKFFVNFqoBsjDV+oc06FAYq3NUvqZ+/gH4bp
	0Livp8hpXgXyvBQq0ZHXfiJx0oJpXiEf+C0KRg+4SkHzGL+jsQ+Lj/FxYljtHj7yvHCNnNkQ1OacF
	lDVXldgZ85+h6UCcqvzCB+axAsfhK02lo4TbBQlmh99s1IH/NnXWZmNQIiTCudcwrmemoD5u+dt9f
	Ikyl8x3kPxIuoXvM9RYymtkyJsDTOfXTI/os0sPVNB9ZzHchoVeBcFwDK78tsgCiJ5c8f4Qvh3O8p
	cfq+eXTg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzlSY-000000008zM-3jqg;
	Thu, 27 Aug 2026 22:32:46 -0300
Message-ID: <ede0c6a1da476063e793df66974e907f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: hehuiwen <huiwen.he@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3 4/7] smb/client: fix data corruption in emulated
 insert range
In-Reply-To: <c2b5c3cf-f961-4522-bb61-eb40deb87f6e@linux.dev>
References: <20260823151053.935889-1-huiwen.he@linux.dev>
 <20260823151053.935889-5-huiwen.he@linux.dev>
 <a228fb66678a69c7f85bfbf89f47b2ad@manguebit.org>
 <c2b5c3cf-f961-4522-bb61-eb40deb87f6e@linux.dev>
Date: Thu, 27 Aug 2026 22:32:46 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

hehuiwen <huiwen.he@linux.dev> writes:

> Windows Server 2022 handles overlapping same-file COPYCHUNK ranges
> internally, so the old forward copy does not cause corruption there.
> Samba and ksmbd do not handle such overlap safely.
>
> The generic/064 result is caused by the 4 KiB minimum added by this 
> patch.Samba reports a 1 KiB block size by default, so the test's
> finsert probe uses a range smaller than 4 KiB and gets -EINVAL,
> resulting in [not run].
>
> My Samba setup used "block size = 4096", so I did not see this locally.
>
> I will reconsider how to handle this and address it in v4.

Awesome!  Thanks for looking into it.
