Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34412C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 21:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2A87615A2
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 21:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhKGVwf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 16:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhKGVwe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 16:52:34 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F610C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 13:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:To:From:Date:CC;
        bh=QLg8Gu0cmn2d0O6RsXEspUeg+2gHlFNe3PxIRShXKO0=; b=XyvrJMNSQRai3qbVZ4D2nKY1ar
        bBYiDychuCudvTKd5JbWSA3pzR/Su9huPn9/LMToH9uZZX+d4tN7eHwWXnhLpg8p6EfPP5wFqS6Kx
        OpVua6/fbrlotCgM8yc/HAAQiL3IlIi7xXaad1uwOdPO6IUnPy1tBfiUuQMoplWpXfqjNAPBDba8c
        1By7nuq+AayB6r23IdUXID7uYuCAeyfn57ge3hOAspe0F+JPRPmnhL2+noCtmdt3kyHHJ6uJVE0+A
        FgkRvbYzw5k0IhoHyl8Wqzs7oFjaGjPveKtMTzMmZgZPeBEjLVccH205zZPxmuUhEWgsxm9aNaZCr
        uHZuq3gPAC305d9cdQdjnBZOK2FU7PED///Ii79tljYZtziXl76q4wU9l0scZkS77UfOZHfk4CthM
        ia0/+rq4v7ZjjEj/Sx1HXeOitnFwexm1CsqnJxf5ttvEv3+xP8aSLtlpJl8rQT303n6fucOqeWAih
        JdIHrqt8fzE1n+Hxw1zd78tx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mjq2v-005gAs-GY; Sun, 07 Nov 2021 21:49:49 +0000
Date:   Sun, 7 Nov 2021 13:49:47 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Julian Sikorski <belegdol@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Permission denied when chainbuilding packages with mock
Message-ID: <YYhJ+8ehPFX1XDhv@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YYhI1bpioEOXnFYf@jeremy-acer>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Nov 07, 2021 at 01:44:53PM -0800, Jeremy Allison wrote:
>On Sun, Nov 07, 2021 at 10:10:17PM +0100, Julian Sikorski wrote:
>>
>>but it is not really clear _why_ is the access being denied. Any 
>>ideas where to look? Thanks!
>
>What debug log level are you using on th server ? To debug
>something like this use log level 10.
>
>fsync failed: Permission denied
>
>is strange. I need to see what access mask the fsp is being
>opened with. If it's a directory, it might be running into
>this (from smbd_smb2_flush_send()):
>
>        if (!CHECK_WRITE(fsp)) {
>                bool allow_dir_flush = false;
>                uint32_t flush_access = FILE_ADD_FILE | FILE_ADD_SUBDIRECTORY;
>
>                if (!fsp->fsp_flags.is_directory) {
>                        tevent_req_nterror(req, NT_STATUS_ACCESS_DENIED);
>                        return tevent_req_post(req, ev);
>                }
>
>                /*
>                 * Directories are not writable in the conventional
>                 * sense, but if opened with *either*
>                 * FILE_ADD_FILE or FILE_ADD_SUBDIRECTORY
>                 * they can be flushed.
>                 */
>
>                if ((fsp->access_mask & flush_access) != 0) {
>                        allow_dir_flush = true;
>                }
>
>                if (allow_dir_flush == false) {
>                        tevent_req_nterror(req, NT_STATUS_ACCESS_DENIED);
>                        return tevent_req_post(req, ev);
>                }
>        }
>
>as 'man 2 fsync' on Linux doesn't show EACCES as a possible return
>error from fsync.
>
>If this is the case, then the client redirector is relying on Linux-specific
>behavior. From 'man 2 fsync':
>
>NOTES
>       On some UNIX systems (but not Linux), fd must be a writable file descriptor.

If this is actually what is happening, Samba is implementing the
Windows semantics, and not the Linux ones (as we should). From
the Microsoft MS-SMB2 spec:

https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/026984f6-38af-4408-8200-50557eb0a286

--------------------------------------------------------------------------
3.3.5.11 Receiving an SMB2 FLUSH Request
10/04/2021

When the server receives a request with an SMB2 header with a Command value
equal to SMB2 FLUSH, message handling proceeds as follows:

The server MUST locate the session, as specified in section 3.3.5.2.9.

The server MUST locate the tree connection, as specified in section 3.3.5.2.11.

Next the server MUST locate the open being flushed by performing
a lookup in the Session.OpenTable, using the FileId.Volatile of the
request as the lookup key. If no open is found, or if Open.DurableFileId
is not equal to FileId.Persistent, the server MUST fail the request
with STATUS_FILE_CLOSED. Otherwise, the server MUST locate the Request
in Connection.RequestList for which Request.MessageId matches
the MessageId value in the SMB2 header, and set Request.Open to the Open.

If the Open is on a file and Open.GrantedAccess includes neither
FILE_WRITE_DATA nor FILE_APPEND_DATA, the server MUST fail the
request with STATUS_ACCESS_DENIED.

If the Open is on a directory and Open.GrantedAccess includes
neither FILE_ADD_FILE nor FILE_ADD_SUBDIRECTORY, the server MUST
fail the request with STATUS_ACCESS_DENIED.
--------------------------------------------------------------------------
