Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7894B3AA9CA;
	Thu, 27 Aug 2026 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787871571; cv=none; b=ZfnAiUEXDSiEeWbfhKEnuTYAjzpjfxqhxdzyUFeKGzUMNrRgAAvGTkJjmgqDemTrfIOLLofF3uD001AeJG6u6e2KAWVtRpSUzbu12aShyaW2WHAq1WhhgnXxEdc5d3ZswlPmQLT48jMRa8GzamPK/IkQ85tTanG96kWqnltV7Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787871571; c=relaxed/simple;
	bh=Bbt9HxWbrJ1lCK2u8DaGS18B13vieZ80j1irQqCa1O4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=t5mxGxR2dyo2ZBl+jpPbFhxgT7ku2oPD483h8GvItJkuPKIzz0fVtOmy9MWnzZ2hTaVmXGOuN+KiiyW181W7Rr3fexKWg8rb5BGD9a1/YPgWQ4vuG+Jo1I5eLVu817KyVUZVQYnA1YphOiX10QsXQWdLN/W7GKY55nrJW+KyBEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=E5GlpDs6; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="E5GlpDs6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bbt9HxWbrJ1lCK2u8DaGS18B13vieZ80j1irQqCa1O4=; b=E5GlpDs6/A0/TwUajXhAmAp6n+
	uU46VnkzLb1SvtK4+noQD1KQLoHNGiwqGmi7rQIH5ij1CsS5ggOddcCV2Pl1FU8v1rF6yq0cHok2n
	M0LuojzjtkB7GEe9VLfUUF43OTtudCmS/Juv+TB8eed6bFT7qN5rxU10I+aeT0IYf9Trrttb5gA5I
	7YYCFclqrDYAg/Z64K5lWOyYDyXV3/WO3wIzIavQvoF6boOE6Sg8yYbL+ZntG3nMHxGu/JOqbTBxX
	/HOiePNUqWrWhDU/SM825XIw0ApewzSLXS19mKympqHW0Tg3uVAV43JKZA5erKaAV++mRdjhMACtB
	lR3WPWOg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzj3z-000000008a3-3UGq;
	Thu, 27 Aug 2026 19:59:15 -0300
Message-ID: <e789bd4431e38ad9b76ab49a841fbfc3@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Christian Brauner
 <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>, netfs@lists.linux.dev,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/10] netfs, cachefiles: Miscellaneous fixes
In-Reply-To: <20260827134304.2075713-1-dhowells@redhat.com>
References: <20260827134304.2075713-1-dhowells@redhat.com>
Date: Thu, 27 Aug 2026 19:59:15 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Looks good.

Acked-by: Paulo Alcantara <pc@manguebit.org>
