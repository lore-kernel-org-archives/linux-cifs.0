Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161CE1E9B07
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389397; cv=none; b=ksC25yUSmfFe8oRmPqCXyT/48LWmlrf52zypXJjoOV0hEf6jX8ModxEf33yQMMvUUSVNbsBxqpGVxwoOSOzyKJO0tYm9DklbakgqhyZjoUK/JydWz8b2O2Mli/QapmRTcUQdPIxy1oEC5VkO2hWUQIVf6Ag00UwpLsy0cSakyK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389397; c=relaxed/simple;
	bh=7dJixGBTt+NrdNAcuCoObOwarkWWWOSzHHtAYIPWrKU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=vC/n9mZosIf7PV/hpb2DDFWrNtPAhmolCi5ZLacCu5R51co8HLAm+dXAB/J6OQZzYeFK1Wl6qxBvx/BHr/YZ5Axa7lVyKNfZCgAYJtoi3lEvE+Irv5tlCuyKCRX+CAXJIWpV8vyJoohGvCJAgSjYQYw5MrkGdciPDHpnrffeeLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=aQ6kGq6F; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="aQ6kGq6F"
Message-ID: <37d0ffb8661d10b285f2386812ac6c12@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1737389394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sSx94nU62D4/SyhBNTvriyzcYOjkTf0wogVZD4dOFek=;
	b=aQ6kGq6FfssCjeO+5pNGXDyoPJf4i1/Ljt6r0sBh/KNHeOHchpubb3MnUhgSgGJGJamxQA
	mTFrqCQ7vpRG1NibQIjhhrVo1ycsUX51lLzSn5hw/H0eK8+9g6tffejClsYl6SJDUcnPl1
	53+MlSMnxqtPUDbIeHk/nM+jdDheRYdrlU+EiSCpjK9PMm42dDVVEkSb07elPkoIAfp6G9
	o4OLO3OpAQIjC8R/PnHgaacDZdewPiAg5f9USRk1SRhPDuGml/bGNVlJdCCAOfGUiBsS/v
	fhnqjSqP6blgD1NToXEzr7dl62vSXUqi3hBiqRJ6jC9L6bMY+S/hDrmvrqoJlg==
From: Paulo Alcantara <pc@manguebit.com>
To: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Pavel Shilovsky
 <pshilovsky@samba.org>
Cc: linux-cifs@vger.kernel.org, Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH cifs-utils] configure.ac: libtalloc is now mandatory
In-Reply-To: <20241226204212.2311264-1-thomas.petazzoni@bootlin.com>
References: <20241226204212.2311264-1-thomas.petazzoni@bootlin.com>
Date: Mon, 20 Jan 2025 13:09:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thomas Petazzoni <thomas.petazzoni@bootlin.com> writes:

> Since commit c6bf4d9a59809fbb0c22ef9eb167c099ab8089fb ("Implement
> CLDAP Ping to find the closest site"), libtalloc is mandatory to
> cifs-utils. This needs to be reflected in the configure.ac script to
> get a failure at configure time and not build time.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> ---
>  configure.ac | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
