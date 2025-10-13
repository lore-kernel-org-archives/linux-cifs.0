Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA310156CA
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 12:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760357831; cv=none; b=mv/PUSgYpP8GenpfRPUi0rVEVa8V/H/0qN0hH3DRNdT6WNcgETjuEMyqU+dy1L/t+iDR15Ii8z0wR9RW/Pd0d85Ba10WIjP3XmBMTMefb9SG2hh+vNSG7DZC6ta9vPZ74nLXs9r9w0Fk+9gq5eJra+sDAGALIpNS/gZBwiILplo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760357831; c=relaxed/simple;
	bh=3BYzlot5v7ctNT34wrzPZGcB+3LZLjeuOR/yvEPGpUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DbZ4zwHGAlpZJMcYxlUeQZdL/WAKjLAzJf2nuZ5PoX10zql2smwgAoOeqKIEiD0PQmPM1b1pDdfkWoa6gs4VaeUBr1c3S5NyQM5iEeerSifPigDAiSwn9DYIAMnBlU2nOBR/iqUuixHiz60IPwq1LrZM7aRGctrSUgazjKIsKbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=heQINvJR; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="heQINvJR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760357820; x=1760962620; i=markus.elfring@web.de;
	bh=BAyNqSSrJGUl7HzMWFCaJF4Em7mHepMhTO6rd20deF0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=heQINvJRw8qPIiBjyZl2G+iwcdJ+yQ/UPQK02jCjhFoPi1KkTPPyQLmqOP730zgO
	 kAuf0agCBM5z0ws2NyMlzarFqSIMbOvW44CyDsIi/oX+NoxJ17cr8BB4j2QhD7zaj
	 fQlUnAZB1qEzWkrDtlhz9F7b88JvoBCDg9XD8JpaSOd9GyRYkSsGm71wpW0/9HNUR
	 IhrdsFzxYdlZUA8nlw+lo+VUkkw0kDkcy2LIK0NPH3QXX0RmJEH/WkvYUPQf9gxZE
	 jtBe3Qci444MeGa4/32EwCLgCJeYcPQH0GIo7IvU16gBiLdPtOK1Z4QSeXYPcXG7P
	 IqWOtOTC1AlqaYJO/A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.186]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M8C07-1vDWXf37rv-0051Fv; Mon, 13
 Oct 2025 14:17:00 +0200
Message-ID: <1865e9dc-c6aa-489d-8945-e5a29a470523@web.de>
Date: Mon, 13 Oct 2025 14:16:59 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5Bcocci=5D_Improving_source_code_parsing_for_?=
 =?UTF-8?B?4oCcZnMvc21iL2NsaWVudC9kaXIuY+KAnT8=?=
To: Julia Lawall <julia.lawall@inria.fr>, cocci@inria.fr
Cc: linux-cifs@vger.kernel.org
References: <335b0fe9-313f-4e3d-a01d-1954f3c46489@web.de>
 <805f36f6-ea15-cbc9-f510-45856eb6f6d7@inria.fr>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <805f36f6-ea15-cbc9-f510-45856eb6f6d7@inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NyWp/2GHyBJad5sAMyy+Abh5FesQUWopNdIxWqM72LF6H2tZ12N
 G1Up4cA3IgfTppe/p3+psqeuOL3AltZtrT4mcPBhMV7MJ4UjO8vlutIl5ouz/WZRK2HWVkZ
 dzZX2ozUHGLS5auDtlN6aHU7VSCYAi1edsjbv/7YyK9+ocJ86BQyj0M15G/h/tl2ypgj6CN
 xC7pffsgRstemlbwNvk3w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:t9j50hlWv6s=;Y8myFg5Mqn1he0prNu8Jd2GU4LI
 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
 +bup92JsERF0kc7ki7BtmB3U8KCruoqEq1I=

>> =E2=80=A6
>> bad: static int cifs_do_create(struct inode *inode, struct dentry *dire=
ntry, unsigned int xid,
>> =E2=80=A6
>> fs/smb/client/dir.c:211: passed:#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGAC=
Y
>> fs/smb/client/dir.c:280: passed:=20
>> =E2=80=A6
>> nb good =3D 679,  nb passed =3D 7 =3D=3D=3D=3D=3D=3D=3D=3D=3D> 0.72% pa=
ssed
>> nb good =3D 679,  nb bad =3D 283 =3D=3D=3D=3D=3D=3D=3D=3D=3D> 70.79% go=
od or passed
>>
>>
>> Under which circumstances will data processing become better supported =
for such files?
>> https://elixir.bootlin.com/linux/v6.17.1/source/fs/smb/client/dir.c#L17=
8-L455
>=20
> If you want the problem to be solved, please make some effort to narrow =
it
> down to a smaller number of lines.  Like 5.

I guess that you can recognise remaining development challenges for the Co=
ccinelle software.

Will the chances grow to support preprocessor directives like #ifdef and #=
endif better anyhow?

Regards,
Markus
