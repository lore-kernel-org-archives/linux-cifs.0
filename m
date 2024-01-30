Received: from mail.totaltradecircle.com (mail.totaltradecircle.com [217.61.112.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D31679E9
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jan 2024 09:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.61.112.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706606002; cv=none; b=rQegIopffLzSgzA1UrDymFrF5+rRAehN0yKNmqTwBFJS/1qF5a2Zhi+tgkVQPymx+WAOlPr1yXRYWygU2aXiODnwmnYnpWk7hRR7gNtWpMHU+vOm/AVQEhdVyjs8RUWRvvTXmfx8GwVpdRXZtNEwC06+XEzWdraUaeB7UWeu68w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706606002; c=relaxed/simple;
	bh=Q+o3lnpDoF2X+Yfrmflkha+YTGaWlcOIaDF4AiyLnGA=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=quRt4/CecgSp6WLwD/CHNpvcyd8FprLU0xLdtFftJIvRn8+NCA05xf5qAvg+WRRcsA2Uhv6ybAO3NIsCCCA+gKPRU/d21IpijphtKJd2Ebcs/UhuVZzViP78wd8m4J7WFOn2yMCtZWD5YHrjwEd4tnCxHKKUBVlyydK8PnpParI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=totaltradecircle.com; spf=pass smtp.mailfrom=totaltradecircle.com; dkim=pass (2048-bit key) header.d=totaltradecircle.com header.i=@totaltradecircle.com header.b=EaB+2eEx; arc=none smtp.client-ip=217.61.112.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=totaltradecircle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=totaltradecircle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=totaltradecircle.com header.i=@totaltradecircle.com header.b="EaB+2eEx"
Received: by mail.totaltradecircle.com (Postfix, from userid 1002)
	id C0215827AA; Tue, 30 Jan 2024 10:13:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=totaltradecircle.com;
	s=mail; t=1706605989;
	bh=Q+o3lnpDoF2X+Yfrmflkha+YTGaWlcOIaDF4AiyLnGA=;
	h=Date:From:To:Subject:From;
	b=EaB+2eExpj1FzNZP6w+mCUBro1mqxmi2/x9SGSHW5HVFbttg//DGfsseUurx8gQaP
	 tTmI/Sg0vwolioYWrDmDd+uE2bLSSQ9k0zLUrYlyyvnbqB0dkIGsVsjbA0mhSzhH3m
	 kCSOE4RSAc1EmLwBpnTY5h3JGjUVR+8wLY1E2H+s+p5CC6XUmOlVTcpLFVFd3nMjYm
	 Gqu6kjhgiDLf/qy7xUazXIvE5Q/WPmcDXGCcsFraS/gLnYvNirGCuLcXP6U8QsX3FD
	 45aLo5fntI5AuVh+YIgffiH8Qc3q85IWpL8goBGBEo413nZD+f7Y9dLNJPyvh+dLbA
	 YRBdnWbb0TL0w==
Received: by mail.totaltradecircle.com for <linux-cifs@vger.kernel.org>; Tue, 30 Jan 2024 09:13:05 GMT
Message-ID: <20240130094851-0.1.2v.50ci.0.6b89hrb54c@totaltradecircle.com>
Date: Tue, 30 Jan 2024 09:13:05 GMT
From: "Edmond Downton" <edmond.downton@totaltradecircle.com>
To: <linux-cifs@vger.kernel.org>
Subject: Details of the order
X-Mailer: mail.totaltradecircle.com
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

We are a manufacturing company from Poland, and we have created unique pa=
ckaging solutions that are a novelty in the market and work perfectly not=
 only for ice cream, sweets, and other snacks but also for funnels, candl=
es, and lanterns.

This is a reusable product with a delicate structure, lightweight, and an=
 attractive appearance. It offers an excellent alternative to traditional=
 napkins that become unpleasantly sticky and soft when exposed to moistur=
e.

If you are interested in such a solution, please contact us, and we will =
be happy to provide more details.


Best regards
Edmond Downton
