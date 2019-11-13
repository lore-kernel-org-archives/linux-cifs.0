Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3326FC43331
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 02:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6A682067B
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 02:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jiZ9tdeb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfKMChx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:37:53 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46816 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfKMChx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Nov 2019 21:37:53 -0500
Received: by mail-lj1-f193.google.com with SMTP id e9so696971ljp.13
        for <linux-cifs@vger.kernel.org>; Tue, 12 Nov 2019 18:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=InTVvJwtXBQU9AfgaVU/pGfcboRmh7eM4LId7E48evo=;
        b=jiZ9tdebWsVzO8UU5eYtC93jDckq7D15nCWF6Dt1+4aZLLnYU8p39dRoAW/GY4APiJ
         MDoVPtQiEaRgcOaBZvxPdRzKpqTSWfwWj24wFUkYwEKO1OabybgBcZ9K7D7GLXDR1VgY
         nReufz5XHtevDPTf9ll5r3BJULE0URpB5+k6tBseAQM5p3CNydFcm0dcP1omnLaqIdyy
         xljyqlpcE1CzucPa/SIN9qbqylfJwWvuPA1S/7v1+rFheSZVHaxCmQIhusUlcr4LcuOI
         nf2vp0oj6QyxSdBY+lwxtXfoxkwzGbr0EWfXs2hhYtdoZiVyZ68IshGcaVkcpEUORghR
         BOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=InTVvJwtXBQU9AfgaVU/pGfcboRmh7eM4LId7E48evo=;
        b=BVi9nBw3pf3DlX8E9Seqb+etF6c1UPqcvlM4MC8pDu7FIJdD9UZK3LYV5jH/rbBdfd
         fE57m69quSbBXnjrxzvNajT6g8By/Q9HIc7tmaHLowXPZJa4eXvIoP2W5Qh0SjnXJ7qo
         8yDtmgkNU9MZqhqqJkWeB57uqPV/1Dcc1cI+Jm9oeV59+J2XluOfFc83g8t+KL7VDnLZ
         CkjqHXVnM5l62c0/INlqt1CWZ/+hT89v0idhJg06uk+qAWOa0uX6gR4rnUoqYoAQN3YQ
         m4r+Edu83jhZeuD8zT7WLBWx6HNzfUb25ZyCkRh4hZ6exUsXUxAPLJ0fNPSB1x3fKm0U
         kbuw==
X-Gm-Message-State: APjAAAVXY/6Hf9hfXR7/Qj0v++/ZyLoid+UlNU3+Q7H9Xru1i4sm8RfQ
        rx6JlnSBeE2RwaRxU0ID6FCx4WChwdqip3Z8iA==
X-Google-Smtp-Source: APXvYqxVI6oJNlqNib0vs2Wpv+Cs6RPyox53x1wgantqBIkPvq11dKL8zo2QmZ8M/yYeC3qQmG3FKNr78nx2N8GJnAk=
X-Received: by 2002:a2e:898a:: with SMTP id c10mr550866lji.177.1573612670054;
 Tue, 12 Nov 2019 18:37:50 -0800 (PST)
MIME-Version: 1.0
References: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com>
In-Reply-To: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 12 Nov 2019 18:37:38 -0800
Message-ID: <CAKywueQ4nx2=V889Ty40QZOfoVij7Wp4dmhuhHV4A6mhGpgYAA@mail.gmail.com>
Subject: Re: A process killed while opening a file can result in leaked open
 handle on the server
To:     Frank Sorenson <sorenson@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000369fb80597314056"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000369fb80597314056
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=D0=B2=D1=82, 12 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 11:34, Frank=
 Sorenson <sorenson@redhat.com>:
>
> If a process opening a file is killed while waiting for a SMB2_CREATE
> response from the server, the response may not be handled by the client,
> leaking an open file handle on the server.
>

Thanks for reporting the problem.

> This can be reproduced with the following:
>
> # mount //vm3/user1 /mnt/vm3 -overs=3D3,sec=3Dntlmssp,credentials=3D/root=
/.user1_smb_creds
> # cd /mnt/vm3
> # echo foo > foo
>
> # for i in {1..100} ; do cat foo >/dev/null 2>&1 & sleep 0.0001 ; kill -9=
 $! ; done
>
> (increase count if necessary--100 appears sufficient to cause multiple le=
aked file handles)
>

