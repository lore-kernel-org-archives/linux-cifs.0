Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F98D18FDBE
	for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2024 12:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727700744; cv=none; b=oTKJmdLzdPnJ4EAZkmprLAc/dWeVGU/VNoM9f2FCikXSB9nZohODamB1/7VC8fKD/wEQMdJlxYOUxb+obpZOyyMdgQtp0MgGV0sKuqadZzSTPf+cb1SWOtR2O3LemtgNYxtBspndqV6WiBuAaM6/2y7QJ3DfbM4oGd7mmdGSCYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727700744; c=relaxed/simple;
	bh=I3XAswTbM6b/JGrNsCLhXccVrlOMtrETAjtdN/rctYU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=N2LE8nIw6ou3ynAjpIvg5YCvEcxw+k8GOogUwnjKtRE3A9WX+mdSRI0xrAxyiYQ7Jdfbt0rW9VTipN2kPGxpgzloEelWATqAomw8JV/6xpDreDcP0LlgpimVgbMHBsWXOX+5/qAaLr6zpv0mOebFymcGbEwveTVcbeja6H0nXaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aVAiL5Lx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aVAiL5Lx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727700742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iheTQuAAGoNV0Ml7YHfX3/4X0Beg93WMcxdOLm415Rw=;
	b=aVAiL5LxFLKUu3me1kwOs/WO/wlz573H8Qpe3F3MtQLRRTmJQ8zt3rruB/5m9NxkMDijp8
	7iJUHwxFMJ838+5faSaRqfVdQorYAU/JYqMt1NRbEJFSqZcLiK/EMxeKJ7ZdUcJCrPoK+0
	7p4PXuhtYteHclcYirta1apJ4TSr8d0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-yIEMnkANOcKlKeIOv07qjw-1; Mon,
 30 Sep 2024 08:52:17 -0400
X-MC-Unique: yIEMnkANOcKlKeIOv07qjw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E827197730E;
	Mon, 30 Sep 2024 12:52:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28F8519541A0;
	Mon, 30 Sep 2024 12:51:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2968940.1727700270@warthog.procyon.org.uk>
References: <2968940.1727700270@warthog.procyon.org.uk> <20240925103118.GE967758@unreal> <20240923183432.1876750-1-chantr4@gmail.com> <20240814203850.2240469-20-dhowells@redhat.com> <1279816.1727220013@warthog.procyon.org.uk> <4b5621958a758da830c1cf09c6f6893aed371f9d.camel@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: dhowells@redhat.com, Eduard Zingerman <eddyz87@gmail.com>,
    Christian Brauner <brauner@kernel.org>,
    Manu Bretelle <chantr4@gmail.com>, asmadeus@codewreck.org,
    ceph-devel@vger.kernel.org, christian@brauner.io, ericvh@kernel.org,
    hsiangkao@linux.alibaba.com, idryomov@gmail.com, jlayton@kernel.org,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org, linux-mm@kvack.org,
    linux-nfs@vger.kernel.org, marc.dionne@auristor.com,
    netdev@vger.kernel.org, netfs@lists.linux.dev, pc@manguebit.com,
    smfrench@gmail.com, sprasad@microsoft.com, tom@talpey.com,
    v9fs@lists.linux.dev, willy@infradead.org
Subject: Re: [PATCH v2 19/25] netfs: Speed up buffered reading
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2969659.1727700717.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 30 Sep 2024 13:51:57 +0100
Message-ID: <2969660.1727700717@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

David Howells <dhowells@redhat.com> wrote:

> Okay, let's try something a little more drastic.  See if we can at least=
 get
> it booting to the point we can read the tracelog.  If you can apply the
> attached patch?

It's also on my branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Dnetfs-fixes

along with another one that clears the folio pointer after unlocking.

David

