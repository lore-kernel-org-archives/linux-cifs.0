Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3212BE7DB
	for <linux-cifs@vger.kernel.org>; Fri, 12 Dec 2025 09:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765532518; cv=none; b=ragHlRNY3yyTgdp0laf9bvbXJd1C8XrRM0woMgs147WYRFaT21U1j1WYsLm+bpp7uzKdEL0ET9i7UXqflAgiHnhMutxnW8L/Nh+nEK1d0DFMJaoY7rgYX4q4M6eJ3geCDLa0HpNXxJivIXd2wra2GkPS1DthUiYt+s39rTTzJU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765532518; c=relaxed/simple;
	bh=BF9ek5MpVI6SUJFQOia7nonzzEAfmhXaRQHQCCLHQKA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=naOrcnKD402Qjably2hldDDsfOQmFbk9rTV66nGD6RRglHiAmYkrLx7AYBW1Ry44DX8cT0HySJZvcNaYOLfqoQCpPpKTxXfedqLBjETA6D5oV4EYML+Xm1XTww7G1B9mYbEU5RpAYWbFbvnsnNZjS991KrvfEEIBaF6BixE4PZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ix6doKwU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ix6doKwU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765532515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AKaBD+kakiww/gs3KzKGxRoDKBObQTNyCy5SSxqvpc8=;
	b=Ix6doKwU+VrAMMnvZ4SJTSmXV9qfPTkpz32f6ZPD+rUeQ1TPivogx/6VtJ5rVzzjGSVmbg
	xgSutO8nlLcmKCvAV0z8oVyGYegIBJIIRo79jlpsg35U+DkDfdxbweJL3uK+88LZC9+STG
	u/jmUYwDUz9TzqEgOIE2eXPNZJzmKTk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-m3HbcGHjPMWeUmQ8Y_AqjA-1; Fri,
 12 Dec 2025 04:41:52 -0500
X-MC-Unique: m3HbcGHjPMWeUmQ8Y_AqjA-1
X-Mimecast-MFC-AGG-ID: m3HbcGHjPMWeUmQ8Y_AqjA_1765532510
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 470E21800358;
	Fri, 12 Dec 2025 09:41:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC85D19560B4;
	Fri, 12 Dec 2025 09:41:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8f3290fe-d74c-4cd6-86f4-017c52e1872e@linux.dev>
References: <8f3290fe-d74c-4cd6-86f4-017c52e1872e@linux.dev> <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev> <650896.1765407799@warthog.procyon.org.uk> <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev> <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com> <782578.1765465450@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
    Paulo Alcantara <pc@manguebit.org>,
    CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>,
    ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH 2/2] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <811839.1765532505.1@warthog.procyon.org.uk>
Date: Fri, 12 Dec 2025 09:41:45 +0000
Message-ID: <811840.1765532505@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> Please see my minor suggestions and KUnit test results at this link:
> https://chenxiaosong.com/en/smb-map-error.html

Okay.  Note it would be useful if you could reply to the email with minor
suggestions so that they're archived along with the emails.

Also note that the format we end up going with for smb2status.h is up for
discussion.  My preferred idea is something along the lines of:

	enum nt_status_codes {
		STATUS_SUCCESS		= 0x00000000, // 0
		STATUS_WAIT_0		= STATUS_SUCCESS,
		STATUS_WAIT_1		= 0x00000001, // -EIO
		STATUS_WAIT_2		= 0x00000002, // -EIO
		STATUS_WAIT_3		= 0x00000003, // -EIO
		...
	};

and switching to using cpu-endian in the code.

David