This is a known problem and the client handles it by closing unmatched
opens (the one that don't have a corresponding waiting thread)
immediately. It is indicated by the message you observed: "Close
unmatched open".

>
> The client will stop waiting for the response, and will output
> the following when the response does arrive:
>
>     CIFS VFS: Close unmatched open
>
> on the server side, an open file handle is leaked.  If using samba,
> the following will show these open files:
>
>
> # smbstatus | grep -i Locked -A1000
> Locked files:
> Pid          Uid        DenyMode   Access      R/W        Oplock         =
  SharePath   Name   Time
> -------------------------------------------------------------------------=
-------------------------
> 25936        501        DENY_NONE  0x80        RDONLY     NONE           =
  /home/user1   .   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x80        RDONLY     NONE           =
  /home/user1   .   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)     =
  /home/user1   foo   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)     =
  /home/user1   foo   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)     =
  /home/user1   foo   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)     =
  /home/user1   foo   Tue Nov 12 12:29:24 2019
> 25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)     =
  /home/user1   foo   Tue Nov 12 12:29:24 2019
>

I tried it locally myself, it seems that we have another issue related
to interrupted close requests:

[1656476.740311] fs/cifs/file.c: Flush inode 0000000078729371 file
000000004d5f9348 rc 0
[1656476.740313] fs/cifs/file.c: closing last open instance for inode
0000000078729371
[1656476.740314] fs/cifs/file.c: CIFS VFS: in _cifsFileInfo_put as
Xid: 457 with uid: 1000
[1656476.740315] fs/cifs/smb2pdu.c: Close
[1656476.740317] fs/cifs/transport.c: signal is pending before sending any =
data

This will return -512 error to the upper layer but we do not save a
problematic handle somewhere to close it later. op->release() error
code is not being checked by VFS anyway.

We should do the similar thing as we do today for cancelled mids:
allocate "struct close_cancelled_open" and queue the lazy work to
close the handle.

I attached the patch implementing this idea. The patch handles the
interrupt errors in smb2_close_file which is called during close
system call. It fixed the problem in my setup. In the same time I
think I should probably move the handling to PDU layer function
SMB2_close() to handle *all* interrupted close requests including ones
closing temporary handles. I am wondering if anyone has thoughts about
it. Anyway, review of the patch is highly appreciated.

@Frank, could you please test the patch in your environment?

--
Best regards,
Pavel Shilovsky

--000000000000369fb80597314056
Content-Type: application/octet-stream; 
	name="0001-CIFS-Close-open-handle-after-interrupted-close.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Close-open-handle-after-interrupted-close.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k2wo7q7g0>
X-Attachment-Id: f_k2wo7q7g0

