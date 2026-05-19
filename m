Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7256E3F1650
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 08:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779181019; cv=none; b=pxcKMI/n0XsYsnkt5Yn2EtPsh+V6NfkAO8lnoBLsfxrLITZo/KfSKpwEx/ogXtJAzhB+0GS9h41o1SRMFlMcLy6ExhpJyYvlCrIrkfYrZQClvw8byIuuqG4x5EB83CwV8kIgoQkV3bGouuDFsd++FZdgaOYF0j7k3IpMhh8RvEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779181019; c=relaxed/simple;
	bh=LIKHPLUgP24fnZDPyTwTfhpS6fhfyuzVDI+ALoRe6pU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=EUYFQSLkNJ/6au3mkkqY137oNXvNPs1hlhasqYMkd2HFNKuZUJCbXsdYRM52bpGV8Zb1XmLTrsIXNnA6E9V3lXOfO571CuyUInXoi0UporZ4YbvQ/HG77APZW35wyMej6QED4zvZ80maFg5Yu90E7t7Yp/HcRLbpGM+N+xD0o9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cCQn5H0s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCQn5H0s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779181017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nfLpYbjE/MjvadsVry23QrY3IrkdWcPR/NULNuNBao4=;
	b=cCQn5H0s3A1wRRzEbmtFll44ebxnYRAxSgKq/LuyJekuteWcVDBrUokfQhFwcqz0f4kamB
	AYTyet3ZrAHPmi6LAXMVckQ2DRXWnHoXIO4fF0VcIf0CFc+17usD0nDjWCMIKjpcrIUZr+
	nJDK1hMWka53gU8AsBnK9a16V1OoSr4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-455-kyoVeZ09Ov2A6xqp-vQlCw-1; Tue,
 19 May 2026 04:56:50 -0400
X-MC-Unique: kyoVeZ09Ov2A6xqp-vQlCw-1
X-Mimecast-MFC-AGG-ID: kyoVeZ09Ov2A6xqp-vQlCw_1779181008
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5786B1956052;
	Tue, 19 May 2026 08:56:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3932B1800352;
	Tue, 19 May 2026 08:56:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260519091545.171c4b85@pumpkin>
References: <20260519091545.171c4b85@pumpkin> <20260518222959.488126-1-dhowells@redhat.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Matthew Wilcox <willy@infradead.org>,
    Christoph Hellwig <hch@infradead.org>,
    Paulo Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>,
    Leon Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Marc Dionne <marc.dionne@auristor.com>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>,
    Trond Myklebust <trondmy@kernel.org>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/21] netfs: Keep track of folios in a segmented bio_vec[] chain
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <586307.1779180995.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 19 May 2026 09:56:35 +0100
Message-ID: <586308.1779180995@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

David Laight <david.laight.linux@gmail.com> wrote:

> > 	struct bvecq {
> > 		struct bvecq		*next;
> > 		struct bvecq		*prev;
> > 		unsigned long long	fpos;
> > 		refcount_t		ref;
> > 		u32			priv;
> > 		u16			nr_segs;
> > 		u16			max_segs;
> > 		enum bvecq_mem		mem_type:2;
> > 		bool			inline_bv:1;
> > 		bool			discontig:1;
> =

> There doesn't seem to be any point using bitfields.
> There is a massive hole here anyway.

Depends on how you define "massive".  On a 64-bit machine, the whole thing
fits into 48 bytes - 6 words (or 3 bio_vec slots).  next, prev, fpos, bv a=
nd
ref+priv take up 5 of those words; nr_segs and max_segs take up half of th=
e
6th, leaving a 4 byte hole.

You're right, though, I could make them all non-bitfields as the enum is
marked mode(byte).

> >  (1) next, prev - Link segments together in a list.  I want this to be
> >      NULL-terminated linear rather than circular to make it possible t=
o
> >      arbitrarily glue bits on the front.
> =

> Do you ever need to follow the list backwards?

iov_iter_revert() exists, unfortunately, but yes, I would like to avoid ha=
ving
a prev pointer.

I have a couple of ideas on how to get rid of that - or at least store the
start in struct iov_iter and always work forwards - but I haven't got roun=
d to
trying that yet.

> >  (2) fpos, discontig - Note the current file position of the first byt=
e of
> >      the segment; all the bio_vecs in ->bv[] must be contiguous in the=
 file
> >      space.  The fpos can be used to find the folio by file position r=
ather
> >      then from the info in the bio_vec.
> =

> Should fpos be off_t (or u64) rather than 'long long' (they are all the
> same underlying type).

It's not 'long long' and off_t is actually 'long' in asm-generic.  Actuall=
y, I
should probably switch to using uoff_t.  Note that this file position shou=
ld
never be seen as negative; I think loff_t should only really be used in
llseek.

> >      If there's a discontiguity, this should break over into a new bve=
cq
> >      segment with the discontig flag set (though this is redundant if =
you
> >      keep track of the file position).  Note that the beginning and en=
d
> >      file positions in a segment need not be aligned to any filesystem
> >      block size.
> =

> At this point you lose me :-)

Apologies, but I'm trying to define how a bvecq chain works.  I need to co=
dify
it more coherently.

So there's a number of reasons I want to be able to maintain the file posi=
tion
information in the chain:

 (1) I can treat buffered writeback and DIO write more similarly if there'=
s no
     requirement to access the folios in the list to get file position
     information.

 (2) When cleaning up lists of folios in buffered writeback, the file posi=
tion
     is needed to access the i_pages xarray in order to clean up the marks=
 on
     it.  This means I don't need to go from my list to access each folio,=
 but
     can look them up through the xarray instead.

 (3) Some network filesystems, e.g. ceph, allow discontiguous (sparse) wri=
tes
     to be made to the server in a single RPC operation.  This gives a mea=
ns
     to convey that information to them, but then allows the data to be
     conveyed in a single blob to the socket (the mapping between blob off=
sets
     and file regions is tabulated separately within the RPC call).

Note that some of this also applies to reads too.

The last bit about filesystem block size alignment is because network
filesystems don't typically require any block alignment, doing RMW locally=
 on
the server.  I should really have separated that from the discontiguity bi=
t.

David

