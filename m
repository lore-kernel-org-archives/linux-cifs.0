Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C92B1494DB
	for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 09:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767085648; cv=none; b=sGvTUJ0WV/dTbmVe4EgZHicVKEq8Irfvern1Vk/PDdo+1hV+Ld0p3hFjpllUXoXsDXsedj2YTE0uRd4Ne3PRTCeQxAbH95D+aCA/8l5BPp/hdy42+FVyW8HUwlqOEJlIlpW+7PiDYs0XXBqJJVZ2WA9IxjKzWbaY7CYQ8WQLWBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767085648; c=relaxed/simple;
	bh=T7Br9cc7xxSZKilnACm3k9gl4hR5g+ngzm7LBUaN3Iw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=b9iWrjEQxEu2bws2tLstl6YQNHLitvM99V2qT30rhLIWNte0TTwV/iRxLn4hLct/6v7rAeQTCN/vvbB8MPdO7bA1WKMaQnZ+OeZO51Sz235YeHMnXnvWcnVbOcSRFpG+Re/WecEpqkd62bMxrCP+DPzjudu/dC6rZ0yRK1aQp90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S0/LsCvL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S0/LsCvL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767085645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8s0WXwbpUrhqWCF6N2iAimDRlHSHIJxpUCF8p1ODxek=;
	b=S0/LsCvLRTgDUOnICabBEoNoYzOC7oumAUKIy1fNapMnQbiFvllx6mzg39h0q5VEaAEnid
	LkhCGefKX0NC1MDkIFISfuIpaW5PkntAon2/C9YhJhjosQ600EtEOQz8RceCp2T3UcM0b2
	m4TEr91Eak+h5T5emYSTn8v4CcdAe9A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634--JP4qd_9MNucNg4h2hVKhA-1; Tue,
 30 Dec 2025 04:07:22 -0500
X-MC-Unique: -JP4qd_9MNucNg4h2hVKhA-1
X-Mimecast-MFC-AGG-ID: -JP4qd_9MNucNg4h2hVKhA_1767085640
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12688195608E;
	Tue, 30 Dec 2025 09:07:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6F015180035F;
	Tue, 30 Dec 2025 09:07:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <c7d613d6-4424-495f-baf3-cf30ea70dc00@linux.dev>
References: <c7d613d6-4424-495f-baf3-cf30ea70dc00@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
    Steve French <stfrench@microsoft.com>, smfrench@gmail.com,
    linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
    sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
    senozhatsky@chromium.org
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1354091.1767085636.1@warthog.procyon.org.uk>
Date: Tue, 30 Dec 2025 09:07:16 +0000
Message-ID: <1354092.1767085636@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> I would like to make two minor changes to this patch of yours in the next
> version:
> 
>   1. Update comment: sorted by NT status code (cpu-endian, ascending)

Sure.

>   2. Update coding style: use tabs instead of spaces

Do you mean in the perl script?  Sure.  It's just that emacs wants to use an
indent of 4 in perl scripts.  It's probably possible to change that.

David

