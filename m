Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE1FC43331
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 05:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94363222D0
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 05:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8ih+a9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfKMFTQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Nov 2019 00:19:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57998 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725908AbfKMFTQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Nov 2019 00:19:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573622353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGuZyE9W8OcTOnsHhumceVeR7NvKMrgIGUKxkd1qjmc=;
        b=S8ih+a9MdKjByVg91R/Snu2c5KCdcyC2HRnNVZwoEa6RGI8NpS+ec+9kIE5/xauubvYvX8
        owpr/k/Lg7SlWZNQJPkjCbqXsWCfflqhART7uq/3VyXMFbsFNiT59zYd+DIRs5kQOdE2t/
        Q58cTaXLKuTNbsSRQ/82t6eSIFLrF9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-6w5SMwvsP3mAR5Czdz9jVg-1; Wed, 13 Nov 2019 00:19:12 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93FD664A99;
        Wed, 13 Nov 2019 05:19:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 883DB100EBAB;
        Wed, 13 Nov 2019 05:19:11 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7693018095FF;
        Wed, 13 Nov 2019 05:19:11 +0000 (UTC)
Date:   Wed, 13 Nov 2019 00:19:11 -0500 (EST)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Frank Sorenson <sorenson@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Message-ID: <579288007.11441637.1573622351338.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAKywueQ4nx2=V889Ty40QZOfoVij7Wp4dmhuhHV4A6mhGpgYAA@mail.gmail.com>
References: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com> <CAKywueQ4nx2=V889Ty40QZOfoVij7Wp4dmhuhHV4A6mhGpgYAA@mail.gmail.com>
Subject: Re: A process killed while opening a file can result in leaked open
 handle on the server
MIME-Version: 1.0
X-Originating-IP: [10.64.54.39, 10.4.195.18]
Thread-Topic: A process killed while opening a file can result in leaked open handle on the server
Thread-Index: YC75cmuxQs+Qb50EISx9ggbkIUfibw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 6w5SMwvsP3mAR5Czdz9jVg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org





----- Original Message -----
> From: "Pavel Shilovsky" <piastryyy@gmail.com>
> To: "Frank Sorenson" <sorenson@redhat.com>
> Cc: "linux-cifs" <linux-cifs@vger.kernel.org>
> Sent: Wednesday, 13 November, 2019 12:37:38 PM
> Subject: Re: A process killed while opening a file can result in leaked o=
pen handle on the server
>=20
> =D0=B2=D1=82, 12 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 11:34, Fra=
nk Sorenson <sorenson@redhat.com>:
> >
> > If a process opening a file is killed while waiting for a SMB2_CREATE
> > response from the server, the response may not be handled by the client=
,
> > leaking an open file handle on the server.
> >
>=20
> Thanks for reporting the problem.
>=20
> > This can be reproduced with the following:
> >
> > # mount //vm3/user1 /mnt/vm3
> > -overs=3D3,sec=3Dntlmssp,credentials=3D/root/.user1_smb_creds
> > # cd /mnt/vm3
> > # echo foo > foo
> >
> > # for i in {1..100} ; do cat foo >/dev/null 2>&1 & sleep 0.0001 ; kill =
-9
> > $! ; done
> >
> > (increase count if necessary--100 appears sufficient to cause multiple
> > leaked file handles)
> >
>=20
> This is a known problem and the client handles it by closing unmatched
> opens (the one that don't have a corresponding waiting thread)
> immediately. It is indicated by the message you observed: "Close
> unmatched open".
>=20
> >
> > The client will stop waiting for the response, and will output
> > the following when the response does arrive:
> >
> >     CIFS VFS: Close unmatched open
> >
> > on the server side, an open file handle is leaked.  If using samba,
> > the following will show these open files:
> >
> >
> > # smbstatus | grep -i Locked -A1000
> > Locked files:
> > Pid          Uid        DenyMode   Access      R/W        Oplock
> > SharePath   Name   Time
> > -----------------------------------------------------------------------=
---------------------------
> > 25936        501        DENY_NONE  0x80        RDONLY     NONE
> > /home/user1   .   Tue Nov 12 12:29:24 2019
> > 25936        501        DENY_NONE  0x80        RDONLY     NONE
> > /home/user1   .   Tue Nov 12 12:29:24 2019
> > 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> > /home/user1   foo   Tue Nov 12 12:29:24 2019
> > 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> > /home/user1   foo   Tue Nov 12 12:29:24 2019
> > 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> > /home/user1   foo   Tue Nov 12 12:29:24 2019
> > 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> > /home/user1   foo   Tue Nov 12 12:29:24 2019
> > 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> > /home/user1   foo   Tue Nov 12 12:29:24 2019
> >
>=20
> I tried it locally myself, it seems that we have another issue related
> to interrupted close requests:
>=20
> [1656476.740311] fs/cifs/file.c: Flush inode 0000000078729371 file
> 000000004d5f9348 rc 0
> [1656476.740313] fs/cifs/file.c: closing last open instance for inode
> 0000000078729371
> [1656476.740314] fs/cifs/file.c: CIFS VFS: in _cifsFileInfo_put as
> Xid: 457 with uid: 1000
> [1656476.740315] fs/cifs/smb2pdu.c: Close
> [1656476.740317] fs/cifs/transport.c: signal is pending before sending an=
y
> data
>=20
> This will return -512 error to the upper layer but we do not save a
> problematic handle somewhere to close it later. op->release() error
> code is not being checked by VFS anyway.
>=20
> We should do the similar thing as we do today for cancelled mids:
> allocate "struct close_cancelled_open" and queue the lazy work to
> close the handle.
>=20
> I attached the patch implementing this idea. The patch handles the
> interrupt errors in smb2_close_file which is called during close
> system call. It fixed the problem in my setup. In the same time I
> think I should probably move the handling to PDU layer function
> SMB2_close() to handle *all* interrupted close requests including ones
> closing temporary handles. I am wondering if anyone has thoughts about
> it. Anyway, review of the patch is highly appreciated.

I think your patch makes it better. I seem Close() that your patch now fixe=
s the leak for.


But there is still a leak in Open().
I just got one instance where I leaked one handle.

The log shows :
CIFS VFS: \\192.168.124.207 Cancelling wait for mid 25 cmd: 5

and the wireshark shows an Open() request/response for this MID but we neve=
r
send a Close() for the handle.



>=20
> @Frank, could you please test the patch in your environment?
>=20
> --
> Best regards,
> Pavel Shilovsky
>=20

