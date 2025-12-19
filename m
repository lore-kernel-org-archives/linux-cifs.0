Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131A330149F
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 10:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766141440; cv=none; b=tS+F9jiBGrUeN5wGsrTfD4wcYtrdHDKLr+i40rRzVh+uwvx3LGEGiX9Z1IjYU7kembQ4ggOSrYvPXBUjWl+D33yl5cLHvvXlQqQfb5YZeuAM4jvnQAhv+hmvStjcIu0V6HlJGWtpEUrwN94Fxv+lDTH4jvIbSIWiMyAYOrzEhCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766141440; c=relaxed/simple;
	bh=ofxbx3sXR4paZuEun5zDDrq/I96N1ooYk5unAT6srIY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=qBs/77IGmaLWfogsINnk40mNdnfMCcPCD3WiQd4bPzYhZJ1wGGJDETUxMIiD8FHXcaZmT51W4F3AMIZ+rg4SKrkBl646RXWySSngxR+3xRMJzAgmcN0E0EeBbJTaV1BllUJyKNuzdoNlsetx9GQoIuvJ0kfslI14MyEsvmJkV4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qk1cHMci; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qk1cHMci"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766141436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ofxbx3sXR4paZuEun5zDDrq/I96N1ooYk5unAT6srIY=;
	b=Qk1cHMciWAm4+7wnVnxbDodvv60SUBbZMxi9kKJmKyn1Z12XefF4BjleMoA0XKuu5cyeb9
	+ezhYVCBqH8znXibqJSM2nOIbNBM5eIxG+WqojJD/uftnvyQUD5v8AA4wct0nrrDYw2TWM
	JJNsEkvQgW8BcsFX21mxYiVrz4wSAUM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-70pvqtglOCy1FmFnh7q5WQ-1; Fri,
 19 Dec 2025 05:50:32 -0500
X-MC-Unique: 70pvqtglOCy1FmFnh7q5WQ-1
X-Mimecast-MFC-AGG-ID: 70pvqtglOCy1FmFnh7q5WQ_1766141430
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 646421800642;
	Fri, 19 Dec 2025 10:50:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0659D30001A7;
	Fri, 19 Dec 2025 10:50:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAKYAXd_owC9vmSF+ukH-GgG5mWwFWGtwrXNT-8gfUZGHVDTcRA@mail.gmail.com>
References: <CAKYAXd_owC9vmSF+ukH-GgG5mWwFWGtwrXNT-8gfUZGHVDTcRA@mail.gmail.com> <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev> <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com> <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev> <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com> <805496.1766132276@warthog.procyon.org.uk>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: dhowells@redhat.com,
    ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>,
    sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <812020.1766141424.1@warthog.procyon.org.uk>
Date: Fri, 19 Dec 2025 10:50:24 +0000
Message-ID: <812021.1766141424@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Namjae Jeon <linkinjeon@kernel.org> wrote:

> ChenXiaoSong, If you agree with this, Can you make the v2 patch ?

Can I suggest adding a comment to indicate what the +4 represents in the
SMB2/3 case?

David

