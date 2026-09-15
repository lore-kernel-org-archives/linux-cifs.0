Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666CF4AF9EF
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 15:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487415; cv=none; b=e4HjdJNTHkckbiMh5RmBZ+EME/nCCRKYEbscJplJyIvUBgMM/UAHxlTBfhTjzR8LnD4+LEtLUFkX4u4S6noW4nBTgET+Dyjq5JjCvgEHs4eZux98ZWfn8lUxf+tRHPANuydEPFoRT6YpaMfpPuw/jXb+blpsC+eryNUjdxY+z4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487415; c=relaxed/simple;
	bh=cY1z6ES1KX17wWen73tjfc60pc5racjJxvUpbNV8Les=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=qOvdXJiKuuYjFebymj9x58UpEKUxbAhQDV3eoaCeT/zrStpECkSA3zVZZgS+Ssyhv9ud0waRHi62WZ9YCNnHzscbGJ/Reo+toGdkL1mwj3cuD/oaR6KI828+hmaZ6R4DBn9l9GdY2xwgaTVrE1+veXp+Z2Fhh/dKM/8WinEv2iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=dsd1uLDl; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="dsd1uLDl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CsseMELhZOpXExVsu3cuzn5zFYABpGK8t9y8k74e07U=; b=dsd1uLDlP0b5yCJk0azKDH/Vdw
	4uf5fFW53ZPlZVqsCcCiLjZ8yKtMtz90CrHBFXfuusBBqVVKiyDbTP6Ju6xm4wDC0dd/qWyYW2502
	J4oiFPN8b83ZkobSAgY0cMdwIgKQP6CIeWJguVjzZBq6IHNs/oCu8dGXWbE1KhYOPIaZilU/g23nh
	WEss/NJQAValmAPxvdwYzoxRuHeBPXudNW1DN2caTCwyTmSw88q8ycJuVgaEVtNalOXyuUXXY5FAY
	rO9E3bHIcSsza/UBQbzs2+WwrXY3Z1kdh06BIQZVyqeeRl6xBD38UOrmN/AApG3+IQwYkmovigCZt
	Z0VYNFyA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x6VQA-00000001VDp-2Ll8;
	Tue, 15 Sep 2026 12:50:10 -0300
Message-ID: <ed4bccef24c46bf4c4d9fe98b7e280f5@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com
Subject: Re: [PATCH v4 00/10] smb: client: fix OOB reads and UAFs in SMB2/3
 receive paths
In-Reply-To: <a4e7d433-f5ed-4508-8749-90c433262b85@redhat.com>
References: <20260913214510.3071370-1-sorenson@redhat.com>
 <a4e7d433-f5ed-4508-8749-90c433262b85@redhat.com>
Date: Tue, 15 Sep 2026 12:50:10 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> I can respin v5 without patch 8, or (assuming there isn't further
> work to do on the rest of the patches) we can simply drop patch 8.

You can keep patch 4 and drop 8 in the next version.  Thanks.
