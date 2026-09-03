Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5FC4D90A1;
	Thu,  3 Sep 2026 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449103; cv=none; b=h8/BfSifWzoFwXN60i8abq7//7SxytsvBmxfhn2J/vkebAOiskFX9Qp4IC4thk38Wodb6INWdoS7SsKf+TLep4cJt2di4rPZpFUUVhFLN3tgUItvd9U2eHsC4BwJWV036rFIVQ/21XXlhKSkw5jsakIq8jLJaCWl+yfNFENTqrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449103; c=relaxed/simple;
	bh=NyGRGuF29kh00jfQ2fPtYHGG5EzkxZsLU4p5OGSPGbw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=s7TfJ03tZIxKj8FJrgimdoLb9V45uJLmZzm7EOPDFfDEG8ilNoYGwKYQXcKnftSlgyszN1LEstYCL/BpLfJpDSLrQ2cNeJlYtop5yUdqYdlqqKELmqIhG5DLcwz559Hzb66XYNZcdINlKS3qb7jmcCHVVZOxTM7S1n1FxjBR3kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=iVnNLjXy; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="iVnNLjXy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gdD8YZUJOHzVP6iYQpDhL1RKn07IE/n9VzVU+dGrWlk=; b=iVnNLjXyD97SfJLtrL0mmTIePY
	zeftMWP3VCg5REpIYs1JsSZvYViat2bVVEJh4iJVkTUgDFlNJynU6R7Oj3235HXwn8CDYLvH5Z55r
	XZupoDkKo2v/dGjy05g2sKUfY6bvogowSML2Vb42cIiVXr+w646oFg/jjTMUN9+o9dsCcdcK6wDGU
	h8bKCI9FVBapfQZo4tjgkmae21HNc5j1zy/RETj0M6XAp9CHU/cWvBX5abUPGheeZU5Uzu7ED3qr8
	MeGWfwN6EZ+itq9DRyNyen7+eb3vibl7k9bV4ms+1NbtBSzCOKQBXebcyVQn0e3XFBS4GIlcwoPKu
	RXqEa6FQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x29JD-00000000cDh-2t6P;
	Thu, 03 Sep 2026 12:24:59 -0300
Message-ID: <9aa7600f65742727d7588941599394c3@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Karl Mehltretter <kmehltretter@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: pin DFS superblock in iterator callback
In-Reply-To: <20260902182814.25700-1-kmehltretter@gmail.com>
References: <20260902182814.25700-1-kmehltretter@gmail.com>
Date: Thu, 03 Sep 2026 12:24:59 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Karl Mehltretter <kmehltretter@gmail.com> writes:

> tcon_super_cb() stores a raw superblock pointer, but __cifs_get_super()
> takes its active reference only after iterate_supers_type() has dropped
> s_umount and its passive reference. Concurrent DFS automount expiry can
> therefore free the superblock before cifs_sb_active() uses it.
>
> A deterministic KASAN test reproduces the race as:
>
>   BUG: KASAN: slab-use-after-free in cifs_sb_active+0x77/0x80
>
> The same test passes with this change applied.
>
> Take the active reference in the callback while iterate_supers_type()
> still holds s_umount shared. cifs_put_tcp_super() remains the matching
> release.
> ...

Applied.
