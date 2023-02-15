Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA58C636D4
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Feb 2023 13:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbjBONDG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Feb 2023 08:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbjBONDF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Feb 2023 08:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27E535252
        for <linux-cifs@vger.kernel.org>; Wed, 15 Feb 2023 05:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676466128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1kO8N6JLykhQ4YdfKs2d43b+gPORvqK7xPAz9ypT+Zk=;
        b=evrgbIJa3NmCarau6CRjtl8FINp/OfKkv5n+GqX07uBwkZprbvu7eTMEJVw/NAzfv6Nvgj
        H0pCtrxIck+a89ydGwuCbu6apizx9neVnJ8nbBDrXC3d+dZLlgl+tS8kBxm56M900gjQh6
        q7/NvzaXrEVyeyVOMZEKzAY13vNVGCE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-BxtiEXZhM5WJBsv1CLOnxg-1; Wed, 15 Feb 2023 08:02:02 -0500
X-MC-Unique: BxtiEXZhM5WJBsv1CLOnxg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 842BD3C10691;
        Wed, 15 Feb 2023 13:02:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57EA9140EBF4;
        Wed, 15 Feb 2023 13:01:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230215-topic-next-20230214-revert-v1-2-c58cd87b9086@linaro.org>
References: <20230215-topic-next-20230214-revert-v1-2-c58cd87b9086@linaro.org> <20230215-topic-next-20230214-revert-v1-0-c58cd87b9086@linaro.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     dhowells@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] Revert "splice: Do splice read from a buffered file without using ITER_PIPE"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3055588.1676466118.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 15 Feb 2023 13:01:58 +0000
Message-ID: <3055589.1676466118@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Konrad Dybcio <konrad.dybcio@linaro.org> wrote:

> next-20230213 introduced commit d9722a475711 ("splice: Do splice read fr=
om
> a buffered file without using ITER_PIPE") which broke booting on any
> Qualcomm ARM64 device I grabbed, dereferencing a null pointer in
> generic_filesplice_read+0xf8/x598. Revert it to make the devices
> bootable again.
> =

> This reverts commit d9722a47571104f7fa1eeb5ec59044d3607c6070.
> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Commit d9722a47571104f7fa1eeb5ec59044d3607c6070 was part of v13 of my
patches.  This got replaced yesterday by a newer version which may or may =
not
have made it into linux-next.

This is probably a known bug fixed in the v14 by making shmem have its own
splice-read function.

Can you try this?

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Diov-extract

(Also, can you include me in the cc list as I'm the author of the patch yo=
u
reverted?)

Thanks,
David

