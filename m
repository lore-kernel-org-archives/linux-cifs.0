Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAFA42A9B
	for <linux-cifs@vger.kernel.org>; Fri, 26 Apr 2024 08:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714121580; cv=none; b=tOOfbDrFMv0f2KLGm8c4b+lE42oHsDI0tZwk1+izIBAvbsyv4xwep+p1VWF+eynPYq7rLAO451S6zrhoQURWeRgx64y8RIMFgoaH/hLG+TpEn0lr5IF/DtRKzfQe/xyrAsBmBVN0ImEed210z0fBmj6ftMa0aWe7OUTQZntcsxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714121580; c=relaxed/simple;
	bh=hUX2DVFFmTQX/4s5jbyX/Z7hdBlcgTsJJWSFEVnr4JM=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=RgHvsa3LfyBm4I54fA9Qlqyl/P9xBa8BQbCnzHY6n/9a4TnuN47lioYkc9e6nKco/4bCoTo//9bDc+K1g2M0n0nBHZoDEiWzvhZUqHpVBwo0FAXRTpWe9+funRM2fl9VBzFi+VtqUguikAlVGbA0Dm7wedtZVtma2QQ+2ZVc65Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TGD744Z6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TGD744Z6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714121578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5XDOx+LRv/jq1Nvyq0OuXZVtvg/bIzTKjHQEeVzF+Yk=;
	b=TGD744Z6zmhqWBHlyzhKBQVdEzz5V2sf8dzZLDgGQ3nUaz8SGEkNa+A1Q+NGzgbjA2mdNv
	743gn0JurIhn5DBds8PTUJNLAmLCAQiJ2FR4aRB9p6Bxp925ukI8YRMo40FwJritu3twc4
	Nlkfkls7VM0GGb90zYMcmkj4bz/8G2w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373-Ri3cBZkiMNm8Eg-Jxet00Q-1; Fri,
 26 Apr 2024 04:52:54 -0400
X-MC-Unique: Ri3cBZkiMNm8Eg-Jxet00Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43FFC293248B;
	Fri, 26 Apr 2024 08:52:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3E9710000AD;
	Fri, 26 Apr 2024 08:52:52 +0000 (UTC)
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
Content-ID: <2145849.1714121572.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Apr 2024 09:52:52 +0100
Message-ID: <2145850.1714121572@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

The "lkp install" didn't complete:

=3D=3D> Retrieving sources...
  -> Source is https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/li=
nux.git
  -> Cloning linux git repo...
Cloning into bare repository '/root/lkp-tests/programs/turbostat/pkg/linux=
'...
remote: Enumerating objects: 10112942, done.
remote: Counting objects: 100% (889/889), done.
remote: Compressing objects: 100% (475/475), done.
remote: Total 10112942 (delta 554), reused 549 (delta 412), pack-reused 10=
112053
Receiving objects: 100% (10112942/10112942), 2.78 GiB | 4.16 MiB/s, done.
Resolving deltas: 100% (8300839/8300839), done.
=3D=3D> WARNING: Skipping verification of source file PGP signatures.
=3D=3D> Validating source files with md5sums...
    linux ... Skipped
=3D=3D> Extracting sources...
  -> Source is https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/li=
nux.git
  -> Creating working copy of linux git repo...
fatal: '/root/lkp-tests/pkg/turbostat/linux' does not appear to be a git r=
epository
fatal: Could not read from remote repository.


I looked around under /root/lkp-tests and there's no pkg/ directory.  It s=
eems
to be using tmp-pkg instead.

Is there a way to skip the cloning of the kernel?  I already have my test
kernel running on my test machine, booted by PXE/tftp from the build tree =
on
my desktop.  Just tell me what options I need to enable.

David

