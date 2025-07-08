Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB90829ACFA
	for <linux-cifs@vger.kernel.org>; Tue,  8 Jul 2025 09:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751965721; cv=none; b=gTnQKCWSR2buSdOSMcrjU5ugqrzwJY1Fg1De2mzALReIjF1RhVFKhCUzcEJH/w+RMs82gfjzYTxDfXzpXOiYnQVfpL9IMFoZ77ofLYXL5k0+jVHysSG3iQt7M4/cm79/HdzKtOyzI1gwgAyk7uu2FxjCu1Qn6MYcf+2fAHi0jtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751965721; c=relaxed/simple;
	bh=+BEhpRAI3WqIU5PHLov5vFkJrJLWkW1/+f220VxTYOQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=rUlxvFg+VghyrNaHggiYdkgXwvbzSuSViD7HcCAciF+7sskZkh+2+pvUtH76Glxr5L8sv60z4I5bOfBV4CQAXcg4SLNzhFfy4k1/1aLnxVqcCtyzTn83AQhIK4fbQ2ZKLdsMCl/df9pZcQiAloxsy0AI/Dt8L2TMvBoZdQFQGlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gg3OMHHN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gg3OMHHN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751965718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BEhpRAI3WqIU5PHLov5vFkJrJLWkW1/+f220VxTYOQ=;
	b=Gg3OMHHN0CrupdsRcoCDTUWWFiIZL/EUYFleXnY0S/oZj6Ag3Q5jDrDBciDzfsAnE5rGPf
	VzvBNfWZ5LjrRA9EocBE+Pwkx5Hd0yWAuW5VV7tCFuNTuPnyk/jFwVCbVWPs4muACudcNZ
	gmGkiyZ0b/LQBfd3csL66RfvdRrNduM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-FCrmVsh2NjyN66k4myr0zQ-1; Tue,
 08 Jul 2025 05:08:37 -0400
X-MC-Unique: FCrmVsh2NjyN66k4myr0zQ-1
X-Mimecast-MFC-AGG-ID: FCrmVsh2NjyN66k4myr0zQ_1751965710
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67F98180135B;
	Tue,  8 Jul 2025 09:08:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B3851956087;
	Tue,  8 Jul 2025 09:08:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CADvbK_cR9RCeZo5d3--h7iTBfHszpmdDS7+0kfCUsViOamwR5Q@mail.gmail.com>
References: <CADvbK_cR9RCeZo5d3--h7iTBfHszpmdDS7+0kfCUsViOamwR5Q@mail.gmail.com> <cover.1751743914.git.lucien.xin@gmail.com> <2334439.1751877644@warthog.procyon.org.uk>
To: Xin Long <lucien.xin@gmail.com>
Cc: dhowells@redhat.com, network dev <netdev@vger.kernel.org>,
    davem@davemloft.net, kuba@kernel.org,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
    Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
    Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
    Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
    kernel-tls-handshake@lists.linux.dev,
    Chuck Lever <chuck.lever@oracle.com>,
    Jeff Layton <jlayton@kernel.org>,
    Benjamin Coddington <bcodding@redhat.com>,
    Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
    Alexander Aring <aahringo@redhat.com>,
    Cong Wang <xiyou.wangcong@gmail.com>,
    "D . Wythe" <alibuda@linux.alibaba.com>,
    Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>,
    Sabrina Dubroca <sd@queasysnail.net>,
    Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
    Daniel Stenberg <daniel@haxx.se>,
    Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next 00/15] net: introduce QUIC infrastructure and core subcomponents
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Jul 2025 10:08:18 +0100
Message-ID: <2545781.1751965698@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Xin Long <lucien.xin@gmail.com> wrote:

> Yes, there is a patch that adds Documentation/networking/quic.rst in the
> subsequent patchset, which I=E2=80=99ll post after this one. It addresses=
 exactly
> what you pointed out:
>=20
> https://github.com/lxin/net-next/commit/9f978448531b958f859bbd48dce8a703b=
256b25a

Excellent, thanks!

David

