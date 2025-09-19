Received: from mail.commetrax.com (mail.commetrax.com [141.95.18.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE0D2C21EF
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 08:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.95.18.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758268857; cv=none; b=CZKoEf0I5iTD4iG1Q6HkizWoSsIbIib5entUTqoQk7UBnGs/g3TaadR4meDaf2msRKGXS/dwOFZo8TDBPdPP5EKbvG8w2UZC2D6DGJfkL1dl3KUy4z9LFnc04JKkRoxdOxXYADiOt/UBlctCxNBjhkKAmqq9KeXOnTcQVKfrQ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758268857; c=relaxed/simple;
	bh=v3RQWSOntUoa93sDsYL7hYHyokRIR6tnNKjG7I6ek50=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=W9JvUUAvvl6+649dU/zen/N3/0LRMMzvnV4NdpbFsbVSbl6mIrAGEveuCxCi/jbHEGoW9KS8Q3Or4mWtCVB/r8LUt8jXuml8EYbjqlzmDIL7bTQLVmQKhJuV4wpZyMVG9mF+cMnbo5nFuZH6Zgr33Sjv0VL+fN4BrguJwGJvAKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=commetrax.com; spf=pass smtp.mailfrom=commetrax.com; dkim=pass (2048-bit key) header.d=commetrax.com header.i=@commetrax.com header.b=QUqVxtUv; arc=none smtp.client-ip=141.95.18.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=commetrax.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=commetrax.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=commetrax.com header.i=@commetrax.com header.b="QUqVxtUv"
Received: by mail.commetrax.com (Postfix, from userid 1002)
	id 67B87243DC; Fri, 19 Sep 2025 10:00:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=commetrax.com;
	s=mail; t=1758268852;
	bh=v3RQWSOntUoa93sDsYL7hYHyokRIR6tnNKjG7I6ek50=;
	h=Date:From:To:Subject:From;
	b=QUqVxtUv7doFYCZfuLJAZzaMchfvEBl7E9zpxmAu4nWI8vPtXA8zkI9de5BpELFnK
	 po+axrbhzPmbdsgJUO7koh6Fvtm9VMDJjLxFnSG8P8Dq65wniK4vCX1YN5bB6Qc+n7
	 LHLT1PK/kQRtU5I0St9R5A1Eo0AByg6cqKoC4hI1rs57ZhnF/jj7v/SgyBVpEW11ee
	 brYEMurV6iH/4VN+n47tzMi/oq3ON8KHqE+Tm93vseuBHmJTTnzHQInntljV5TcRiE
	 p0r8AcTY1mlx7Beu/kt5W94KAt8QrcwbJ/GHlVME7fNNaFOC+7qV7CaGZv8hrC8qIs
	 CCr/pdrecFFrw==
Received: by mail.commetrax.com for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 08:00:27 GMT
Message-ID: <20250919084501-0.1.bs.132w4.0.r95p1wqlgu@commetrax.com>
Date: Fri, 19 Sep 2025 08:00:27 GMT
From: "Luke Walsh" <luke.walsh@commetrax.com>
To: <linux-cifs@vger.kernel.org>
Subject: Outsourced welding teams
X-Mailer: mail.commetrax.com
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I would like to reach out with a proposal to support you in welding and a=
ssembly processes.

According to CEDEFOP forecasts, the shortage of welders in Europe will co=
ntinue to grow until 2030. This means higher risks of delays and increasi=
ng costs for in-house staff.

That is why more and more companies are choosing the =E2=80=9Cone-stop se=
rvice=E2=80=9D model: one partner, a ready team, and full responsibility =
for a specific part of the project. This is exactly what we offer =E2=80=93=
 from outsourcing to complete coordination of welding and assembly work.

Do you currently have projects in your schedule where such support could =
make a difference?


Best regards
Luke Walsh
