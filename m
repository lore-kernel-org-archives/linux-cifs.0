Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="YzRrBSHV"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26827B6
	for <linux-cifs@vger.kernel.org>; Fri,  1 Dec 2023 09:54:40 -0800 (PST)
Message-ID: <fc5847aac02cc745c46136a513898d1a@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701453278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aDcHwLQNTI4RvAcH+sx4Fok80DCq//+Hi/Sa9zSL1NM=;
	b=YzRrBSHV9pCb/Ui5ZXLWE9yo+NHmTDDrTm52dnfdZQylabyHEoEveXGyTn10bfyF3Z84Du
	QRUQfUmjbTEVf5QPo+ZpTt4XmzW06CdY0sCcQQ1NAwCYT3pSp7p6IM+ca4NcPsU2jJlvND
	O9Wqe8fvkBXX1dJE0PXKWVJRuuzKQ/equ7y+jTbpzdgXA1YVTB6bLIZ13PeCchi3zG8eus
	6Cez9Z3T8vUkAPd41hTknCqViMSksYMpadULrWBwvx/Sl9Sq/wd/JAdicC4JDk+/BpZ3e6
	EZvRuyoavnZW/p7X3qGlX9DBkMlparC+QtCpZXqwNc9L0j0eJsvcX/9Qyn0OTQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1701453278; a=rsa-sha256;
	cv=none;
	b=Wc1BREpLn/vdrEnVLgH61xCt9QRxz7ZPxFvfPp7K6BkmDIjMafbyMJPH438RlQJUr28pFs
	HzxscCtjd3Z5Iv17+IUpy7H/VuoZsr3zaZvLYOlbpFxP8H70GSXkREoF2YhsYESQINTzm6
	Cspw2EprJUpUK4j2KYBBBWz+CFHyGurjaRfrNZn4DkCamVEuDzJarUnjTSL55vO5+cf0fv
	GFlJXRvAOMSSoUjUHvAO7sNr0lPLKpgN/N5bJdczfnlytrWJMM9nwmlnKoPcS+cncmbWnZ
	jdn0BqB+2zyz6sCOeQwwCI16XMnhRduEpH2UjoIFv2weZUg5Fbya9MtQ4WQcHA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701453278; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aDcHwLQNTI4RvAcH+sx4Fok80DCq//+Hi/Sa9zSL1NM=;
	b=kH8x6VzMxMTmPhX3zgS7q9aCt3j3pphXxuGYGAh1CCdAgNBZBmmKIuGos/4qnaS2nvoi64
	yJR9+1BBIm+0ZLrqkCf/m/eqzrMSOV+mNh41N335owGHfb8Zq4kDJET6GxW45nvajE39mv
	bD4mRMVl1VsDeZViRzOTsIK9Z4CnY4BuOmBwD0NbVymXt5TZOqNQFEjU9K3QFgsk0TFeFw
	W5RaSVoOKr3X25hQmq2M8YR26HvztLq4A2QiiY2EwhRsqmG1pgMtg/1x8KGahXRQRAVQA5
	C5mZA1tplw9kDFpuf3Q3KtWMeTCAPr/MrZdrGvRcNyiBH6DJl/XVXe5TxyNJJg==
From: Paulo Alcantara <pc@manguebit.com>
To: Jeremy Allison <jra@samba.org>
Cc: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>,
 ronniesahlberg@gmail.com, aaptel@samba.org, linux-cifs@vger.kernel.org
Subject: Re: cifs hardlink misbehaviour in generic/002?
In-Reply-To: <ZWobTKPFwuY1GNgi@jeremy-HP-Z840-Workstation>
References: <3755038.1701447306@warthog.procyon.org.uk>
 <d5c487188936f998eeedc2e2e3e726ba@manguebit.com>
 <ZWobTKPFwuY1GNgi@jeremy-HP-Z840-Workstation>
Date: Fri, 01 Dec 2023 14:54:35 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jeremy Allison <jra@samba.org> writes:

> Looks like a ksmbd bug where it's not checking for multiple
> opens on close with DELETE_ON_CLOSE set, and just removing
> the file.

Interesting.  Using 'nolease' mount option on the client make the issue
disappear.
