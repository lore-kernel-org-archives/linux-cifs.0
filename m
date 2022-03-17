Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63689C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 16:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiCQQSQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 12:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbiCQQSL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 12:18:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 773512156CD
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 09:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647533813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DzUc0fbL/Wfl6TD+2pofl1aOjoc4l6i5AmYpNFDGmDI=;
        b=bCi3S2Q603AW8uhxEbuDCXAcdUVciHBAx3zm5mMhZ4q8bZVBxNsixGsTZb+dwY1XsjNSrx
        +CGKcrZmgt3jlbSxne4VKwOVZK15or7mVIoR2W0CzXp8jagHtZ8lmTKM6KAK//sVNmOBN1
        otU8R9IjnHjQA0rpzASIbX17DT5scXc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-M9BUyVmuMXu5SbX5vVsk7Q-1; Thu, 17 Mar 2022 12:16:52 -0400
X-MC-Unique: M9BUyVmuMXu5SbX5vVsk7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D04493C01DA4;
        Thu, 17 Mar 2022 16:16:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3550C28100;
        Thu, 17 Mar 2022 16:16:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <4085703.1647475640@warthog.procyon.org.uk>
References: <4085703.1647475640@warthog.procyon.org.uk> <CACdtm0YuO+t46wQf9pKu9-U-=vguvwpEu6VXrkXV3JDocFM2qg@mail.gmail.com> <2314914.1646986773@warthog.procyon.org.uk> <2315193.1646987135@warthog.procyon.org.uk> <CACdtm0Y_F7JjoqvC63+3CU0brETf+iEQ_UjMyx+WzhtwE1HGSw@mail.gmail.com>
Cc:     dhowells@redhat.com, Rohith Surabattula <rohiths.msft@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, jlayton@kernel.org,
        linux-cifs@vger.kernel.org
Subject: Re: cifs conversion to netfslib
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <170114.1647533810.1@warthog.procyon.org.uk>
Date:   Thu, 17 Mar 2022 16:16:50 +0000
Message-ID: <170115.1647533810@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> I am seeing the occasional:
> 
> 	CIFS: trying to dequeue a deleted mid
> 
> but I haven't managed to work out how I get to that yet.

That turned out to be due to EFAULT occurring in sock_recvmsg() called from
cifs_readv_from_socket() because it was handed an iovec-class iov_iter.  It
went through:

		if (length <= 0) {
			cifs_dbg(FYI, "Received no data or error: %d\n", length);
			cifs_reconnect(server, false);
			return -ECONNABORTED;
		}

which called cifs_abort_connection() which forcibly marked the MIDs as
deleted.  However, they got dequeued later which triggered the message.

Telling netfs's DIO read to turn it into a bvec-class iov_iter instead stopped
that happening, but it's may be a latent problem.

I also found the causes of the occasional "server overflowed SMB3 credits"
messages that I've been seeing:

Firstly, the data read path was returning credits both when freeing the
subrequest and at the end of smb2_readv_callback().  I made the former
conditional on not doing the latter.

Secondly, cifs_write_back_from_locked_page() was returning credits, even if
->async_writev() was successful.  I made that only do it on error.

And now it gets through generic/013 for me.

David

