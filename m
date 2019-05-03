Return-Path: <SRS0=KlGx=TD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39C3C43219
	for <linux-cifs@archiver.kernel.org>; Fri,  3 May 2019 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96E9F2070B
	for <linux-cifs@archiver.kernel.org>; Fri,  3 May 2019 21:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="npcDww1z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfECVIK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 May 2019 17:08:10 -0400
Received: from hr2.samba.org ([144.76.82.148]:21658 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbfECVIK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 3 May 2019 17:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=VNspjs9VC9guH+qsODYRCpoC5byx9t2O+ooU/CXSptM=; b=npcDww1zWon1xqm5QuhvxcjztN
        1E9N5PmxNp3GvYAF88f4QdMeMfMJNugx7JEGsh7XXjmvyWo5pPtCrEe8RdMnhHrbCc+4TGpm9J3F7
        VX56CSd+HOk3VdVuGFt6cwJc7OWLmKtI/L9A0dFpAB1ClpNLzaurxzAUM2bJVuTe+97o=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hMfPb-0006fU-Q1; Fri, 03 May 2019 21:08:08 +0000
Date:   Fri, 3 May 2019 23:08:03 +0200
From:   David Disseldorp <ddiss@samba.org>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Samba Technical <samba-technical@lists.samba.org>
Subject: Re: SMB2 SET_ZERO_DATA and PUNCH_HOLE
Message-ID: <20190503230803.58266ae2@samba.org>
In-Reply-To: <CAN05THSthhyGctyByj5eun6C_KK58xWgNYer+7TKBrqyObNZsw@mail.gmail.com>
References: <CAN05THSthhyGctyByj5eun6C_KK58xWgNYer+7TKBrqyObNZsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 25 Apr 2019 17:23:56 +1000, ronnie sahlberg wrote:

> Folks.
> 
> In the cifs client  we use FSCTL_SET_ZERO_DATA when userspace wants to
> punch a hole in a file. SET_ZERO_DATA maps quite well to the
> PUNCH_HOLE semantics in that it will deallocate what it can and
> overwrite what it can not with 0.

Cool, I'd be interested to hear how things go when testing against
a Samba SMB2+ server - it similarly maps FSCTL_SET_ZERO_DATA to
PUNCH_HOLE.

> On windows 16/ntfs the deallocate blocksize is 64k.
> 
> Does anyone know if this is always 64k or if there is a way to query
> the server for this?

smbtorture4 includes a sparse_hole_dealloc test for checking this via
incremental ZERO_DATA + QAR requests:
https://git.samba.org/?p=samba.git;a=blob;f=source4/torture/smb2/ioctl.c#l3981

I don't recall seeing anything non-64k at the time, but I didn't check
that thoroughly.

Cheers, David
