Received: from mail.growora.pl (mail.growora.pl [51.254.119.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554C3283FE8
	for <linux-cifs@vger.kernel.org>; Mon, 21 Jul 2025 07:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.254.119.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753083324; cv=none; b=XphYAtqVBRconYFQGpTW1hUK3zrucQaHzqhPHHC/zZCjEoWL5cdvF/DnBUBOieofQvy41paEqFU/lrLpo0VK2S2H/Q9SuxtQl02Z1WYQZdAImxFs+6c7e+f58zOuoZ809tmXnnv/CZ+qGXiaqrVi4NC3L+HrRp6vTL93AKXvNuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753083324; c=relaxed/simple;
	bh=RSy3akR1+Z0TK1MqUcCTAhuNDshd4oA9g7Cu4aFIABY=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=D1gdhH5Gx7BPYfaG72QpXmkkkl/IwmgVBXbrOWE3QkYzsfVQHKlsEJwIqVtQMcsckWiu9pk8rsk940qVk58xC4wLNyW1Yx8cZGnTkU8CJAZFYXqotc3M2YcrvyFTj/rRzn3UITab280pUr8YgzMou/3OAzStom3jB2lbQQGxSCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=growora.pl; spf=pass smtp.mailfrom=growora.pl; dkim=pass (2048-bit key) header.d=growora.pl header.i=@growora.pl header.b=pG4jl6p6; arc=none smtp.client-ip=51.254.119.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=growora.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=growora.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=growora.pl header.i=@growora.pl header.b="pG4jl6p6"
Received: by mail.growora.pl (Postfix, from userid 1002)
	id 7DB4D2283F; Mon, 21 Jul 2025 09:31:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=growora.pl; s=mail;
	t=1753083200; bh=RSy3akR1+Z0TK1MqUcCTAhuNDshd4oA9g7Cu4aFIABY=;
	h=Date:From:To:Subject:From;
	b=pG4jl6p64wsnxbLqz3swtt0RzxTe2RUZyTym7tUq9PnOG1L+hLUqZ2wr6D448ZQQV
	 WJ2GI6kQNRZ0NeKMasNqQlnehJMpap87BBOj0Maacbgl9FPFK9bDWN6H9LnblFGcVO
	 scoRpQqrbhyA5dGeZXwKaZTUDkQU38n1PzOdWa+CHKg3u1o0r/21/JOOnAkmii/2NQ
	 A2ALbpaLZbT0AQaezk9Q8OgDbQQZsVWu221d8mmA1g4G53W3+JnD9NOIBWSF9EUthB
	 dqr3ozT/ZoOHgLRVCY+H2RjIU5+zTCvELy8dUeYYxqKLisotvS1jrw1rijaD6dsDtG
	 VWSlRrAQ4YPYg==
Received: by mail.growora.pl for <linux-cifs@vger.kernel.org>; Mon, 21 Jul 2025 07:31:04 GMT
Message-ID: <20250721084500-0.1.kq.29pit.0.17fxr5qbo1@growora.pl>
Date: Mon, 21 Jul 2025 07:31:04 GMT
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
