Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5D113DDC7
	for <linux-cifs@vger.kernel.org>; Fri, 26 Apr 2024 09:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714122300; cv=none; b=Y3rY1IIm1XtTAIc3VK5z0tBzHLpjwndvrbb/gW3DAvH0PBVpYXEAuxG9nyl3YRMj4DBzePMVktc5pjMbrwxbuaR/aBupsUJrWS9tmcPWWWzN29DNaBQlzRjgBa7bFuZ6y8wYw20mHhNE1Eev90TE1tzMIRNj+1RTSr4eN4j+xTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714122300; c=relaxed/simple;
	bh=6NNWrHZ8QYLMXcRHSm4QHBMib2eMk/fIeCbE+svUghk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=DWGYA0MA4EsuLbAREuR59lT0z7ryxKMAqByvs4mdoFY/EVVq54lAXxE/muHDWwFkT1BYdCwwQex5rI+UQHBkQhHPIOXAQoiJ4gQQWHixCPGiLfI3YZ8glPssb/dQpw2IM/Vb1ASD/rSGAjVB7goEQlxEDKcVJSmbOxYUEVtGKqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJjXPCpX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJjXPCpX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714122298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6NNWrHZ8QYLMXcRHSm4QHBMib2eMk/fIeCbE+svUghk=;
	b=EJjXPCpXBDMirUa52bJv7pPpiWqlT5ygtZ4rdwcnkvnh8X773f8yWg7mNhuMiOB/RgUIwW
	oI/IRWaYeCnOoPPyWObLHnJg6/ZtkLkCHjTRdgSeF18IV7edmjVpt27QJbnsQ5WIa0BJB3
	mujtwdNKS2auxGM7kODfvd3jzFgGug0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-6fuerLXVOliK6Ject2zWEg-1; Fri,
 26 Apr 2024 05:04:51 -0400
X-MC-Unique: 6fuerLXVOliK6Ject2zWEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AC5B3830095;
	Fri, 26 Apr 2024 09:04:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 148F1EC685;
	Fri, 26 Apr 2024 09:04:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Zin4G2VYUiaYxsKQ@xsang-OptiPlex-9020>
References: <Zin4G2VYUiaYxsKQ@xsang-OptiPlex-9020> <202404161031.468b84f-oliver.sang@intel.com> <164954.1713356321@warthog.procyon.org.uk>
To: Oliver Sang <oliver.sang@intel.com>
Cc: dhowells@redhat.com, oe-lkp@lists.linux.dev, lkp@intel.com,
    Steve French <sfrench@samba.org>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    "Rohith
 Surabattula" <rohiths.msft@gmail.com>,
    Jeff Layton <jlayton@kernel.org>, netfs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org
Subject: Re: [dhowells-fs:cifs-netfs] [cifs] b4834f12a4: WARNING:at_fs/netfs/write_collect.c:#netfs_writeback_lookup_folio
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2146095.1714122289.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Apr 2024 10:04:49 +0100
Message-ID: <2146096.1714122289@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Okay I got it to install somehow by moving tmp-pkg to pkg, running lkp
install (which failed), then moving it back and running lkp install again,
which succeeded.

Running lkp split-job gives me:

/root/lkp-tests/lib/erb.rb:35: warning: Passing safe_level with the 2nd ar=
gument of ERB.new is deprecated. Do not use it, and specify other argument=
s as keyword arguments.
/root/lkp-tests/lib/erb.rb:35: warning: Passing trim_mode with the 3rd arg=
ument of ERB.new is deprecated. Use keyword argument like ERB.new(str, tri=
m_mode: ...) instead.
/root/lkp-tests/lib/erb.rb:35: warning: Passing safe_level with the 2nd ar=
gument of ERB.new is deprecated. Do not use it, and specify other argument=
s as keyword arguments.
/root/lkp-tests/lib/erb.rb:35: warning: Passing trim_mode with the 3rd arg=
ument of ERB.new is deprecated. Use keyword argument like ERB.new(str, tri=
m_mode: ...) instead.
job.yaml =3D> ./job-performance-1HDD-btrfs-cifs-filemicro_seqwriterandvarg=
am.f-b4834f12a4df607aaedc627fa9b93f3b18f664ba-debian-12-x86_64-20240206.cg=
z.yaml

It looks like some of the Ruby scripting is out of date.

David

