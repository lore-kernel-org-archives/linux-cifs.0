Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45093D3AC
	for <linux-cifs@vger.kernel.org>; Mon, 19 Feb 2024 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708359182; cv=none; b=mDFhT5V89v8RqMz3EuO6h9YaoIXXYtp0H2K/h0q1r1yP3kczkbHdomcgNeea9gfEDlMEgRWp3gLFj68n0keWx9lO3sZfrflRmhVyN8E2wQErTMPsJC9cosgMIdSJjfXQRQXG8leEQih6OMEonzX2OzfNx/QIvuyZ4xB0rE8X1EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708359182; c=relaxed/simple;
	bh=TEbeuKi1D4WwK34OueQCHICSRhZ5+jaTYtBPp4NOkog=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=vEEbohQr0HoB9Zr4dIgvkXiaE5sjxscDlhX9W7/FiuKGGcdX9qibmyE+2U2444BFHxb2GA/l/W8SoF5+Mmte8euHiF/e4gXpisPp8P2XJye0SRHm2Gq99yOHbu3T5xDhFUko9pW+xmaGtd+bxtDCqbCIoBBLM5x0A/OwOK+6P4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gwyaOQWi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwyaOQWi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708359179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qw1Zo0E33/fdGs8X8g9v7Lf2Wcxxz6qcLyaGW55/s6Y=;
	b=gwyaOQWiC4UyoY03u19z7Dh4VVkp7glu13R5RF5WlQKeBiljp1J0SVb4Kcbag+paOE60/l
	JDGZINPNyjosqysfBC6ZuaRYB68lJqTxrLCruc0fTVnU+es+Jbe7ybQEsK+mQLs1h4MAAp
	laKd5Vbu86OG4sXedG5n2YPvmtoG5Z0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-3bJK7h8bOYeO_1GkDHJOeg-1; Mon, 19 Feb 2024 11:12:52 -0500
X-MC-Unique: 3bJK7h8bOYeO_1GkDHJOeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B26D2882087;
	Mon, 19 Feb 2024 16:12:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.15])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EFA71121306;
	Mon, 19 Feb 2024 16:12:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240209105947.GF1516992@kernel.org>
References: <20240209105947.GF1516992@kernel.org> <20240205225726.3104808-1-dhowells@redhat.com> <20240205225726.3104808-10-dhowells@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Jeff Layton <jlayton@kernel.org>,
    Matthew Wilcox <willy@infradead.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Christian Brauner <christian@brauner.io>, netfs@lists.linux.dev,
    linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-mm@kvack.org, netdev@vger.kernel.org,
    linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Rohith Surabattula <rohiths.msft@gmail.com>
Subject: Re: [PATCH v5 09/12] cifs: Cut over to using netfslib
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <229304.1708359168.1@warthog.procyon.org.uk>
Date: Mon, 19 Feb 2024 16:12:48 +0000
Message-ID: <229305.1708359168@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Simon Horman <horms@kernel.org> wrote:

> Nit: this hunk would probably be better placed in the
>      patch at adds cifs_req_ops to fs/smb/client/file.c

I've moved that to the patch that adds cifs_req_ops.

David

