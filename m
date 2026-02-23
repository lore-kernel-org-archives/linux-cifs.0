Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4279937881C
	for <linux-cifs@vger.kernel.org>; Mon, 23 Feb 2026 21:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771881101; cv=none; b=Z2A0cPKu4rzYgTK92BF1Y990daIw/sPseYvAXe87Rd1yxErojuQrIuanHb/J3E8gXSkPNQq7RZSW4e+FeSZpmEa2qeZZfMC9vsaxhsikNW1K3n4/5krav5k7VmFw0vTviwvEeRxC1g3XwFhkAhAQ0XejliBwtCM/Cvx4kMO2ziQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771881101; c=relaxed/simple;
	bh=JGQ3fSO1WHuuw4xmkDzFAQnaYdLo7HDvhAjKWxtM8TA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=U2H4NFAKYNyrRNjyPJeKcqrLDJdBKY3Cvj1Ucxljer8OJzE6kAD0+37lnPHZYo2v+XRFB+ywo3z/aW/E+WVOV1laa3aNxMoGJ0U6hPf+wixsjHsIURI70h4M0BopvpL4lsTFC97w/I9drE2PMdEQA01osvj356oHwwXrh6nm4us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=A5B8OhZt; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="A5B8OhZt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nING/EBX3FGup9lRecZmmtiuOAkijwAQDBUItI7JuYc=; b=A5B8OhZtxjwrT5G99xnQXFtGnj
	kkGhK0tUoAltL+p5PLf92hjYUmReQ04I16DqhMkHZXfmPzHA9/FrmVVhlt3/jbGwAGrhwU1evUdiD
	VEMUKeO4hO3gJ1+3+8lAbhoMDfsV5b+Rh/iQm4DCThIlJpK7KAlDgdN60NKKJ6zyVhAwITacZ1Exm
	S+Ff8F+v7Zm7kl9UvHGPcH2Wr7emCofqnGWNZBCD+XqzfCkA3l2lvsIPVLCUDL/yTg1F8V9eFSJ40
	9AMhkMj2jM6aOxMUs9z9IaeJyQtw9RDZ4lnQVl2pTHANHRJAd0o1kV1BndEM5O9GTxKFW47cnuKHP
	bxIwQRDg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vudDD-00000000e6h-3Waw;
	Mon, 23 Feb 2026 18:11:27 -0300
Message-ID: <830a3b8b209e9e276da7ad9398f8711b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: chenxiaosong.chenxiaosong@linux.dev, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, geert@linux-m68k.org
Cc: linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] smb/client: make SMB2 maperror KUnit tests a separate
 module
In-Reply-To: <20260221080712.491144-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260221080712.491144-1-chenxiaosong.chenxiaosong@linux.dev>
Date: Mon, 23 Feb 2026 18:11:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

chenxiaosong.chenxiaosong@linux.dev writes:

> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Build the SMB2 maperror KUnit tests as `smb2maperror_test.ko`.
>
> Link: https://lore.kernel.org/linux-cifs/20260210081040.4156383-1-geert@linux-m68k.org/
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/Makefile            |  2 ++
>  fs/smb/client/smb2glob.h          | 12 ++++++++++++
>  fs/smb/client/smb2maperror.c      | 28 +++++++++++++++-------------
>  fs/smb/client/smb2maperror_test.c | 12 +++++++++---
>  4 files changed, 38 insertions(+), 16 deletions(-)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
