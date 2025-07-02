Received: from mail.growora.pl (mail.growora.pl [51.254.119.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E810211F
	for <linux-cifs@vger.kernel.org>; Wed,  2 Jul 2025 08:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.254.119.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751444102; cv=none; b=oCZMmpunz80Fuzs++oKbOMdOSywbotmmLeVxqtGJOnjUlOSAXLrHbtfSDZ3E6oU3DYxqKiYWW9gKlarn0t1ReE2xXPkiil1k4MnbVkOyNEZB7nIhSFZAxIsYDRurhiC9cud7AIbXBWAK6jYOVBTsh2OIYIw/VAN2ZvQ22q6c/rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751444102; c=relaxed/simple;
	bh=RSy3akR1+Z0TK1MqUcCTAhuNDshd4oA9g7Cu4aFIABY=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=O9fHe3DdLqwCHOvAvYs35/sw51fuuP0OK2EDtEn2aHi5Vq2Xm2TVFmzWAzGSc53pD6XV26jLdr5PveYsNuk+lclM25nKv7nYFeVmk1dF1gNry/XgYlj7htKXIdIOLtop2VM8DBHhjBd4gKdsp9o1mWGr7Ve+9R9lMfA0FzJCEnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=growora.pl; spf=pass smtp.mailfrom=growora.pl; dkim=pass (2048-bit key) header.d=growora.pl header.i=@growora.pl header.b=QIMlUlvC; arc=none smtp.client-ip=51.254.119.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=growora.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=growora.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=growora.pl header.i=@growora.pl header.b="QIMlUlvC"
Received: by mail.growora.pl (Postfix, from userid 1002)
	id A3BC3247E0; Wed,  2 Jul 2025 10:10:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=growora.pl; s=mail;
	t=1751443867; bh=RSy3akR1+Z0TK1MqUcCTAhuNDshd4oA9g7Cu4aFIABY=;
	h=Date:From:To:Subject:From;
	b=QIMlUlvCsisPc/DTgw2nCxk6hnPjzVMeQeXyYJ7Kvk4psEls/4QlC5M6/iAn9Nd+T
	 VbmopHOWDVvby87XSPFv0boqwzzUNjBm+gDs+PWbi2YzIaua7UmxOGJFq3ZAh54z1j
	 GR/0P/FkpbMVlx7fVOp7SUUJS984fNmqk69tcpn7WSEbp8nraau8T+mqcNmJ/NrTXw
	 vV61OhyirsChadaiY/hQvsHdj0j/qLVXtFgx7OCvYbesFq6VrV9lK0zuJomaXUyUa+
	 nvRjWQ0OwO0YgCd8OhD39+csdlt3awmRTUhsXyK38isGRo7olGOjRGzo0sf25etXFN
	 YjK2QyhgVjT0A==
Received: by mail.growora.pl for <linux-cifs@vger.kernel.org>; Wed,  2 Jul 2025 08:10:24 GMT
Message-ID: <20250702084500-0.1.kd.23my9.0.bjf2v14dr2@growora.pl>
Date: Wed,  2 Jul 2025 08:10:24 GMT
From: "Mateusz Hopczak" <mateusz.hopczak@growora.pl>
To: <linux-cifs@vger.kernel.org>
Subject: Wsparcie programistyczne - termin spotkania 
X-Mailer: mail.growora.pl
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Szanowni Pa=C5=84stwo,

czy w Pa=C5=84stwa firmie rozwa=C5=BCaj=C4=85 Pa=C5=84stwo rozw=C3=B3j no=
wego oprogramowania lub potrzebuj=C4=85 zaufanego zespo=C5=82u, kt=C3=B3r=
y przejmie odpowiedzialno=C5=9B=C4=87 za stron=C4=99 technologiczn=C4=85 =
projektu?

Jeste=C5=9Bmy butikowym software housem z 20-osobowym zespo=C5=82em in=C5=
=BCynier=C3=B3w. Specjalizujemy si=C4=99 w projektach high-tech i deeptec=
h =E2=80=93 od zaawansowanych system=C3=B3w AI/ML, przez blockchain i IoT=
, a=C5=BC po aplikacje mobilne, webowe i symulacyjne (m.in. Unreal Engine=
).

Wspieramy firmy technologiczne oraz startupy na r=C3=B3=C5=BCnych etapach=
: od koncepcji, przez development, po skalowanie i optymalizacj=C4=99. Dz=
ia=C5=82amy elastycznie =E2=80=93 jako partnerzy, podwykonawcy lub ventur=
e builderzy.

Je=C5=9Bli szukaj=C4=85 Pa=C5=84stwo zespo=C5=82u, kt=C3=B3ry rozumie z=C5=
=82o=C5=BCono=C5=9B=C4=87 projekt=C3=B3w i wnosi realn=C4=85 warto=C5=9B=C4=
=87 technologiczn=C4=85 =E2=80=93 ch=C4=99tnie porozmawiamy.

Czy mogliby=C5=9Bmy um=C3=B3wi=C4=87 si=C4=99 na kr=C3=B3tk=C4=85 rozmow=C4=
=99, by sprawdzi=C4=87 potencja=C5=82 wsp=C3=B3=C5=82pracy?


Z pozdrowieniami
Mateusz Hopczak
