Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B305BC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 00:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344717AbiCQAIo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Mar 2022 20:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiCQAIn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Mar 2022 20:08:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B41481C916
        for <linux-cifs@vger.kernel.org>; Wed, 16 Mar 2022 17:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647475646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnk61cl6NtNBjPp4T84yxo6yhw++yBOfcMiKdB2kSNs=;
        b=S60qjA5vtzbSFMX/nuHhrENouasGpwrERJj+AYa+dpFIyngJqsS6Ywgo1zzjRCATqJGH0d
        TwOphHwemWqWYbSmvyS+Sc7ajnaUZFstRpyDZe9M3hEovfC+rW3pXAQgLev8tteggCJm11
        bssQeZ7oq8YzHdTPWCLv1bM/iRFz+TE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-Rut4cQzaNE-q941DkgAt0A-1; Wed, 16 Mar 2022 20:07:23 -0400
X-MC-Unique: Rut4cQzaNE-q941DkgAt0A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C49853811F29;
        Thu, 17 Mar 2022 00:07:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B1321427B21;
        Thu, 17 Mar 2022 00:07:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0YuO+t46wQf9pKu9-U-=vguvwpEu6VXrkXV3JDocFM2qg@mail.gmail.com>
References: <CACdtm0YuO+t46wQf9pKu9-U-=vguvwpEu6VXrkXV3JDocFM2qg@mail.gmail.com> <2314914.1646986773@warthog.procyon.org.uk> <2315193.1646987135@warthog.procyon.org.uk> <CACdtm0Y_F7JjoqvC63+3CU0brETf+iEQ_UjMyx+WzhtwE1HGSw@mail.gmail.com>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, jlayton@kernel.org,
        linux-cifs@vger.kernel.org
Subject: Re: cifs conversion to netfslib
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4085702.1647475640.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 17 Mar 2022 00:07:20 +0000
Message-ID: <4085703.1647475640@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> wrote:

> I noticed 2 other issues while running xfstests.
> =

> Noticed kernel OOPS during test generic/286:
> folio_test_writeback returned false which means PG_writeback flag has
> been cleared. I am not sure whether head page has PG_writeback flag
> set initially? Can you please confirm.
> =

> [ 2275.941096] CIFS: bad 2000 @64f0000 page 64f0 64f1
> [ 2275.945785] ------------[ cut here ]------------
> [ 2275.945787] kernel BUG at /home/lxsmbadmin/latest_14mar/linux-fs/fs/c=
ifs/cifssmb.c:1954!
> ...
> [ 2275.969812] Workqueue: cifsiod cifs_writev_complete [cifs]
> [ 2275.974909] RIP: 0010:cifs_pages_written_back+0x1e1/0x1f0 [cifs]
> [ 2275.975570] CIFS: bad 2000 @64f0000 page 64f0 64f1
> [ 2275.980641] Call Trace:
> [ 2275.980643]  <TASK>
> [ 2275.980648]  cifs_writev_complete+0x43d/0x500 [cifs]

I don't see that, but it fails in some other ways.  I think the bits shoul=
d be
set.

I am seeing the occasional:

	CIFS: trying to dequeue a deleted mid

but I haven't managed to work out how I get to that yet.

I'm also occasionally seeing cifs_open() return a number >0, which causes =
all
sorts of fun. =


> Noticed that with netfs integration, file open with O_DIRECT flag is
> not supported.

It should be.  It jumps off to netfs_direct_read_iter() in various places.

openat(AT_FDCWD, "/xfstest.test/hello2", O_RDWR|O_DIRECT) =3D 3
fstatfs(3, {f_type=3DSMB2_MAGIC_NUMBER, f_bsize=3D1024, f_blocks=3D5496101=
6, f_bfree=3D23691924, f_bavail=3D23691924, f_files=3D0, f_ffree=3D0, f_fs=
id=3D{val=3D[1904023890, 0]}, f_namelen=3D255, f_frsize=3D1024, f_flags=3D=
ST_VALID|ST_RELATIME}) =3D 0
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D278528, ...}) =3D 0
pread64(3, "\253\253\253\253\253\253\253\253\253\253\253\253\253\253\253\2=
53\253\253\253\253\253\253\253\253\253\253\253\253\253\253\253\253"..., 40=
96, 0) =3D 4096

Btw, I've pushed an update to my cifs-experimental branch.

David

