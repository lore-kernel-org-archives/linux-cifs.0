Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D11199D8
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 18:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762626368; cv=none; b=ZkyqzUSesc20UISu8BMuAp5dLJn2Ssf5yCFOAe9Ida4m7NnE/DbfkwU4vWnp5Kn0VLib1TyYGp4bWUxHCas2+0MXxIu716JyHLWMoGQB4ZJulPY/1Pzv2UOZin2Bdptlywg+oDWu6r1bQduCaTmc9NTsZgn1BXeF4/Qq8M7IkiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762626368; c=relaxed/simple;
	bh=3PuqQZnrVolbPPF+5k8cNRZuvPBkP3W5oJbsN/qLIx4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=QLDEtsCas0JNW6yMCt+nYVArKiZ0Fxx2gUk9tOe3BpHMx/M1fRZ6BQCB0Jeu//uGG4t9/vzYt9uv4w+xSVLXd4MAAhO0kQqXaYCD6OMXKc5MkQHpy1GAXWUU3kbbroeyiFyH4CnK6czB6GSrSu3zdun84jeToz8xyuhyDMcLo78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=jk2/Nx7A; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="jk2/Nx7A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3PuqQZnrVolbPPF+5k8cNRZuvPBkP3W5oJbsN/qLIx4=; b=jk2/Nx7AjKGdHC7Kn6EZnqFOkG
	KTcGm+DtZInf5iEcRsis441DszjdIBz/H7zssjkvEY0zLzuf8PoZs/1YeMntVTSwJPq/F4tAs8O99
	sHYw+WIQIQDOQ9aBWKJA9nQozfXRIgmFMsKuW19vgP6zyYh2G7BsAxUnRIe7WixnVnUQlfWLAjYLz
	Bsvm0IZte/M07tSnYhuSQoRn8ZesC/3qz6iPPt/E/uMey8PnrCL+b016K3qtlZlsQltzOhPRh34U5
	e3HH0iIxfqaeTWyT06aAi8iskdhny2Q6AAB5RxcjH4e2KtIEtvcFwLKP1hqJbjUwgnzM+Msn6aL9S
	m9NvSHUA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vHndJ-000000000V8-0RHU;
	Sat, 08 Nov 2025 15:25:53 -0300
Message-ID: <926cdc492899f9626612d5d881c34317@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Henrique Carvalho <henrique.carvalho@suse.com>, Steve French
 <smfrench@gmail.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath S M
 <bharathsm@microsoft.com>, Enzo Matsumiya <ematsumiya@suse.de>, Jay Shin
 <jaeshin@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v4] smb: client: fix potential UAF in
 smb2_close_cached_fid()
In-Reply-To: <7eba7884-3b54-4711-b5b3-5d82e1981acb@suse.com>
References: <baf7ee5f-aa34-41f3-a00c-8e3b7686d566@suse.com>
 <7eba7884-3b54-4711-b5b3-5d82e1981acb@suse.com>
Date: Sat, 08 Nov 2025 15:25:52 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> Resending to include linux-cifs@vger.kernel.org.
>
> Since there were concerns about a potential deadlock in this path (from Enzo
> and copilot), I reworked the patch a bit.
>
> In theory the existing code is fine as long as the refcount invariant holds,
> but we've already been proven wrong in this area a few times. So I'd rather
> make the deadlock impossible and WARN if the invariant is violated
> instead of
> relying on it being perfect.
>
> @Paulo, what do you think about this?

Sounds good.
