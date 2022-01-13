Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7B8C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jan 2022 18:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbiAMSWU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jan 2022 13:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiAMSWU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Jan 2022 13:22:20 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221D0C061574
        for <linux-cifs@vger.kernel.org>; Thu, 13 Jan 2022 10:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=upzyRxSQEVcd+sZJ5pXTbxbYz783mKH0c6SU5ycDxQY=; b=XMJOM8+QE8b3PX3FZj71mTb3MZ
        Gx+xnjBo1RKz07P0ytoqFxhFwueDCxn4XldrgztjZ0MVkhs/cMgpkGPo4zUuRZndn9qGTnmJbq/ra
        N2ClQ6B7hM+TJdpYJk2NhuSFRJBksl7t13ssmlW1NcXkrEwGgwEyOMCOxLnHKrlM4KTjDsAvoEUWe
        3Jkz1xzyAbI+OT/HJBcXsgMz9zWPjnoRHLSNZ/0+c86SZuN4TGf311cQs0kE5VZGaTeKlhtHWNpF0
        fbcaBEkh07XV3a7MEdWLpe621lgIeLNcMWYqd5VxsYxleZZFgWzAang5Lf1j/L0fCWH4uI8TEa1z1
        /kdU5QGozCambxuk66tLe8jRJ2JqUS09SdTm6cnlfvQ89v6QKrijmB+wMg+VlRuEVINqG/SnKdH2W
        kfBwROj2pxysqqbSrvgqyOsOc5j5JGBA6uGXA7cC6Oq1aZu1740g0NsciWwG9kI1Fzhd5+kEOoejl
        OYuboEjV0GKyohP5xI1PXV9O;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1n84jp-0078lO-BA; Thu, 13 Jan 2022 18:22:17 +0000
Date:   Thu, 13 Jan 2022 10:22:14 -0800
From:   Jeremy Allison <jra@samba.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     David Howells <dhowells@redhat.com>, smfrench@gmail.com,
        Shyam Prasad N <nspmangalore@gmail.com>, jlayton@kernel.org,
        linux-cifs@vger.kernel.org
Subject: Re: Incorrect fallocate behaviour in cifs or samba?
Message-ID: <YeBt1g9+syau0j1w@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <1828480.1642079920@warthog.procyon.org.uk>
 <1856457.1642087232@warthog.procyon.org.uk>
 <YeBkxLnh8+sUv968@jeremy-acer>
 <20220113191607.04e20180@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220113191607.04e20180@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jan 13, 2022 at 07:16:07PM +0100, David Disseldorp wrote:
>FWIW, Samba's fsctl_zero_data semantics are based on observed Windows
>server behaviour and the MS specs, which state(d at the time):
>/*
> * 2.3.57 FSCTL_SET_ZERO_DATA Request
> *
> * How an implementation zeros data within a file is implementation-dependent.
> * A file system MAY choose to deallocate regions of disk space that have been
> * zeroed.<50>
> * <50>
> * ... NTFS might deallocate disk space in the file if the file is stored on an
> * NTFS volume, and the file is sparse or compressed. It will free any allocated
> * space in chunks of 64 kilobytes that begin at an offset that is a multiple of
> * 64 kilobytes. Other bytes in the file (prior to the first freed 64-kilobyte
> * chunk and after the last freed 64-kilobyte chunk) will be zeroed but not
> * deallocated.
> */
>
>IIRC while implementing this I observed Windows deallocation behaviour
>using FSCTL_QUERY_ALLOCATED_RANGES (referred to as QAR in the previous
>code snippit).

Oh thanks so much for clarifying David. It's always nice
to hear things from the person who actually wrote the
code :-).
