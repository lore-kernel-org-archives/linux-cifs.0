Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C7330D406;
	Wed,  8 Jul 2026 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783521786; cv=none; b=hfG8ZOEaRm3vQ/rolOLIvqscXGHkC0licLvVgFc9V3UrzVjFlalWNX1nGmyFvwZA22UHWHEQD8zDYRXgQ7ESauuJN4/bxg3JA48m7AHdVUQDBDTMnLf3PHxGiFQLmNtARlq8Pabw0YB+nmyKkZvBI6DNLb8Qme3LPD0IGrQeCUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783521786; c=relaxed/simple;
	bh=Gwc2oyOBn66JfxvkdS5RA+xnNz2eZVZY3LFbywGMZI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Tf/Gk8kU+LMeUQ54vl8/wOUl8cW7QMf3nwG+dthN0XUA8ROciat9/fkfhizzjBGmbetAx/ysJp+ZgvSINwV7yaTmJGmWxz47KiYTHo6r7gF8illO1gc4RKVFH8xfhrv/R4n9ia8fVXh7O77Zd69j1aDCRjFpkNKBSJ9YG0Hx1gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=oDlDGYD5; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="oDlDGYD5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1783521765; x=1784126565; i=markus.elfring@web.de;
	bh=Gwc2oyOBn66JfxvkdS5RA+xnNz2eZVZY3LFbywGMZI4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:Cc:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=oDlDGYD5UZJM5YzD8dM7esKxpcyART/i3HP/NRxs8k9r3ldzbgpULWzPkErBZVlS
	 SMYiXkTJDig7QK3P+9xJmaGjYigV2pzIV/SysfPEIAzzrOBSSDf9nmu+jPfgblxbs
	 C25xJdD3hZLxsgfAZTic6+ccbCjLfEHHv492czY7tiB6DRWzKUHdygjeBwxUOVljp
	 OyMT9rDkPsnuVdoS9ZRHmihRT47EcVEDKlG7mToRNEtg+Y8dft+0IbpL8BAPWWS0I
	 d6PrPftKK3Be2tqdjRk21pn4/f54wQ+U4gOhCdUfJIBM5D3oioGpYVF5wZQKZRLQ4
	 EDCA9Bov+iHXUDaO0g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MPrLL-1wTwwh3SOh-00KSeg; Wed, 08
 Jul 2026 16:42:44 +0200
Message-ID: <24f4035a-e004-4d0f-bc39-244100f2a1f7@web.de>
Date: Wed, 8 Jul 2026 16:42:32 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix overflow in passthrough ioctl bounds
 check
To: Guangshuo Li <lgs201920130244@gmail.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
References: <20260708123520.761116-1-lgs201920130244@gmail.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260708123520.761116-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oTRkmTu9VKrwptTrZQkZ4N5wcI2My2TxnYvGLCSu9nsZihsiYRC
 HSEblPOhaBrES4mjjGNEo6q1pHlshnom9G2rr1USjgF/zV9IsrRUeMmv1dxxl/TsENipxXx
 fCW3lUiPy5z65uVA4cMAPuFu0jescxrlGR6f70oCOBaFA22eWblVuUSDtRdBv8lhvLi139+
 FxMeUmDxd05ltz45Lm2ow==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qaVpJ56J2s0=;UpZrgiKCJzmBd5IADHwZIELkalh
 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

> smb2_ioctl_query_info() validates the PASSTHRU_FSCTL response payload
> before copying it to userspace.
=E2=80=A6
> Use size_add() for the offset plus length check so overflow is treated a=
s
> out of bounds.
>=20
> Fixes: 2b1116bbe898 ("CIFS: Use common error handling code in smb2_ioctl=
_query_info()")

Were implementation details improvable already before this commit?

Regards,
Markus
