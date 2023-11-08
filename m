Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ACC36AEA
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="XGQo6g6+"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210572598
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 11:03:40 -0800 (PST)
Message-ID: <cc16527c57147c936aa17643d437e7fb.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699470218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nSNPW+HEdO5vuAodw3qxwgTVqTGmo5xRb1HNPzH/thw=;
	b=XGQo6g6+f7+8AkPOh57CM3h1gejZXuqNR3fFM3WfVgEQfvtm+F7kx7wTDe60hgfNLpe7Z3
	Tr+6ezPl4LHL1QRdMZnpo8TkqepJeXNgQJZXbvH9Z3PLdARLeAgKRQbgIQAyHiJ/TFscJR
	QHH2kkycLwAAeJGnVR7sh0g7BlAtDj47hqCeHmvvbASxarskFyIx6OMg8fxJG83g6YcMaf
	CfXyio2ba0c2UGPOnGh+NjxDdkBr8c6zV+jVm4FCvSRrvOZ75/mSY6kLZY8Mx8KD4dkBQ8
	akWJPUqn2rY/mIxIbhYRXy+PoX7R7T541BMOUzB9Jht8hYiaMNzJmTWyDlsVew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699470218; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nSNPW+HEdO5vuAodw3qxwgTVqTGmo5xRb1HNPzH/thw=;
	b=qtPUq071sz7yyDIl7T+kWLr4ll30ECVmFYGp4mfKWa2+HPBXrQKrGeAS9Q/UDe3+0JSkUL
	DHyvR0VNsinpRbrxgD67sTI5I5ekYWNAGnKuvJM6CWCbTuBEbEHs4ORg5BadpdaAAMvanb
	+YiO1aNfNDqRnURTO050xU1v61b77zuNyXp/HpRG6kjOjx2TqBmB9zyhV/esq/IobejpVQ
	NX+xy9+3GkAdnICZW6Cl5vOUjK4FvxDUza07dZfbdQ+3tR0v164GEL7ar81jgP4nci8R78
	T2/SPcRX1lonVyqDvmAf3Zaru9ojkJYrJGWbXKFTJulfwtoOnIEdq6o8x5eDeg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699470218; a=rsa-sha256;
	cv=none;
	b=IEr/dRzZTAFe/Nymh5yGaEj+IBJpFlS5OQhJFQTwSxRvrBWLfaFxXAgY/ZvYJd/804mH1C
	TvsxTLgvuubCfWYQiQNZjn5O8PWVd9qF4eXYklz+n88q3gZipsyZxOIV9t8ZZ1MMft9lGL
	RymSbr1JE1pACeGqjl4+aLaq6SqWG7H/f33oK71+Td8nSgsQubmYyYkWEMb0vUWNpZWdjp
	zNfuIvBsog0seOpLl8yRUCiYZ/SSu6z55xcsB3vyY4+ETUx5TCxAr/5n9s/R90Yz6ASDrZ
	FXX8r4K9FNig75q6G+2aL0u3iiITZrK0VOXr/eWFM1UwWu9S4wbS0FfcG0cf9Q==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 08/14] cifs: account for primary channel in the
 interface list
In-Reply-To: <CAH2r5msjbq_g8NRr1ctfmkWsTs9-G3zPVrt7-Jm4g44jeeks4A@mail.gmail.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-8-sprasad@microsoft.com>
 <efd21d30cc8b110347931c98fb21db62.pc@manguebit.com>
 <CAH2r5msjbq_g8NRr1ctfmkWsTs9-G3zPVrt7-Jm4g44jeeks4A@mail.gmail.com>
Date: Wed, 08 Nov 2023 16:03:33 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Updated patch attached. Let me know if any objections.
>
> I made minor updates to Shyam's patch following your suggestion of
> changing the logging level you suggested, and saving off dstaddr so we
> don't have to hold a lock on it

Looks good, thanks!
