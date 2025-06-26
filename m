Received: from mail.marketanalysis.pl (mail.marketanalysis.pl [51.68.198.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435A2175A5
	for <linux-cifs@vger.kernel.org>; Thu, 26 Jun 2025 07:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.68.198.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750924068; cv=none; b=i4obiNu//azJlmzyQ+xeyzj55BCBZBzUaSb9zyYpLFCfw0YQjqTrSOt6nsqWaIM+ahnpDSIurt5m+19cNER+GKzGotmnds9hknD8RIenu+P6LHdMyip6Glv8yQW1jCSWoZfydsAaPBbvB+0PO6ZZ0zcZC3J6TDZwbSKHOGg6Xnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750924068; c=relaxed/simple;
	bh=+FIo8PEfnOjOhKqO9fikm05U23xQ9nuy82+HVQTYkFQ=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=O9rsdXfXZv877AUDG9+7ubkMG9hhd8lH3pZYe9S/rTmPeRosZzklAWVcBFKJ6edE8h2KIYzn5p6M55OMfHxOx10fiTOApMsMDSog+HVMkmxi4W7adLH5VJdfq2U6LgcRivT6fUEGPgxHqO8cLcPnwUwtmsCb2LtNo5DaqrtNnQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marketanalysis.pl; spf=pass smtp.mailfrom=marketanalysis.pl; dkim=pass (2048-bit key) header.d=marketanalysis.pl header.i=@marketanalysis.pl header.b=jhAfWJPH; arc=none smtp.client-ip=51.68.198.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marketanalysis.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marketanalysis.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marketanalysis.pl header.i=@marketanalysis.pl header.b="jhAfWJPH"
Received: by mail.marketanalysis.pl (Postfix, from userid 1002)
	id A1882A5B64; Thu, 26 Jun 2025 09:45:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marketanalysis.pl;
	s=mail; t=1750923953;
	bh=+FIo8PEfnOjOhKqO9fikm05U23xQ9nuy82+HVQTYkFQ=;
	h=Date:From:To:Subject:From;
	b=jhAfWJPHq3y1NVDVEQZ6Aum7ltmJCDIGDppUQovhv5zZ9/5p9Bp7uHvTrqwd9oKNn
	 3mgNmf5fhgVfRREPFWE7Uo0D1K5gH8B/TKle79lMJm57Wx+D6kHlws5c1IrzPCwdLk
	 hNUHZWPG23AUN5JrorAeCM29hVYaj26a5NhcrVqYxNeQh+M1KsFeUPgFf/oOLsmF2C
	 +ETACJ5Gjh4/ZUe1e7D4qtKFe0c87SjMzhgGttT07ZfPk3BAsc2vYa8+TcRWccOMjR
	 P6mIyHLOSL3W78CLpHQD2v1aPGV3B0qoKyDKg5B78MkVhqjVbb2K9zgB2VwLzNqSv6
	 KNIzah0P7pOcQ==
Received: by mail.marketanalysis.pl for <linux-cifs@vger.kernel.org>; Thu, 26 Jun 2025 07:45:29 GMT
Message-ID: <20250626084500-0.1.pf.2delf.0.p82h4467ev@marketanalysis.pl>
Date: Thu, 26 Jun 2025 07:45:29 GMT
From: =?UTF-8?Q?"Adam_Ka=C5=82u=C5=BAniak"?= <adam.kaluzniak@marketanalysis.pl>
To: <linux-cifs@vger.kernel.org>
Subject: =?UTF-8?Q?W_sprawie_zam=C3=B3wie=C5=84?=
X-Mailer: mail.marketanalysis.pl
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dzie=C5=84 dobry,

czy wiedz=C4=85 Pa=C5=84stwo, =C5=BCe macie mo=C5=BCliwo=C5=9B=C4=87 zap=C5=
=82aty za towar w znacznie p=C3=B3=C5=BAniejszym terminie?

Terminowo uregulujemy w Pa=C5=84stwa imieniu faktury u dostawc=C3=B3w, a =
po zap=C5=82acie wystawiamy Pa=C5=84stwu faktur=C4=99 sprzeda=C5=BCy z od=
roczonym terminem p=C5=82atno=C5=9Bci (30-90 dni).

S=C4=85 Pa=C5=84stwo zainteresowani takim rozwi=C4=85zaniem?


Pozdrawiam
Adam Ka=C5=82u=C5=BAniak
