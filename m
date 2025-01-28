Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB301991B8
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jan 2025 09:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738057659; cv=none; b=bWPpOf7nuZAGjPyAi1KFiov0+ivxhUwgV05VQGbBTpCuwSAaERDvLk0uv9IYzQjo7iDQvhGswVjv6LMA1/Fb8hdTADvs0ECBU8H/A9nXqsD5PDR+jeE388HBzQ/67VUlNk1AmoeHijCe4XHjEU5eJSGcRFasqjAr0oFPQvq2+FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738057659; c=relaxed/simple;
	bh=buSii/6lgiWFEVTCsdatzpVaxCyAtCt1M6w30EM4PRQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=DZHMUZPwhqWbE2CIn1Yn5LNQkVSVfG3K+EytfErefDf9juRZCyFZUoLg0YC2aWcC831FBZXe/3rpqQPZokJRcMCE5nek+jUWXVL0hDpGpAQPelm0v61wkS2iu7k1zko71dRH+X55Ck6R+MKOMqP5TAlJFjwE5oEK4GMBfs3/tMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gl976mX1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gl976mX1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738057656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nERoU20uTJEhjHEMRjSSqI/7CtUS+UfOz4UGG+FXfsc=;
	b=gl976mX1D8/N4wlUK6esXVbOIoYTvOFSvz2EpPUPFliNl5ZbL9aSEACmMs0ZTUX5f7vL5V
	H8S0U4RoRSeEA3tZ+BbfNo/mD7qURH4BvgB/6ZZP3fQ4E/wjfiYDtawBXSp69U1HQ1S5oX
	mjDV3jdBmZfWIZIrQhv7753LdT3B5XM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-UGq4SzeaNUKFg87OIouEVw-1; Tue,
 28 Jan 2025 04:47:34 -0500
X-MC-Unique: UGq4SzeaNUKFg87OIouEVw-1
X-Mimecast-MFC-AGG-ID: UGq4SzeaNUKFg87OIouEVw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C958019560B2;
	Tue, 28 Jan 2025 09:47:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.56])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AC633003FD1;
	Tue, 28 Jan 2025 09:47:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mv=ujxf7p--oQV3m9nukGqh5doo_kPReeLOzjQOSC1+DQ@mail.gmail.com>
References: <CAH2r5mv=ujxf7p--oQV3m9nukGqh5doo_kPReeLOzjQOSC1+DQ@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, Vinicius Costa Gomes <vinicius.gomes@intel.com>,
    Christian Brauner <brauner@kernel.org>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: Re: creds warning building cifs in recent mainline
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3198056.1738057651.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jan 2025 09:47:31 +0000
Message-ID: <3198057.1738057651@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Steve French <smfrench@gmail.com> wrote:

> I see this warning building mainline from a few days ago.  Do you also
> see these warnings about struct cred?
>
>   CHECK   client/cifsacl.c
> client/cifsacl.c: note: in included file (through
> /home/smfrench/smb3-kernel/include/linux/sched/signal.h,
> /home/smfrench/smb3-kernel/include/linux/rcuwait.h,
> /home/smfrench/smb3-kernel/include/linux/percpu-rwsem.h, ...):
> /home/smfrench/smb3-kernel/include/linux/cred.h:175:41: warning:
> incorrect type in initializer (different address spaces)
> /home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    expected
> struct cred const *old
> /home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    got struct
> cred const [noderef] __rcu *cred
> /home/smfrench/smb3-kernel/include/linux/cred.h:183:51: warning:
> incorrect type in initializer (different address spaces)
> /home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    expected
> struct cred const *override_cred
> /home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    got struct
> cred const [noderef] __rcu *cred
> /home/smfrench/smb3-kernel/include/linux/cred.h:175:41: warning:
> incorrect type in initializer (different address spaces)
> /home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    expected
> struct cred const *old
> /home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    got struct
> cred const [noderef] __rcu *cred
> /home/smfrench/smb3-kernel/include/linux/cred.h:183:51: warning:
> incorrect type in initializer (different address spaces)
> /home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    expected
> struct cred const *override_cred
> /home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    got struct
> cred const [noderef] __rcu *cred
>   CC [M]  client/fs_context.o
>   CHECK   client/fs_context.c
>   CC [M]  client/dns_resolve.o
>   CHECK   client/dns_resolve.c
>   CC [M]  client/cifs_spnego_negtokeninit.asn1.o
>   CHECK   client/cifs_spnego_negtokeninit.asn1.c
>   CC [M]  client/asn1.o
>   CHECK   client/asn1.c
>   CC [M]  client/namespace.o
>   CHECK   client/namespace.c
>   CC [M]  client/reparse.o
>   CHECK   client/reparse.c
>   CC [M]  client/xattr.o


It looks like a problem in the header files due to the creds patches that =
just
went in:

a6babf4cbeaa (tag: kernel-6.14-rc1.cred, vfs/kernel-6.14.cred) cred: fold =
get_new_cred_many() into get_cred_many()
6efbb80490a5 cred: remove unused get_new_cred()
51c0bcf0973a tree-wide: s/revert_creds_light()/revert_creds()/g
6771e004b409 tree-wide: s/override_creds_light()/override_creds()/g
a51a1d6bcaa3 cred: remove old {override,revert}_creds() helpers
95c54bc81791 cred: return old creds from revert_creds_light()
0a670e151a71 tree-wide: s/override_creds()/override_creds_light(get_new_cr=
ed())/g
49dffdfde462 cred: Add a light version of override/revert_creds()

I don't any warnings though.  Are you using gcc or clang?

David

