Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614DEC4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Nov 2023 10:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjKFKC0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Nov 2023 05:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjKFKCZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Nov 2023 05:02:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EED2A6
        for <linux-cifs@vger.kernel.org>; Mon,  6 Nov 2023 02:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699264894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPgIyr8eZGTaHHUAuqbeAy3ULtRETSOYafFMSoTIqOE=;
        b=Qvm/o70qZuYGZcl1bpocc8a2rc5T366xsOyZEMXlNF/5iJA1k9cDRP3mO5qCy3h9GK0Z+3
        0G8QD13o+Ia1tTa+kY9E/iG7vsWE3A4gWGnhPf2oy+CPa24SDBTGTLFo6x5rxYBKF5C5Vd
        RzjVK2SEla1tc9O8oqY+lreGCpnHAL0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-UYj-SFJDNK6K_-IvvJ016g-1; Mon, 06 Nov 2023 05:01:19 -0500
X-MC-Unique: UYj-SFJDNK6K_-IvvJ016g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6011D185A780;
        Mon,  6 Nov 2023 10:01:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37F56492BE0;
        Mon,  6 Nov 2023 10:01:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZUiXkPPP1TuOgmmf@fedora.fritz.box>
References: <ZUiXkPPP1TuOgmmf@fedora.fritz.box> <20231022183917.1013135-1-sanpeqf@gmail.com> <ZUfQo47uo0p2ZsYg@fedora.fritz.box> <CAH2r5msde65PMtn-96VZDAQkT_rq+e-2G4O+zbPUR8zSWGxMsg@mail.gmail.com> <20231105193601.GB91123@sol.localdomain> <ZUfvk-6y2pER6Rmc@fedora.fritz.box> <20231105201516.GC91123@sol.localdomain>
To:     Damian Tometzki <damian@riscv-rocks.de>
Cc:     dhowells@redhat.com, Eric Biggers <ebiggers@kernel.org>,
        Steve French <smfrench@gmail.com>,
        John Sanpe <sanpeqf@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Paulo Alcantara <pc@manguebit.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: smb cifs: Linux 6.7 pre rc-1 kernel dump in smb2_get_aead_req
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2545099.1699264877.1@warthog.procyon.org.uk>
Date:   Mon, 06 Nov 2023 10:01:17 +0000
Message-ID: <2545100.1699264877@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Damian Tometzki <damian@riscv-rocks.de> wrote:

> the revert of f1b4cb650b9a0eeba206d8f069fcdc532bfbcd74 solved the issue of
> the kernel dump.

That almost certainly did not fix the problem - merely hid the wanring.

Prior to f1b4cb650b9a0eeba206d8f069fcdc532bfbcd74, ->user_backed is explicitly
set if the iov_iter is initialised to a user-backed type, now it's just
inferred from the type being 0 or 1 - so I think that the iov_iter has not
been initialised somewhere.

Somewhere being from SMB2_tcon() and cifs_send_recv() on down.

David

