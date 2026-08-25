Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678B237F326
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787667018; cv=none; b=l8XDy0isH1WhWG1emjhcoE7x8TVzdWN6JGa2nWeFTop+zimupIfv6i5yUSssOGBtyyd3K+KbLm5dV2bjgHeEA1u5faSqBxenc5/HUpTdRH7WNnsITK7qcFRYWpl9TRzMaUtV1nUaTPTXsUkh05JAfBdeON5nfk1eNykYP4VJk8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787667018; c=relaxed/simple;
	bh=0Y1f1yiKgifTZS0ucZW96p5tF+I3JV/JHXqZjaIcvto=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=AST16UVS7IzkanTNDLzJNFMaJB9e4Ci6NK7LRKaSy5nQ9CXLfpG+ts9F5mdM2zxiQvbNWjH5swnljRGhqoz/m5hLIaZn0XEBlJ8vYIBEqzoBnNO7nV7K4m2v2kcWG0ouTz63zWQwNazWie8W14alATiYilK691cpxUGVcOMAz4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=7eN35CpC; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="7eN35CpC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7ylhns7FI/CIBmrkSH4oe/CWVkLKr55WN2p/BiRIKgA=; b=7eN35CpCn+UZSbuIK94OQ8jWCM
	x6BjPi8iPJEIuq78dGS6HrOd0c1Qk1oIBbMND8JiQ7lPHWnxQOlrYjEzysVJZMS+tJsGXXKIcWPrm
	O1FIvIrjpzkjJWqmAOmI8/WLh0fiR3bQKU/aC9x+RBgVXqGV9GcjPqiphoWgw5/QBycd2frgI7on8
	+nSsQB5aWuHW9mCgDbvW82Dw1bm9/stFNphWKkq65LpEjQT1i8/bXw9xMjZtZXohECkqY7Aabik00
	GK0fqABehnNEXVVrS+tBg6LfU1gertnrlbvBrTieZybYgFr2N6Vus297WOw2RnkcV/tm9l9KQtvTY
	hUvFBccA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wyrqq-00000000e8Z-1dHY;
	Tue, 25 Aug 2026 11:10:08 -0300
Message-ID: <a542067cb9bf6bd0578292ff017efd05@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Pierguido Lambri <plambri@redhat.com>, Frank Sorenson
 <sorenson@redhat.com>, Steve French <stfrench@microsoft.com>, Samuel
 Cabrero <scabrero@suse.com>, linux-cifs@vger.kernel.org, Stefan Metzmacher
 <metze@samba.org>
Subject: Re: [PATCH] cifs.upcall: fix krb5 regression with --trust-dns
In-Reply-To: <20260818191917.434889-1-pc@manguebit.org>
References: <20260818191917.434889-1-pc@manguebit.org>
Date: Tue, 25 Aug 2026 11:10:08 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> Customer reported randomly failed krb5 authentications against certain
> servers when using --trust-dns parameter.  Turned out that the client
> failed to establish sessions against those servers when using
> CIFS/KRB5_NT_SRV_HST service principals.
>
> Restore old behavior of always trying cifs/KRB5_NT_UNKNOWN service
> principal first when using --trust-dns parameter.
> ...

Applied to #for-next.
