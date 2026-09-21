Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511314C4F79;
	Mon, 21 Sep 2026 16:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009309; cv=none; b=n38eeL6amy4omSJVnaOx9DVLtuFQcf9KlPt/eXzzmquZ5sRCKyF2CRQVHnKQKPv9KprTpFI5y7jUISfRu0i00zF6W+/Ff82+4RuwmvUi4fzZyjrYmEe0h09NhFS/Ps7JNMq6v/qNlL7LLQ8yyvMRMsxPYND43EEI0aKOl6n3jGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009309; c=relaxed/simple;
	bh=Ckar6c2jphMV2u1ijs4ljVmCmMJWzR0KP3P8wBSkQ9M=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=txbupGhXEu+2PSSKapAEzsn39y/5Ei30wRDsy7hzMI9pEZ/TgvQrBWTTDm2uCMK7r9dIb5qbKLCVWQjG8lfquKhYF4s8YxMV0XBCjX+R+9HxXQVkJfxUBUsSuhMTKQDOPeZBNSAywzIQA2ta6L1oXINhO8Zjvez4ZcY8h11wyM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=bRr3hMex; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="bRr3hMex"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GvU6dxNGy7KWFeIFvxSEJIFe9lA3O138bl4GFsvtCig=; b=bRr3hMexSjTGkZBHZ+SER6CHdl
	4ztSOKTgDyNUfy5bVaZar1lPBva8TIPbEGrXn/98R8gTjuuXH1XiHqpnA2IEVVxvaAOjKJDsdM7Wc
	EDLDUNkopAUTF0vqKzuEXXUNeYjtG4A9r3JGEqpp1wCxAZQXhvud+m1Kh0sjEmz2RWJh2lV31sLoo
	vnOxtTpaaWHBf8b2+eT2zD1385x2k+S54i3McA+++m4+h/2tyOc+kPAr/XmaQWxyjkosg5uFAcVU9
	lVCNdRXFGqmfGcEbZAzxZoVLUOGIkpnzHym8IojiVTYz4xW1VH6NxSoWoIVclMaylLNjZGjGnXvPA
	p+BtQPpQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8hBq-00000001wQv-1e9d;
	Mon, 21 Sep 2026 13:48:26 -0300
Message-ID: <6e4432d117a597ae07c295c30164364a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org, netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>, Christian Brauner
 <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 2/5] smb: client: discard post-EOF pagecache when
 extending a file via truncate
In-Reply-To: <20260921154957.903891-2-pc@manguebit.org>
References: <20260921154957.903891-1-pc@manguebit.org>
 <20260921154957.903891-2-pc@manguebit.org>
Date: Mon, 21 Sep 2026 13:48:26 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> cifs_setsize() relied on pagecache_isize_extended() to zero the tail of
> the folio straddling the old EOF, but that helper is a no-op on CIFS
> (i_blkbits is 14), so data dirtied past EOF through an mmap survived and
> became visible once the file was extended.
>
> Drop that call and lower the truncate_pagecache() boundary to the smaller
> of the old and new sizes, which is block-size independent and reliably
> discards the pagecache beyond the old EOF.
> ...

I'll address Sashiko's comments [1] for this patch and 1/5.  Please
ignore the whole series for now.

[1] https://sashiko.dev/#/patchset/20260921154957.903891-1-pc%40manguebit.org
