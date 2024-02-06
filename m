Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C15712AAD7
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 08:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707207726; cv=none; b=miY5EVL1exDZs9dYRckFQcU/cBtwmXbPztwIjRUaBnIjawHZuH+zK2YI5qDKltXTFnt6yAVmcmhtCPAamX/K9A6yRiM1TYioD4BBxWkHxFadcdIHFnp9gsGaVCTgKgCXcTNah4mq3ggZZn3booB9YT7TQ/14eTaHDfaxBZQKzUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707207726; c=relaxed/simple;
	bh=kelaMat/AOTeAa8/plgeOwsnR/i6DPcZ9A5qzyjIPg8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=bdhAOH97WaSsyf610iTIOm3SHENEyHuQUdlJis0cPYTzxqOPuj9ZSI7IVc0NTViQcVGK2Cnt++roeV5dKRkjpRHOJL7gdql+Bv6y7mfneiPpupKuVPn5X1xQtM7aAv5bG7yZf8PkfAY2KpUSlEZYrkmH2UB7ITvanghsLplyBOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LtnpRot1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LtnpRot1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707207722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xWfVAO1uz9Wu1LuxFYpWyRes31teEZ7e3K0pGLWRHfo=;
	b=LtnpRot1c7xWwlCL7mKCZiLalWRA1CCE/SAVC3BjOOzdQWUjOQH7Hk6l+GKseSHn0aG0TT
	NUs9cNNrrrDx0KlAXQftxzTWozd9zbFkPcqsXjiygZ9dy66AnAbzrH/AeMHBZh0oX3U/2Y
	F3K8YzTLpE5Ug246bwQ4kFoTF1AaWvI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-s00yOtGBOXqQ2ry5FI57VA-1; Tue, 06 Feb 2024 03:22:01 -0500
X-MC-Unique: s00yOtGBOXqQ2ry5FI57VA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCFBC101FA2C;
	Tue,  6 Feb 2024 08:22:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.245])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38B31111F9;
	Tue,  6 Feb 2024 08:22:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a384b6e0-b32f-43b4-be09-99a919d78f91@rd10.de>
References: <a384b6e0-b32f-43b4-be09-99a919d78f91@rd10.de> <262547e6-72e1-436f-8683-86f7a861f219@rd10.de> <3003956.1707125148@warthog.procyon.org.uk> <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com> <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de> <3004197.1707125484@warthog.procyon.org.uk> <3113886.1707204762@warthog.procyon.org.uk>
To: "R. Diez" <rdiez-2006@rd10.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    linux-cifs@vger.kernel.org
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3114514.1707207719.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Feb 2024 08:21:59 +0000
Message-ID: <3114515.1707207719@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

R. Diez <rdiez-2006@rd10.de> wrote:

> > Out of interest, are you able to try an arbitrary kernel?
> =

> I'm afraid that is beyond my Linux Kernel abilities. I am just a user ab=
le to poke in some configuration files, and maybe fight a little with Syna=
ptic / APT.
> =

> But maybe the Ubuntu guys can. You can reach the guy doing some extra te=
sting here:
> =

> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634

No worries.  Steve can probably try that.

Thanks,
David

