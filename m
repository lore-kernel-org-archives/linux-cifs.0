Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6A7C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Feb 2022 14:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbiB1OkB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Feb 2022 09:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbiB1OkA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Feb 2022 09:40:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32B886F494
        for <linux-cifs@vger.kernel.org>; Mon, 28 Feb 2022 06:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646059161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mdaocAi1oYiZvvsxCSy0zGl10s5ARkCh7O1MONuTu2c=;
        b=MUHJfnFPjDvujbDQ8S2PoPsbJ/JcWMq50FURY7OjJIA6zoR9vs3ARRkkyDaCClew2lkrFH
        xWafnXfvxYE8bvqY8QWgCvpV3Xq/vZXNBnsoYM2tulIol62OA8D3t0Ij3exyY+zd+WVtVo
        c2yGyKQ4gvisGUbImdEofq6Fuu9F8G8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-05diB5kTNC6bfd-XemHmrg-1; Mon, 28 Feb 2022 09:39:18 -0500
X-MC-Unique: 05diB5kTNC6bfd-XemHmrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 096FD835DE3;
        Mon, 28 Feb 2022 14:39:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32AB72ED88;
        Mon, 28 Feb 2022 14:39:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0ZteTve1EbSgDX_jochhHT7Ufm3gJg7j28BOjmRSg8dTQ@mail.gmail.com>
References: <CACdtm0ZteTve1EbSgDX_jochhHT7Ufm3gJg7j28BOjmRSg8dTQ@mail.gmail.com> <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com> <914621.1645046759@warthog.procyon.org.uk>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] [CIFS]: Add clamp_length support
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2500956.1646059150.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 28 Feb 2022 14:39:10 +0000
Message-ID: <2500957.1646059150@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> wrote:

> > Rohith Surabattula <rohiths.msft@gmail.com> wrote:
> >
> > > +     credits =3D kmalloc(sizeof(struct cifs_credits), GFP_KERNEL);
> > > ...
> > > +     subreq->subreq_priv =3D credits;
> >
> > Would it be better if I made it so that the netfs could specify the si=
ze of
> > the netfs_read_subrequest struct to be allocated, thereby allowing it =
to tag
> > extra data on the end?
>
> Do you mean the clamp handler in netfs should return the size of data
> to be allocated instead of allocating itself ?

No, I was thinking of putting a size_t in struct netfs_request_ops that
indicates how big the subrequest struct should be:

	struct netfs_request_ops {
		...
		size_t subrequest_size;
	};

and then:

	struct netfs_read_subrequest *netfs_alloc_subrequest(
		struct netfs_read_request *rreq)
	{
		struct netfs_read_subrequest *subreq;

		subreq =3D kzalloc(rreq->ops->subrequest_size, GFP_KERNEL);
		if (subreq) {
			INIT_LIST_HEAD(&subreq->rreq_link);
			refcount_set(&subreq->usage, 2);
			subreq->rreq =3D rreq;
			netfs_get_read_request(rreq);
			netfs_stat(&netfs_n_rh_sreq);
		}

		return subreq;
	}

This would allow you to do, for instance:

	struct cifs_subrequest {
		struct netfs_read_subrequest subreq;
		struct cifs_credits credits;
	};

then:

	const struct netfs_request_ops cifs_req_ops =3D {
		.subrequest_size	=3D sizeof(struct cifs_subrequest),
		.init_rreq		=3D cifs_init_rreq,
		.expand_readahead	=3D cifs_expand_readahead,
		.clamp_length		=3D cifs_clamp_length,
		.issue_op		=3D cifs_req_issue_op,
		.done			=3D cifs_rreq_done,
		.cleanup		=3D cifs_req_cleanup,
	};

and then:

	static bool cifs_clamp_length(struct netfs_read_subrequest *subreq)
	{
		struct cifs_subrequest *cifs_subreq =3D
			container_of(subreq, struct cifs_subrequest, subreq);
		struct cifs_sb_info *cifs_sb =3D CIFS_SB(subreq->rreq->inode->i_sb);
		struct TCP_Server_Info *server;
		struct cifsFileInfo *open_file =3D subreq->rreq->netfs_priv;
		struct cifs_credits *credits =3D &cifs_subreq->credits;
		unsigned int rsize;
		int rc;

		server =3D cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);

		rc =3D server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
	                                                   &rsize, credits);
		if (rc)
			return false;

		subreq->len =3D rsize;
		return true;
	}

David

