Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE1FC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Mar 2022 08:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiCKI17 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Mar 2022 03:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiCKI16 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Mar 2022 03:27:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 442CC1B8FDA
        for <linux-cifs@vger.kernel.org>; Fri, 11 Mar 2022 00:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646987215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wlaP9+roIv8WEhpOtJJ7QViYWXtJ77vxkd2PAzZem+w=;
        b=LGedq6xCWLhFJ4k8p2fUp3zbPA5YCcz5notGzfsQsE6NqIA08TtskTmwAKpTMEj4CH6DA8
        RiXlr0QpUa910uLjD/daMOpeGCSdTES+kcDLQXaKN8/Kqsvxf0U61WJK5RHAEsErY9gckg
        uwVWLrSk+9h88vw9uL+Qxk75RWCdIn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-bLkTHbMtOueRST_rkRhC6w-1; Fri, 11 Mar 2022 03:25:42 -0500
X-MC-Unique: bLkTHbMtOueRST_rkRhC6w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA4181091DA1;
        Fri, 11 Mar 2022 08:25:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B79CC7369B;
        Fri, 11 Mar 2022 08:25:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <2314914.1646986773@warthog.procyon.org.uk>
References: <2314914.1646986773@warthog.procyon.org.uk>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, jlayton@kernel.org,
        linux-cifs@vger.kernel.org
Subject: Re: cifs conversion to netfslib
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 11 Mar 2022 08:25:35 +0000
Message-ID: <2315193.1646987135@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


David Howells <dhowells@redhat.com> wrote:

> The other issue is that if I run splice to an empty file, it works; runni=
ng
> another splice to the same file will result in the server giving
> STATUS_ACCESS_DENIED when cifs_write_begin() tries to read from the file:
>=20
>     7 0.009485249  192.168.6.2 =E2=86=92 192.168.6.1  SMB2 183 Read Reque=
st Len:65536 Off:0 File: x
>     8 0.009674245  192.168.6.1 =E2=86=92 192.168.6.2  SMB2 143 Read Respo=
nse, Error: STATUS_ACCESS_DENIED
>=20
> Actually - that might be because the file is only 65536 bytes long becaus=
e the
> first splice finished short.

Actually, it's because I opened the output file O_WRONLY.  If I open it
O_RDWR, it works.  The test program is attached below.

David
---
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
	off64_t opos;
	size_t len;
	int in, out;

	if (argc !=3D 4) {
		printf("Format: %s size in out\n", argv[0]);
		exit(2);
	}

	len =3D atol(argv[1]);

	if (strcmp(argv[2], "-") !=3D 0) {
		in =3D open(argv[2], O_RDONLY);
		if (in < 0) {
			perror(argv[2]);
			return 1;
		}
	} else {
		in =3D 0;
	}

	if (strcmp(argv[3], "-") !=3D 0) {
		out =3D open(argv[3], O_WRONLY);  // Change to O_RDWR
		if (out < 0) {
			perror(argv[3]);
			return 1;
		}
	} else {
		out =3D 1;
	}

	opos =3D 3;
	if (splice(in, NULL, out, &opos, len, 0) < 0) {
		perror("splice");
		return 1;
	}

	if (close(in) < 0) {
		perror("close/in");
		return 1;
	}

	if (close(out) < 0) {
		perror("close/out");
		return 1;
	}

	return 0;
}

