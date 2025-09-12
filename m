Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD07F26561D
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 19:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757706096; cv=none; b=M6m+qoozz+JJr4ZNgokrSbmt2Ee3WYMwI6lpQURoMWiky5HT2yNO5zKfxYUYxW8naaK9ixC8FnpqSnVSEYZ2wDxg4cRewIcNagUN/YqNkzkB6ehIpIudr6tlkxVqghDTCzap5Gx//MNdS8ET5dncPKjhxBO5ywXqXcC+Czeze48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757706096; c=relaxed/simple;
	bh=uhe8fq2nnnUMD/GdTm4MvARwZLh2zhYZ209DCKYKOQ8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=EXBXx42DarWjBEBkpfHir7J/1SvKnW7o82FBmfg4JxYkeB//Aw3GuDRPQjgXg0/UThsazl5LP127vLROzW6oMTHRdEn1iPP/blx+OVhTfJ47xln614tNJKMjmrPuFg71MCJ78IXX4ZT7dpM273Ef2A15qigT+PT5XQPIfUXlVC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ja/z3kNe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ja/z3kNe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757706093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hnTYSV3LnjJK60eoSbEKhxRG7UXw3pjk1IAkLrEiYOk=;
	b=Ja/z3kNeNW7x3aLrXV1JJY5hypCapnDhHyLu9Dl5AOkYB31La23ZZnbuVeiMBPmoe4gmlS
	xPOjcIG4MjoR7qya+YIUh1yVCUyhVaON0+qxRs+gHq9luq9L9hbIVha9ogjuC89MI7Vrvx
	AIwXlJf1Euen3ZsRHWYxjSvh1nKKwA4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-OTMoVVPlMNWTVinvpP7umA-1; Fri,
 12 Sep 2025 15:41:28 -0400
X-MC-Unique: OTMoVVPlMNWTVinvpP7umA-1
X-Mimecast-MFC-AGG-ID: OTMoVVPlMNWTVinvpP7umA_1757706086
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6322F1955DDB;
	Fri, 12 Sep 2025 19:41:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7803B30002CE;
	Fri, 12 Sep 2025 19:41:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mvR=H=neH_vM8UkuXELVpTBeVfQWK5eRPoxUvgokROdNg@mail.gmail.com>
References: <CAH2r5mvR=H=neH_vM8UkuXELVpTBeVfQWK5eRPoxUvgokROdNg@mail.gmail.com> <20250912014150.3057545-1-yangerkun@huawei.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, Yang Erkun <yangerkun@huawei.com>,
    gregkh@linuxfoundation.org, willy@infradead.org, pc@manguebit.com,
    sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
    stable@kernel.org, nspmangalore@gmail.com, ematsumiya@suse.de,
    yangerkun@huaweicloud.com, Bharath SM <bharathsm.hsk@gmail.com>
Subject: Re: [PATCH v4] cifs: fix pagecache leak when do writepages
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Sep 2025 20:41:21 +0100
Message-ID: <2331639.1757706081@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


Steve French <smfrench@gmail.com> wrote:

> On Thu, Sep 11, 2025 at 9:11=E2=80=AFPM Yang Erkun <yangerkun@huawei.com>=
 wrote:
> >
> > After commit f3dc1bdb6b0b("cifs: Fix writeback data corruption"), the
> > writepages for cifs will find all folio needed writepage with two phase.
> > The first folio will be found in cifs_writepages_begin, and the latter
> > various folios will be found in cifs_extend_writeback.
> >
> > All those will first get folio, and for normal case, once we set page
> > writeback and after do really write, we should put the reference, folio
> > found in cifs_extend_writeback do this with folio_batch_release. But the
> > folio found in cifs_writepages_begin never get the chance do it. And
> > every writepages call, we will leak a folio(found this problem while do
> > xfstests over cifs, the latter show that we will leak about 600M+ every
> > we run generic/074).
> >
> > echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
> > Active(file):      34092 kB
> > Inactive(file):   176192 kB
> > ./check generic/074 (smb v1)
> > ...
> > generic/074 50s ...  53s
> > Ran: generic/074
> > Passed all 1 tests
> >
> > echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
> > Active(file):      35036 kB
> > Inactive(file):   854708 kB
> >
> > Besides, the exist path seem never handle this folio correctly, fix it =
too
> > with this patch. All issue does not occur in the mainline because the
> > writepages path for CIFS was changed to netfs (commit 3ee1a1fc3981,
> > titled "cifs: Cut over to using netfslib") as part of a major refactor.
> > After discussing with the CIFS maintainer, we believe that this single
> > patch is safer for the stable branch [1].
> >
> > Steve said:
> > """
> > David and I discussed this today and this patch is MUCH safer than
> > backporting the later (6.10) netfs changes which would be much larger
> > and riskier to include (and presumably could affect code outside
> > cifs.ko as well where this patch is narrowly targeted).
> >
> > I am fine with this patch.from Yang for 6.6 stable
> > """
> >
> > David said:
> > """
> > Backporting the massive amount of changes to netfslib, fscache, cifs,
> > afs, 9p, ceph and nfs would kind of diminish the notion that this is a
> > stable kernel;-).
> > """
> >
> > Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
> > Cc: stable@kernel.org # v6.6~v6.9
> > Link: https://lore.kernel.org/all/20250911030120.1076413-1-yangerkun@hu=
awei.com/ [1]
> > Signed-off-by: Yang Erkun <yangerkun@huawei.com>

Reviewed-by: David Howells <dhowells@redhat.com>

