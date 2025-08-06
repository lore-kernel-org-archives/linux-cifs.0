Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0EF244691;
	Wed,  6 Aug 2025 13:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754485881; cv=none; b=rUBr51j+OAS2GQiadJuny4R4jkga4MPDD9aikob8UoGYu0wiKMaI9GRm2XrOme6vbJhAB55e1s5dbTAfno3K3W0Aj15fMKTqs2if1Xxiqa0aDIEXiKHhrkVxkKRaAnRBOXbszSclVossxcOXE9b2f7oluZTpic00qkQak8aOtmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754485881; c=relaxed/simple;
	bh=n50a8r7uu+2wluil0SpQn7Z6cWcti4zXj0/AUdxMNRo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=m3WhAMuj2Btn9bEBqUpFTJ7oaGpH54qMD61DqT1ejJEShHL0aynMUETJc37AHJGl8VckJQF1gHeiTWXHiHuLU2O2Cz0sH4JrareivPuxtXuhWe0i55KI08Q5POHLDACoD26s+g7MDh8O8+fUKShCTdnohxcfTIfBaqq0ymh5yVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=OUBnto96; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="OUBnto96"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SvxNES5JqcIgcUoGp6T5BKitgZiJye1TWEWSz2w4T0U=; b=OUBnto96vuT4XmvPxOCksx+HX9
	Kr0j83PMyKck4/vC3i8wzw/nntBL0tZOJ6/xHMTbC3QbhXSNSZXVW17YSfbGv3bujq4/+Oym5k+ji
	mVrzb1piO+5d/vMnJ2be0Oet7GqhPurVirmQD5SVXHvqM1W6hVHNOBvhBFOXn+MQ90FQhEuvuLwnU
	CbESFop3d/Zr/OtwMGUZwB/2OFrdGWbAMGDPEugpxT5uEzRrqqhx/4EVKlLDBMcd5khIouM+57pTl
	r1onnMZ/7R8E38mIjwjZ6Tnmw0nKMve7ouK3UdNwmdOq/Iq7DpLoKDCDg3KjDQgCzZEugC/lgo3xT
	xO7ik3Gg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1ujdv9-000000008xq-2dDR;
	Wed, 06 Aug 2025 10:11:07 -0300
Message-ID: <fc9d868ff4fc3a1dff624a2a99a4179c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Stefan Metzmacher <metze@samba.org>, Yunseong Kim <ysk@kzalloc.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, linux-cifs@vger.kernel.org, syzkaller@googlegroups.com,
 linux-kernel@vger.kernel.org, notselwyn@pwning.tech
Subject: Re: [PATCH] ksmbd: add kcov remote coverage support via ksmbd_conn
In-Reply-To: <d12e1d6a-d9e8-4bb3-abe4-9bcef1cb8f77@samba.org>
References: <20250805155627.1605911-2-ysk@kzalloc.com>
 <d12e1d6a-d9e8-4bb3-abe4-9bcef1cb8f77@samba.org>
Date: Wed, 06 Aug 2025 10:10:59 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Stefan Metzmacher <metze@samba.org> writes:

> conn->kcov_handle is a new element in ksmbd_conn
> and I can't find the place in this patch where it is initialized...

It is initialised to 0.  See ksmbd_conn_alloc().
