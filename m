Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B5E346ADC;
	Tue, 28 Jul 2026 03:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785209928; cv=none; b=L4QzCZHCnKWSy/FodSlWa69KPVdELcDITn1v2pvUraexD6LtEBiC3p7S0yOsCvHFUu9mpQ4/t6YpYOM58o9ZN5KKiKFKEt6XJ4QtOrvxHvEqiJPnUIV2buN/GDhaOubWnoYveAj0tz/HBT+vV9vxyYyBD/0iVwm/Y8ZYO/IXHrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785209928; c=relaxed/simple;
	bh=XLX7xUN0STtbaswLUVy039LSW+Xs+KrNDznhT2Gm/LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pcq3YXGxMRdwjOHplPI+mYlWyEb+EyMCgOzgDx6NTGlUnR947juUIa7+M4rLvDHnjCxZqj8v/EaW7WhFeyZIdJjIkelAbFRI146E7d0+YFza+mWiAuqZuafub42LgLdwUK0hLMsTYVApyRCvyFlbSHkqj5VgzSp6TtEkPoWdl7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JSyKXuDG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JSyKXuDG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XLX7xUN0STtbaswLUVy039LSW+Xs+KrNDznhT2Gm/LE=; b=JSyKXuDGcCUSLsTgGBqRbciS0B
	kFVK09+sQqt+6WtkgyufXQ2tmGk1MQ7ZoKbJKHjWilgJMbgqwrhyrPUcL2J/Tj6r11a0Ute0gJEyH
	OQytpqMVZSd5g9xv3LMBWGDmEH8/E148VAQJQPRRq6+0NDkM3CjoBAMDjzGKuvgXRjSKYmygehdL7
	IlCaosfa0oJCRrflUp9sRcI5xE+cYrnYIKPK142uDz94+RCWHc/VBk8g0a4WAG/5Df1gqFCIzo7uB
	iTWFSGZ5leqG0pNbkHfF1HFf3hVhPVCyEpcO8zgwT+QOb91DoPHFwBWGXs3woGwzGNNWiQ0H+XByV
	U3bb11mA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYeQ-00000004Kt2-1JMg;
	Tue, 28 Jul 2026 03:38:42 +0000
Date: Mon, 27 Jul 2026 20:38:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, metze@samba.org, zlang@kernel.org,
	linux-cifs@vger.kernel.org, fstests@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v3 xfstests 0/2] generic: new test to check nlink
 returned by fstat()
Message-ID: <amgkQi1o99dX9meD@infradead.org>
References: <20260724031210.332153-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724031210.332153-1-chenxiaosong@chenxiaosong.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Still looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

