Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BF8C43331
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 03:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3144821925
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 03:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ARdC6pq6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKMD2c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Nov 2019 22:28:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25007 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726953AbfKMD2c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 12 Nov 2019 22:28:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573615711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RwyCE7j/yjy/n/zbBS8gsy020wZmLpfeqtayGJzdV/w=;
        b=ARdC6pq6VFOW7KZUKd8tU9jkc+Y5fXjsbeltGvU182ProOhtaNu4/CRtxGuhZMh6fgSX93
        szcnMzQrRT6DyguWJHK7pYv+0cMipK9oKZyfcshxO3iokLBiKP4yZgpXt3bOL07/dNOBdC
        rWhxEk7FPmkIgpomvdRWh021urgN1qM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-UDFKb7_KPRKl7dXSK9yIaw-1; Tue, 12 Nov 2019 22:28:29 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAD5F1823E55
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2019 03:28:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C008460CD1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2019 03:28:28 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id B015518089C8;
        Wed, 13 Nov 2019 03:28:28 +0000 (UTC)
Date:   Tue, 12 Nov 2019 22:28:28 -0500 (EST)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Frank Sorenson <sorenson@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Message-ID: <2126815784.11429957.1573615708414.JavaMail.zimbra@redhat.com>
In-Reply-To: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com>
References: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com>
Subject: Re: A process killed while opening a file can result in leaked open
 handle on the server
MIME-Version: 1.0
X-Originating-IP: [10.64.54.39, 10.4.195.8]
Thread-Topic: A process killed while opening a file can result in leaked open handle on the server
Thread-Index: hbXa2lGHIZV0Bxgg/SpmfN6BvNrP4w==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: UDFKb7_KPRKl7dXSK9yIaw-1
X-Mimecast-Spam-Score: 0
Content-Type: multipart/mixed; 
        boundary="----=_Part_11429955_1197574691.1573615708412"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

------=_Part_11429955_1197574691.1573615708412
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable





----- Original Message -----
> From: "Frank Sorenson" <sorenson@redhat.com>
> To: "linux-cifs" <linux-cifs@vger.kernel.org>
> Sent: Wednesday, 13 November, 2019 5:34:27 AM
> Subject: A process killed while opening a file can result in leaked open =
handle on the server
>=20
> If a process opening a file is killed while waiting for a SMB2_CREATE
> response from the server, the response may not be handled by the client,
> leaking an open file handle on the server.
>=20
> This can be reproduced with the following:
>=20
> # mount //vm3/user1 /mnt/vm3
> -overs=3D3,sec=3Dntlmssp,credentials=3D/root/.user1_smb_creds
> # cd /mnt/vm3
> # echo foo > foo
>=20
> # for i in {1..100} ; do cat foo >/dev/null 2>&1 & sleep 0.0001 ; kill -9=
 $!
