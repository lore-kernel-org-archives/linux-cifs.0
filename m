Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6B71F76BC
	for <linux-cifs@vger.kernel.org>; Tue,  3 Dec 2024 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733243758; cv=none; b=o1WARrrUhPJRkCRIsrIaBVpdXWInmrRVClKyOUQB939UvBn/3sRCUj5oVwGBF3T9Stu5GcWI2/YQWUoViebPlZ34+bhYh/2W8quj5ei6vbmlfPhXHQtuyXBqfOqx1TUuuHPr1OP01JbTLdR7mnRJ+6QVOvAUTenycSglQntxiEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733243758; c=relaxed/simple;
	bh=KjSyMjzqAkAbnFkoXM1gbHC40fHVHUtHU0IYm3CS7so=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=XeYwO6ZqrRkCxDfBgImiNE4VuLKv18fKHx87Jot7GKnpfeZIk1fRUnCXZLKu1djObkk/kZyCXMhZxLzFjnsB2XszOJgPEAIMu57A15zNcgSVgyq+OS9Zkp7VwOBgP+5AH+fsCDFgEKs3j7FplMnuv8rrmswREENOsvXg3B9BGF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3RqPvSk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3RqPvSk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733243756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KjSyMjzqAkAbnFkoXM1gbHC40fHVHUtHU0IYm3CS7so=;
	b=A3RqPvSkDNDQclRvOuZ4RqjaFGtoIpL40+qdO/ckjtp2izauSkce9r1ZKOeMTP09WfGF/k
	GXYtmAHwlYEWbZLSv+1TEoHSxKB8pSi+zwqScrg85U+N5p88cMdi7HjKZ3v9u1Ca1Ud0jM
	AtLubNzTV7yPKvKLv6f/r/D2OtA4pJA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-_ZYgf5BjMr-fezu2uZ_YZw-1; Tue,
 03 Dec 2024 11:35:52 -0500
X-MC-Unique: _ZYgf5BjMr-fezu2uZ_YZw-1
X-Mimecast-MFC-AGG-ID: _ZYgf5BjMr-fezu2uZ_YZw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A57D1955D47;
	Tue,  3 Dec 2024 16:35:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.48])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B90401956052;
	Tue,  3 Dec 2024 16:35:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mtJ-GtVWf-U5-WMrcg92cv+pd94n+F8phztuLKpYMv9Bg@mail.gmail.com>
References: <CAH2r5mtJ-GtVWf-U5-WMrcg92cv+pd94n+F8phztuLKpYMv9Bg@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: xfstest test
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <537403.1733243749.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Dec 2024 16:35:49 +0000
Message-ID: <537404.1733243749@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Steve French <smfrench@gmail.com> wrote:

> I sometimes see xfstest generic/207 fail (e.g. to Azure
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders=
/5/builds/281/steps/70/logs/stdio)
> but usually passes.
> =

> e.g. "write of 4096 bytes @5455872 finished, expected filesize at
> least 5459968, but got 5455872"
> =

> Does anyone else see that fail? or have a better repro scenario to
> narrow it down?

Can you collect some tracing from it?

It works for me, but my Azure I/O is so slow that it tends to overlook the
races.

What patches are applied, btw?

David

