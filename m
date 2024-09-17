Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ED818893F;
	Tue, 17 Sep 2024 21:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726607834; cv=pass; b=sYYMUKaJcZwttoifP4SqgiBAVhkTJADjJplfB6/ZS+1CjH9lMRHDc3CUZog7OgdHTFs7UO4pqqz+JMl/+n3VHQbZSLb+pgFN8KB14UNNWq1Hc3MrDJwp4cBRs8FaTvSDs3JlTNF6faqA8pevwPLSgRw/xCe4QL1q5twNI2H0p5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726607834; c=relaxed/simple;
	bh=GrEatGzohiCK8MEXRWd25lZFK+7byL7YaHtLHZUnW30=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=KI67Nw/BQVZAvOtBbkxInpbZvgImOW86HVJDyrIq+2+T3Qhe42Qz9x9rhef8HTNoD2pUm38rhgLcys/QOBpgs31fczasjp1wpuCAhlrcnBlLFKqT43YGjnoCwcGG1QEFLjM+YXEIjRDe8zU0kfxB8VzYrMSIXCDGhg25i7zR3bE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=nYAY4Isb; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="nYAY4Isb"
Message-ID: <7f29cbf81602313df348fe6d36bdb0e2@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726607831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ggagET1eJZyltH2WYLd8/L/pzvrZG79a8hMd2Kblfw8=;
	b=nYAY4IsbcvAsJZA3a2SLtpBc8twWJ7AsREhokcadWXdGmsq2vtc63alVjgBzN/CJsFwOJE
	ZbIihE1IHTKzHK+QU+eVa/7nc00QwjGk6ZBf8hIK0um0P5CPnIonjNrgjX40eIT10Besfo
	TKzp1Sq/5upoQVV5Axjx2YKstpJqzpqDzg8oYlWX3P7wxRvRk1vYHibC7KLF4ER2ZblqTx
	lMVk/63TQm/clD4NyqpoAsD6TmBkZ7vNzL9eGjCvDAnpdtfSu1BDh3KkRPYosLv5Mv12KO
	9FCRW79fL+t4ye+3JwUOMnu04inErl2Ca2bMEOpFayqGK+GJvAWVokLOyPUQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726607831; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ggagET1eJZyltH2WYLd8/L/pzvrZG79a8hMd2Kblfw8=;
	b=DndteNXoEpemzRZ+505Dcc53U00gsM5mWXoulP/qcoqcAXP1FJzuUW9QFdOg2uZa+QumD8
	aokYRTtIE2F4KLUJMaJb5mgo8vDlAXOy1Gpg1rJRf+cmm8qIC1Z7GqM6aKKNLPNv2pn4Kj
	dDlbXP48T5kmBTodS55PDzAqLJSUTM1//72Nl71juwlsCcEGrua7WAw+CqgAV1K7rBkdTN
	Z/B9YZ5+87lP0No1SUyaKfT4Jw05pURzcSSdOzmj4mWZwBYoD1HSZEp70BLsPhwkdZQI+e
	Wi9dYWlwfOjBESknEsUCP+WOTe9q+g/u+YYocaMSN0YJLikwbEsSQUnpJx/QoA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726607831; a=rsa-sha256;
	cv=none;
	b=o97GdF70tLt8bZzyCjKXSQjmZXNtOP3/L23fuWPoW32wGtzjQBF8/kl6YhtjWLMn6v5W0e
	dIk2qp9sTj6zPQdkDQ3P8kk/hU3H40/Toq/rYbdrsW+S8edHbAhnM78zP9NrzMqT8sdCCj
	Oc6FmMYStz09XKeuLV8+/MmkabhoxCwcHPNda4WYi6iCQXQVf93HS7/JNRS/mQw+5kMLLj
	h6u2imL3aZA7MiJQNOUSFUhw83AkPIubWqxnJrs3cl5pU3/k2j2pqKCVj8hkeQdaJb84bS
	zGZW0L3GNfGZw/TKmQYQV9wZ6lvQyaH3GZc+RW6vniiPe3k92JqpTEfHDH9MiA==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without
 WSL support
In-Reply-To: <20240917210707.4lt4obty7wlmm42j@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <73552a5120ff0a49a5e046a08c6c57f4@manguebit.com>
 <20240917210707.4lt4obty7wlmm42j@pali>
Date: Tue, 17 Sep 2024 18:17:08 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Would you be able to fix the client code to do this?

Yep.  Will send it to ML soon.
