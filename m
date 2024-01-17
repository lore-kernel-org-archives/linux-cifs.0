Received: from mail.totaltradecircle.com (mail.totaltradecircle.com [217.61.112.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7567112B6A
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jan 2024 09:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.61.112.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705482437; cv=none; b=XznRvHHRi4dCUApLT+JqCw7Nq8zJe0epVXfeOclJuhfd3AtOEEBo39hGKtQLoll7AKfd5PXzo+JrrJyybmRsLHGibwSc5M4jwSDES8QAwXKNARBhRCOoMe2r3uMDZEJb+ppLimsOAvhJ5T+hV95K+PepvUEjrvyj94sTckyFUtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705482437; c=relaxed/simple;
	bh=Q+o3lnpDoF2X+Yfrmflkha+YTGaWlcOIaDF4AiyLnGA=;
	h=Received:DKIM-Signature:Received:Message-ID:Date:From:To:Subject:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding; b=tgDuJi4YhsJx4uPm5gG+dETgaL6u1gNQwO7V+0I8aT8GzsKe8chdXNDH8SyQObyyWmxUHwywYhiAppDcOaLKTz4rceZOIzHv667uB3n+vn+uj0uEfwYfXj22impuY3pZHcdGvdBxj/+AnKI+UjTVMCm9X+W3Ej3VaOAW/u8KVeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=totaltradecircle.com; spf=pass smtp.mailfrom=totaltradecircle.com; dkim=pass (2048-bit key) header.d=totaltradecircle.com header.i=@totaltradecircle.com header.b=NgysNyEN; arc=none smtp.client-ip=217.61.112.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=totaltradecircle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=totaltradecircle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=totaltradecircle.com header.i=@totaltradecircle.com header.b="NgysNyEN"
Received: by mail.totaltradecircle.com (Postfix, from userid 1002)
	id A8B29827E3; Wed, 17 Jan 2024 10:00:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=totaltradecircle.com;
	s=mail; t=1705482041;
	bh=Q+o3lnpDoF2X+Yfrmflkha+YTGaWlcOIaDF4AiyLnGA=;
	h=Date:From:To:Subject:From;
	b=NgysNyENBuL9GnRqIxV9RAIMmoxlgR3EeM/t3vc6A6t9S238BLoTm6W1MT6tNc0bm
	 qgnB/4jh4DbqHwKt9fEcPZi/ijrTwQoCfgH4Pfaz9zFoBPB2ygTUdt/MLTLKG+5j/6
	 wEuYc7vH9s0FQxMtUunzirddZfDJNXeBW/PxrXRIHoP8sRYt4cu4nZw/pHBT/DxJpy
	 kIqYqwzY880AbW+6gTZ8AiMxIBBawizC/77Hc1dnjSlkk5Y2GtWS6ppjKXZax6kuQO
	 +/LjS8aWJmOp+ZZV0g5NtzuqCKPwyWyecqWBCI9I3Y+HZvTrQBFup/Bg2cgjoWiIH6
	 iFWv25ne9WI1Q==
Received: by mail.totaltradecircle.com for <linux-cifs@vger.kernel.org>; Wed, 17 Jan 2024 09:00:38 GMT
Message-ID: <20240117084500-0.1.2m.50ci.0.jwn4mjkfjo@totaltradecircle.com>
Date: Wed, 17 Jan 2024 09:00:38 GMT
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
