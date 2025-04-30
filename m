Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356941F09A7
	for <linux-cifs@vger.kernel.org>; Wed, 30 Apr 2025 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746042291; cv=none; b=VtEtAhZ3EAXXKw8AzMR1BrtlycZMlaL7Jn+X2ysJMNeTqiTrNBFf1TWFNWj6ZsSk8S275ZnoJ1bupsiW8LoLnD7HtJIM5TKL0Atq/Z3a8XHUk7G9IJTWjIaKZWp5VdzUTySZT1EOUNNNDfprQVGENoyfCAntBOFrpsqL0W8KCHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746042291; c=relaxed/simple;
	bh=2pAffM+GOSbj5pJtW7Lr7363yXbodqdZaPrIQNWcsx4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=QKNH4VJbKMdkZiq5pHHkYelhW0Kp5rswNKh7wjxA/qhmadH5oYw/DRdAYae5h+8ZmjPkNodo+Zrn59MFIn2cYo1cwaxwoffeCSGrccZtEcv2abjzY/HMw4E1YQkNmgfdgbiiFAW/YyxyAinQCU8PxFcR67W0DQWOtEYCre/rDiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=QawxLtne; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="QawxLtne"
Message-ID: <5d0f085859348bbd37fa2ec3b34426eb@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1746042287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ELHYoQ5yrh6EuliN9dTxbJsjLEZYTdF2pzgOjoGZwJ4=;
	b=QawxLtne83hzxPwh+hWojwCM8qwMqXgeoR7pXGskLTuwL4e+j0EIijizccWN4twAvHkycL
	n1iW9PbhoSTFCVnyuQEPW/FjrSsF/0fzDtcRz2d949R3zifbOXyEzFVaGyaiMglOczdkGD
	QhY/BhLU6Qofzw7rpsBkYXIL1wcrFL5D3jkra/YP27ipFA6a5edRvhAZyRAtEvGa2ayUBK
	bWXU3rwfvMx5E/UZHVo3MkgCv5/Pc9WHB+7dMrLeSJC+Ccpej/ZQbaQ5VV4W+JmBKnOMIp
	acB6RZEuQtvUduSUOjp4Ea2rFB54SxFFcP4Zj9ZUZ0yI8guEYDKyEryleA7LdQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>,
 Pierguido Lambri <plambri@redhat.com>, Bharath S M
 <bharathsm@microsoft.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
In-Reply-To: <CAH2r5mu74CbSKRVi0P7LD57j3t=KxqLX_M6V+qvi-aRE2t9YTw@mail.gmail.com>
References: <20250428140500.1462107-1-pc@manguebit.com>
 <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
 <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com>
 <CAH2r5mu74CbSKRVi0P7LD57j3t=KxqLX_M6V+qvi-aRE2t9YTw@mail.gmail.com>
Date: Wed, 30 Apr 2025 16:44:44 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> What causes it to lose handle lease but still have read and write?

We don't know what caused it from the network traces we have.  I was
able to reproduce the downgrade from RWH to RW against Windows Server
2022 by mounting a share twice with 'nosharesock' and then having one
client writing to a file and the other client remaning the file's parent
directory.

For more information, see MS-SMB2 3.3.1.4.
