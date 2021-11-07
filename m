Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD28C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264E76056B
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbhKGWFv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 17:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbhKGWFv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 17:05:51 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6DFC061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 14:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=hcg1u99ftUckMpfmpl4o3AP12FkeYAtMw6frd30xnVY=; b=ted2Irt7m0oTiUzsF/BVACOodQ
        l2UIOWyAqIoGFWDTvZqqu4vUGX6DYK4XvkHjiMGBLAqMTcmiOKvfI2699+lB11//y2hN1xD17voGO
        +CQnc0elfF0hcVhsNm21GKB+WrAcTQBWjz/11cpJyr/b7wV1SZHKE4Zjrt0CDpSYv11S0RRQs8Qph
        wPHbm0RBF9lbFKoJSI6kYeHunaQS3U+rpl2cognGXUEdom9evCQarOwMwlBsb+vMsOiFcqzrIo2Ut
        fIVnfNO3uE3nwwAo1hAsRgTg4VF5NAYAy7bL5GY2qj+QlhX4Pr+yV0P5OQS9AQe0MHJkRi98/Cn2l
        jBFOf8/98DRZ5jKfzYkkRnv3dLSsd/cgFLBfHXq/t7UAEtLORaGkjrxtBr+pNGAeAuvKP/r9IZUFV
        1Q88E/Ae4KQ56S2U5vhCJPGbxvhtdlw+qhnaRlDNGoEE/TsWF3dRh6xRTV4bvbFKyXCNo7Wjuzn+M
        Qd3qQkVvGgmjJk7bCPl+dOAk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mjqFl-005gEY-Au; Sun, 07 Nov 2021 22:03:05 +0000
Date:   Sun, 7 Nov 2021 14:03:02 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Julian Sikorski <belegdol@gmail.com>, linux-cifs@vger.kernel.org
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: Permission denied when chainbuilding packages with mock
Message-ID: <YYhNFiBDJS2Mi9PE@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer>
 <YYhJ+8ehPFX1XDhv@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YYhJ+8ehPFX1XDhv@jeremy-acer>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Nov 07, 2021 at 01:49:47PM -0800, Jeremy Allison wrote:
>>behavior. From 'man 2 fsync':
>>
>>NOTES
>>      On some UNIX systems (but not Linux), fd must be a writable file descriptor.
>
>If this is actually what is happening, Samba is implementing the
>Windows semantics, and not the Linux ones (as we should). From
>the Microsoft MS-SMB2 spec:
>
>https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/026984f6-38af-4408-8200-50557eb0a286
>
>--------------------------------------------------------------------------
>3.3.5.11 Receiving an SMB2 FLUSH Request
>10/04/2021
>
>When the server receives a request with an SMB2 header with a Command value
>equal to SMB2 FLUSH, message handling proceeds as follows:
>
>The server MUST locate the session, as specified in section 3.3.5.2.9.
>
>The server MUST locate the tree connection, as specified in section 3.3.5.2.11.
>
>Next the server MUST locate the open being flushed by performing
>a lookup in the Session.OpenTable, using the FileId.Volatile of the
>request as the lookup key. If no open is found, or if Open.DurableFileId
>is not equal to FileId.Persistent, the server MUST fail the request
>with STATUS_FILE_CLOSED. Otherwise, the server MUST locate the Request
>in Connection.RequestList for which Request.MessageId matches
>the MessageId value in the SMB2 header, and set Request.Open to the Open.
>
>If the Open is on a file and Open.GrantedAccess includes neither
>FILE_WRITE_DATA nor FILE_APPEND_DATA, the server MUST fail the
>request with STATUS_ACCESS_DENIED.
>
>If the Open is on a directory and Open.GrantedAccess includes
>neither FILE_ADD_FILE nor FILE_ADD_SUBDIRECTORY, the server MUST
>fail the request with STATUS_ACCESS_DENIED.
>--------------------------------------------------------------------------

Steve,

I just took a look inside cifsfs and it looks like the smb2_flush()
function is being called on a file descriptor without a check that
the fd is open for writing as far as I can tell. Am I missing such
a check ? Can you investigate to see if this is the case ? This would
also fail against a Windows server too I think.

Jeremy.
