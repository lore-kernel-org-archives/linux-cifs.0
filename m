Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792951502;
	b=P+MO114VZL4ZcrU6VZnZVMPVJXo8qcVUAefxOsmZO4b3qjM5b+IXYGZX358UT1tN7Vu6
	 a29nox4MGqHfyDosg6ELxvz5yR4aGcxhm4zLmiuUI4v6Xcz9zGx8Zky93gNltyk7/xYVB
	 QAfVgE03I+JLLzPseBykuCNjP8kjxEp0GElP1Y91keDgfKM3Y8aoeM4arbGn3pyOANc1s
	 PkcR/4Fy00U+ejMzrAR5ftTh0AQDsEgO0se2/vWreR5yDog4K41aUuA+EWrn43RoBz4zS
	 EqtYhacK9gb6CaKSZ+FRS4f1g5dWfp4HQR27oC3hAYZhCRWa0uZOuFV7bzC9CoVayUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792951502;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=CnVyvtnTlxDCNAyD44yaN4/wMBbGbKRh9CCf4t5ifW4=;
	b=3hV5QVaGvKmMO3K2TgIK9T20bsAp6QFJfiSw+CZ0cb9Tx2KMq/Xoz1LCIIk8k2ojKku/
	 DtqsCLmSgprsoVJfQMLdjGkej5MunLA/JtFE6h2jqIDg2R+yaUihvIZJ/sZtNLgC3fTRk
	 A9Ve1+yGPB6J24jsqA/3YT1fqso4rQIGW2WSx7fo9dVOh50Cbf7BNMDmDNEZHfdOgZUV+
	 uP1GCmoTPPqnhL+NKznGRisO7yKb8wtP7UDp+Gncp9E+EntTVg7xX6+5Svqcq1hLcp3TH
	 UDggT2XswSez/yq/OLpFkcy8gFiYfT19D0erzdKUW/f+oPtY7/N0YBpbUJCPuIAKQug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="EYKCK/ri";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A788606A31F;
	Sun, 25 Oct 2026 18:05:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A788606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=EYKCK/ri
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CnVyvtnTlxDCNAyD44yaN4/wMBbGbKRh9CCf4t5ifW4=; b=EYKCK/rinufTYAXWAB+pd1LZM+
	eBShHEY3H+YwPP+8RRgbKL0vzlnLIlkQYRKWxUn44vct1ohf9AfnzjL66Y52eQQmRc3CvguG1tzgm
	skNGKOqfh65ZwYWSgLqCYl9OeCCa8005Sfiwk85fuCmCariaoA7PrR+lnYAMngKFAG/NET/WqMTDc
	j1Mnki+b85476tmqFFzufhZJVV/7ek4a7nGZM1JfjWoBQGOAnXvteSF8RQQOx+KFwX7uWlRUZX7fS
	SJ7cfJz7a7iosjXStoTEKToZ+CXTg1Cs9yyC8lGIlU6aUAn0i0URKMlX90sUXoC7Fgd5wS1p7RboF
	4yzx6GYw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xL2aa-00000000CwZ-3s1U;
	Sun, 25 Oct 2026 15:05:00 -0300
Message-ID: <5037929e5c9e3b02fa889471892c528c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: mixalhs <mike.michalo@gmail.com>
Cc: bharathsm@microsoft.com, linkinjeon@kernel.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ronniesahlberg@gmail.com, samba-technical@lists.samba.org,
 sprasad@microsoft.com,
 syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, tom@talpey.com
Subject: Re: [syzbot] [cifs?] KASAN: slab-use-after-free Read in
 cifs_crypto_secmech_release
In-Reply-To: <18D91F35-4165-4679-A3A7-0B8F9A9E0F5E@gmail.com>
References: <8bb0534e33a5f5d152d2b1768d1fd7c6@manguebit.org>
 <20261024184605.44432-1-mike.michalo@gmail.com>
 <e071a5df45f7ccf80a9d899749e09e11@manguebit.org>
 <18D91F35-4165-4679-A3A7-0B8F9A9E0F5E@gmail.com>
Date: Sun, 25 Oct 2026 15:05:00 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

mixalhs <mike.michalo@gmail.com> writes:

> No KASAN reports in either case.
>
> Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

Thanks!  Really appreciate it.

I've updated #cifs-next with your Tested-by.
