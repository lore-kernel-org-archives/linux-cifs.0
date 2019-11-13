Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD14C43331
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 06:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F54222D3
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 06:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TyY0dgyi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfKMGtx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:49:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27698 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725866AbfKMGtx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Nov 2019 01:49:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573627791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g+4xMaNo+tzQjGRzxJdy2Rvo8uOtBOW3ziNorVASgCA=;
        b=TyY0dgyiEf/WN4Tc4iImaiVPgd45yqCYtijzxBZYMuu+Hdyjadd11BzAl7v5xA3EAuNp3F
        7tlVNXmESyWIHGSMY317Dwq864g5Sy6uiduu21hzhS/EYaH9QnDEnSW54y2G19wEB1PXqm
        dNc+jb7OWkIp3eCS3jDH9yTYLz6bWS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-wbHaKJXeNPqKcXkYkc4ebA-1; Wed, 13 Nov 2019 01:49:48 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F7F2800C77;
        Wed, 13 Nov 2019 06:49:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25DBD62937;
        Wed, 13 Nov 2019 06:49:47 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 175FD18095FF;
        Wed, 13 Nov 2019 06:49:47 +0000 (UTC)
Date:   Wed, 13 Nov 2019 01:49:46 -0500 (EST)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Frank Sorenson <sorenson@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Message-ID: <81694688.11451093.1573627786969.JavaMail.zimbra@redhat.com>
In-Reply-To: <579288007.11441637.1573622351338.JavaMail.zimbra@redhat.com>
References: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com> <CAKywueQ4nx2=V889Ty40QZOfoVij7Wp4dmhuhHV4A6mhGpgYAA@mail.gmail.com> <579288007.11441637.1573622351338.JavaMail.zimbra@redhat.com>
Subject: Re: A process killed while opening a file can result in leaked open
 handle on the server
MIME-Version: 1.0
X-Originating-IP: [10.64.54.39, 10.4.195.10]
Thread-Topic: A process killed while opening a file can result in leaked open handle on the server
Thread-Index: YC75cmuxQs+Qb50EISx9ggbkIUfib2RXUgTo
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: wbHaKJXeNPqKcXkYkc4ebA-1
X-Mimecast-Spam-Score: 0
Content-Type: multipart/mixed; 
        boundary="----=_Part_11451091_1124064339.1573627786966"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

------=_Part_11451091_1124064339.1573627786966
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Steve, Pavel

This patch goes ontop of Pavels patch.
Maybe it should be merged with Pavels patch since his patch changes from "w=
e only send a close() on an interrupted open()"
to now "we send a close() on either interrupted open() or interrupted close=
()" so both comments as well as log messages are updates.

Additionally it adds logging of the MID that failed in the case of an inter=
rupted Open() so that it is easy to find it in wireshark
and check whether that smb2 file handle was indeed handles by a SMB_Close()=
 or not.


From testing it appears Pavels patch works. When the close() is interrupted=
 we don't leak handles as far as I can tell.
We do have a leak in the Open() case though and it seems that eventhough we=
 set things up and flags the MID to be cancelled we actually never end up
calling smb2_cancelled_close_fid() and thus we never send a SMB2_Close().
I haven't found the root cause yet but I suspect we mess up mid flags or st=
ate somewhere.


It did work in the past though when Sachin provided the initial implementat=
ion so we have regressed I think.
I have added a new test 'cifs/102'  to the buildbot that checks for this bu=
t have not integrated into the cifs-testing run yet since we still fail thi=
s test.
At least we will not have further regressions once we fix this and enable t=
he test in the future.

ronnie s




----- Original Message -----
From: "Ronnie Sahlberg" <lsahlber@redhat.com>
To: "Pavel Shilovsky" <piastryyy@gmail.com>
Cc: "Frank Sorenson" <sorenson@redhat.com>, "linux-cifs" <linux-cifs@vger.k=
ernel.org>
Sent: Wednesday, 13 November, 2019 3:19:11 PM
Subject: Re: A process killed while opening a file can result in leaked ope=
n handle on the server





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


