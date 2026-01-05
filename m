Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8657C29DB99
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 08:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767600948; cv=none; b=ZqNYRhsXxkzQjmvaYXOND9/ENeTZRKp55V8q2xlSWoXwPVeTwpzFC5zH6DrLLov9BSD8CE8Mhih6YFH0tI2oKYoCwm2LaeZ2r0Lc4NWEd+lS8jHpaAvm4Qc+z5Q4/OQc5PcZSFB0dZr6y//wIg5+I13qIew8Bu8AtKHCfGHfDEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767600948; c=relaxed/simple;
	bh=QtVm32aqTv9jG/LwEO1K+YiTQ/k3k9DAJJeKfL/k0A0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=cyNZV+EUq9MTNOWQAqR++LkIe/qvCxdQYftMlAy6C6ikR9hjFThSVThV0+px0GHAJxsdFUwDurth1VaZpdluE/zrPz9+9uaqD7rhuHviQQ1dyBCMxJ+SLvpB6CIge7vVKuubNd4TzXBdc1TRCywo7Se3YrPUC1Vd7UFhEBHaiP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wp2VDeZv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wp2VDeZv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767600945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QtVm32aqTv9jG/LwEO1K+YiTQ/k3k9DAJJeKfL/k0A0=;
	b=Wp2VDeZv+VeRwWsc5c25+mi8ZztqeVMCM+1m5GfcZ+TOeHMfIY9Om7LA76uVXPTRqf45Rs
	Ib8IliomhmfnT/bpyZ981TBPQ5Yn48GYS1S8khNSZxJlRtQ3TA+TWOEEvyvi/2V5adCKI/
	gj+anbwLa0/fPvdpOm36z5IZ00wVLJY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-ambDp2yKO5SHzUAB1-CzyQ-1; Mon,
 05 Jan 2026 03:15:43 -0500
X-MC-Unique: ambDp2yKO5SHzUAB1-CzyQ-1
X-Mimecast-MFC-AGG-ID: ambDp2yKO5SHzUAB1-CzyQ_1767600941
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 532B51956054;
	Mon,  5 Jan 2026 08:15:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 05EE419560AB;
	Mon,  5 Jan 2026 08:15:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5677f64a-9607-41b9-93d4-7c256d1bbb14@linux.dev>
References: <5677f64a-9607-41b9-93d4-7c256d1bbb14@linux.dev> <20251231130918.1168557-3-chenxiaosong.chenxiaosong@linux.dev> <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev> <1696856.1767599900@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH v7 2/5] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1697247.1767600934.1@warthog.procyon.org.uk>
Date: Mon, 05 Jan 2026 08:15:34 +0000
Message-ID: <1697248.1767600934@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> The SMB code currently uses __u32, __u16, __u8. Perhaps we can consider
> replacing them all with u32, u16, u8 in the future.

It's probably not worth doing that.

David

