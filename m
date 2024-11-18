Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6281F1E130F
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 18:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731956368; cv=fail; b=ek5K9JyoJeYrBQMujYSMqMPcHHFsVoYJ3UB13hKMx9UH/Ib5J9MWXH9wfiJxzqAUIiagCWIc94I1HAaZ6TGlw/gliVilWxnCfBt+/Orea0gCb9uruibnLje1ZTEPUbfnFjVE3n6Exed805Mhsu9Kz99Tfved29pPEYb41iF4V+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731956368; c=relaxed/simple;
	bh=e/D4dGGzmmnbaSkf/OE3ObWSW7ztdaJ4tQtln53Xhhg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Qn9W5G5jQLJlVwLjRgVo1P3417cle8kK3qCDla0e37Xz7qH2u/ddwWjLajzqbTaQGuPBcrkBHA+Fx//q6Fc31A7dv1Uz0Y0koLYQGJMluH6gsvdFy0xWvBOAcljJIWxBNZUuaVOH56ciY+wMBDkYBwRZN1kSaOyOpufmjZYG5L4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=DEA729iI; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DEA729iI"
Message-ID: <3d10dd5c3a7f190533474e4ec48f07e4@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731956364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kWvezka22UZIjUIHSe1lhBbCoQ0GczC6qfffqKBxOVY=;
	b=DEA729iIShZmbTc57x3QodgrUmj/k/+p6YNIm8gyphHJ3MtuvlOrSDMTxieEqC4KfrsMsu
	9CHFOklU9dHn/1eCgSQcogIcvfZDsqNhkYyrq1VqIijUo6Xn5KESAC3BdTLQOoqVZy497Y
	ascuxe+G2tXbqynf5sYx2H6CLnQdr+w04PQaMuFpQwUGO8knPpthN2a7QzYRIoPCysNhuL
	QFO7d7/Rfzj8nad0N0dEQp/qAZcYViNaXK63xOlbkGBoUl/JphuMyFxEnITLCtt17F6cDJ
	WymnYhhFgEvgcd8mUFRDl+lruJMlOItJCH92ETQ08/DzTTKegg4cswBWFiz8kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731956364; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWvezka22UZIjUIHSe1lhBbCoQ0GczC6qfffqKBxOVY=;
	b=aHIv/HNlOW+5N7Qmr0PSQHmzcWJhtFobO5Q+0Vcm1o3tUCgGKWre55nkkr29GIEv9s3UMD
	p3SR0U/N8lZzJVjNMLDZ8A1JG0WPITC2az4oeV+HmrO63AqtvGimEcDlas8iiREQmjkwhD
	hMBsfUKMXPn266JrO1bRxg9295SI1vfgGmwV/DqkpVANbvMUkasTRt52B9XZmSel+Kz6eT
	lS/jkM9HAPhk41Yvt8FWSBFmqTpIRSnqw3UhmYavNm5BeJzluFil/iXiG3KClMhByvrpE9
	SlywyNvWpBulG/9lJAW8YHc8tw5gRPWaysvKmsDiQGNdwbzya/UO7RXcI1AoSw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731956364; a=rsa-sha256;
	cv=none;
	b=gFuVnNlyidkYtU4iKnC44w/nfbl/yfhhjD1ofATfezbKqXHbDjtZ5ELHJLrnTCWKywW5Kx
	1atg3mXqTtpN/JREQiI8rmypR3KReVd5XS+yFdxGDveEmNH01WTy2lym2KMBzzLEQ4jpL+
	bN/0NWChZQz8r6pBiBDIoD8e6Mp83tJPBqcFi3LaAmvjukVm66KJnhoYY1VCSN8QDSXnuD
	74uuHWiFloAqTuRFQmP3mfJsWSMMHfHTKJR6iLwQb8Awby6GwmbFZiEue3NBxYvIQPlymd
	LthwEvKl6I/IuTm4MnWc61fw3PBhDv49x9I1/GvCwA/LbVwPDPNxeJ/nYfb9fQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] smb: client: handle max length for SMB symlinks
In-Reply-To: <CAH2r5mueythTtWNcgaduN1=CW3gt+xQc2mY=naYEn_mmKY2vMg@mail.gmail.com>
References: <20241118153516.48676-1-pc@manguebit.com>
 <20241118153516.48676-3-pc@manguebit.com>
 <CAH2r5mueythTtWNcgaduN1=CW3gt+xQc2mY=naYEn_mmKY2vMg@mail.gmail.com>
Date: Mon, 18 Nov 2024 15:59:20 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Presumably a symlink could be up to PATH_MAX (4096), is there any
> reason not to fix the client side to be able to handle at least 4096?

Even if we fix client to handle larger responses, Windows Server will
not allow more than 4091 characters due to MS-FSA 2.1.5.10.37.  It's
even worst with encryption that we only support parsing large responses
with SMB2_READ.

Yes, we could fix the client to support up to 4091 chars, but that is
out of scope for this series.  This patch is for allowing users to
create SMB symlinks and read them back with and without encryption.
