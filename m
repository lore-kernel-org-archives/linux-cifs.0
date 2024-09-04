Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825C9535D4
	for <linux-cifs@vger.kernel.org>; Wed,  4 Sep 2024 22:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725487325; cv=none; b=YKYy+rYXsMnXNU9K2LIwU9lXnQAUFPqZVX2p+cIQeazVqSltMT2Hd2pMJ2e8jb9ShHLfm80TpRSaICzFHBUbPx+T8BqggDGAQ7xTxVVKP3O4QNCK+FAHZtnJKMJPKiupKqO9UzLTZgCv5Xxa3O0Mf4JknTIH3Vtk1Es4nzZFihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725487325; c=relaxed/simple;
	bh=f393uc7UEhviBqg4GZHZUDOa2j7FR50YPbzgdwHy8Pk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=sSyswox9na+iRe/GUGj2VsQK8nM7ZMBgiSKxCxszoev2/w/DBb12qwNhigvJ/KqxALc+eyfPgro0kycoBUvHJO1N/FF6sgttzAPXk+ONBStmYpDlBqV9TNTRh1KUqpxv+WVoxUPuqhIK6fXwfZHS/J/xvrgCIs8PnIFIXWAoI00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WrpNffsf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WrpNffsf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725487321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IHF0Ph21ttcF9eggr2GftptTjTXE6YMP3K7gdGsE7Iw=;
	b=WrpNffsfGEe/P5reSTVme/yeHWu3oa6ESxVkUhwzNPCo/7wM3zBX5pKkKtYlwdZfzcVqjU
	Nps9MTw5rd2MQnrCAIkjpmGzvTaRMD2twJ/dagHOc9RGfiD/Qi9pv2rtr6nKlDJsQdVoSf
	WKtDB5sfloGxAhOqsElnSWtt9q7SVis=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-85Pv1Um6OvuNedHLe-QKlA-1; Wed,
 04 Sep 2024 18:01:57 -0400
X-MC-Unique: 85Pv1Um6OvuNedHLe-QKlA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 715C81953959;
	Wed,  4 Sep 2024 22:01:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC46D19560AA;
	Wed,  4 Sep 2024 22:01:52 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1dihdj9avrsvritngbtie92i5udsf28168@sonic.net>
References: <1dihdj9avrsvritngbtie92i5udsf28168@sonic.net> <pv2lcjhveti4sfua95o0u6r4i73r39srra@sonic.net>
To: Forest <forestix@nom.one>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Rohith Surabattula <rohiths.msft@gmail.com>,
    Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-mm@kvack.org, stable@vger.kernel.org,
    regressions@lists.linux.dev
Subject: Re: [REGRESSION] cifs: triggers bad flatpak & ostree signatures, corrupts ffmpeg & mkvmerge outputs
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2450248.1725487311.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Sep 2024 23:01:51 +0100
Message-ID: <2450249.1725487311@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Forest <forestix@nom.one> wrote:

> Write corruption still exists in 6.11.0-rc6.

Can you try adding this:

	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3Dc26096ee0278c5e765009c5eee427bbafe6dc090

Unfortunately, it managed to miss -rc6 because Linus released early before=
 the
PR could be sent to him.

David

