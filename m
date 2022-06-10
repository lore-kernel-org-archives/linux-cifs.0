Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F6CC43334
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Jun 2022 18:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347484AbiFJSGp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Jun 2022 14:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349758AbiFJSGo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Jun 2022 14:06:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBFFEB1FF
        for <linux-cifs@vger.kernel.org>; Fri, 10 Jun 2022 11:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654884401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMsjmdghjftZcHJYxe23lhIe8tlheZvEV884DJ3XaMQ=;
        b=hFAyWA42f1/5pvbsGWSpXO1dsYj6wlEllNPGHyGnRKSfqZs8T4yEBtEOZkOukgDS1ai2j0
        9llwQFhzNyYujqFDdvhx59mCg+VVm/gU4mMVt8Z1RVYFjWln63VwW2SZtqHlsCl0iqFn7l
        Mo4fqh1XQxzu6YlQ1hRK/lNI1+I6zzM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-RurBROcsP7ulDRyRjKQieg-1; Fri, 10 Jun 2022 14:06:40 -0400
X-MC-Unique: RurBROcsP7ulDRyRjKQieg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 055FD1C01B20;
        Fri, 10 Jun 2022 18:06:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A360018EA7;
        Fri, 10 Jun 2022 18:06:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wgkwKyNmNdKpQkqZ6DnmUL-x9hp0YBnUGjaPFEAdxDTbw@mail.gmail.com>
References: <CAHk-=wgkwKyNmNdKpQkqZ6DnmUL-x9hp0YBnUGjaPFEAdxDTbw@mail.gmail.com> <40676.1654807564@warthog.procyon.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <smfrench@gmail.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical@lists.samba.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-hardening@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <652127.1654884394.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 10 Jun 2022 19:06:34 +0100
Message-ID: <652128.1654884394@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Side note: I think this could have been done with an unnamed union as
> =

>         struct my_inode {
>                 union {
>                         struct inode            vfs_inode;
>                         struct netfs_inode netfs_inode;
>                 };
>         [...]
> =

> instead, with the rule that 'netfs_inode' always starts with a 'struct i=
node'.

I'm slightly wary of that, lest struct netfs_inode gets randomised.  I'm n=
ot
sure how likely that would be without netfs_inode getting explicitly marke=
d.

> But in a lot of cases you really could do so much better: you *have* a
> "struct netfs_inode" to begin with, but you converted it to just
> "struct inode *", and now you're converting it back.
> =

> Look at that AFS code, for example, where we have afs_vnode_cache() doin=
g
> =

>         return netfs_i_cookie(&vnode->netfs.inode);
> =

> and look how it *had* a netfs structure, and it was passing it to a
> netfs function, but it explicitly passed the WRONG TYPE, so now we've
> lost the type information and it is using that cast to fake it all
> back.

Yeah, I didn't look at those as they didn't cause warnings, but you're rig=
ht -
those should take struct netfs_inode pointers in some cases, rather than
struct inode.

Note that some functions, such as netfs_readpage() and netfs_readpages() d=
o
need to take struct inode pointers as I'm trying to get the VFS ops to jum=
p
into netfslib and get all the VM interface stuff out of the network
filesystems - the idea being that the network filesystem will provide netf=
slib
primarily with two functions: do a read op and do a write op.

I'll have a look at your patch in a bit.

Thanks,
David

