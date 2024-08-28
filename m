Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F3015B12F
	for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2024 11:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724845957; cv=none; b=LXehroq9HNnWNA3Lxm6zbHtIlG1d4rnQBjFizUHENS6c46tqpdOpn1bK1i85MztgY5FHu5hM14SDFWlRsyUkLxRidp8oOc5DcEhJBQa96cRRoIHEDAQ5sQrdFwVEvGw3t+uFMb7MIEFSuOFveXaMFW2eGXQ7d/PvLv3+Hd/nfDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724845957; c=relaxed/simple;
	bh=r/XTHRpAAFzLh4zwb+wQat2/9X4mQV1qUFYphpElkIk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=spwAJ61/r0YV/3QAASa2rPP4jEVxFRsQTgJIM0kVyxALKTxhQQ+mNMWah524yW/TFhGZWQV9czoSSFZ+aX5Phe0vypqvRrGhcZGiKBPURODmZnsICRp4H+z/wtz/E2jz0JbnVJcJUAAh3NTJk/rdFrioE4BsYMiHkvPmXf6RFCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KoCkSl6t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KoCkSl6t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724845953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtcOzYtriZ9WqL8I/lJRoP02TrW8/k207iuQXfWTiV4=;
	b=KoCkSl6tjwBW2cwqQ5oCO69YIM4rb+Fi9d5xHgI8zweZLCPPa/zTRPb4onM3dQOezQex4p
	Y/B9/WXm2x/aOoPibPbqTFLPdp3IjTWcpU42oOdTau6Db0VbmIbQbSfxikLGMYvhDTl/NJ
	CHvC0OFAF0l5yn2nuRrseDRnTHKPt5I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-hEl6BB3jOnK0z0KaSlZZzA-1; Wed,
 28 Aug 2024 07:52:31 -0400
X-MC-Unique: hEl6BB3jOnK0z0KaSlZZzA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97C6F1955BF2;
	Wed, 28 Aug 2024 11:52:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 058FE1955D56;
	Wed, 28 Aug 2024 11:52:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240828105536.1e6226df.ddiss@samba.org>
References: <20240828105536.1e6226df.ddiss@samba.org> <20240823132052.3f591f2f.ddiss@samba.org> <Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation> <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com> <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk> <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna> <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com> <476489.1716445261@warthog.procyon.org.uk> <477167.1716446208@warthog.procyon.org.uk> <6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com> <af49124840aa5960107772673f807f88@manguebit.com> <319947.1724365560@warthog.procyon.org.uk> <951877.1724840740@warthog.procyon.org.uk>
To: David Disseldorp <ddiss@samba.org>
Cc: dhowells@redhat.com, Jeremy Allison <jra@samba.org>,
    Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
    ronnie sahlberg <ronniesahlberg@gmail.com>,
    David Howells via samba-technical <samba-technical@lists.samba.org>,
    Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <965292.1724845945.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Aug 2024 12:52:25 +0100
Message-ID: <965293.1724845945@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Okay, that fixes the problem.

For reference, the file can be prepared thusly:

	xfs_io -c "pwrite 0 16M" -c "fpunch 0 1M" -c "fpunch 2M 1M" -c "fpunch 4M=
 1M" -c "fpunch 6M 1M" -c "fpunch 8M 1M" /xfstest.test/foo

and then the test run:

	xfs_io -c "seek -h 1" /xfstest.test/foo

Something like punch-hole is needed to set the sparse flag - otherwise QAR
isn't used by llseek().

So:

	Tested-by: David Howells <dhowells@redhat.com>

if you need it.

The Fedora samba version I applied this to was:

	samba-4.19.7-1.fc39.x86_64

though I had to drop the testing bits as they didn't build.

David

