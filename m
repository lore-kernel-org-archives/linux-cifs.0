Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762603CF57
	for <linux-cifs@vger.kernel.org>; Mon, 22 Jan 2024 13:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705930076; cv=none; b=Urdm1qpvSLt59YEMbrlZqJVc7xuwqcABRyWxzO4RCizMS/9vjc8DEnBQcWCq4eEi9QIeGJdMdB/t7T3aR44nvQ7V3S5THDUatj6V5td8qJslVG/MuBZWY5usZU3TCvx5T2A0KA+WPoDar19eQy53fep6n7UOD33ZM35SGvbA77U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705930076; c=relaxed/simple;
	bh=mo1Uk+/fhW3IPG1/cLxsjv2tQK6eqwAYck8QrbiGYJE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=D93bnKNBjBM9gwakrka8DvgzXGveNXgouJ9jzc14Xy2RiKG/OT6hBlntO8pQFNXa1P0i12wXi0mGXgHJ6i98ZRtyZE9TIceDtpu5oPs4/7wv9BUg6Anv0wdsfjuMLZeY5QqHKtPyUBjSdAnx1xwiXqdrDHUHD+FfR7rXrCufccc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P77MrDMT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P77MrDMT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705930074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6S41t4XvfGFeRUMB8juts0UssTcHbAptg+Nm1HjUcuI=;
	b=P77MrDMTCHAQbQZtsSAPKNs/185lwZnmjU4RvLg9IyI8AvSo4QrqCttZiPCcnfhqzWhTU+
	qOhIgVtO2eYwTnQta9dKvSDT3QmohQAsbEej0Rjipnj8rkzQIlxTYeTUCkz3RqP4Q+zZ8Z
	5ayMXmxcTYbeCl8rNTRoMiF8KhHMfdM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-jsdqrakFOni7kclJKVOa5w-1; Mon, 22 Jan 2024 08:27:50 -0500
X-MC-Unique: jsdqrakFOni7kclJKVOa5w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4344185A789;
	Mon, 22 Jan 2024 13:27:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38A1E492BC6;
	Mon, 22 Jan 2024 13:27:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mvpZEk0cf2VAu9AyVYs20uk7f9G4y8461F3WX2v+afpoA@mail.gmail.com>
References: <CAH2r5mvpZEk0cf2VAu9AyVYs20uk7f9G4y8461F3WX2v+afpoA@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: cifs: integrate with netfs updates patch series
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3837549.1705930069.1@warthog.procyon.org.uk>
Date: Mon, 22 Jan 2024 13:27:49 +0000
Message-ID: <3837550.1705930069@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Steve French <smfrench@gmail.com> wrote:

> I had to do a few minor updates to David Howell's recent netfs series
> for cifs.ko (to rebase on current code, and eliminate a few checkpatch
> warnings, see attached) but patch 8 fails to build  - see below (so
> only tentatively merged the first seven for testing):

I've updated by cifs-netfs branch.

David

