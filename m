Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398221DA55
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757614666; cv=none; b=pFKbnftRbhke9zPiVv8WeiUQdNgoNER9+4PKrwIdy2JjjTQJ6ufEnDFDY1qkVCLFcBTgtzS5/gtT/6xYImAqelAHYCEijRk+UKrsZP0SvgGGeWKckq8gmx5Q6F/PR08ivRAR4oo2JfH59jE390WiUW7TRvmKcHtssWPcqWxPuzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757614666; c=relaxed/simple;
	bh=YYz8tWbLOemzDoqau8FtWsPcBZJizFNlWXNUYaKCidY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnkL7Fd9Ow9x2Dz4EexuCyjA8Wu24nUK0EhKh2gEp2UojkW1Z98AJDQV+c9woizvU5wdOq9namHU62WcZ9bLJSMnFIZhG2omH4u+bKHUrxhgYUqtHzrqPB0PtNyFFYkjvfnQ7egu5OXi8T9Prl2tmdPgWK07VksUBC9DDliBi38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ADPKr9UR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ADPKr9UR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WFUCNCHe+0otnnl9WC8jbDApQRqhgsqIqvfkYyj6Vek=; b=ADPKr9URaaRaESn89LiXR/cWpP
	Gt0M7rdMfL/ggm/57JdYMbFg2lLII6JKFnx5+nT0csgyti4Fg8la9bOEklyDagn+2MZ0Ter8tXOmw
	bsTGd7FgrF8AF5vD5HubfKn48PXVj0C6Auv85BF+5+4SPqrQSdcvYYxX3wwfoWMYjouqtHX+/xH2f
	vgGlndErUzB8bqPN3rOBWB7jYP2k3KdWqPN3778gem7xmWErGmcpVyI9aaOxcig5xwrK5QbUyW2SA
	DPZ6NkSOiG5Ji2zx8cc6vK+8FYoVSWtg/TB7WVQEyyC+QLz1d1N34pXBFrl2RcfnHrFjz0rfM8Dkh
	8HUusGYw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwlrK-0000000Fm9W-1UIm;
	Thu, 11 Sep 2025 18:17:26 +0000
Date: Thu, 11 Sep 2025 19:17:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: yangerkun <yangerkun@huawei.com>, sfrench@samba.org,
	gregkh@linuxfoundation.org, pc@manguebit.com, lsahlber@redhat.com,
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, stable@kernel.org,
	nspmangalore@gmail.com, ematsumiya@suse.de,
	yangerkun@huaweicloud.com
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
Message-ID: <aMMSNnJA6VknuVMB@casper.infradead.org>
References: <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
 <20250911030120.1076413-1-yangerkun@huawei.com>
 <1955609.1757607906@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1955609.1757607906@warthog.procyon.org.uk>

On Thu, Sep 11, 2025 at 05:25:06PM +0100, David Howells wrote:
> yangerkun <yangerkun@huawei.com> wrote:
> 
> > >     	if (folio->mapping != mapping ||
> > >   	    !folio_test_dirty(folio)) {
> > >   		start += folio_size(folio);
> > > +		folio_put(folio);
> > >   		folio_unlock(folio);
> > >   		goto search_again;
> 
> I wonder if the put should be prior to the unlock.  It probably doesn't matter
> as we keep control of the folio until both have happened.

Well, folio->mapping != mapping is the condition for 'this folio has
been truncated', so this folio_put() may well be the last one.  I'd
put it after the folio_unlock() for safety.
> 
