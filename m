Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189A79DD4
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 21:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712094504; cv=pass; b=ucohKG4C4sr2yKUmkbLTg+JYcXDnyXbuRdLmjdEeCK+6M6gDYctXdYqOjfhR3pVJqy0SKmKPseRxzmwD3CtC1scpUcVGlkBN8fPDk+gMcx1RlKf3VX2ti76RFkwddCAkzqQxaD7qHxODXiZW/q6fYJUzRe2SGh7oGSdTUdsXBfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712094504; c=relaxed/simple;
	bh=8wLCNeO3FaePWhu2ClcazkEkZGqRc4h+x5lPxvel/d4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=d+1x1rj+O9dZBIzgYjio5rcENJIvws9/AYdM119fVzjOcdWhUZ6WoJ8K3d0wjnD7l65Cl1zvzxTwCfnjMmZKaAPqsatPd0h6FWqSmR/OaaqvSZTGXh4InFAbw3tdnTBxE0J6YnGlTlonQfkFJKUEGvH+HG1jBHlOkPHqMXV/YGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ecZQhCuE; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ecZQhCuE"
Message-ID: <5a107c89a3810432d690d173f327d75e@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712094500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ilFoEPylQRmux9yjTuy+sOOh8iJ7CLrHtzQGMAAuMV8=;
	b=ecZQhCuEGJMwzvr3Wq6P8PhXDLWKMArtsU6qvnoHhNmMYx6OnvdDVsTGLarXZHoKUzjMxC
	2NG4XvuGynsdQS1gfFgACzCT7ez5Jtm7mfYhIKBB6bRTF4QzUdC+6dwY31PsnzPUI2W4cx
	XclTY99jsa7d77+PHgThCBSEHTbejWBoYaR7z+ZJUaMH0IPOtHJw2yoGE0NYil9F8NjorU
	xoERDfdmi/cp0iCawSwzxCfO9uSjULypB4dSvGwvbZWrsbeNpuFtEghjPAW362GKJf2myI
	vapSgF927gHD99ARRiworVg5iyg/g1GdgUlOZsBE13CC2jrKlNZQ1PHKTaXasg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712094500; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ilFoEPylQRmux9yjTuy+sOOh8iJ7CLrHtzQGMAAuMV8=;
	b=WO/gRUa0OuOPQpvYy+GOgcvYOdWxjL8s9XqvjOGm0MYo0In8RmXWVdtjBT6ZSU6zr8YJSj
	+gDqxxqdujivT7BU1009WSQmd2Zk8XuMRbRXzs+6AzEpABg2i1c2ZpfPtXAHZ8+cPhrN0s
	dOV3yButUD2/yvUOeQm7ZpoJiXdQDWJ2VYHmn0hvdHY+iDdB0m2X52wmmT0qLuB5RFjR50
	M7zWCCyGvTBEi7a0WQ0obmh5GSHL0Bvy7GdU0LxWNXlQJJ5uF/8o56ZQl3dsllfgwIYkp6
	vWQ05REGIfX0G2JQH3ZBojKNLHkEHKH0Kg+eM1cvie8tMjTpkECddaAKrOl/ZA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712094500; a=rsa-sha256;
	cv=none;
	b=oFGnj+BHWT9P+ppbTyoIMNfW5cV9Nlp6enxlE/Ow1TDgAhIGsM97yVSs6Ijh1+BmySfa8H
	kn8sjNhMTHgjLcz4MjGDf2zBFfAYLncOqDdypQrvAaZkj/EY8MHKUmPm3+a9gY8RAu58rX
	CADgoAo2+s27Z/LUa/S98wlVDoVb+qoSfNReGw0681HJgdIGewAgQksaPfXJRhO4gL/S9v
	R11zUP7zLcTK/oR0GslKwhB8hXa4LAX64NCXjMVSQdh42u8hyd4M5OX9WvVH/CVmyzCrCc
	CIep+sCHb8AeFRBeT81Dg9HWqi0XqVYDU6+oMSQqWe/uy5vt74b9lNBMwK4MVA==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 11/12] smb: client: fix potential UAF in smb2_get_enc_key()
In-Reply-To: <CAH2r5mut+JkLhMCjeqPDNxLP4mhTa0LnEHTneL66Ktyc6WzVBA@mail.gmail.com>
References: <20240402193404.236159-1-pc@manguebit.com>
 <20240402193404.236159-11-pc@manguebit.com>
 <CAH2r5mut+JkLhMCjeqPDNxLP4mhTa0LnEHTneL66Ktyc6WzVBA@mail.gmail.com>
Date: Tue, 02 Apr 2024 18:48:17 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Isn't this needed to send the SMB3 Logoff request?

Yes, good catch!  Please drop this one.
