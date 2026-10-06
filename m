Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8C2361667
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791301920; cv=none; b=QFFB9Blhfyd2hlp+slL19b+woZrKkXzkXmZqbcGzo2/DDOwwBgZqKc5MJvEzSVGXyhYKWY38QJfuioFwAvcULQ7dEhNgUeKY54QHa43A6yLSVfoVEdKjOUGpW4mxPd73AxrrdjDI+l0/WM8Vl90j+bsrNn8A6IpWDc5C/fRoDis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791301920; c=relaxed/simple;
	bh=tNTtUn1xl/DhiQhfBosKQ2AOJMNf4ccUpwY4udYMkdg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=IhjpwHo1c5PygxBko6ibLqjIq63oqMOhbtzuty4fRsCuro0eDp0BZQc63jQUN8EIB5u3lg6CMjlHUgJdXtLol2saQw9wo1qEouxgL5s9z5IIHa4psZXX4KyUT633VuoYcaDkQon3bTucsoxMJuLFeAxcSK/tdvmLSthdrbl4OTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=wlt2SK4t; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="wlt2SK4t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tNTtUn1xl/DhiQhfBosKQ2AOJMNf4ccUpwY4udYMkdg=; b=wlt2SK4tRcz40RyjUbVysfPadI
	ORPzf+ru0boydtVQFF/qEmQ+ysyUvpnfFcd/8P7PywzD4qLdQ31fj3XKIJRssu+ytmWXEX3uIVWbj
	SRPsqv8zmrW13qtaan1rqQEX2GqEx9krQIO/kwgU9UuanK1HY0UjslhPc8wEvXljGhbN3wvMJGigF
	Ibru9aziTeQWMd8cvs0e1lgxcLHhWZ/veYMSTv4b56vgrsiRDrRagzpzm5R/BPPP4/2t3gcQcX/Gb
	GBdc0+wnb3LgIv6Bf8uJDbPTiW5BIWx9fqOS899+A0Qgc6ErFxn1fdYDc8410bUkqcflQ3G9uC2q6
	1/qq4Msg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xE7SF-000000032g3-0GRd;
	Tue, 06 Oct 2026 12:51:47 -0300
Message-ID: <bf32ad6883839c45d61831fcca7a9017@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH v2 0/2] reconnect fixes and improvements
In-Reply-To: <asT6p2KwY3DLYDRT@suse.de>
References: <20260928150355.850472-1-ematsumiya@suse.de>
 <asT6p2KwY3DLYDRT@suse.de>
Date: Tue, 06 Oct 2026 12:51:46 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> Any comments on these 2 patches?
> We have at least a couple of customers with huge workloads impacted by
> this problem.

Did you send v3 addressing sashiko[1] and Namjae reviews?

[1] https://sashiko.dev/#/patchset/20260928150355.850472-1-ematsumiya%40suse.de
