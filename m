Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6DD4334D0
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786109542; cv=none; b=MHI9rvBprgxyr0RgX8sknXLMoTJadopCSu7SlU8axVSzJ93Z92skmJAyz1cIyo5phRgud9IMv7yJjYJsxpWSEHB3dkAB9y8soE+et9HrYGY2uyJ5Z5Vps7Xt+jbCxEtDCYP0oUI5CEKa3Wp7OtbZCCAKeypq1aBSEckLOlh4uBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786109542; c=relaxed/simple;
	bh=8RV8vz+bjGLzjbV2g+QG4H18uLzWAHLrnTQAi5HDsFA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=qh87iUzejckVz8J4YizUYQe84CD1R9o2KwL1SqrMVRhhTv8rP3jyPq489MQAPBQ+XqAjN0zRJjGq+Gwt76WPRAryF1UbAL6U+0T3RO2Fco68buP2aGqsyr54Yv9IpfiZYHwnqod+oMESg5F2tM+BBr82AVHnaT3K9jBI+2Jkwg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=SvH+dY7M; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="SvH+dY7M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8RV8vz+bjGLzjbV2g+QG4H18uLzWAHLrnTQAi5HDsFA=; b=SvH+dY7MnYByqfySC00+/FJICz
	QUt/3jlfWD7CJkJUvkEjgztEjquSCI6sOuq0yc5Ken6d/8PslX78MCpylAD3cidG/N8DgfhsbuVc4
	lkquWpIpZydhiL6tdZDxDvQ/fBz2+J+J6WjiOLpeXDYdtXMvIxQ745pl7dPgcZNxNOI1ydykmCup4
	RxJk0GhrqNZ+iCwtw8zXm2Za4sniNxV23G8UUHB8wh5vAV4wSBzAFp2Kw+D9W4G21d3EElBAQEe57
	iMUUN+01EzNxYSB1QJQV2vbCDEqNubNAXLH7aT3dTb2e1qTLOs6k5ep5WuCirQdKhhXxwbRV3ko9q
	hAQQAuAQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.4)
	id 1wsKg6-00000000qIa-3qjJ;
	Fri, 07 Aug 2026 10:32:02 -0300
Message-ID: <50a3417071b9f5b50f6a10c350ecdfd9@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, tom@talpey.com, senozhatsky@chromium.org,
 slow@samba.org, mikhail@mstefan99.com
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] smb/client: return EOPNOTSUPP for unsupported O_TMPFILE
In-Reply-To: <20260807085806.725742-1-chenxiaosong@chenxiaosong.com>
References: <20260807085806.725742-1-chenxiaosong@chenxiaosong.com>
Date: Fri, 07 Aug 2026 10:32:02 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

ChenXiaoSong <chenxiaosong@chenxiaosong.com> writes:

> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Some SMB servers return STATUS_OBJECT_NAME_NOT_FOUND or
> STATUS_DELETE_PENDING when creating an O_TMPFILE.
> The SMB client maps them to ENOENT.
>
> The ENOENT error is supposed to be returned when the path
> (a target directory in this case) does not exist, while a
> lack of support of O_TMPFILE by the target file system should
> be indicated by EOPNOTSUPP.
>
> Reported-by: Mikhail Stefantsev <mikhail@mstefan99.com>
> Fixes: 3e7d63037a2b ("smb: client: add support for O_TMPFILE")
> Closes: https://lore.kernel.org/linux-cifs/75fb5359-b268-492d-8d4a-504d1af60f2a@app.fastmail.com/
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
