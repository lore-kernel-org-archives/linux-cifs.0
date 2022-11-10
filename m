Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9A3C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Nov 2022 15:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiKJPF0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Nov 2022 10:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKJPFZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Nov 2022 10:05:25 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4491D67B
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 07:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=qL7ePikABfIXzVw6Z/2qzrMSs56bypG7tZY4JaTRn2Y=; b=dwHkPkGxtw488Wcw6xjv3IVLI0
        HE7vSvZsb6syBN/WUOGIQOBVmFRXByuMryjGfYLIRytop6vfCDk9FC1RruZQBVDo9ZLBdPzt1NMuq
        ojjkDT0qaDHUq1RUsez1NNyOjLHG9WuzsYf1s5HIW3ovxc6U0pHbIuhaNbdvMjOAhK2b5AzqKZjBe
        lT9NTjBnELFv88XziPtyGx9qEjkR2qbrcvlxPRmmqx/XDx8fgvZ/TGK0wtTCDNC981elZHa5plnE7
        Pg+H3EpOG29CKM9c1Y4HJI1hjGDnhKMYl2yqlpO4N9p1MRrLcCa0ZYdpzAw0ATcorIgHm1dmtU+oJ
        5zQMP+loOegjM6TP+UdHCU+i+EydSoNOq98wXUWMQHW4yOKe5GNli/k6Ejyvz4gLexPfR9WzSadLO
        nlyahZy4A/Q8YfEZOxwaEvxBO/TFkcizRAxmKRaWHL+IQGaYPGL3TzB2d8DabTxobaYBuRFb+x605
        5q9JVI0HZ6UNA1Yx+kcZ7P4c;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ot96Q-00815o-LS; Thu, 10 Nov 2022 15:04:26 +0000
Date:   Thu, 10 Nov 2022 16:05:03 +0100
From:   David Disseldorp <ddiss@samba.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jeremy Allison via samba-technical 
        <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>, metze@samba.org,
        Steve French <smfrench@gmail.com>, vl@samba.org,
        Jeremy Allison <jra@samba.org>
Subject: Re: reflink support and Samba running over XFS
Message-ID: <20221110160503.4dd8b219@echidna.suse.de>
In-Reply-To: <Y2zjpE6f6WLtkqiz@infradead.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
        <Y2molp4pVGNO+kaw@jeremy-acer>
        <Y2n7lENy0jrUg7XD@infradead.org>
        <Y2qXLNM5xvxZHuLQ@jeremy-acer>
        <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
        <Y2vzinRPFEBZyACg@jeremy-acer>
        <Y2v1zQbnPoqg+0aj@jeremy-acer>
        <Y2v+au3rvWOUOr1t@jeremy-acer>
        <20221109233055.43b26632@echidna.suse.de>
        <Y2zjpE6f6WLtkqiz@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 10 Nov 2022 03:42:28 -0800, Christoph Hellwig wrote:

> On Wed, Nov 09, 2022 at 11:30:55PM +0100, David Disseldorp via samba-tech=
nical wrote:
> > I think it's doable too :-). As indicated in my other mail, I think
> > FICLONERANGE will need to be used for FSCTL_DUP_EXTENTS_TO_FILE instead
> > of copy_file_range().
> > I'm not sure how to best handle FILE_SUPPORTS_BLOCK_REFCOUNTING -
> > ideally we'd set it for Btrfs and XFS(reflink=3D1) backed shares only.
> > Another option might be to advertise FILE_SUPPORTS_BLOCK_REFCOUNTING and
> > then propagate errors up to the client if FICLONERANGE fails for
> > FSCTL_DUP_EXTENTS_TO_FILE. Client copy fallback would work, but the
> > extra request overhead would be ugly. =20
>=20
> We could probably add a bit to struct statx if that is helpful for
> samba.

I think that'd be helpful for the above example.

The corresponding MS-FSA spec states:
  2.1.5.9.4 FSCTL_DUPLICATE_EXTENTS_TO_FILE
  ...
  The purpose of this operation is to make it look like a copy of a region =
from the source stream to the
  target stream has occurred when in reality no data is actually copied. Th=
is operation modifies the
  target stream's extent list such that, the same clusters are pointed to b=
y both the source and target
  streams' extent lists for the region being copied.

So it would appear that SMB clients can expect metadata I/O only.

There's one other SMB caveat which should be considered with any statx
changes, from MS-FSCC:

  2.3.9 FSCTL_DUPLICATE_EXTENTS_TO_FILE_EX Request
  ...
  When the DUPLICATE_EXTENTS_DATA_EX_SOURCE_ATOMIC
  flag isn=E2=80=99t set, the behavior is identical to FSCTL_DUPLICATE_EXTE=
NTS_TO_FILE. When the flag is set,
  duplication is atomic from the source's point of view. It means duplicati=
on fully succeeds or fails
  without side effect (when only part of source file region is duplicated).

Cheers, David
