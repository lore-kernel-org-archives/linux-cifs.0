Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22131EF0A9;
	Tue,  3 Dec 2024 13:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733231914; cv=none; b=raE2H9Yy1LX1XPHerw5AckYzE58jLETAcn86cY6JBriL84I4KLdhmcLwzBLaTNDVPdi41xBKIRo5jdtqSLoD3lSPJbrcuStGz9bj+4eQOEBuhMeDPSj4MVjvML7Sd/KX0tHNS2sFUnXaAuQt4Wh4m6wCc53PgEDwHrinnrwRmEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733231914; c=relaxed/simple;
	bh=arkZn71AicmvNfXlYC9WFWkRS7Fpcj8pueowc+tjBhs=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=HtZ8UX5ao7RVSINJpfcPS00XvasZo0HcTTGZmHu/6k5+KWXTDTINW+kr8USM9kiAU+IttwcyDWsc8PyajNM7I4n6wbDNk8sjJVweR0MTcb1EhsVRPxzT3wom18uTh7QqIro6nFIhJ9AeniSc5iRZ4LOJtjEOxhHzTXb5LBuylb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=lFWipe3S; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="lFWipe3S"
Message-ID: <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1733231908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n52tYw9Pih3oWwVRYAf7wVYscUliGktjGFz4U8In5Ds=;
	b=lFWipe3SGDa6s+W30iuE9oKcOQd1NN1i8GuDZhdFFYD+VSXlDpFS0FDbof6GvTUx7ZLOUK
	zMTkXobdk1934CiES920BXIaIw3qAhay62NeMuYNRJrz1o4Zq5r/oft1egavBqMLq661MZ
	ieo6uFMvsa/0en/IWw7ESsxnAAaX0AGNHRvMg2gK9u5Lzi/Wwt+a3BUxDDvRqEJhy5YSLd
	lkRw3VYLcRyNU9CfxfOcLjDPNUTpovd4QOoxQ6FFwgQwHtT4aXB4zyHDCQTbk5zyxeLuSP
	bMDJla89w0egPVVzdBDhw5f3Aogk3rzw6tLBrpXXelHv+ymL0ojqw6hA5c6cUA==
From: Paulo Alcantara <pc@manguebit.com>
To: Michael Krause <mk-debian@galax.is>, Salvatore Bonaccorso
 <carnil@debian.org>, gregkh@linuxfoundation.org, Steve French
 <stfrench@microsoft.com>, Michael <mk-debian@galax.is>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 linux-cifs@vger.kernel.org
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
In-Reply-To: <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
Date: Tue, 03 Dec 2024 10:18:25 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Michael Krause <mk-debian@galax.is> writes:

> On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
>> Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
>> in smb2_reconnect_server()") which seems in fact to solve the issue.
>> 
>> Michael, can you please post your backport here for review from Paulo
>> and Steve?
>
> Of course, attached.
>
> Now I really hope I didn't screw it up :)

LGTM.  Thanks Michael for the backport.
