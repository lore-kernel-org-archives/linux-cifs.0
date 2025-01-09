Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28278A2D
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jan 2025 08:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736409775; cv=none; b=D3aLsQOn5ZV6pFLpUjIB65OGsopz4vE8lMZzk+DgddAFlNgGJOi1TFPZd5vty+PKRB7nToz9K7SbUNxQ6HF+ZrZNA5dnhTS8A06eknAlLEb7cxB3CYXV8BuPw+zuhHPvlnNa6p7c/7qnWa0FfrRuDtV30DrQavriAkDo0XP9Ktg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736409775; c=relaxed/simple;
	bh=svLg5B8tg9UE26Gu01oCNhx3CH6c/VVu4+WAlEcP9HI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YagCl0wQfK8NHbQ2GU4QaiWgLAT9GZgnI5P3Re5oO0MxtiHosYBULTWzzYlmbmlOaPN23gboAR/ecMVYRFEb8j7g8xAOKjKsij4NDiONf0OYqwGwK2/gMTmhGhj4n1+TwWs6/yZnt0tczccQpEhR6n31/JEA6xJUF1PZYmUTW+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5Am3jy5l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5Am3jy5l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JN1xZbT3ZGGlK9gxzji0O7DBQdiRxYV2mGUQn5HJg48=; b=5Am3jy5lVDacb3eKY1Xbv6Y1ka
	zlf760ICTd41Psu3XTULTk3kKxw9Ld70GzeqKYo2E5CX3gmrlTe802DqglY2WLQYnWjEeJ082IoMK
	gLcMI+ikoC2HN028Sehf/xtRzYmsFFHEPJ8fw0K9OygoQogU01TyrQLf4YQWK+pdCDkFLEhS8gVU/
	3UsZX7rdTnPNlng6067lmSU0BQs1TEaHjyt7l90SDGm+PQl2REeYRLetD4IudjTfkzlxuf4HtPJNg
	wg0m2nkPti8eRkHO+csekAt9huPuRM9C4mlfY9vGKu2YOhGq9ZXjMyXdvqVI3QYojF0cc2ZBX3JxD
	z7aa8+KQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVnVF-0000000B7x9-39mw;
	Thu, 09 Jan 2025 08:02:53 +0000
Date: Thu, 9 Jan 2025 00:02:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kangjing Huang <huangkangjing@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using
 ib_device_get_netdev()
Message-ID: <Z3-CrT64eQdPQIDu@infradead.org>
References: <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal>
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
 <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal>
 <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 07, 2025 at 10:51:19PM +0000, Kangjing Huang wrote:
> This is good to know. However, since the SMB protocol explicitly calls
> for enumeration of all network interfaces on the server host,
> including their RDMA capabilities, I believe this is a sensible
> exception to the layering rule. Or is there anyway else to do this
> enumeration from the kernel space?

No, it's not a sensible exception.  It's a massive data leak and a
completely idiotic protocol feasture Linux should not support.  If the
protocol requires a lsit of network interfaces, a Linux server should
require explicitly require that list to be configured and not expose
private information to the untrusted network.

