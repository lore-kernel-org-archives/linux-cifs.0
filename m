Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967CB13EFE8
	for <linux-cifs@vger.kernel.org>; Fri, 26 Apr 2024 09:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714124570; cv=none; b=JJyCJWPerOON8ni969dsk1bwsQTDGdcvCqPVc/H/RanIYnJcYm/sUavG6cIRSFQ1w7DfIwIdeHNSY8SYmKKLPMhPq/YZEVcyro5HpnjxM08Z/mGBMGkyFaqTs98CCbPecmCP9YgnpakA+mVoasdaB5IQc4mKHfc5AV3nw0Gl4JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714124570; c=relaxed/simple;
	bh=PufP8/ByS1FLwd22jzfG9PutCnHEVIfvSeOi9ocQe9E=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=bYHJB+zzyu1p6Fgh3dEAa6M87gdEi8n1uSVrJrfpeHoEuOpJUPf5yakfV1cL+A4AuC9oFz8ZNKTFssd1t0K6EyJHOMZS2gDTkd4Vf+0rHhdj682zcrbSYj/8v32BJdEDxW2pMCvfZu/AmVd9PNLIjHur5/z8FG3Tw8/ypyuinBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=idWJTBUn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="idWJTBUn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714124568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Ii9FxdCUhkSL/NP0ErV+eSCcUrQRGZSNZBjNMLs3pc=;
	b=idWJTBUnIs5kVNHiU4ziE6Bv0C0oGKwxqB8BbOuxWfw13ZsvC1eFlyq8cvCp6qtB0qsKxX
	vmJs6n0v6Y9ipfh0qfYBm3soOFMzf42EUTw5omCWwLxRT2KC0ACRLtbFBUdEg7gb8gONz9
	Z9DdHPlj3X//Z0EasxaMZw6I3/zMfgI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-nd8bGkfbPNO6Q_6JHXsyew-1; Fri, 26 Apr 2024 05:42:44 -0400
X-MC-Unique: nd8bGkfbPNO6Q_6JHXsyew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7825C8001B2;
	Fri, 26 Apr 2024 09:42:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 35B522033A49;
	Fri, 26 Apr 2024 09:42:42 +0000 (UTC)
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
Content-ID: <2146613.1714124561.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Apr 2024 10:42:41 +0100
Message-ID: <2146614.1714124561@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Trying to do "lkp run job.yaml" doesn't work:

/root/lkp-tests/filters/need_kconfig.rb:20:in `read_kernel_kconfigs': .con=
fig doesn't exist: /pkg/linux/x86_64-rhel-8.3/gcc-13/b4834f12a4df607aaedc6=
27fa9b93f3b18f664ba/.config (Job::ParamError)
        from /root/lkp-tests/filters/need_kconfig.rb:176:in `block in expa=
nd_expression'
        from /root/lkp-tests/lib/erb.rb:51:in `eval'
        from /root/lkp-tests/lib/erb.rb:51:in `expand_expression'
        from /root/lkp-tests/lib/job.rb:646:in `evaluate_param'
        from /root/lkp-tests/lib/job.rb:694:in `block in expand_params'
        from /root/lkp-tests/lib/job.rb:79:in `block in for_each_in'
        from /root/lkp-tests/lib/job.rb:78:in `each'
        from /root/lkp-tests/lib/job.rb:78:in `for_each_in'
        from /root/lkp-tests/lib/job.rb:691:in `expand_params'
        from /root/lkp-tests/bin/run-local:138:in `<main>'

I tried to run the filebench directly, but that only wants to hammer on
/tmp/bigfileset/ and also wants a file for SHM precreating in /tmp.  I was
able to get it to work with cifs by:

touch /tmp/filebench-shm-IF6uX8
truncate -s 184975240 /tmp/filebench-shm-IF6uX8
mkdir /tmp/bigfileset
mount //myserver/test /tmp/bigfileset/ -o user=3Dshares,pass=3D...,cache=3D=
loose

/root/lkp-tests/programs/filebench/pkg/filebench-lkp/lkp/benchmarks/filebe=
nch/bin/filebench -f /lkp/benchmarks/filebench/share/filebench/workloads/f=
ilemicro_seqwriterandvargam.f

It tries to remove /tmp/bigfileset/, can't because it's mounted, and then
continues anyway.

It should be easier than this ;-)

David

