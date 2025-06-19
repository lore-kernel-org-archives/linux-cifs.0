Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3087230E83F
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 22:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750372304; cv=none; b=Wg36I8gjeqkAuEDHdh+h7S8DYW78B0FRF8ovzmh5cU99msFDRxzexIOSKu855DJddOIEsoW6u98a8Yvy+GixUjj46mzya3YVQ4Mc3Lkcw0GhO7qEUIofWgefhYHj7mVXZ1kzJ2hP58OJ126YqzFR2gEzpWc74cVOfKz0S74ZOF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750372304; c=relaxed/simple;
	bh=FHIszSV3tMAr1tXnsr+bBkILf3jRaqNdmflJuCFEihw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=KbKBnv5miHzAe0hjOq5T0KcFRdvD6M28nM4NxCNmeAIGdgjq2/db40+6OVF5p3ufuOJvPzQeACZFAXoeMdXqDQRy+AfEim3PM2LR0Qq0r/8tvGgp8G4bUiUUG/WC75dTO2uP8NR/2xmFAvz+wqbQO+7HrxYmE88jAi+aYdX/moo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QyV8MZ2J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QyV8MZ2J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750372301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FHIszSV3tMAr1tXnsr+bBkILf3jRaqNdmflJuCFEihw=;
	b=QyV8MZ2JKw0icUERGdCjsDDfGLmpivlKSB5rImOA8lnskem/WEW0/Y3e1YiY86d7UKSKGS
	NkVkl3uL3dDroPtxIWDmNIo+CdLItJfWE76MIxUKcbG3t8BTnPqNdkHUgBEVcUNxdz4PXp
	IXkvA7liEDs9l1Bm9C/M0x6urgzMm/k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-N1J1aw97N-uBtjSDyW1tcA-1; Thu,
 19 Jun 2025 18:31:38 -0400
X-MC-Unique: N1J1aw97N-uBtjSDyW1tcA-1
X-Mimecast-MFC-AGG-ID: N1J1aw97N-uBtjSDyW1tcA_1750372297
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4633180028D;
	Thu, 19 Jun 2025 22:31:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9E09D195609D;
	Thu, 19 Jun 2025 22:31:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <869961.1750344431@warthog.procyon.org.uk>
References: <869961.1750344431@warthog.procyon.org.uk>
To: Jeremy Allison <jra@samba.org>, Steve French <sfrench@samba.org>,
    samba-technical@lists.samba.org
Cc: dhowells@redhat.com, paalcant@redhat.com, linux-cifs@vger.kernel.org
Subject: Re: Seeing lots of coredumps from samba when using upstream cifs
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <882335.1750372293.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Jun 2025 23:31:33 +0100
Message-ID: <882336.1750372293@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

David Howells <dhowells@redhat.com> wrote:

> Hi Jeremy, Steve,
> =

> I've been trying to investigate all the reconnection issues cifs is seei=
ng in
> the currently upstream kernel from running the generic/013 xfstest again=
st it,
> and I've realised Samba is coredumping a lot (attached is one example, a=
t
> lease several others look similar).
> =

> The version of the Fedora Samba RPM I'm using is: samba-4.21.4-1.fc41.x8=
6_64

The problem seems to be fixed in samba-4.22.2-1.fc42.x86_64.

David

