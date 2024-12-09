Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1182115853B
	for <linux-cifs@vger.kernel.org>; Mon,  9 Dec 2024 19:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733773381; cv=none; b=lQY0Bk7pxrhpY76dTJz+HgPGCnoNYNQYEHCcnGleU+jVhH4ZUNyXNGbhyLPDQejP0imvl6NB7ZDBLWwTtfMyd5K5QJI1nzhcQ+gQe1ztwOW0XC0GXf2FmXfimJykSz/WWj6TLEireGWkQf9JfZA0S/xCyDVg1PYo1vKTT7e9WL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733773381; c=relaxed/simple;
	bh=A3OCQpyB2eTj5070uFaRGMX3N4neA1J6CjFoTYi0Aic=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=JmL86ivrhwDy09urxW3d9X4hKWX8iOQkcROv0Epp++p/52LinXMOeOKdKA+COOImVRYeW1f/ZRbDcby3l3R+rdz30B0vIz6mHzG+YRifJrIXkOa+cV2zDhFvhNQCRJRiVCK1JhCxTsYmRVlaa7oEU+TIcF8260/Rw/l1VdF0GGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=VzcOZnKN; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="VzcOZnKN"
Message-ID: <829df5e75aba7f0857ff688689b52676@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1733773377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ajmSioU+88uG9MWf6dCQ1kvc9ZR7R1DFIT5uXHpC/8A=;
	b=VzcOZnKNw8jMW4xLOHV6Zas1qEOgpz6y5Dve5PV0E/SmTxr+2Mysy2dIXqBLSCRIh7CIY1
	Smn3JE407MOClH+WflFFcgyJ5E8J5jSU9vkhdGqi9Rr3/cj0GsVGvpX9HF284uBb/J3Tt8
	Ww6VbMjaHwb/3L7qUAWo4ahv4hYSmvcUy5AMugOCBH3WL+vR20rnO5ZxQC6SspOZlTdGXZ
	SUJ5KUrH8JDFg0vlXPaj5z2F9FZIkyoztd29ZNmQYSl9ZOqIM6NIVYsw236u0rVAzz3hNO
	2tNmq1BxVETZa16xmfcJuMjOngqbb2jMSdsEOvIX4MWqFDwH3ipHlQmRuXHiXA==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Ralph Boehme <slow@samba.org>, Steven French
 <Steven.French@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Special files broken against Samba master
In-Reply-To: <20241209193445.yrcaa7ciqegvs6fz@pali>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <20241209183946.yafga2vixfdx5edu@pali>
 <1098e751d1109d8730254ada7648ae4d@manguebit.com>
 <20241209193445.yrcaa7ciqegvs6fz@pali>
Date: Mon, 09 Dec 2024 16:42:54 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Monday 09 December 2024 16:28:08 Paulo Alcantara wrote:
>>
>> Yes.  Have you sent a patch with the proposed solution yet?
>
> I have not sent, I was not working on it. I was in impression that you
> are going to implement the proper solution.

Yes, but priorities have changed, unfortunately.