> ; done
>=20
> (increase count if necessary--100 appears sufficient to cause multiple le=
aked
> file handles)
>=20
>=20
> The client will stop waiting for the response, and will output
> the following when the response does arrive:
>=20
>     CIFS VFS: Close unmatched open
>=20
> on the server side, an open file handle is leaked.  If using samba,
> the following will show these open files:
>=20
>=20
> # smbstatus | grep -i Locked -A1000
> Locked files:
> Pid          Uid        DenyMode   Access      R/W        Oplock
> SharePath   Name   Time
> -------------------------------------------------------------------------=
-------------------------
> 25936        501        DENY_NONE  0x80        RDONLY     NONE
> /home/user1   .   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x80        RDONLY     NONE
> /home/user1   .   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> /home/user1   foo   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> /home/user1   foo   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> /home/user1   foo   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> /home/user1   foo   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)
> /home/user1   foo   Tue Nov 12 12:29:24 2019
>=20
>=20
> (also tracked https://bugzilla.redhat.com/show_bug.cgi?id=3D1771691)
>=20

I don't think it has to do with "CIFS VFS: Close unmatched open", in fact t=
hose are probably the times
where it did not leak. Unless the SMB2_close() fails with an error.
Can you try the patch below and check that these SMB2_close() are successfu=
l?

I think it is more likely that we leak because we can not match the SMB2_Cr=
eate() response with a MID.
Do you get "No task to wake, unknown frame received" in the log?

We need to do two things here.
1, Find out why we can not match this with a MID and second,
   This it to fix THIS bug.
2, In the demultiplex_thread, where we get a "No task to wake, unknown fram=
e received" we should check
   is this an Open? if so we should invoke server->ops->handle_cancelled_mi=
d()
   This is to make sure other similar bugs do not cause leaks like this.

regards
ronnie sahlberg


> Frank
> --
> Frank Sorenson
> sorenson@redhat.com
> Principal Software Maintenance Engineer
> Global Support Services - filesystems
> Red Hat
>=20
>=20

------=_Part_11429955_1197574691.1573615708412
Content-Type: text/x-patch; name=patch; charset=WINDOWS-1252
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRl
eCBkNzhiZmNjMTkxNTYuLjEwY2I0ZDRmYjEyMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xv
Yi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTU0OCw2ICsxNTQ4LDcgQEAgc3RydWN0
IG1pZF9xX2VudHJ5IHsKIH07CiAKIHN0cnVjdCBjbG9zZV9jYW5jZWxsZWRfb3BlbiB7CisJX191
NjQgbWlkOwogCXN0cnVjdCBjaWZzX2ZpZCAgICAgICAgIGZpZDsKIAlzdHJ1Y3QgY2lmc190Y29u
ICAgICAgICAqdGNvbjsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QgICAgICB3b3JrOwpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9zbWIybWlzYy5jIGIvZnMvY2lmcy9zbWIybWlzYy5jCmluZGV4IGUzMTFmNThk
YzFjOC4uNjEyMGMzMDdkODhlIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJtaXNjLmMKKysrIGIv
ZnMvY2lmcy9zbWIybWlzYy5jCkBAIC03MzUsMTIgKzczNSwxOSBAQCBzbWIyX2NhbmNlbGxlZF9j
bG9zZV9maWQoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogewogCXN0cnVjdCBjbG9zZV9jYW5j
ZWxsZWRfb3BlbiAqY2FuY2VsbGVkID0gY29udGFpbmVyX29mKHdvcmssCiAJCQkJCXN0cnVjdCBj
bG9zZV9jYW5jZWxsZWRfb3Blbiwgd29yayk7CisJc3RydWN0IGNpZnNfdGNvbiAqdGNvbiA9IGNh
bmNlbGxlZC0+dGNvbjsKKwlpbnQgcmM7CiAKLQljaWZzX2RiZyhWRlMsICJDbG9zZSB1bm1hdGNo
ZWQgb3BlblxuIik7CisJY2lmc190Y29uX2RiZyhWRlMsICJDbG9zZSB1bm1hdGNoZWQgb3BlbiBm
b3IgTUlEOiVsbHhcbiIsCisJCSAgICAgIGNhbmNlbGxlZC0+bWlkKTsKIAotCVNNQjJfY2xvc2Uo
MCwgY2FuY2VsbGVkLT50Y29uLCBjYW5jZWxsZWQtPmZpZC5wZXJzaXN0ZW50X2ZpZCwKLQkJICAg
Y2FuY2VsbGVkLT5maWQudm9sYXRpbGVfZmlkKTsKLQljaWZzX3B1dF90Y29uKGNhbmNlbGxlZC0+
dGNvbik7CisJcmMgPSBTTUIyX2Nsb3NlKDAsIHRjb24sIGNhbmNlbGxlZC0+ZmlkLnBlcnNpc3Rl
bnRfZmlkLAorCQkJY2FuY2VsbGVkLT5maWQudm9sYXRpbGVfZmlkKTsKKwlpZiAocmMpIHsKKwkJ
Y2lmc190Y29uX2RiZyhWRlMsICJDbG9zZSBjYW5jZWxsZWQgbWlkIGZhaWxlZCB3aXRoIHJjOiVk
XG4iLCByYyk7CisJfQorCisJY2lmc19wdXRfdGNvbih0Y29uKTsKIAlrZnJlZShjYW5jZWxsZWQp
OwogfQogCkBAIC03NzAsNiArNzc3LDcgQEAgc21iMl9oYW5kbGVfY2FuY2VsbGVkX21pZChjaGFy
ICpidWZmZXIsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAljYW5jZWxsZWQtPmZp
ZC5wZXJzaXN0ZW50X2ZpZCA9IHJzcC0+UGVyc2lzdGVudEZpbGVJZDsKIAljYW5jZWxsZWQtPmZp
ZC52b2xhdGlsZV9maWQgPSByc3AtPlZvbGF0aWxlRmlsZUlkOwogCWNhbmNlbGxlZC0+dGNvbiA9
IHRjb247CisJY2FuY2VsbGVkLT5taWQgPSBzeW5jX2hkci0+TWVzc2FnZUlkOwogCUlOSVRfV09S
SygmY2FuY2VsbGVkLT53b3JrLCBzbWIyX2NhbmNlbGxlZF9jbG9zZV9maWQpOwogCXF1ZXVlX3dv
cmsoY2lmc2lvZF93cSwgJmNhbmNlbGxlZC0+d29yayk7CiAK
------=_Part_11429955_1197574691.1573615708412--