RnJvbSA3NDIxOTI1YjJlN2VlMGQ0N2VlYmZiMjkxMjY4Nzg0MDc4ZWE4ODEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNv
bT4KRGF0ZTogVHVlLCAxMiBOb3YgMjAxOSAxNjozODoxMyAtMDgwMApTdWJqZWN0OiBbUEFUQ0hd
IENJRlM6IENsb3NlIG9wZW4gaGFuZGxlIGFmdGVyIGludGVycnVwdGVkIGNsb3NlCgpTaWduZWQt
b2ZmLWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9j
aWZzL3NtYjJtaXNjLmMgIHwgNTkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tCiBmcy9jaWZzL3NtYjJvcHMuYyAgIHwgMTEgKysrKysrKystCiBmcy9jaWZzL3Nt
YjJwcm90by5oIHwgIDMgKysrCiAzIGZpbGVzIGNoYW5nZWQsIDU4IGluc2VydGlvbnMoKyksIDE1
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm1pc2MuYyBiL2ZzL2NpZnMv
c21iMm1pc2MuYwppbmRleCA1MjdjOWVmZDNkZTAuLjgwYThmNGIyZGFhYiAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9zbWIybWlzYy5jCisrKyBiL2ZzL2NpZnMvc21iMm1pc2MuYwpAQCAtNzI1LDM2ICs3
MjUsNjcgQEAgc21iMl9jYW5jZWxsZWRfY2xvc2VfZmlkKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykKIAlrZnJlZShjYW5jZWxsZWQpOwogfQogCisvKiBDYWxsZXIgc2hvdWxkIGFscmVhZHkgaGFz
IGFuIGV4dHJhIHJlZmVyZW5jZSB0byBAdGNvbiAqLworc3RhdGljIGludAorX19zbWIyX2hhbmRs
ZV9jYW5jZWxsZWRfY2xvc2Uoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgX191NjQgcGVyc2lzdGVu
dF9maWQsCisJCQkgICAgICBfX3U2NCB2b2xhdGlsZV9maWQpCit7CisJc3RydWN0IGNsb3NlX2Nh
bmNlbGxlZF9vcGVuICpjYW5jZWxsZWQ7CisKKwljYW5jZWxsZWQgPSBremFsbG9jKHNpemVvZigq
Y2FuY2VsbGVkKSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFjYW5jZWxsZWQpCisJCXJldHVybiAtRU5P
TUVNOworCisJY2FuY2VsbGVkLT5maWQucGVyc2lzdGVudF9maWQgPSBwZXJzaXN0ZW50X2ZpZDsK
KwljYW5jZWxsZWQtPmZpZC52b2xhdGlsZV9maWQgPSB2b2xhdGlsZV9maWQ7CisJY2FuY2VsbGVk
LT50Y29uID0gdGNvbjsKKwlJTklUX1dPUksoJmNhbmNlbGxlZC0+d29yaywgc21iMl9jYW5jZWxs
ZWRfY2xvc2VfZmlkKTsKKwlXQVJOX09OKHF1ZXVlX3dvcmsoY2lmc2lvZF93cSwgJmNhbmNlbGxl
ZC0+d29yaykgPT0gZmFsc2UpOworCisJcmV0dXJuIDA7Cit9CisKK2ludAorc21iMl9oYW5kbGVf
Y2FuY2VsbGVkX2Nsb3NlKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIF9fdTY0IHBlcnNpc3RlbnRf
ZmlkLAorCQkJICAgIF9fdTY0IHZvbGF0aWxlX2ZpZCkKK3sKKwlpbnQgcmM7CisKKwljaWZzX2Ri
ZyhGWUksICIlczogdGNfY291bnQ9JWRcbiIsIF9fZnVuY19fLCB0Y29uLT50Y19jb3VudCk7CisJ
c3Bpbl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisJdGNvbi0+dGNfY291bnQrKzsKKwlzcGlu
X3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCisJcmMgPSBfX3NtYjJfaGFuZGxlX2NhbmNl
bGxlZF9jbG9zZSh0Y29uLCBwZXJzaXN0ZW50X2ZpZCwgdm9sYXRpbGVfZmlkKTsKKwlpZiAocmMp
CisJCWNpZnNfcHV0X3Rjb24odGNvbik7CisKKwlyZXR1cm4gcmM7Cit9CisKIGludAogc21iMl9o
YW5kbGVfY2FuY2VsbGVkX21pZChjaGFyICpidWZmZXIsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8g
KnNlcnZlcikKIHsKIAlzdHJ1Y3Qgc21iMl9zeW5jX2hkciAqc3luY19oZHIgPSAoc3RydWN0IHNt
YjJfc3luY19oZHIgKilidWZmZXI7CiAJc3RydWN0IHNtYjJfY3JlYXRlX3JzcCAqcnNwID0gKHN0
cnVjdCBzbWIyX2NyZWF0ZV9yc3AgKilidWZmZXI7CiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbjsK
LQlzdHJ1Y3QgY2xvc2VfY2FuY2VsbGVkX29wZW4gKmNhbmNlbGxlZDsKKwlpbnQgcmM7CiAKIAlp
ZiAoc3luY19oZHItPkNvbW1hbmQgIT0gU01CMl9DUkVBVEUgfHwKIAkgICAgc3luY19oZHItPlN0
YXR1cyAhPSBTVEFUVVNfU1VDQ0VTUykKIAkJcmV0dXJuIDA7CiAKLQljYW5jZWxsZWQgPSBremFs
bG9jKHNpemVvZigqY2FuY2VsbGVkKSwgR0ZQX0tFUk5FTCk7Ci0JaWYgKCFjYW5jZWxsZWQpCi0J
CXJldHVybiAtRU5PTUVNOwotCiAJdGNvbiA9IHNtYjJfZmluZF9zbWJfdGNvbihzZXJ2ZXIsIHN5
bmNfaGRyLT5TZXNzaW9uSWQsCiAJCQkJICBzeW5jX2hkci0+VHJlZUlkKTsKLQlpZiAoIXRjb24p
IHsKLQkJa2ZyZWUoY2FuY2VsbGVkKTsKKwlpZiAoIXRjb24pCiAJCXJldHVybiAtRU5PRU5UOwot
CX0KIAotCWNhbmNlbGxlZC0+ZmlkLnBlcnNpc3RlbnRfZmlkID0gcnNwLT5QZXJzaXN0ZW50Rmls
ZUlkOwotCWNhbmNlbGxlZC0+ZmlkLnZvbGF0aWxlX2ZpZCA9IHJzcC0+Vm9sYXRpbGVGaWxlSWQ7
Ci0JY2FuY2VsbGVkLT50Y29uID0gdGNvbjsKLQlJTklUX1dPUksoJmNhbmNlbGxlZC0+d29yaywg
c21iMl9jYW5jZWxsZWRfY2xvc2VfZmlkKTsKLQlxdWV1ZV93b3JrKGNpZnNpb2Rfd3EsICZjYW5j
ZWxsZWQtPndvcmspOworCXJjID0gX19zbWIyX2hhbmRsZV9jYW5jZWxsZWRfY2xvc2UodGNvbiwg
cnNwLT5QZXJzaXN0ZW50RmlsZUlkLAorCQkJCQkgICByc3AtPlZvbGF0aWxlRmlsZUlkKTsKKwlp
ZiAocmMpCisJCWNpZnNfcHV0X3Rjb24odGNvbik7CiAKLQlyZXR1cm4gMDsKKwlyZXR1cm4gcmM7
CiB9CiAKIC8qKgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJv
cHMuYwppbmRleCAzYmJiNjVlNThkZDYuLjRmNDc4MDBlZTI3OSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTEzMTYsNyArMTMxNiwxNiBA
QCBzdGF0aWMgdm9pZAogc21iMl9jbG9zZV9maWxlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCXN0cnVjdCBjaWZzX2ZpZCAqZmlkKQogewotCVNNQjJf
Y2xvc2UoeGlkLCB0Y29uLCBmaWQtPnBlcnNpc3RlbnRfZmlkLCBmaWQtPnZvbGF0aWxlX2ZpZCk7
CisJaW50IHJjOworCisJcmMgPSBTTUIyX2Nsb3NlKHhpZCwgdGNvbiwgZmlkLT5wZXJzaXN0ZW50
X2ZpZCwgZmlkLT52b2xhdGlsZV9maWQpOworCWlmIChpc19pbnRlcnJ1cHRfZXJyb3IocmMpKSB7
CisJCXJjID0gc21iMl9oYW5kbGVfY2FuY2VsbGVkX2Nsb3NlKHRjb24sIGZpZC0+cGVyc2lzdGVu
dF9maWQsCisJCQkJCQkgZmlkLT52b2xhdGlsZV9maWQpOworCQlpZiAocmMpCisJCQljaWZzX2Ri
ZyhWRlMsICJjbG9zZSBoYW5kbGUgMHglbGx4IHJldHVybmVkIGVycm9yICVkXG4iLAorCQkJCSBm
aWQtPnBlcnNpc3RlbnRfZmlkLCByYyk7CisJfQogfQogCiBzdGF0aWMgaW50CmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJwcm90by5oIGIvZnMvY2lmcy9zbWIycHJvdG8uaAppbmRleCAwN2NhNzI0
ODZjZmEuLmUyMzlmOTgwOTNhOSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycHJvdG8uaAorKysg
Yi9mcy9jaWZzL3NtYjJwcm90by5oCkBAIC0yMDMsNiArMjAzLDkgQEAgZXh0ZXJuIGludCBTTUIy
X3NldF9jb21wcmVzc2lvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogZXh0ZXJuIGludCBTTUIyX29wbG9ja19icmVhayhjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJICAgICBjb25zdCB1NjQgcGVyc2lzdGVu
dF9maWQsIGNvbnN0IHU2NCB2b2xhdGlsZV9maWQsCiAJCQkgICAgIGNvbnN0IF9fdTggb3Bsb2Nr
X2xldmVsKTsKK2V4dGVybiBpbnQgc21iMl9oYW5kbGVfY2FuY2VsbGVkX2Nsb3NlKHN0cnVjdCBj
aWZzX3Rjb24gKnRjb24sCisJCQkJICAgICAgIF9fdTY0IHBlcnNpc3RlbnRfZmlkLAorCQkJCSAg
ICAgICBfX3U2NCB2b2xhdGlsZV9maWQpOwogZXh0ZXJuIGludCBzbWIyX2hhbmRsZV9jYW5jZWxs
ZWRfbWlkKGNoYXIgKmJ1ZmZlciwKIAkJCQkJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVy
KTsKIHZvaWQgc21iMl9jYW5jZWxsZWRfY2xvc2VfZmlkKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
ayk7Ci0tIAoyLjE3LjEKCg==
--000000000000369fb80597314056--
