Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9A13C0B
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2025 07:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736925463; cv=none; b=Taf571FdTTapV56/isDcC4Sd5sQFPDa3WWBycez0yUc0LwyO5o0OLQg0tnYoNGG3bc7DKQTbwr7+RmGwjN5l4kazf+qisV08ImJl+/7vPFtTXpDhr7ynun5CHotsLNeLpji6jd5KgwytBtb4gxmWHXKK6B9uI5nk7Y3Q0jie5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736925463; c=relaxed/simple;
	bh=dciaPnc75qrbqmz1fjdrVhM4M2lf7i5+WUIFe/M6AMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOrlRSeIVcIjp2ksBZcyC7bf4YgdWSoAn63w8qH15bgvESUrSvfDPT5wHE7/xLPgCXQ6HdFvRGRt+ZN7PbXqA4x8ys1h5rWlVwDmPKA+kX1KiYmOAMjD+2boRGk/QfA0BdXcIsiCiCGHG6cLw7+ThFuoQXk7mu1d8RDqzIzxE54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Zly25/wR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zly25/wR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BPJbyC4gorZRdIvMMHiZpU9IkVUm2otEpeCoOO0oFHg=; b=Zly25/wRq4Nh4vcOIsC5BpkuEq
	SZm2cbt++sos5/pVFzKs3WKtVDLjh+663hcR+vq10OdPhEo6JVcqMvdIg/l9eBRwfajP1H6Pa53k8
	/ISD6suSt0S8EyJmR5YyOCmJxSFy7x2VpirWZyqm595Zm2ilDaYsntw3mBoDWoXig9ioHJW5LKxD3
	+ugehYfrWb1mBQMmUvxOs6p6BkDrd2zrkUaULH9YnF8wAlCq0xoW+bgTa6zU3hCrL6cFnpXlXLz5A
	onFnwg8HvOEQ3xbS42GzHxW/TpGDydDIvj0ohcVsxPJT4Ae8Dn4pXBvrw0FCM+achtworm6M3urhg
	+/MsEljA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tXxen-0000000AvCv-1vi6;
	Wed, 15 Jan 2025 07:17:41 +0000
Date: Tue, 14 Jan 2025 23:17:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tom Talpey <tom@talpey.com>
Cc: Kangjing Huang <huangkangjing@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using
 ib_device_get_netdev()
Message-ID: <Z4dhFaNYkf5ooM9r@infradead.org>
References: <20241108175906.GB189042@unreal>
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
 <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal>
 <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
 <Z3-CrT64eQdPQIDu@infradead.org>
 <CAPbmFQawOrGmgYrg8z73E4hCiE3JAw7e1SGS0BApbQCfv90xzA@mail.gmail.com>
 <b2936a7b-770a-4806-8bde-9f0742600679@talpey.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2936a7b-770a-4806-8bde-9f0742600679@talpey.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 09, 2025 at 12:49:16PM -0500, Tom Talpey wrote:
> Absolutely. Windows has a number of filters on both sides to decide
> which interfaces to advertise (server) and which to actually connect
> to (client). For example, back-end cluster interfaces are never
> exposed via QUERY_NETWORK_INTERFACES.
> 
> The ksmbd.conf file already has the "interfaces=" stanza, perhaps
> you/we should simply consider using that list as the base. This
> effectively would force the "bind interfaces only" flag to true
> for RDMA adapters however. Making system-specific lists like these
> explicitly opt-in is rarely popular.

Filter still seems like the wrong approach vs an explicitly configured
list.  That's what for example nvme over fabrics does for discovery.

