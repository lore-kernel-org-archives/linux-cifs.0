Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A723F15687D;
	Sun, 12 Oct 2025 09:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760262290; cv=none; b=WGRbYo9rDLikuvvW1m0E1/ErYQkrdmcIDCfJ5Cj0BBdhy4EQP7hNMZOyt/6vjvhUHp5YGZhU0/n4/EoEkUuaa2DTOYNxSe52JssvS4SkLlJJyBhJ68Lyoxv0+cwcGB+fAYWT8LOQU4AXlCje/mJoteZabG55QVk6FX6BvtrJCT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760262290; c=relaxed/simple;
	bh=9C9xfIVLIeJOgs/BNgZkXg7n9LRkgsh6vUgoctG8FC0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jxO93o41LfLpaRX/VQ62gVLdUqHfz2wrvhFuapYCrwZRoqzH3ucYeiGlrjvk8LVJaHnypYgZ6hPKTzHD3P67hhobgCAR5cV9jB0EBg2SEjtwVqF68dtWVAa/kJih4SSrBuWI8yQ4ghdrfqKijL40VlCn5s8c3vigTPjZBYy1dZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=HAZN9G1a; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="HAZN9G1a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760262274; x=1760867074; i=markus.elfring@web.de;
	bh=9C9xfIVLIeJOgs/BNgZkXg7n9LRkgsh6vUgoctG8FC0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=HAZN9G1aI86g+DsGvvxRSIB0kUSj1UglOfqKmz8iXRXZsrtIWZKbVzMcQmJ+PhRd
	 WH4L0RKY1Q7eYJeWyFMnQOlG+9MfFL8+B5qDS1b6kvGWQnGU0TG7CKvNTCMzt4oCd
	 QT1WLOrrig94AIg9gOwKsZYYSqUPaeSSm0Xny4ccMWVUxmhWt+p86jVUTh2enjf1G
	 M1ZagqVwd7vJ4CGs7wrrS2X724gTIDCVPNM5rD1K5KZJNBg1iOQEccfq6XQQBg85l
	 +kvCHJDYpGefi3Y1HHHb4eLttpsWVorxNJbvcjH+h1cetyedzEn0zuWnptNK3Enee
	 TArVsAwF2iyuYCoDhA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.235]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N5CQh-1u99HD1wfN-00ubqF; Sun, 12
 Oct 2025 11:44:34 +0200
Message-ID: <287946c3-488b-4fa5-a634-41d4e9d4245a@web.de>
Date: Sun, 12 Oct 2025 11:44:16 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [0/3] smb: client: Better exception handling for SMB3 hash
 allocations
