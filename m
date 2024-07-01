Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F7215EFB8;
	Mon,  1 Jul 2024 13:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719838900; cv=none; b=oyk6/KUaIfpV7tl/NIISZjjIF7u5HqPJlJIEk5Kd/Zj+5sHMiEuazLmrAfPxaLAd6AOYTIsszJXR8QhkVuIE81MtirLbeQ/pwqadv5h3mF5J136LAphMo90KyTsfyciK60S8dx7nepO6YXCV/Op8RgMaanHNWcytHpdqHXff1O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719838900; c=relaxed/simple;
	bh=I5l4BmXzzjYrEFqjls37V5m4ptisjD/c/HozJlF8dEU=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=XZ7T48aTV9y6X+Z81mOOnB/BjZ/ymtxZ++GiNTVbRhitzG/ms/SWfMOHK/EVdbHFey5RFt0SfnO6u8AW4verTm1oBc+Ioq3soM1BdB8Zzr19Hr+5y0at2GRiFdYNs6LKlU640DwCyUHeA9Bxow70tqdJKf/jyhHbIRRqGoU1grk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=e7DPe1iS; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="e7DPe1iS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1719838880; x=1720443680; i=markus.elfring@web.de;
	bh=RheuWezdV3dKfPfPXlPzuZw1wJlMe7l1v3xBfQujEMU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=e7DPe1iSWlAR3vgcYGuyIxX8+4Oj1iGauSSTWqmeCInM+JIoldR/JT0WYLQWM/vA
	 IwdOoULXtOEi+zd5QnzFuqkPcDGjczE23hH7u6r1waODPFoB0quO7wf8+KOJoEn1O
	 vjQXcuEEVIm5rsjUixPTYnHYvtT2afrhJ8IuZdthwzBe+gnKBBvW7VNOXfnGuZCkR
	 xFZ6refvHVzdFk/PzCkOCIlFcennevibKRQiGa/b1+b7msX6ZQRgNgSpdf5e4Pzw+
	 UByOvECBuOz1UlLkpBCO5CpKAKCLWa8/joPUJuLK9VVgLY+04rfwpSJ3lVaHehFeh
	 /2ub96fwZV5p/JS98w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MwjK2-1sCezq2isc-014Pjz; Mon, 01
 Jul 2024 15:01:20 +0200
Message-ID: <5fecc08a-c3b7-4745-abc9-0f5b4de03c22@web.de>
Date: Mon, 1 Jul 2024 15:01:15 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Haoxiang Li <make24@iscas.ac.cn>, samba-technical@lists.samba.org,
 linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20240701064847.84726-1-make24@iscas.ac.cn>
Subject: Re: [PATCH] fs: smb: client: Add missing check for kstrdup()
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240701064847.84726-1-make24@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WGM+jFjvbr01rKJUJEZYPEiqQkoIMOHon5Q3YwwJMi5/5cPJkXb
 hWPKRkzf1iYYz3Zl3XNNJvJ6mUz2Y/Q1HjCp8NnX8jVgV0FLyaK+RjuMNieZDeMYsE3WPVm
 XEB797PD/jaIx0OSp6csgjzik08v9HIfoCL6cT5K8ANNGomp8ska6HAbTE/2JBMhH41BvRA
 F+wc6w0VU2O4veIVJFDrg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:n/hCUtUIstI=;SUHx5PArkiOBs4twGmmXl0aGEFv
 5g5IXJUuAVq/FhX+EfKgzJ52yGtoWn6fP4ZZp9m0TAkLfQS3LCwvWXpYvF0MD2D68znERpik8
 2wqSP6FJPuJEC8HNrGT7VOOTbGCB45jl2k0TSfx3De8ZtVq/lunJWx6M0uk2NdnfAOfGlb3OD
 /3GGNxctlAa2C02fNKFN/ojohyayJohKzXOPWoABfISpFbKFZYgHJZbf0xpREMGyTMXThL6sA
 fXTQHxT1jgfQcFmtl+rPEhTzlWzDYvrwMQzdrk1qUy7KliD4hNl5P10/Ghbi6Kl2f3lUeA4UR
 maVho+4C4tqZW1MIBcIurKBHv+RjwlrQ6khiU6GFwrUupBYOhSS07NIz+ikqiswVHQA6AlesV
 FL6JOv0ceG3j+CfY+z43QgFCplTHogtQ6mQFfTuOHcbPL+XQmHozKaABcclim8SHjqhscsfZh
 iUxBdK0AZ/ZPHiefjicqjovD5dvJYQDr3UZpfnMEon7C0QWuj9LSs0QTcPWQBM7CH6GQKaQYL
 OOQs8rrtWCHftQ8O0rWX4xsf/ESI+PkzOPRt7RfdzyTRpdFhwuEs3PoDJ1JLztdL7su/Ns5f+
 Qkzwg5i9gCh7fb9VhkitLeZIIlNiJtcjGfnyT1aXa4nc/3Mgwwt4zGgfB79Vt3F0U0V40pSCd
 YLBE2vsiysvvN33YYFQGwW3nSgp4TjmIzy0lM0TLZq1gwV1PqbEGde+/uwBtpalaajaTRa+fH
 b9jL6HlkU31g3me8D1NyZ5gBDojDEs1y4nv8gbKYzxtPyYD/l3QrovSx7aImJC9tIifrZZKxV
 gfzJTvWKo2stICzv8cCacu1EEQAF+2rmdxGNs9xLGl+64=

> Add check for kstrdup() in smb3_reconfigure in order to guarantee

      checks?             calls?             ()


> the success of allocation.

I suggest to take further patch/code review concerns better into account.


=E2=80=A6
> Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>

Will requirements be reconsidered once more for the Developer's Certificat=
e of Origin?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.10-rc6#n398


How do you think about to use a summary phrase like =E2=80=9CComplete erro=
r handling
in smb3_reconfigure()=E2=80=9D?


=E2=80=A6
> +++ b/fs/smb/client/fs_context.c
> @@ -920,6 +920,8 @@ static int smb3_reconfigure(struct fs_context *fc)
>  		ses->password =3D kstrdup(ctx->password, GFP_KERNEL);
>  		kfree_sensitive(ses->password2);
>  		ses->password2 =3D kstrdup(ctx->password2, GFP_KERNEL);
> +		if (!ses->password || !ses->password2)
> +			return ERR_PTR(rc);
>  	}
=E2=80=A6

How do you think about to avoid also a memory leak here?

Regards,
Markus
