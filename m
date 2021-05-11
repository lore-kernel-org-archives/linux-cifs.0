Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC80C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 13:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8CE0611CB
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 13:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhEKNEi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 09:04:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhEKNEf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 09:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620738208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wEXY8BTqa3d3uYB2YjcuwQfVE+POd7RJ8n0NUW4FWKQ=;
        b=WcH6ZTVjfMuYQlhcGA1dCqDY8WmKqDiF/9s7Izunj9shVoNSKnQ2BrgjiIURlJEBUY1gUv
        ZpeOYmLsVyyw5Dz2ML1/i7nO3ahhoiDyJ0eDD3AMNaaMptZOkFAODNVonDgnnrVS8yy1F9
        N84Lr4/aXfJPDRQ19ESb28Onn7DYcbc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-9PDcTZLuOZaP9USgtjLcrQ-1; Tue, 11 May 2021 09:03:25 -0400
X-MC-Unique: 9PDcTZLuOZaP9USgtjLcrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69F6E19611BE;
        Tue, 11 May 2021 13:03:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2B7F60C04;
        Tue, 11 May 2021 13:03:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5ms+NL=J2Wa=wY2doV450qL8S97gnJW_4eSCp1aiz1SEZA@mail.gmail.com>
References: <CAH2r5ms+NL=J2Wa=wY2doV450qL8S97gnJW_4eSCp1aiz1SEZA@mail.gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Compile warning with current kernel and netfs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2509399.1620738202.1@warthog.procyon.org.uk>
Date:   Tue, 11 May 2021 14:03:22 +0100
Message-ID: <2509400.1620738202@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

>   CC [M]  /home/smfrench/cifs-2.6/fs/cifs/fscache.o
>   CHECK   /home/smfrench/cifs-2.6/fs/cifs/fscache.c
> /home/smfrench/cifs-2.6/fs/cifs/fscache.c: note: in included file
> (through include/linux/fscache.h,
> /home/smfrench/cifs-2.6/fs/cifs/fscache.h):
> ./include/linux/netfs.h:93:15: error: don't know how to apply mode to
> unsigned int enum netfs_read_source

Yeah - that's a bit the checker doesn't know how to support.  It's meant to
make enum netfs_read_source-type struct members take less space.  I think gcc
and clang are both fine with it.

David

