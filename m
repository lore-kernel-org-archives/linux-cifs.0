Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87674EB64D7
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jun 2023 23:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjFMXep (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Jun 2023 19:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjFMXeo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Jun 2023 19:34:44 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B7F1713
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jun 2023 16:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=fXvfTZg6b7z+gzNDpU83sunvHkwgM2ODmMeyATC7lzA=; b=D3i56uhl8wI8HSeeawvOnPRmlg
        A9ilPacra+L1kbwooMXM4RR+Pwv0HUjjihJzgnNxVufd7VCzjN8bvEEsgCVQCr00XVq5qZ86suM8m
        akTV2cm4Walq9GoXDxDRJgS2SREyDFixD3Jf9HUREJISDM29YA9rN4xx9dy3+sTrJ/xVqOTl/PAiK
        lJVJVO6rXH0b064GvreK4Oc+2Ol3ueVJ7vo+nKynMkLiGfBqUdZhFiRJ8ykhKBF1R9oqbFv2+NTeF
        gEybUaxSH0RrzFyXvlksdIpnTOZUvysER/7Lb/aizWVpCaMCd3aS7utwCfMp7CoWbImCz8qcDsmAq
        KlIBqEM6glXpZ+cN1eeL5K5B4Oy+8ISB2lzBl5uDdqTSj43Xpjm6QFs4VWQfHYahSCpDjNCBLpNdF
        qK3qWtAXZaLkuEmWrMNp5UNDKuYBwVHjzCkkB9bKiHQFfI+3gByIgcQKSoDrcqEaKKFEX8VQ0By9Q
        L3jFDanvisSxBJssAavwV8Rz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1q9DX5-001ngJ-1N;
        Tue, 13 Jun 2023 23:34:39 +0000
Date:   Tue, 13 Jun 2023 16:34:35 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Samba returning mtime for multiple time stamp fields
Message-ID: <ZIj9CwDYeT0GKb0J@jeremy-rocky-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muZavtKBU__Qy2s+XRG11u1HXyjC3oXF2yxY5h1b2jh1g@mail.gmail.com>
 <CAH2r5muVt+x26kMQ+OsB4WOVZ4bqeTLtG0GAVSXksSuE6YDy=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muVt+x26kMQ+OsB4WOVZ4bqeTLtG0GAVSXksSuE6YDy=Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jun 13, 2023 at 06:17:35PM -0500, Steve French wrote:
>Samba seems to be the only server with this bug (I tried it with and
>without vfs_btrfs as well).  The test works to the other servers I
>tried including Windows.
>
>Windows server updates ctime on hardlinks, but Samba fails to update
>the timestamps in this case since it looks like it populates both
>ChangeTime (ctime) and LastWriteTime (mtime) based on mtime rather
>than setting:    ChangeTime = ctime (and LastWriteTime = mtime).
>Locally the mtime and ctime are correct on the Samba server, but
>remotely it reports it wrong.

Can you log a bug please and upload traces of the client
talking to a Windows.latest server and a Samba.master
built server.

Thanks,

Jeremy.
