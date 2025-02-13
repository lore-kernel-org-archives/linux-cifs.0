Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0C227EBD
	for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2025 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739448515; cv=none; b=JXaY4uGEtU3qgJo7Okr1ok5DbFb8AZuMKQWApFbB5mv6nVH807v9+KyGkoKP2DUFwGVKw/fzH47cATjnaC5+5p474I59KUiP+sQ7HH7GkDdYDQAhKAB3dmgEyLABbO6Wcq7eaHev0CXWRLo0vA3wTYoNmez7VDhpwtUv2Y2Ja0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739448515; c=relaxed/simple;
	bh=2BzmOKVQdwX3Pzz/exe0hOrjqqyR2kLG2vPa8UYfJyo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=WnqukgFLaW1X9wTOY5Vw4s/9bZZbWJgEqymbz0QH0HjmNSWjm936zK74lClFmqYh0maTp3PfFxcobzU3+S3rkPfZq+H7mTbrqawIE4P7MuJg4FPAbs5TBZez+zF8GFKr404I1aun1dgq9XRtfaSuGRjZRj08XW43KcxIUgb5Lrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Nzefvw0T; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Nzefvw0T"
Message-ID: <e5c527b78033ccbc39dba8056780d3c9@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1739448510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kt9F1dXVOCdpiH7QIbWxP+leN9o1/s+v4/98/Py582U=;
	b=Nzefvw0TT/1pXOnTk7RVsqtKQEcwokQ9IXlVGGJ5A4ogFRxV81j/HLnOb/NEpQax313YB/
	VDR5E8MuxEijTkb/mBM0baMohVpGoJReG6ogSpj7G9sbxBOKw74R4qyd0L44Xe+Q4ocMj7
	TUjrK8r9FxVGONYbngc9KAG7T0B27/SM3R2NZika7e8saa3AOtZ4cOAGocBVPoXKH8tWvs
	cqTa+f1IPLTkME5hbyllExKfRD0larbUTK6KVUcsOpbxOoFW0Q1acEqmSR+snrP7pCnNVm
	k0OZ0dP5t5VBy0vEHlPmxc6qPl95XCY8ZnSNT54F+XrvLHGiy8cXHfCTe9Ag9A==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>, Pali =?utf-8?Q?Roh=C3=A1r?=
 <pali@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
In-Reply-To: <CAH2r5mvvgoGvvgpBj09zCA1G=Heca3if8x41cuthmUxGTdNgRw@mail.gmail.com>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250212224330.g7wmpd225fripkit@pali>
 <ee932bc4f65b5d332c3f663aca64105e@manguebit.com>
 <CAH2r5mtzwOtokQjbX9NzzB6G==t5Wq3Xqz=-K+qqLuBnoKB15g@mail.gmail.com>
 <20250213000234.s5ugs57chvi7g7pa@pali>
 <CAH2r5mvvgoGvvgpBj09zCA1G=Heca3if8x41cuthmUxGTdNgRw@mail.gmail.com>
Date: Thu, 13 Feb 2025 09:08:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> ok - how about this updated patch to getcifsacl?

LGTM.  Please also make sure to add:

Reported-by: Jianhong Yin <jiyin@redhat.com>
Closes: https://lore.kernel.org/r/2bdf635d3ebd000480226ee8568c32fb@manguebit.com
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
