Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90975212D27
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 20:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728419134; cv=fail; b=XfjsYs98FG0En6LAR1elb1a3CPvdSFaQX0DPuwB2Ylzbckpsks50jPCnUUX7d/hrKVx+jHReDXENur+j/AbjV0yUn33nCdsui8fv4HV2jqmHkBbc/CWbMRKa4Ofb82vnvece8RxdlTpRT6mAZELdvMXBa8DiatZfS59hbJ25lOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728419134; c=relaxed/simple;
	bh=XLYThtT/UArpe8ujZa41czx4MdxHVCBmmDDcsStwh9Y=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=qeQdb80CF2amFIodTjasXgwWRHYbzSLK6jocDtGb06AmRnL0NOx6XwKjWoBg/94yBBY4a7FE8uE7oSpKEaMm5INJ2mmiLTh13aEpf6uN0utkVNrozF0UmtDvRHtmpv3Z4NGX9sghxkeLMxyQW8sLYEjcACjvfTl+csjMg6VIfUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=MlA7UmXO; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="MlA7UmXO"
Message-ID: <05ed718277b1a302d0119729f4cda6ed@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1728419129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z0VbGj0/eAPsjVJIqUkyvhhLM7sscqvv9x7YpqgoFMA=;
	b=MlA7UmXOIQYWlVT/07j6uOMkeNgxyIM8uUCTKTULm6Tdeeu805w+CTM0lSlY9hG2NV+xJu
	s5bjCvCM5IUjqmCZ4qS0ab0t1LnXMlvhqF1X8NH5ZrzI6o2DlKrxQKFGOOL55NN5rmLPui
	6rqJ3nOi7EnTEQBxzHT5bcO0R9TM/NDN01bgMDQbZOeisCu1E2HiqCeCHfWhAnLQj8r8SY
	GOvCHIS4Vk0lxwsX9FvbJgkBAw934YOACrZhKtKnUTljomKt1x8Bu98euhj4do3n4v7+zU
	LiK6k+2PdvPnTU2OcYpP0fkOqKwdiqpaHyNVhf7QYXx47ertJl3uXgpvooej9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1728419129; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z0VbGj0/eAPsjVJIqUkyvhhLM7sscqvv9x7YpqgoFMA=;
	b=BrS0PhmkVc3rPCKJQEvj7Zh5NJwjoyG60MFoK7oUJYFMUS/RQijdRuOSNeH2fZ/p09xiaU
	JEddPdDrlQ2FH4GFZ512RP3i6eJcCp4+58P8UjT1JTLlxbXlLa8gATyz3fHf4f/54HsWb+
	V3zLbmJPTjNwqk8G5EUoRMuJQNNh04yDbCeFLUjA8y7+I9V2QUFakmUbbx161572YyiPdh
	nAI0zDzJH3Xr0SuS4ESiOFDP7Rtv/Kgm7H+EPKxLt6HbjWDBp3SpyVtrUNb45P0XMCLtQT
	HXKIC9jzrC1aGlMwWlg85fMmEE7FQE1bLMMKR/SYd+vXo2lN+id3QdeP+m2P1A==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1728419129; a=rsa-sha256;
	cv=none;
	b=hAn9db8YSehndlOKc+XHxqP9YdCNUvoxA5FpF5SpRnY96sixUOouo/+TLqhZp5+0JF+mao
	XTWdZyAfjE1LV/ow2qowWqE8fXFT0LheqlG/CPAww4/eErUixm9ieRvDcuTI97vPb0M6tP
	AuvnIIAfsitI6qSkyA1oSh9owEl1u5eFPJa47hEYe5jUH8cQJv/7TueJCMhdgx2DX1436m
	zDr5oSrhVTCjMgUllAsEo/Gjj7LdpElIiY5W/T1n6L6wTxs7LmxtKc/uWmqp/jEwPoU0wz
	M6ORhlX2S8Sk5THIKomYggxYr+xOXv5PKMGLZNvKoP5uREupJX5/xagjuw8SXQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3 client] minor updates to "stop flooding dmesg" patch
In-Reply-To: <4fc5c70cf311ed65d7c617cb154ef90c@manguebit.com>
References: <CAH2r5ms2jpBVtpYaE2hOgnfnjx73MnmPW2pQZnY-42ARYMf9ZQ@mail.gmail.com>
 <4bfa6f89b43289e2a66642f182f733c6@manguebit.com>
 <CAH2r5ms8JwSnRbyFmijk4Vhmd9-Khs+V3Co8sx6u=AEu0yb1Xg@mail.gmail.com>
 <4fc5c70cf311ed65d7c617cb154ef90c@manguebit.com>
Date: Tue, 08 Oct 2024 17:25:26 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.com> writes:

> Without this message we at least have
>
>         VFS: \\srv has not responded in N seconds. Reconnecting...
>
> which tells the user that connection was lost.  And, in case server
> dropped the session (e.g. STATUS_USER_SESSION_DELETED), we'll also have
> the above message printed out as we currently mark tcp ses for
> reconnect.

Err, no.  I forgot that we only print this in server_unresponsive().  We
call cifs_reconnect() when the session is dropped and don't print
anything.
