Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96718C12002
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 17:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F6FA600D1
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 17:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbhGUQg3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jul 2021 12:36:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231950AbhGUQgZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 21 Jul 2021 12:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626887821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45Nv4CwiblR8FGtkBjhkDjeZeYsNgqMrzsXCoaXKlcs=;
        b=Ic9L2YT1Yo4hu8O6cqAmQBQFtkcRA0BWkkM7R/eNsfOFEsbX8yMattnlpQMrOUv4k3sMrz
        MGYcuDEaLOvB913+Qijt7bwItca2V+UoCWL+8jhuhUoGT2stlRGp63q0M46/suDaI+HyCO
        5HBHKbPCcSDWVoi5Vzqa4CNwCVk00TI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-JezP4jySNK6olxZIv66-5Q-1; Wed, 21 Jul 2021 13:16:58 -0400
X-MC-Unique: JezP4jySNK6olxZIv66-5Q-1
Received: by mail-qv1-f70.google.com with SMTP id kj25-20020a0562145299b02902fbda5d4988so1987736qvb.11
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jul 2021 10:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=45Nv4CwiblR8FGtkBjhkDjeZeYsNgqMrzsXCoaXKlcs=;
        b=cqVqXzm1cXLN08sC54mpm/dlMRh2+zTSBkGhiOoQ30zCM9DB1/Tq6CLSyGuzX07Lai
         P8hJwA68a4gDfZ73edZcVutdWLI8yDZjLP6F0//6dkBHQSf30CGnawJc12i6NpDiczIE
         taWajcCo6nZzrM2sHMeE0Ec6WQXFXOzuH7CgqO3UJO4567Z69lX8owUB7Xv+Y1pW138V
         S4Jzyj4WPtoUJ51pIOEBS5xhyQYj3RPmLxi4u2Af52CagtYBWbg8UQtdKRwW6bQchZox
         /h0eUFqKrQKA1HjWFv2IzAX1QsMjqJY+wjYy5fYObgCByfecGNEGBDjV902ByK9toYvG
         UBQQ==
X-Gm-Message-State: AOAM5335vrt4pBNqwlLfX7250A1A36pmOJXdUmqvON1qZavThRGpUNOi
        gYWBBkqdWNiimwefRNMzL+CbLAvL9BPQk5IEvtE8IFnnb7nBIso3Xx2/PsKjKAQkMLmf5oV/vZ9
        7VFkZDArUfUKAQT+PgA/Qdw==
X-Received: by 2002:ad4:45a6:: with SMTP id y6mr36933567qvu.1.1626887817698;
        Wed, 21 Jul 2021 10:16:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwroCy17a7YpgGcviCUSg3J+GVy+n4E5MAqofjS2RsLBi/0nF/2omAf2j+swlCqTU83eT+04Q==
X-Received: by 2002:ad4:45a6:: with SMTP id y6mr36933536qvu.1.1626887817521;
        Wed, 21 Jul 2021 10:16:57 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id t6sm1744741qkg.75.2021.07.21.10.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 10:16:57 -0700 (PDT)
Message-ID: <0555748529d483fb9b69eceb56bf9ebc1efceaf1.camel@redhat.com>
Subject: Re: [RFC PATCH 02/12] netfs: Add an iov_iter to the read subreq for
 the network fs/cache to use
From:   Jeff Layton <jlayton@redhat.com>
To:     David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Mike Marshall <hubcap@omnibond.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 21 Jul 2021 13:16:56 -0400
In-Reply-To: <162687509306.276387.7579641363406546284.stgit@warthog.procyon.org.uk>
References: <162687506932.276387.14456718890524355509.stgit@warthog.procyon.org.uk>
         <162687509306.276387.7579641363406546284.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 2021-07-21 at 14:44 +0100, David Howells wrote:
> Add an iov_iter to the read subrequest and set it up to define the
> destination buffer to write into.  This will allow future patches to point
> to a bounce buffer instead for purposes of handling oversize writes,
> decryption (where we want to save the encrypted data to the cache) and
> decompression.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/afs/file.c          |    6 +-----
>  fs/netfs/read_helper.c |    5 ++++-
>  include/linux/netfs.h  |    2 ++
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index c9c21ad0e7c9..ca529f23515a 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -319,11 +319,7 @@ static void afs_req_issue_op(struct netfs_read_subrequest *subreq)
>  	fsreq->len	= subreq->len   - subreq->transferred;
>  	fsreq->key	= subreq->rreq->netfs_priv;
>  	fsreq->vnode	= vnode;
> -	fsreq->iter	= &fsreq->def_iter;
> -
> -	iov_iter_xarray(&fsreq->def_iter, READ,
> -			&fsreq->vnode->vfs_inode.i_mapping->i_pages,
> -			fsreq->pos, fsreq->len);
> +	fsreq->iter	= &subreq->iter;
>  
>  	afs_fetch_data(fsreq->vnode, fsreq);
>  }
> diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
> index 0b6cd3b8734c..715f3e9c380d 100644
> --- a/fs/netfs/read_helper.c
> +++ b/fs/netfs/read_helper.c
> @@ -150,7 +150,7 @@ static void netfs_clear_unread(struct netfs_read_subrequest *subreq)
>  {
>  	struct iov_iter iter;
>  
> -	iov_iter_xarray(&iter, WRITE, &subreq->rreq->mapping->i_pages,
> +	iov_iter_xarray(&iter, READ, &subreq->rreq->mapping->i_pages,

What's up with the WRITE -> READ change here? Was that a preexisting
bug?

>  			subreq->start + subreq->transferred,
>  			subreq->len   - subreq->transferred);
>  	iov_iter_zero(iov_iter_count(&iter), &iter);
> @@ -745,6 +745,9 @@ netfs_rreq_prepare_read(struct netfs_read_request *rreq,
>  	if (WARN_ON(subreq->len == 0))
>  		source = NETFS_INVALID_READ;
>  
> +	iov_iter_xarray(&subreq->iter, READ, &rreq->mapping->i_pages,
> +			subreq->start, subreq->len);
> +
>  out:
>  	subreq->source = source;
>  	trace_netfs_sreq(subreq, netfs_sreq_trace_prepare);
> diff --git a/include/linux/netfs.h b/include/linux/netfs.h
> index fe9887768292..5e4fafcc9480 100644
> --- a/include/linux/netfs.h
> +++ b/include/linux/netfs.h
> @@ -17,6 +17,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/uio.h>
>  
>  /*
>   * Overload PG_private_2 to give us PG_fscache - this is used to indicate that
> @@ -112,6 +113,7 @@ struct netfs_cache_resources {
>  struct netfs_read_subrequest {
>  	struct netfs_read_request *rreq;	/* Supervising read request */
>  	struct list_head	rreq_link;	/* Link in rreq->subrequests */
> +	struct iov_iter		iter;		/* Iterator for this subrequest */
>  	loff_t			start;		/* Where to start the I/O */
>  	size_t			len;		/* Size of the I/O */
>  	size_t			transferred;	/* Amount of data transferred */
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

