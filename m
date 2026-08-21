Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5D637F72C;
	Fri, 21 Aug 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787331954; cv=none; b=HEZmkWzlorg71aBe/QjRjpykUEj9YiYlRtvLfdKV9576untJuKtAxjPPar55vEDvf7wRU0oz4bGk1zPjys+7inKHRf12Ns82ShpC4KLhSymaxP2YFFu1yWoMTbwRWVU8YNuC/eUtEfnT2UJU8JDFrhwpo0lR5cS2XjnUU5seJsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787331954; c=relaxed/simple;
	bh=ZvQ+AaMtQHp0fpWkeenc2WOp6Y+SGx1Q4wQ5S+G51GM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=YMP6ibGQqA4igGlrnq6j1Jgp6CH9XsfLXSaEsx4HWpwdkAKKknSiC3QAQUXablHRqLxFqmbDaggd99qVqK4zAZWMKKSdKvtUvl4TTLlwaEolInYCs3uonP88UJICxXFMGZwv3vialtOyucbn0KR2t1MlYi40ntTVl/Q0Eep/5Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=enHm2Ekt; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="enHm2Ekt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZvQ+AaMtQHp0fpWkeenc2WOp6Y+SGx1Q4wQ5S+G51GM=; b=enHm2EktfCaOe96Om6N08Ygvof
	81mpTC1fnygmIMwgBB6TxORcECk6x3Y9UOvA8spQsRqHzIatzOWJ8sswKBhmzG8dNtSnUE77zfAwl
	NShjPR1DeX+BTrr5cBMh5pzKq4qjlvpEU5Tk0oMp42WFXVlrJT568qR94vB9sQ8ijpqmzXntxvaEX
	3zly9ATbSZZIJcnG9vm0JwBtGF25Wwh0e1RWhCOz0No0ZQnigPFnF2sLHteX4OMnMOS3phQ+22/ft
	qWdY/dUoBnU/9DwrSC8cCarfuM4hucIGInruufLG1ElijnOmbRfUayIzMGBA9Fgp9bOI44uOQUz5M
	enrnr9lw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxSgh-00000000PiM-1U4t;
	Fri, 21 Aug 2026 14:05:51 -0300
Message-ID: <ce7cdb05343c5d98dcbdec0d61a0bf6c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix copy-paste error in WSL EA length
 accounting for $LXDEV
In-Reply-To: <20260820212210.1475817-1-sorenson@redhat.com>
References: <20260820212210.1475817-1-sorenson@redhat.com>
Date: Fri, 21 Aug 2026 14:05:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> The LXDEV block in cifs_query_path_info() uses SMB2_WSL_XATTR_MODE_SIZE
> (4) instead of SMB2_WSL_XATTR_DEV_SIZE (8), undercounting eas_len by 4
> bytes per $LXDEV EA.
>
> eas_len is used only as a zero/non-zero presence flag so there is no
> current functional impact, but the value is incorrect and misleading.
> ...

Applied.