------=_Part_11451091_1124064339.1573627786966
Content-Type: text/x-patch; name=patch; charset=WINDOWS-1252
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRl
eCBkNzhiZmNjMTkxNTYuLjM5YTkxNjVmOWJiYSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xv
Yi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTU1MSw2ICsxNTUxLDggQEAgc3RydWN0
IGNsb3NlX2NhbmNlbGxlZF9vcGVuIHsKIAlzdHJ1Y3QgY2lmc19maWQgICAgICAgICBmaWQ7CiAJ
c3RydWN0IGNpZnNfdGNvbiAgICAgICAgKnRjb247CiAJc3RydWN0IHdvcmtfc3RydWN0ICAgICAg
d29yazsKKwlfX3U2NCBtaWQ7CisJX191MTYgY21kOwogfTsKIAogLyoJTWFrZSBjb2RlIGluIHRy
YW5zcG9ydC5jIGEgbGl0dGxlIGNsZWFuZXIgYnkgbW92aW5nCmRpZmYgLS1naXQgYS9mcy9jaWZz
L3NtYjJtaXNjLmMgYi9mcy9jaWZzL3NtYjJtaXNjLmMKaW5kZXggYmExZTU3NTQyMzljLi4xZmI5
OTMyZDNkYWUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm1pc2MuYworKysgYi9mcy9jaWZzL3Nt
YjJtaXNjLmMKQEAgLTczNSwxOSArNzM1LDM2IEBAIHNtYjJfY2FuY2VsbGVkX2Nsb3NlX2ZpZChz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiB7CiAJc3RydWN0IGNsb3NlX2NhbmNlbGxlZF9vcGVu
ICpjYW5jZWxsZWQgPSBjb250YWluZXJfb2Yod29yaywKIAkJCQkJc3RydWN0IGNsb3NlX2NhbmNl
bGxlZF9vcGVuLCB3b3JrKTsKKwlzdHJ1Y3QgY2lmc190Y29uICp0Y29uID0gY2FuY2VsbGVkLT50
Y29uOworCWludCByYzsKIAotCWNpZnNfZGJnKFZGUywgIkNsb3NlIHVubWF0Y2hlZCBvcGVuXG4i
KTsKKwlpZiAoY2FuY2VsbGVkLT5taWQpCisJCWNpZnNfdGNvbl9kYmcoVkZTLCAiQ2xvc2UgdW5t
YXRjaGVkIG9wZW4gZm9yIE1JRDolbGx4XG4iLAorCQkJICAgICAgY2FuY2VsbGVkLT5taWQpOwor
CWVsc2UKKwkJY2lmc190Y29uX2RiZyhWRlMsICJDbG9zZSBpbnRlcnJ1cHRlZCBjbG9zZVxuIik7
CiAKLQlTTUIyX2Nsb3NlKDAsIGNhbmNlbGxlZC0+dGNvbiwgY2FuY2VsbGVkLT5maWQucGVyc2lz
dGVudF9maWQsCi0JCSAgIGNhbmNlbGxlZC0+ZmlkLnZvbGF0aWxlX2ZpZCk7Ci0JY2lmc19wdXRf
dGNvbihjYW5jZWxsZWQtPnRjb24pOworCXJjID0gU01CMl9jbG9zZSgwLCB0Y29uLCBjYW5jZWxs
ZWQtPmZpZC5wZXJzaXN0ZW50X2ZpZCwKKwkJCWNhbmNlbGxlZC0+ZmlkLnZvbGF0aWxlX2ZpZCk7
CisJaWYgKHJjKSB7CisJCWNpZnNfdGNvbl9kYmcoVkZTLCAiQ2xvc2UgY2FuY2VsbGVkIG1pZCBm
YWlsZWQgd2l0aCByYzolZFxuIiwgcmMpOworCX0KKworCWNpZnNfcHV0X3Rjb24odGNvbik7CiAJ
a2ZyZWUoY2FuY2VsbGVkKTsKIH0KIAotLyogQ2FsbGVyIHNob3VsZCBhbHJlYWR5IGhhcyBhbiBl
eHRyYSByZWZlcmVuY2UgdG8gQHRjb24gKi8KKy8qCisgKiBDYWxsZXIgc2hvdWxkIGFscmVhZHkg
aGFzIGFuIGV4dHJhIHJlZmVyZW5jZSB0byBAdGNvbgorICogVGhpcyBmdW5jdGlvbiBpcyB1c2Vk
IHRvIHF1ZXVlIHdvcmsgdG8gY2xvc2UgYSBoYW5kbGUgdG8gcHJldmVudCBsZWFrcworICogb24g
dGhlIHNlcnZlci4KKyAqIFdlIGhhbmRsZSB0d28gY2FzZXMuIElmIGFuIG9wZW4gd2FzIGludGVy
cnVwdGVkIGFmdGVyIHdlIHNlbnQgdGhlCisgKiBTTUIyX0NSRUFURSB0byB0aGUgc2VydmVyIGJ1
dCBiZWZvcmUgd2UgcHJvY2Vzc2VkIHRoZSByZXBseSwgYW5kIHNlY29uZAorICogaWYgYSBjbG9z
ZSB3YXMgaW50ZXJydXB0ZWQgYmVmb3JlIHdlIHNlbnQgdGhlIFNNQjJfQ0xPU0UgdG8gdGhlIHNl
cnZlci4KKyAqLwogc3RhdGljIGludAotX19zbWIyX2hhbmRsZV9jYW5jZWxsZWRfY2xvc2Uoc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbiwgX191NjQgcGVyc2lzdGVudF9maWQsCi0JCQkgICAgICBfX3U2
NCB2b2xhdGlsZV9maWQpCitfX3NtYjJfaGFuZGxlX2NhbmNlbGxlZF9jbWQoc3RydWN0IGNpZnNf
dGNvbiAqdGNvbiwgX191MTYgY21kLCBfX3U2NCBtaWQsCisJCQkgICAgX191NjQgcGVyc2lzdGVu
dF9maWQsIF9fdTY0IHZvbGF0aWxlX2ZpZCkKIHsKIAlzdHJ1Y3QgY2xvc2VfY2FuY2VsbGVkX29w
ZW4gKmNhbmNlbGxlZDsKIApAQCAtNzU4LDYgKzc3NSw4IEBAIF9fc21iMl9oYW5kbGVfY2FuY2Vs
bGVkX2Nsb3NlKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIF9fdTY0IHBlcnNpc3RlbnRfZmlkLAog
CWNhbmNlbGxlZC0+ZmlkLnBlcnNpc3RlbnRfZmlkID0gcGVyc2lzdGVudF9maWQ7CiAJY2FuY2Vs
bGVkLT5maWQudm9sYXRpbGVfZmlkID0gdm9sYXRpbGVfZmlkOwogCWNhbmNlbGxlZC0+dGNvbiA9
IHRjb247CisJY2FuY2VsbGVkLT5jbWQgPSBjbWQ7CisJY2FuY2VsbGVkLT5taWQgPSBtaWQ7CiAJ
SU5JVF9XT1JLKCZjYW5jZWxsZWQtPndvcmssIHNtYjJfY2FuY2VsbGVkX2Nsb3NlX2ZpZCk7CiAJ
V0FSTl9PTihxdWV1ZV93b3JrKGNpZnNpb2Rfd3EsICZjYW5jZWxsZWQtPndvcmspID09IGZhbHNl
KTsKIApAQCAtNzc1LDcgKzc5NCw4IEBAIHNtYjJfaGFuZGxlX2NhbmNlbGxlZF9jbG9zZShzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLCBfX3U2NCBwZXJzaXN0ZW50X2ZpZCwKIAl0Y29uLT50Y19jb3Vu
dCsrOwogCXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CiAKLQlyYyA9IF9fc21iMl9o
YW5kbGVfY2FuY2VsbGVkX2Nsb3NlKHRjb24sIHBlcnNpc3RlbnRfZmlkLCB2b2xhdGlsZV9maWQp
OworCXJjID0gX19zbWIyX2hhbmRsZV9jYW5jZWxsZWRfY21kKHRjb24sIFNNQjJfQ0xPU0VfSEUs
IDAsCisJCQkJCSBwZXJzaXN0ZW50X2ZpZCwgdm9sYXRpbGVfZmlkKTsKIAlpZiAocmMpCiAJCWNp
ZnNfcHV0X3Rjb24odGNvbik7CiAKQEAgLTc5OSw4ICs4MTksMTEgQEAgc21iMl9oYW5kbGVfY2Fu
Y2VsbGVkX21pZChjaGFyICpidWZmZXIsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikK
IAlpZiAoIXRjb24pCiAJCXJldHVybiAtRU5PRU5UOwogCi0JcmMgPSBfX3NtYjJfaGFuZGxlX2Nh
bmNlbGxlZF9jbG9zZSh0Y29uLCByc3AtPlBlcnNpc3RlbnRGaWxlSWQsCi0JCQkJCSAgIHJzcC0+
Vm9sYXRpbGVGaWxlSWQpOworCXJjID0gX19zbWIyX2hhbmRsZV9jYW5jZWxsZWRfY21kKHRjb24s
CisJCQkJCSBsZTE2X3RvX2NwdShzeW5jX2hkci0+Q29tbWFuZCksCisJCQkJCSBsZTY0X3RvX2Nw
dShzeW5jX2hkci0+TWVzc2FnZUlkKSwKKwkJCQkJIHJzcC0+UGVyc2lzdGVudEZpbGVJZCwKKwkJ
CQkJIHJzcC0+Vm9sYXRpbGVGaWxlSWQpOwogCWlmIChyYykKIAkJY2lmc19wdXRfdGNvbih0Y29u
KTsKIAo=
------=_Part_11451091_1124064339.1573627786966--

