Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822F23CC303;
	Fri, 26 Jun 2026 05:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782453067; cv=none; b=OcopUH6YDcZ66ZlmIRQL5y2erl4a0gMY/be+HxxwwjCMHPsdKGTzPqepUwsnfpeK/YfIeckljqny3e2kEa0qWHxFwzOV+sJNwKZTf+XsEolqVEE+3s/YhoxHUnpOaVSeqYU4wk9OZoXw2UIm8Z/+VofDAiml6O8AESpO/f4RwqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782453067; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRwJkRxBhbefoOQSEBnl+Oqyx8ieWPW/H3j2ep+zn2NefoM0bjyKFjx2D+bB3Ab/AjrSK5WaKePhEtdQMrEW7NiXGW7BEjBfs+T1wJtPpI5UfwPw03owNRWQsBEkzS6p3N+s30yRNshRs1cINY6MtP++yH4vmyNx//ttLdQ/0sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i1AoA+IM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i1AoA+IM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=i1AoA+IMNrMu0C/F7leiRoxl3P
	BZF790ftGvUaXNrOigMhWqT6GpDKG8Hdc4AT8M7AuiM+CNKrmjb9RflJ2L9KKoUT39TJEJ/d+bqjG
	OBBaXet14GhMp5A0jxzBtunvUQwLyGhUJoKl3UMmtja4LpBjO12MsNwT5GjxwLjhTeM3KkoaDKmnY
	o6UZzYp6tt4+GPojudFPj5CBLXgHZu4AiC6SL6KZD248HzCHfwxRM9rRaUoozLsWS+1qK15M4Mwy/
	BENSsLTAdnJOJu2YyDdUrq+qIkbd4kWUQ21gx5NOhPoXg5SpOnzoQG7UsJ8J5zxsO96sNCPNdzRQV
	Lx1e22ng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wczSu-0000000AY51-3Fhn;
	Fri, 26 Jun 2026 05:51:00 +0000
Date: Thu, 25 Jun 2026 22:51:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 08/15] iov_iter: Remove unused variable in
 kunit_iov_iter.c
Message-ID: <aj4TRGHmTFbBhcny@infradead.org>
References: <20260625140640.3116900-1-dhowells@redhat.com>
 <20260625140640.3116900-9-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625140640.3116900-9-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