From: Markus Elfring <Markus.Elfring@web.de>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Eric Biggers <ebiggers@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <e8a44f5e-0f29-40ab-a6a3-74802cd970aa@web.de>
Content-Language: en-GB, de-DE
In-Reply-To: <e8a44f5e-0f29-40ab-a6a3-74802cd970aa@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:eHnFKBfzovhtU/y1SJT7Kkie7NBgc0BxJUU3BaJ7+0cDWK0nmf2
 QtBZjVoPfnA/stUwcu2Y44IzNmSvn0GG7RKs9DNCUj2NHz/5bQ5AMQhT9NMw3bQi1aRHl4g
 rpM//PQDv4P85trGU5SjSPvqSIBMusZ2hEiBRmmOaQciPIEDTAXe4r3yqPZmRnVG5LNpYJp
 lP6cXDtbObVEkYq44Gb+g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:y6Oxl/FBjT4=;E1I2gzlNVKGnzHv3kygrUbkDBu1
 kWkt89dkfFSyteoLzO6S/I0WkyKCX2G5Pqh+ZhRRHYCCMu14/lbSMraeV3zJoiZs3b3DRW1K7
 mcQQC0Pv6aa83YZJQ6JypeXUendxh9M4QRcra8sdeN+3xbwdyjZgVtAfbYV0YgeAyToRbdmqH
 pG7ku/aweuu6CIjGWQ3BOYRFpnvkC6uW6vNI9JZDY0WlL/MqB/+YSQebVMmoBSAGsgp1P+xmk
 u7hcxbVek//ZjdvcmPhXfVN2mwLTP+9Ny8BLDPdq8wM9dA1zjWc2X64EzjVwOo+JW7V77LK2o
 qHU31GYssO7Mcv4PjYTe8Ab0S8QA4vCM3/ivE3zujoVA8FtuQ4hfmAywQKvOqQM3bEJ3pHSgv
 kHqQGj/5esA4Jg90kK9Eg7jlEUpGzbbYz4rIFqGm+9ob91wgeu2gboJTqNhe9cf3+yFwmzxdG
 X2GQNp7k8Jjt3JacbS1CYbd2T1Ib5rgzkydknwJVR8xX6wM7GddJfawMXiwOcSsznHMolVO40
 73iS0VaQnYWIyXLZ8of7NBUNvq46uiuFVsJh6Hu8AShub0J0Bx8vHU9xP3qrk63H6mPdkMpXz
 +ek4zZmfQgpDHQu0PNZjX3JEkUunuRqCMTlhSRad34Tl4eRea3hyN8S4b1lUrtPOTPLdflaWv
 1dWHo4CytML1pNf1qAHEtWUig4zZhshF6hsZ3HhdlkQ79Ucv3TQTtItKhiPWBPS+guVTPgNZu
 pCmqP4PK45zfG9+JkTzCmdi604X0w+VXPEPeSKbNe52ViETr2RCtWfYwMaqu4NlwTCAwN/QU8
 s/RVITOuEb3k/iI2DKgB+GFS5Ia7x+CXKl2U3sbnSuPsENEONq3a1pdhTz4TE+84/w+KdUu3u
 zHWxwzPr8nx3DSDh2+CqzHeeZgZpmlhdq8Fx4A+/06knU4c16htPHsJergkNzzrUqW3EIWK45
 Wke0reEKwwAz2L5QyvPt+VAyoDfaDTIJubgykXF0K9ZTxPG2hi4o8aGEZsENFXEqoyg6mvPK2
 xmVLDaU56tuV4vLlEUo56raApui6dNZzInSWdd6AbxLqBSGyrjeuANz9VuFoPTpOC7ZJfgM/w
 Q3zRNVEwfgMSU+Jf2744UhPY33Oak3yh9zrPruW/eijbejKjfX1jJFghYCEzzRzMoI/0OwmC+
 7U3Ct3yawRKRGBFsLfIcxwr4PhybaxcAcJpvmBmhMmuY7GcDaTdO6Jxm0kdVU6F1yLps3DLvZ
 5YDb/ZQ9yqwYFeiCvYLmTrfNm8fEJ1NIhEUl8XG0lQt7GGx6llipIL69wN2dNwwe3/2Sl0eBL
 jG+aXMPcns5WdqRxOIclohASF8yGFn2EfEscldt8a9goEn1P2lMmNY9nNpTJbdKTk1OvwSrzC
 e7h68fhQxk3Dp0CVx3l4nskDLxYrFXCpElB/7U4MDdfp8peem5edqlf3X27iT+H4UqLZxkJQf
 RudVswOwc2bFKBDIPvyWrMvYGlz3y0oydfxYva5gxk7c7UVLIIKfL+R0BCG0E1/Xl6fLmzjx+
 NNNZSTdaXTYvLUFH2Vz7wXMKhsOYdYpPA+H5VA+LbUYWEXflNNvjIxSAadDIGC0PkQ1tqhu2j
 fMIPZ7CC2rE2QU0afIiXIv25UghTD4c8FF9jR0JB1VT2tqZIhd9upgbx1ztOHiBRPXa6kusjn
 EjGdHY9xOaLMxrdX4PfjBTD8a+QMFACme/7kFdnAun2e+Fbsb3Hs44ca9iFnCSe/hv45MlDwE
 JfBqe1XJM+GBSHVIb9hly6Ajn2tqt8mBbnqTvjfQkd8AgyW9YocbrYMMG7rxBC6WzT2ys8ywO
 Bs3DYeRGc/WU7/oUqgMHaybjGgkRKVom273tXYYvkakIQHnjpnaNn2TxHe7eSXeO0TpcTf8V7
 Njp+BerQj7kXGJEhI2JZAgAybFss8Zh9dsndIF8g3M3dO8GDx7BwEh+37Aeh8wOpb7T8J2MZe
 6O6oR4JUstc66dzhlOv+Y7c8cXDVZdo6oM2Ln7IerUp2BIQpM5rjYRtVquf0HcLBGWWs9+scw
 v+P8i0ldTnoUIGXXeGHbJWp7kIyjMCW6M0gRv1eP5eQww9+qq1MMjW+sug+g6fhNsvevPRBkH
 LBg9o9x20da2fX9x3D/5n6sHtYmlZnhMWj+RiUc3Ff/1OaKYwFHUAEMhK4vloKiBHE7x3VgQv
 Fvu41KshinjEIi7LjowyCgL9BkJPjFweryU7fV09AMbfx+Ovt7MgR0qxgfSikCyWLdIFQ6Nnx
 4//UV1pDEqmikJ0D8kEZJ8MjPjkzLwSEvLnusGu5E932cwuqeNh44365k+Fw6Ch2kaymSCZSf
 TDf2XgH7xPwtYv+8cZlKtwIC9LbKHbgAa/9Rhxf2IFtFgblDtm9ALuSgfk2iWczxHNlb9xOh4
 AdNBG5ILgQ8t8SOo7oKutdw8QCzflLgWpfp6X9xFxbIeL5o6cfnwYksZwAxj4kztovbA/Fk33
 hLAxUWj8Ehd2bOsHZHMDg+PNwUbFcY5+DDkok3a3b+z4oHkwPWzqEC0isgRzKOZwhih2yuZvI
 QVRwnQJgAAzMAVE+0CyySysddV9T8HSOuVyROSXS+D2n5RKkwh8kjz1w87+t4GCVewiCUqB/V
 iTokJVHe1K7zUK0nxip/Ra+2pSwdS35R9+8BfTJVClsCIA5oLOu33Pyfn9VW0583aiA1QcQRK
 kMGOhMv3JybHAIhyv86RDvd7yca0qdOeT2YDQ25jaMcEPJy4TwXIQVofMPjLt3ASFW7S6W0QQ
 LGA088TSG69vf3W49We2tcRHIQx4LLfw4BP1CiPgvc9oGBBjnyXfVzcpriV19QKTx2eGp/34J
 N19v7PQnxHB71r5oryjVHEIQt7Mh4kcQz79/YcjnfGRt/V18ZHsPbDiyrzvqqBpOfAwoXds2O
 KHseFlNgiyRMdxt9Ts6sATmE7ByTamBtPKwgIyPASS4rCppHOF7PJxSI6nW+HEDznioIEW84R
 SgV1G0kJZarlwawIKQuJ3oH/BLOKmWRXBOTWeVVG0ZJIh7wRd5BtCAwXaKgM0/R1qs2j7S5sX
 A/TSgsIJqwSAcvDUYDZhdYKGer/Px4fICJNgmNyCmkxZtw+I7ePzH6ttmiXKbzT4uZtTLCzo5
 YZsLwxgnaC9WD9U2LkgVWv8mw+YC/DsAh2H3Tb8c9ETYbCtwr5bANWMy4TNJhcRsZoaF4CnXc
 GnU6dNteFRqkqRehgPUjTV6DfKGNuyucuHEdhAQiaP6P3XgKSwDE5Y27kLlNP4uY0d2TRJDGQ
 FW5zIccSEenlZBSV/eDHB4ThDb0N0KNH8Fy6tHAqDp6AArvZTxa5tbhqb1UG/sPLo7zPVCUT2
 mO4zoUfrghvbvdu0Ir1BbTU131XEetMflFURT0GmdAOxEh7v2DwsgZumZRue/IxvXba6ofLme
 07wNiXnkiKTbofUWzwOx+8lg9oU+3dc4/+wnXND7yr+mOK34dubu/pXrluVSX8spmwbzwKvIj
 zvD8qEKAeYt4ZghiTFt6d2gtJ0Cv1Dl2tdqGZdiMkovI9S+6T9l5RiBYTrTFqoAgXFOl4Oiz7
 fcTzpHbYERH6GDm3XLrWJFzY9PqnBP49XTwn2aIxCsdF8gmVRgn6AGtO3gUs3sCdWNx6xNMnc
 J1Gf9ekQsfx6FVu3kM8MX7KGUFeRs26RMJS9DCHs5rDPRgbfj5RXRWLjscN2d0a0LFY6Wp92Q
 NO16BzdZK1EK6ajy8KaSyrZgT4T5IPM8sQezomuy+cDVIBUP6UQ8zTLYMFWxdmvrR24crYf2L
 5IvK00H1MHYsqz2GtsoQXGSdyaux6x1qUeIuBLFJCQXEwGdy2a+OoFNOztPmWSJpvcw8CHfYf
 JFApzC+AwJH4jaZMtsfYH/ZWZhSb0HzHgg6PYNyVfGWQsiRnMdq0wTz6hYgcLbFtRmiCc2dif
 w3qcuHmwBA/DXIuItfZ2Z47i4VO8mrq21yHeqQDP1sqIDIFzBIwC7y0Sfshs70+KEEwb8qt9B
 guMiiMfcU/0lv4Rk6Ib/nozVbqraY6t2igeyA7lJp+XeB3jJ+8hPc/BoCqwwlYQx5cJf4xRba
 ok68pxSy488cyOlffoHjoFsuuZUg+eVpeSn5zPeXbBBkByoU64tnxCSOFemBZMLqYRlp08Lf7
 uqpLQSjLx+f2t9SB8GFxQmA1t8twayXYHieX/NwF4cE7sp0yC39gkWaL9xiZbYGUU+ca4tQ1p
 FLkMBE5RCV/rDMuHl5WsV2R9B9pmcHanYnGSP/GhIn/y4g8VWYpagrqxsxdrcw0xbrK9XJGwI
 ED0Lhj7sCzF/mqbyV40pbKCajP/dxnh/Qyraw5RNMs2jz8C2+hQX428fY5J3xkt06mR7ALdj5
 s2ks6e6Oz4aa/+NLoxg/35/RWXXzNy0QQRjxhBQ0Xb8qyRM82zTVsczf1qLjygaoZf6Vp6XoL
 vhpHqocKO8IaRjXYZLNYFM1Q8qlfoxKWZ+5mb7EktOr2D2y2BInny2Kpr1sO0Bxmx0gAIjRJJ
 qqYqE4mP+z6f0xJaVzOdOAvBBugwC1gQQtJynvJ2TVXKiRatAtXBwbIlBOAZebIBG5/fJPNIK
 olGPzNmR2oVosyWv9KclMuEVsA3uQpyfvKJk1rPc5pmSNNcEZnnx7jJFOLXvD730DKp8Pdz3w
 WOIwN+jQChqXloRsy7wvZeMyYLQnH9ToZ1/IWAvoo1NyzGy/a6Pfj+zM5HvLSYc8tFZ34HDjx
 W7IMz5eavLt9ugpL0URGNxoU6h/3kQppv8q9/jgELuIBBv4Eea2qBCtKRAISwHoA83qsnVJle
 DFPki+YFv8bMwKKUs5Bd2GEaidINC5dp4N/JWgYLA8jRY5yEdeHkZJt26SrQezjlDwvHsNscM
 E+kE/sJwxxcOY/JB5f5rMaL4SxWt/KRhcQTNngUY4lN2d61uSVScD5JQhaxZJUjD3uV5RUNhk
 prf2IrWuvedxUvSRssuvADqsjgiDTKlkcIvzlbxjdW/VlDKWbFxlIMnb+M+l+MGlnEUyixyfh
 /mvIg6uV4gtbMiiCEMZOmPPNazR+aDn8hKKsNvf/xK5RPbAHZHkrhZ19

> Refine a few implementation details for further development considerations.

Software components are evolving further somehow.

See also:
[PATCH 7/8] smb: client: Remove obsolete crypto_shash allocations
https://lore.kernel.org/linux-cifs/20251012015738.244315-8-ebiggers@kernel.org/
https://lkml.org/lkml/2025/10/11/443

Regards,
Markus
