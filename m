Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1921E36EAAC;
	Wed,  9 Sep 2026 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788974120; cv=none; b=hbQO+N0jH4FcRa+AY32a6a6SwyofXlIaoeW2s9XMiMOoqkbn8APWghUCp/7TwQjr39jwPu1CvAAeJ6nGHmvNWWOvbRG5svnQPVzjtI4bruAp1ntaBnEtGRkKFBXS62NUVapwmaKcY/M3ZyHyxh3N0Z0iBn7fVYs78xffWiv6TN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788974120; c=relaxed/simple;
	bh=qaB8n/2tB9PayzHYwghB8f7/R2ZA90wu80TMmFuzgu8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NvwuHjrQrCHpLuKM49v106MEknhRuqUlA77o2dReAx3VcOTkHs98NyFsCpFEApwZ34z9TUAEwE+G6eiAaa6bo7LnrFeZNrbV/L5saqaDeraXCURI8Yim6GFiOYGsHzyrtBZk9+4+3VPoSDqyMrpEj1JwPr5hn/kpWPeMFl0a0zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=aY7uk/pP; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="aY7uk/pP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JXEySazt3f1vkqM2P+npsV9sxhLigvHk2NE8j0svovM=; b=aY7uk/pPpxpwF/tXX1SjCQ4CDm
	BskVJm5/BlnYUS05jlRw+4CNIOC0WHVXg0b4tCBDtn0yD3kVynZ6G4UPbsUwmZwQTWjFiF1IogI8K
	tCoyYgOLe6SwASynrWGypN+Jshk0V9ETgnVRC89587jC9xZMnN1nKl90mmVb/SdZXxA1nuusdIp0p
	rCp/PzzZY0P9pQAUwqsKM+ax878m8vnz00e7UPSws4qSVWpGF21at0fBzwwXm+U5x727Atkoq/Hxm
	4AHZ40NdfbuvdWtx/FauiMQXdxoalYVb1/rlvXjX2gLOsJ7TlJFfsafbzv9+mc4A87y7WsEUkeczY
	gzKweyow==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x4LtC-00000001370-2h1Z;
	Wed, 09 Sep 2026 14:15:14 -0300
Message-ID: <c7ed5817f3eb7d7b2b6430f47638193e@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bjoern Doebel <doebel@amazon.de>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, pc@manguebit.com, stable@vger.kernel.org, Bjoern
 Doebel <doebel@amazon.de>
Subject: Re: [PATCH v3 0/2] smb: client: fix DACL rewrite overflows
In-Reply-To: <20260908161001.2603610-1-doebel@amazon.de>
References: <20260904125844.1803343-1-doebel@amazon.de>
 <20260908161001.2603610-1-doebel@amazon.de>
Date: Wed, 09 Sep 2026 14:15:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bjoern Doebel <doebel@amazon.de> writes:

> Two overflow fixes in the CIFS DACL owner/group rewrite path:
>
> 1. Patch 1 fixes a heap overflow when copying ACEs whose total size
>    exceeds what kmalloc() allocated. The allocation used the old
>    (pre-rewrite) ACE count, but the copy loop iterated over the new
>    count.
>
> 2. Patch 2 fixes a u16 accumulator overflow in the size calculation
>    that could wrap around for DACLs with 800+ ACEs, causing the
>    check in patch 1 to pass despite the actual size exceeding 64KB.
>    Returns -EOVERFLOW when this would occur.
> ...

Applied.
