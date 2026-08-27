Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D044379C22;
	Thu, 27 Aug 2026 02:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787797350; cv=none; b=SbI8yy4Fd6OWCJ1nEjJ/zmfL84aQJ4YK/rKo0t5h2v5X/RSZ4Xc0fBf4P1XLYIkMMAZA1XiU+0utxfVjJoNSwlzNut1XrkpVV7fzTOUN+Re7m4JDJQcuYTVOOJCc5Ii4YSPljdAyOfaE6pLWzoe2fIjq402jL05AANB4hPpIyqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787797350; c=relaxed/simple;
	bh=n46nLhzeNHaVzGnSpQ0O/BbCtM+5OHKtjp1dOYVhBug=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=K2lOBDNm65paEqJiDQ6d9aKPy7FUgstD0/ffugaUVBWVU5W2Wy6b3F1nlErFko93oZwzeZYxq40xYMcEvzP7m4sDGfQixFPmXIcStR02DvxuL3fUEa6Gn+VoEHTpQrL24Ez+/519dTUYx43sovuLimLGffXNHdq/55WK8tBimQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=6TZOt7tw; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="6TZOt7tw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n46nLhzeNHaVzGnSpQ0O/BbCtM+5OHKtjp1dOYVhBug=; b=6TZOt7twnd4Vbhu5rt17EGY4Vh
	9yTZgkszFkM4p3KoirBfICHkwY4IJDYwtmxlXqiKqui+xaKsA5diCN+nUk1a2BDkkR17UMSNVstSM
	eNRNXTRfZTl/HEMQrexdUVy6VMrvAXZpjDXb3cWk+Ss2df21ENFuXqY9HhCGXz+zTgycvrA19vvZs
	6mFgDQyQcVLOxx7jFKfq8iWUOYw2WUyaF8RnYZ2ySPbtbKoOr5rxUbwWN/Jth1jiIvWESrKad7yhk
	SrvpXT3l+MzQi13dkGpIH2aCoAcy3opvxrxlzHMxnjV9dKC/0gMOT7QNAtwNHbi+r2K4SdxDTnapt
	dP0w+cPg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPl3-000000004jv-27gS;
	Wed, 26 Aug 2026 23:22:25 -0300
Message-ID: <3b76251fb75c681910acb36fea7075db@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Steve French
 <stfrench@microsoft.com>, David Howells <dhowells@redhat.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 1/1] smb: client: transport: Fix debug printing in
 __release_mid()
In-Reply-To: <20260825083043.4037868-1-andriy.shevchenko@linux.intel.com>
References: <20260825083043.4037868-1-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Aug 2026 23:22:25 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> Long time ago during upgrading printk():s to the respective pr_<level>()
> calls one misconversion happened and nobody has noticed that. So,
> previously printk(KERN_DEBUG) + printk() worked as one long debug print
> since the trailing '\n' is only present in the followup printk() format
> string. The culprit change missed that and split the message to two on
> the different levels. Restore the original behaviour to make users be
> less confused in the most likely never happen cases of partially getting
> that message.
> ...

Applied.
