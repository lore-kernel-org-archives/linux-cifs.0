Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3A3396B8C;
	Fri, 28 Aug 2026 23:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787958663; cv=none; b=aqjNyHENaT72GR9L40Xz0zpTZbTPQ+BMlLA9IuwuLHc3b6g76Vx1O5BFgs6p4T9UFqsDKuq8moABOo3KC4gSXYVYQYESPeE53x/lvb1NbdZqt2xmpcIQB2yTa+clPXJYkZe4tqVtebGC6jo2/ZEybnZMbcmp3oMs57kgik/Lr4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787958663; c=relaxed/simple;
	bh=i/OHBM4lAjVh263PMpyHhngwq9F1GgbFCw7P7SopbFg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=enXqDtxlqvzNARWM+C4pMflfskMCtuhejWkp+lbZIpiI1iadbtXwxoQqda/NJsuGCH/Xsme3w+u9n5ZI7Y5WD8wo6r06LwTPPWC341xT9DXG/Kczv+MYfET6PMki4Y7wE4R/41XZnVTWJ61EUs+3cKo94Z0Z5+5F6CI/ngBTyhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=5sLzWqKc; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="5sLzWqKc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CKYG8glDfP9v+8wmhv+Y/Tb5gVd1pW5HMJCOFmbq68E=; b=5sLzWqKcMTId/rm9Q2fadOdH+O
	f4h+/ZFtVpdTeRo4kA1PlE8AoyIs3rLY3JsdQz5+c/Zo8fPoso6976swE0m4ClMq0v8RXOT5lci2I
	PbEFdaht5qzKKAVUqrO0YSPPgWIEYRi7LFqWOoI3PwzGA2wOraqfrOyA67h8Foxc7lkt92sOVTq0d
	2JrSipndB3hxii2JheAzOJZ3clHqQyDrzqCznleZSV9Ho/mTQqBp7x5Zh+p7JsEvS+wbJKjBRn930
	cc+YWpmU612F8RMZNU+ZAJHy2thI3SeSMLB/1AVtvo1Dnh0ksOc0ikjADZyaoCMgl7F3R4GMdmTms
	NjW2mGkQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x05im-00000000CN7-1cB1;
	Fri, 28 Aug 2026 20:10:52 -0300
Message-ID: <553e932a490242f297ef212b1e6ddcdb@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5] cifs: don't update i_size in cifs_do_truncate
 without a cached handle
In-Reply-To: <20260827015738.79123-1-sorenson@redhat.com>
References: <c5ae6c999664ec603d3ca6aa8a226439d89eed48@manguebit.org>
 <20260827015738.79123-1-sorenson@redhat.com>
Date: Fri, 28 Aug 2026 20:10:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> If find_writable_file() returns null, cifs_file_flush will return
> 0 without issuing set_file_size, and the outer 'if (!rc)' block
> will set i_size to 0 before telling the server to truncate.  If
> the cifs_open() then fails, the inode will have size 0, while
> the server file is unchanged.
>
> Move the netfs_resize_file() and cifs_setsize() into the 'if
> (cfile)', so they only run after a successful set_file_size.
>
> In the no-handle else branch, evict stale pages with
> truncate_inode_pages before the O_TRUNC open to dispose of old
> cache pages, and let the open response set the i_size.
> ...

Applied.
