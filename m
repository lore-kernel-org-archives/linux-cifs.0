Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1721D61BC;
	Tue, 28 Jul 2026 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785209322; cv=none; b=lVACT3v+cq78lGaxumPW39BJIMWFn1ObDfqwyueF8gRfF3igs52hATmJjeJV/ma9MzThjTCDqDWhyCMWk0KQxzSec93qtrtojj1nhrHb2n83ZZDQdMBAHMU4pljqXvM1gtEb9qAYT5T3XGpUM11iRggyv6L00Q1mZ61DNg3wxIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785209322; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lgqsUmbA39ryBf1JPwdVCgaw3SxIqAlBv2CwW2FaYWZxz0SdegYrQxLGgam1BdoJ6j0UeCOTu5tcqo7Pgih3lNEP3UycEVOvSN+8Obmn5VEgvynb3xjdqVLBcgloz6WNYkbfY5js67yQ7PG7LxX6OOZo0bkcQnGKtsReJADOwFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=haJb8Wif; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="haJb8Wif"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=haJb8Wifbc4a6ZQFsdDarcGwLs
	PvSTdbwy2+ovrCgYUb/iAdHRqGzlDQBDwWt60jPG4tIFbt6wMBjnrPW993UIp9Gv4yDe2aH8xNhov
	cU9/Z80lJChGlYCynAF30NFQ30tpe7he8i/lsteMyKYA5Ms3IzmLDDB+3wadu0UZ50YsJiJbZ2jia
	YenNd/LDBVOgUYNA0OhhMgLXb5Ig0Smutfrjy1ENXI4+HAS720lFw8OMDcqLn7EorBJPAdbt4hr9A
	sUt3S6/16/x2zmYCr3JQO5R5Pbem8pzUQZahURg9WmKvQsMepjJeXmmxZsxRTfYtostpcUSfRoDC5
	mhjN/M4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYUb-00000004KLn-1HvR;
	Tue, 28 Jul 2026 03:28:33 +0000
Date: Mon, 27 Jul 2026 20:28:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, metze@samba.org, zlang@kernel.org,
	lukas@herbolt.com, linux-cifs@vger.kernel.org,
	fstests@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v2 xfstests resend 0/3] add generic/795
Message-ID: <amgh4bf-m25TSMSy@infradead.org>
References: <20260720164207.732522-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720164207.732522-1-chenxiaosong@chenxiaosong.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

