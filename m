Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AA02E3386
	for <linux-cifs@vger.kernel.org>; Mon, 24 Mar 2025 00:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742776628; cv=none; b=I+irKIjtKys0E9J+NwDWQqSdzW6PBO1AFJgSL+uSfPhgDFEQLnOo6xwrPaoTpZ3Rhb45klYBGq6651ItAPdoC5c1B2ONZp5EWmm2nCPD7i8LaTipQ30UgM//yekfuI+QbqvrKtcQ18f5SZXduQEj9QB+iuIE0aq3iv07D7ZN+a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742776628; c=relaxed/simple;
	bh=tk0BMa5mAEYMoElv062SuTMtF1MvPaW7MAHquygtetk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=dDYE0Y7LlAgTf5dO94W9AHkHtSPM56gWbvcH7bdLf+JT09/klgOlvsvse3VrUHGSc6sq+6+TRg09xGYn0hRfBqcAPiLKCNq4WcPdxQAsviOilG37l1UzbLmfcIOV8AECJM/K7VCqJEHlYZ3ecBP7z8bg+5PEJ5RzzEpsZnPyHf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=QSJdAKOm; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="QSJdAKOm"
Message-ID: <02d5d5dccd2fa592baa2d16020d049cd@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1742776619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tk0BMa5mAEYMoElv062SuTMtF1MvPaW7MAHquygtetk=;
	b=QSJdAKOmkzp5L2o0rDnoMZW49hUDRrSiDFxNOW15vHEhy1dHbUksKJ5Vr4ETBOjsgqDJ/g
	/zwidrE1cI8nfyf2BPY3OMHK4hfIYTLYjv7wWBzqft/LLAZZCfojnshANU+p2TbL6CcPux
	XfUPxKglIslX0r+JLkX5/m02SHB/v49KV9pya+tWDt04nmSpXUhNT/2F7JKCGt+XvDtQZl
	Uffsvm57dxPEOIqC7Bp4PJxlrcVdgGT+u/GBHISSx3QqlM5VcFxwt/Zk39t7BOtakZnsqA
	0Fqp+zDJdtX6er2XyhlvqAdcqklT8ZjZzoOPCx+XvaFDWY56NqN1pfB8dE9fIw==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Steve French
 <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
In-Reply-To: <20250323103647.rsex63eilfdziqaj@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250213184155.sqdkac7spzm437ei@pali>
 <CAH2r5ms5TMGrnFzb7o=cZ6h4savN2g1ru=wBfJyBHfjEDVuyEA@mail.gmail.com>
 <20250323103647.rsex63eilfdziqaj@pali>
Date: Sun, 23 Mar 2025 21:36:56 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Hello, I would like to ask, how you handled this regression? Have you
> taken this my fix to address it? Or is it going to be addresses in other
> way?

It's already fixed in cifs-utils-7.2 by commit 8b4b6e459d2a
("getcifsacl: fix return code check for getting full ACL").
