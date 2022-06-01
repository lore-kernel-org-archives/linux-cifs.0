Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45625C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Jun 2022 08:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348797AbiFAIks (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jun 2022 04:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241561AbiFAIkr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jun 2022 04:40:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 923904A3E4
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 01:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654072845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sH1BtnUqb9tIQDLvd8F3V7DhKRqXLiChvQY80QUu680=;
        b=EynyP3KJq8sxsTdZvoPB+ZSky2wJ5o4oF4uB67cMOkUARRfte0YMezPTtXY7b1K8LkZVLH
        owzrsJKF553uOFscJSHlAQzTsAyUeOTW6uvYggyVpEpYAF6hpvx3bzv7ROyo16LA5xNipO
        02WTK4oHav5BeOvpQGOJeVI0LjPFDbY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-ytC6kgrYM_qctSBIOpmqGA-1; Wed, 01 Jun 2022 04:40:43 -0400
X-MC-Unique: ytC6kgrYM_qctSBIOpmqGA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9A54858EFE;
        Wed,  1 Jun 2022 08:40:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58D4B492C3B;
        Wed,  1 Jun 2022 08:40:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAKYAXd_9jw69iKPBvuE4DxdpwcH2H90h3NQDQ7nyxzbTnEcirg@mail.gmail.com>
References: <CAKYAXd_9jw69iKPBvuE4DxdpwcH2H90h3NQDQ7nyxzbTnEcirg@mail.gmail.com> <833010.1654031136@warthog.procyon.org.uk>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: ksmbd threads eating masses of cputime
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <928535.1654072840.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 01 Jun 2022 09:40:40 +0100
Message-ID: <928536.1654072840@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Namjae Jeon <linkinjeon@kernel.org> wrote:

> Okay, How do you reproduce this problem ? Did you run xfsftests
> against ksmbd RDMA ?

Yeah - I've been making sure my cifs filesystem changes work with RDMA.
There've been a lot of connections that haven't been taken down cleanly, d=
ue
to oopses, lockups and stuff.

One thing that could be useful is, say, /proc/fs/ksmbd/

> Okay, we need to add maximum retry count for that case.
> but when I check kernel thread name in your top message, It is RDMA conn=
ection.
> So smb_direct_read() is used in ksmbd_conn_handler_loop().
> I'd like to reproduce the problem to figure out where the problem is.
> Can I try to reproduce it with soft-iWARP and xfstests?

Note that I only noticed the issue when I switched to working on another
filesystem and found that performance was unexpectedly down by 80%.

I was using softRoCE, though it may well be causable with softIWarp also,
since that's not really a detail visible to cifs/ksmbd, I think.

I've just had a quick go at trying to reproduce this, hard-resetting the t=
est
client in the middle of performing an xfstest run, but it didn't seem to c=
ause
the single ksmbd:r5445 thread to explode.

David

