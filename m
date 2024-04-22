Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D67152184
	for <linux-cifs@vger.kernel.org>; Mon, 22 Apr 2024 15:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713798609; cv=pass; b=JAcQrEQecZVKRNXWlpsTxQglL7mO9aVOg3ijYIB0OyWXFhs1QgwAki6XVzXJRxTibRbenHL5p03M8b0x6+eMqCMUwSPWzVkq6guz3G86Dzzl6R+GuC88KHfZvqFQKBCLm9tx1D38QCYjPndyGzb/QXlIfm9pApJBLcqXHjVwfOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713798609; c=relaxed/simple;
	bh=jBDwGHo7SsC5Na++72AunTqMeaaWo6+UF5VIsdwb8Ok=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=gqoUHxwR+F3W5QkD6noLapwOy8IYo3bE5CXnEXyRSUUzsZr5vj43WyOwo8UxyZ+NIc98l8uI0MkUcR5UB4tIa2i5seEdvfTTJDfF25c9BH3i7Z0urH0V6og13Y4NePJknK37kcJ2x2Tp+J1E1MEwzf12UR8ikdrMvpJWyKuR9vs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Yqv9ZH1G; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Yqv9ZH1G"
Message-ID: <6cf617eb193818174f91ccb1a969045f@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713798606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jBDwGHo7SsC5Na++72AunTqMeaaWo6+UF5VIsdwb8Ok=;
	b=Yqv9ZH1GB0MumBuNSdHX4lIvOSoze/E4G8hqS54dUnVTPy4AEijkHuaKH3yZoiww++b8YI
	66vwjaRaJeKzvQwvCxIMLrB1jI/2hc/pn/Ay4W3wbQwzO5uvQ6+zOYS9/nN5NjJKGmqCKd
	JA9PeQb3ATAvVln9D+aoD0AuiYuSugqCQPEz4XGxUcvBNKhqqkVY4G8HsHO0i+GkkAouyE
	zmxakENlNGxKW/cr74VuTG8jXr0re/1Hq8pvlCvESqpCz4e6+/pkjhaVuI1AdwdRVQ44J1
	o4W0+FYOclZotOPrmLgkNV4XfPjjbyIje590SqYcmzY+FByM+Q2RVPHN4iYpdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713798606; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jBDwGHo7SsC5Na++72AunTqMeaaWo6+UF5VIsdwb8Ok=;
	b=KYchHmNSoLghbIoyAx7zlNA6wfJiBsKJ+sxzf0MlLQwh6dYCNtaAI0dSZ05hzIEU6gAQWq
	9bCIRtCM2EzsfdwLpjFpI3CS5YjAJKgbHJOfo+dE7DlcHeTOtCXj9/lufHY9ilE/n1p7Kq
	lgCYS6ja9ogz1nQ7syUJMWKdwGFn/IkilFST/Q13kT9nyYc3HyPNypTZrFDtAuRq/17z7M
	gBEr0+5UgeAGEu3Pj6PlCWQMQzcMeu0zAMh8Ljp8DTgKtacyUYhnKA/e/p3EXlEHWLihfB
	QHcUUEW2ThuLVVXgPf/RhAW6jhtuMkWOGgbhC2FC0loDtIDvgp6/qxTbFwI9ag==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1713798606; a=rsa-sha256;
	cv=none;
	b=Tx6U8YHchjlCJdZn1fkht7k29SRvUcjGw4CGlaI2ijh3Q+DbE39t/3UcswSo+FESTcdVDd
	R0HxfGn0KnM1EgkgEpvbfr920ie2nrXYPjDlfWZuBpYJB3I9frAobhTgPzCyBy6f/1hQS0
	ef+DXZoFVkM8cWZe6g+xEx89H32pp9LTCTVFJoekM7sesKToPU6vUA5U0Jbl0fkkFloFZb
	zrKfWiO1Q1GMR7973gmkXnko4QRT4ondxrVBF7h6iEL0FlsPH/X4d1d7xR51MO+2vVSdeB
	NwKnypnjd2ZQzFHqNO30b++3WjV0ZjphUL8ygWJZnP9apEme/FoIF1Icn0wIDQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Pavel Shilovsky <piastryyy@gmail.com>, David Voit <david.voit@gmail.com>
Cc: linux-cifs@vger.kernel.org, Jacob Shivers <jshivers@redhat.com>
Subject: Re: [PATCH v4 1/1] Implement CLDAP Ping to find the closest site
In-Reply-To: <CAKywueRW3PoAJcfwPWANh-oJeop6VP6BXsSMVR1Xq2LcTmXKDg@mail.gmail.com>
References: <20240403052448.4290-1-david.voit@gmail.com>
 <20240403052448.4290-2-david.voit@gmail.com>
 <80e09054c9490c359e8534e07f924897@manguebit.com>
 <CAPmGGo7XogXA8RppeqOtidWsgL84u+J4SUB7-st=A9a2ooPriQ@mail.gmail.com>
 <CAKywueRW3PoAJcfwPWANh-oJeop6VP6BXsSMVR1Xq2LcTmXKDg@mail.gmail.com>
Date: Mon, 22 Apr 2024 12:10:03 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Pavel Shilovsky <piastryyy@gmail.com> writes:

> Merged it to https://github.com/piastry/cifs-utils/commit/770e891a8b7ad53d4d700e08cf8d3154028b4588.
> I removed a blank line and a style change around addr->ai_protocol !=
> IPPROTO_TCP check in resolve_host.c. Let me know if it is ok with you.

Thanks!

> Jacob, Paulo,
> Thanks for the testing! Let me know if you want me to add
> "Reviewed-and-Tested-by: " tags to the commit.

Please feel free to add:

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
