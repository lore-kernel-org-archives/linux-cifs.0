Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF021474B9;
	Mon, 22 Apr 2024 15:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713798545; cv=pass; b=nEwja2e60jz4sbazR1C16gckStvXRgE1HqXVPY6qPquCb+IW/DpcdRJrIAG/kM8kfkk9LASMXOAdXyEKjbURgucUiEN46B7QQ7y54HJzX7l1qQ51EE08xPZ65osMEEZhM1Xsvdt6QqSZbQRgoJaWrKLObrOuoUNWPc/i/2gYZsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713798545; c=relaxed/simple;
	bh=Laelx3WwGmYXAKn58hviI/QXfuGutDv98jUfvYbPftY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=G99MOCvDwz8aFVxqeWYyQMKJ09DcAgjlt/aRTOHe0axq00N0F/dJ0NWq6Cih3TnfiIAMVEeOgzTp0zvNE0fUMUDoNcznyWjuijhd+l8sGpK16eXuwzjYJ6amZJhbxP40HXa+U8sHihyMh8+b9MSXWv0+3foTrogn4/RVh1BC6Qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=X59CekS+; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="X59CekS+"
Message-ID: <adfd2a680e289404140ef917cf0bd0ab@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713798535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NHiQDl3huVUrNs3zqg+ufyzgDB4ufs3iLmI3DcUaM4g=;
	b=X59CekS+vQyGU4mbbf+XSXxI1Qf14YQydzv+LrL9pId/xgrIM/FP3dIfAHFRqONuzX+fly
	F6uB0f/V05e7G7D+gwWnvc36Ru6RcUKhXv5TVSiNYcfGY6TGglPULS8v0qyW/wOWvKcD1b
	IhfEOEmViOeRTIgeqUsn1RWQcBANLA5QFxWltfhVgwsgGeCRhLr/1GCwIP9Di3CwewoYj5
	0Bb855HwfQeLWUsqRuJlUswD2EUPHq3aj7sloxNW6O7Y4mZnlXINn2aLDW4ftXTbmx/YMQ
	8S08nCBtrvC88p3mXM+YPkJVj2IZA0O0uTC4ALQcf6rCvrLUNbog5GQh3MEkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713798535; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NHiQDl3huVUrNs3zqg+ufyzgDB4ufs3iLmI3DcUaM4g=;
	b=f7vLiCUmWsRz/5cThcXHeJGzr4+qoFf4Owt0NE+badFXbOQcaS3pp64OGMgwIJ1+atALDi
	1qDAVVvAt+uKlzmmqw9pghabd/pBRTuW/TIrKOmRuZLrAGa1wdTfFlRpEaZ+zcnoMReUYY
	SnnHMuSGuKC9RWVgu3NIDImFD+ZNCQG5EFYlJ98tca+CpOEEpqlG2JRxtGM5DUDdq/7KPw
	F+79xaQcq7g4fQtLuCZ4dOyfIM7tVaficOn088RogntPNGUtnz/YoG0m1T1t5t637czDWs
	WCW99AXjVm5+TcV4eUyLx6XrFOlcMZsqcL3ta51GNRZiLpbaKhK5LzO6tk7GKw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1713798535; a=rsa-sha256;
	cv=none;
	b=hw1j1lauKgSuJHYQk7fonUtn2dkUrf4CZRJ0yExPcETXQy6TUZkGjbn6wyir/5+Zhom7TY
	3ymlJTI9VSTJkqej2Crfb8QaK//dNqhdZjSKSaMsswwxHNEWpf6FY4Xw8AQfFrdRF3KkF4
	hrcSbwqQK0POMgZwtDhG5NYi9PHWWqgl984MECj2OGMYyRdKTRgxp+yRj8eF5s232kbPjc
	jEs6N8zf4WmWXuPDu6JTNZNHQewwll1dN9R1PRChbKBLiuNHyXNUUit2wvfrZgaW/JfZX2
	X9Y9C1uqJw/xY2nDjCFYwMkDLZJKKP/FBTEm7+jQ1QqXOkpG55EH0V0Oetipdw==
From: Paulo Alcantara <pc@manguebit.com>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: regressions@lists.linux.dev, Steve French <stfrench@microsoft.com>,
 gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org,
 linux-cifs@vger.kernel.org
Subject: Re: [regression 6.1.80+] "CIFS: VFS: directory entry name would
 overflow frame end of buf" and invisible files under certain conditions
 and at least with noserverino mount option
In-Reply-To: <ZiLQG4x0m1L70ugu@eldamar.lan>
References: <ZiBCsoc0yf_I8In8@eldamar.lan>
 <cc3eea56282f4b43d0fe151a9390c512@manguebit.com>
 <ZiCoYjr79HXxiTjr@eldamar.lan>
 <29e0cbcab5be560608d1dfbfb0ccbc96@manguebit.com>
 <ZiLQG4x0m1L70ugu@eldamar.lan>
Date: Mon, 22 Apr 2024 12:08:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Salvatore Bonaccorso <carnil@debian.org> writes:

> I'm still failing to provide you a recipe with a minimal as possible
> setup, but with the instance I was able to reproduce the issue the
> regression seems gone with cherry-picking 35235e19b393 ("cifs: Replace
> remaining 1-element arrays") .

It's OK, no problem.  Could you please provide the backport to stable
team?
