Return-Path: <SRS0=Gj+3=BW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6AFC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Aug 2020 05:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 742462065C
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Aug 2020 05:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SwVHJIrp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHLFPZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Aug 2020 01:15:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbgHLFPY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 12 Aug 2020 01:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597209323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LqaxVWIWJTlMsi24eVAxDpqUeW9ke6pP0obDrRdAnuc=;
        b=SwVHJIrpM84VjrPRw2AevzXva20S3Bi+aphdULRE+v8fLsstYPlhRsFVlui1ZYgXL4VuOl
        sF3AcpfULY57NEMFF6/ox+W9lFSvoHostM/Kh2CBxbrSAIjYIKGDLCiKdVtg3GfYK1985I
        ftkf2l7+pOTi553bDmIe69MwQxBuyaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-2kvSrrq8PJGHRQWSCDCyVQ-1; Wed, 12 Aug 2020 01:15:18 -0400
X-MC-Unique: 2kvSrrq8PJGHRQWSCDCyVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD9CE1853DA6;
        Wed, 12 Aug 2020 05:15:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A61A26111F;
        Wed, 12 Aug 2020 05:15:17 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 95FAAA554D;
        Wed, 12 Aug 2020 05:15:17 +0000 (UTC)
Date:   Wed, 12 Aug 2020 01:15:16 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Message-ID: <1619554063.45933506.1597209316992.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5mvkUsp29RPEOmDRra+0GQn_AH1QhabKkEdQZafOLBCv9w@mail.gmail.com>
References: <1097808468.45751159.1597108422888.JavaMail.zimbra@redhat.com> <3704067.45751512.1597109127904.JavaMail.zimbra@redhat.com> <CAH2r5mt389QPfeZPSTun9qkc=88ehFC1NzayewCoKU=qv+Epaw@mail.gmail.com> <CAH2r5mvkUsp29RPEOmDRra+0GQn_AH1QhabKkEdQZafOLBCv9w@mail.gmail.com>
Subject: Re: FS-Cache for cifs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.6]
Thread-Topic: FS-Cache for cifs
Thread-Index: Z/YDuT7n5G1SwWSYq+MUtBNiFPEd7Q==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Steve for the info. File a bug for cifs fscache.

Bug 208883 - CIFS: kernel BUG at fs/cachefiles/rdwr.c:715!
https://bugzilla.kernel.org/show_bug.cgi?id=3D208883


----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "Xiaoli Feng" <xifeng@redhat.com>
> Cc: "CIFS" <linux-cifs@vger.kernel.org>, "David Howells" <dhowells@redhat=
.com>
> Sent: Tuesday, August 11, 2020 10:12:28 AM
> Subject: Re: FS-Cache for cifs
>=20
> My tests in recent kernels with fscache and cifs.ko worked but didn't
> provide much performance benefit (which would be expected since close
> releases leases )
>=20
> On Mon, Aug 10, 2020, 20:51 Steve French <smfrench@gmail.com> wrote:
>=20
> > fscache (perhaps more so with the recent rewrite that Dave Howells
> > did) may be most well suited to cifs.ko (SMB3.1.1 mounts) among the
> > various file systems since it would allow offline caching of files and
> > directories leveraging:
> > 1) handle leases and directory leases for "strict caching" models
> > or
> > 2) directory change notification for "loose caching" models
> > (Although file version numbers are not provided, the combination of
> > creation time, 64 bit DiskFileId, and last write time with 100ns time
> > granularity is probably sufficient to use in conjunction with this)
> > In addition the protocol already supports four flags to control
> > whether client side offline caching can/should be done:
> >    SMB2_SHAREFLAG_MANUAL_CACHING
> >    SMB2_SHAREFLAG_AUTO_CACHING
> >    SMB2_SHAREFLAG_VDO_CACHING
> >    SMB2_SHAREFLAG_NO_CACHING
> >
> > So fscache could be very, very useful for cifs.ko, especially for
> > metadata heavy workloads that are largely from one client ... but
> > fscache doesn't have tight integration with many cifs features (like
> > handle leases e.g.) yet.
> >
> > It would make sense to better tie cifs.ko in with fscache (especially
> > as it has shown to be useful on other operating systems over
> > SMB3/SMB3.1.1).
> >
> > On Mon, Aug 10, 2020 at 8:25 PM Xiaoli Feng <xifeng@redhat.com> wrote:
> > >
> > > Hello everyone,
> > >
> > > Recently I'd like to test fs-cache for cifs. But CONFIG_CIFS_FSCACHE =
is
> > not set defaultly.
> > > Are there any concern to enable it? Test it to enbale fs-cache. It se=
ems
> > work. The file
> > > /proc/fs/fscache/stats is update when do some cp operations.
> > >
> > > Thanks.
> > >
> > > --
> > > Best regards!
> > > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >
>=20

