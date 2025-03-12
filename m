Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA7E23ED60
	for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 15:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741794700; cv=none; b=PSHQc2BoCRadZFsParHfx11g/tN8DP0NaFv+RbtmExPxo4cPdFZYmptL3ZMeIqBJ0XwJioDyV0SOwcXsL49l5m25hYcdJerF9kYDHhRY/oZ9lRJ5cvfGITBpfLWM7BoqaUQ6UiJ/ceK0onwTwLDnH6aJ5Z9O2+enPAchtsUXg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741794700; c=relaxed/simple;
	bh=ExpcWRF7xL/y9urhbP9acaAF/DnGniNti2zo1WioAJg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XTx+6I4am5AXYYbH2AjcWejB2B9Zyt7kPP5RLRmSz8fROhp/qeC4aV5aEssM92fHI93SYhmOOd67CwbKpiG4a4cGBl3/EuY9C4AOUhImfgh7BtJpsIFHrMOb90Zh5CWmZK5I2B+AUfzBjGJU+qwVNyQIkDC2x+UyBcTHVAb0fBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KJFQkP1i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJFQkP1i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741794697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjaYk9lEqeh3R5XH5DTdLutk5TtZoWwoSfzeJjL1RFg=;
	b=KJFQkP1io67eMANMzEvm4tiaMX6t8WY3dcfqDac3/M1ds15+khJeXmgWtCDlqChBiQzKsG
	8Ub2YYoHuo1oYBrwnQCaA3OXVG3v3xVD0+n+NLi9ixXrrdIyYPB4VVfLIK6nZs0pu2bOQ/
	w/KWfsODYS7wza5bABC+5h1NZTn/Rcg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-D5l1jRd8Ow2Xey6p8t1ofQ-1; Wed, 12 Mar 2025 11:51:34 -0400
X-MC-Unique: D5l1jRd8Ow2Xey6p8t1ofQ-1
X-Mimecast-MFC-AGG-ID: D5l1jRd8Ow2Xey6p8t1ofQ_1741794693
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2241e7e3addso11575ad.1
        for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 08:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741794693; x=1742399493;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SjaYk9lEqeh3R5XH5DTdLutk5TtZoWwoSfzeJjL1RFg=;
        b=Lmj/4UqvURL/mow9CpV8WrxfiS5fDoU01wsZ1msOvCku+CoK4S3QEJDbDwWSDYXnTQ
         x+MJ6eFZ71uGH3qSNUc+8Y2vmFcYSpw3A1fM8O00eCMFYjdAWfyhLEbmVvdyJsrb6O6e
         pKUZcOVbmaUyti4fmRp0PjaG2uapzu3vt5vZT14og7urVRbw0N5kEcJMJEettylQqhnK
         pymieE67WCK7kWt1fqSg/Q2vSnWEuEnl5/um2JSwzu8BBa8aBm8IyhVEkc7i5SurbCoT
         Y2Y0t/ngX6QJP6YJk0UtqS0tYicfNYZZxgabO+nboRV2h4kFMlgZAiS5PjP9dv6ySFfP
         sjkg==
X-Gm-Message-State: AOJu0Yzx/VOs3LPFNTfBqu5ewSqxz4UBYU8I71crkp3+MZWOfuYMsufn
	8SKV3gHHq7EbUq5Iw8TrVssVzPtJQk/A2ga0/9Pe6jd4yr2+k5BqnErZ/1AnVjWrY92tSC7X7iX
	JgJV05/3P5HRF6WqgMa3h88DKrlHtznz2JAqcnVaNwJqy1mYYCSPNar/dhw==
X-Gm-Gg: ASbGncvy2kJeUrF949qo7NGYv735FymD8Ki9eFOT/1+Sy7Gpk26Z6HilW1avE/Raequ
	F3RGGJLaa0ieD/gVjKZiwg+2DQrpB9iDDNMSvNjtbUINkz2Z0hlfvICoZNXvdwAm3X83iGSiVBQ
	rEUVnZ33vQaW+E3FToHVMTM/XkET1TUtadZkW9ljXELuBZ6PMhrcz2uaR56ACn8E3oaJsz9nSEO
	gEtFDioSz+7t3ByYHxSwIwnChStnYZPe7Oq1GqZCFNG0iZj3XkQOnRd8/G4BOm6DPBuVKbB9SzN
	tmCn8x9S/9wisF1PNWw7AMAakanqi7p6ZEDr
X-Received: by 2002:a17:902:ce0b:b0:223:5945:ffd5 with SMTP id d9443c01a7336-22593184cfcmr118647025ad.32.1741794693139;
        Wed, 12 Mar 2025 08:51:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHJHEN5KfrEimY+bxZvg/LMiYE9HF9aQPYGxsAH7wnsdcaXhHUja7TjsPDBj0lkkW8AK7QFA==
X-Received: by 2002:a17:902:ce0b:b0:223:5945:ffd5 with SMTP id d9443c01a7336-22593184cfcmr118646825ad.32.1741794692799;
        Wed, 12 Mar 2025 08:51:32 -0700 (PDT)
Received: from omnibook.happyassassin.net ([2001:569:7cd5:ea00:c6fc:c4e9:3726:7db0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736c8e06336sm7963782b3a.58.2025.03.12.08.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 08:51:32 -0700 (PDT)
Message-ID: <70d0157ac13725595d64978b11c4d3a91f417803.camel@redhat.com>
Subject: Re: [PATCH] smb: client: fix regression with guest option
From: Adam Williamson <awilliam@redhat.com>
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Date: Wed, 12 Mar 2025 08:51:31 -0700
In-Reply-To: <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
References: <20250312135131.628756-1-pc@manguebit.com>
	 <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41app1) 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-03-12 at 10:32 -0500, Steve French wrote:
> merged into cifs-2.6.git for-next pending additional testing/review
>=20
> Presumably we could also update cifs-utils (mount.cifs.c) to
> workaround this as well.  Thoughts?

Yeah, I was going to ask whether just not passing password2 when doing
anonymous mount might be an option? That way the new cifs-utils will
work with older kernels, rather than being a sudden surprise for anyone
who happens to get a new cifs-utils but not a new kernel, for whatever
reason...
--=20
Adam Williamson (he/him/his)
Fedora QA
Fedora Chat: @adamwill:fedora.im | Mastodon: @adamw@fosstodon.org
https://www.happyassassin.net




