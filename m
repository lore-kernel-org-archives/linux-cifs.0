Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8187C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 17:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJQRQS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 13:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiJQRQS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 13:16:18 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471F069F43
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 10:16:17 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id i16so4618130uak.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 10:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JKilZNWOKGKSdyn0HWJbmfq1Yl0msc9I2KwF2YF0RGQ=;
        b=V9Rgj2nCxk4R8eKkuHBkOz/00Xma5eZ5KuwFENVtzDtjfyPpegHw9Bf0BzFmRnYHzv
         x5gbSnkZ0e0eD8R12q+ouLNHyuTdV5RV2BX5Bkjj9A19E1nKmr/w6882KzjzH7J9EKVF
         106Cgl1Gz9oGzb7Lnv3665amB/Ruz4O7mjqASIRMFZA6PzANROn466ERkKJT4+d8ohai
         vh+v9f1zGjmfWXiszJe5P5oTvBdQb030Rb7+G+1qLlecNqIhD9+9b18Hl6U5NlBHZsDf
         7i++HWCIHRj630a+2BAzUGh5wiUflAy9gxnSxAF/v1ZUHBTyOFwxKrl+wx9kQ3HTbyuQ
         XPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JKilZNWOKGKSdyn0HWJbmfq1Yl0msc9I2KwF2YF0RGQ=;
        b=Zb89SGK/jzjYDuro5pwnZMln5q+Vi6RgOfOZrQ7WpmwCdGxLqjYVSvSRqv+u3es3+x
         8TeFmohFOc0jNTge4wnarH+Znn9zvCPaWaX5m+8RalnUq0gkiZShwUhGQSpzXQW/SoHR
         YPHSTAQ9xLqfrQVtbFyXlVOO8GPKv8KPwXOPP1d3unqVGDb9L/eVAeOlSmlaer4UKQRa
         pxc5Sf+IqIGp3GhIAWyq9eXzl3Su2VaUwlCsZw0/B0L7Cl5zulUpbpyHGLzDcT2AjMxO
         p2UGYabWGdnwnyWiSCWoBuehgFeZDz6lon/W8n65uX6SC7RoALNLIRggPaYxGyp8ZD2g
         Jtgw==
X-Gm-Message-State: ACrzQf1CM3nU91O+8wovpQV9Tdj3yBPvD2DaklkxcMNHbSTU6k0u5xV6
        TFu/S8x1bBj94Vi51HYuZjevJUSbhN9evvshr20VpsY8
X-Google-Smtp-Source: AMsMyM4nC5XOUAU/fo3P3FV+2kU63f7VpzHrWya9j+KCS6+ggylhA4Vqur7Iew00Qr5MDNIpG6CS9XzlcinhEqGiviQ=
X-Received: by 2002:ab0:39d9:0:b0:3e2:39a9:a986 with SMTP id
 g25-20020ab039d9000000b003e239a9a986mr5413374uaw.81.1666026975956; Mon, 17
 Oct 2022 10:16:15 -0700 (PDT)
MIME-Version: 1.0
References: <634d44b475002_14edae2ae82273798886522@prd-scan-dashboard-0.mail>
In-Reply-To: <634d44b475002_14edae2ae82273798886522@prd-scan-dashboard-0.mail>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Oct 2022 12:16:04 -0500
Message-ID: <CAH2r5muQU+e=JxuOQB=SrJAS_bBM-pY0Y7ymPC=n2FrXqTK4XQ@mail.gmail.com>
Subject: Fwd: New Defects reported by Coverity Scan for linux-next weekly scan
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000169d9d05eb3e22a2"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000169d9d05eb3e22a2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Lightly updated the patch to address the existing missing lock issue
near the same line I changed

See attached

---------- Forwarded message ---------
From: <scan-admin@coverity.com>
Date: Mon, Oct 17, 2022 at 7:04 AM
Subject: New Defects reported by Coverity Scan for linux-next weekly scan
To: <smfrench@gmail.com>


Hi,

Please find the latest report on new defect(s) introduced to
linux-next weekly scan, under component 'FS-CIFS',  found with
Coverity Scan.

1 new defect(s) introduced to linux-next weekly scan, under component
'FS-CIFS',  found with Coverity Scan.
7 defect(s), reported by Coverity Scan earlier, were marked fixed in
the recent build analyzed by Coverity Scan.

New defect(s) Reported-by: Coverity Scan
Showing 1 of 1 defect(s)


** CID 1526374:  Concurrent data access violations  (MISSING_LOCK)
/fs/cifs/smb2ops.c: 657 in parse_server_interfaces()


___________________________________________________________________________=
_____________________________
*** CID 1526374:  Concurrent data access violations  (MISSING_LOCK)
/fs/cifs/smb2ops.c: 657 in parse_server_interfaces()
651                             list_add_tail(&info->iface_head,
&iface->iface_head);
652                             kref_put(&iface->refcount, release_iface);
653                     } else
654                             list_add_tail(&info->iface_head,
&ses->iface_list);
655                     spin_unlock(&ses->iface_lock);
656
>>>     CID 1526374:  Concurrent data access violations  (MISSING_LOCK)
>>>     Accessing "ses->iface_count" without holding lock "cifs_ses.iface_l=
ock". Elsewhere, "cifs_ses.iface_count" is accessed with "cifs_ses.iface_lo=
ck" held 1 out of 2 times (1 of these accesses strongly imply that it is ne=
cessary).
657                     ses->iface_count++;
658                     ses->iface_last_update =3D jiffies;
659     next_iface:
660                     nb_iface++;
661                     next =3D le32_to_cpu(p->Next);
662                     if (!next) {


___________________________________________________________________________=
_____________________________
To view the defects in Coverity Scan visit,
https://u15810271.ct.sendgrid.net/ls/click?upn=3DHRESupC-2F2Czv4BOaCWWCy7my=
0P0qcxCbhZ31OYv50ypWUaxuG23arlAOMqBtlZty8jbpwvvNgxXk-2FmAsxmR9vW5nmNrMx1IpP=
6MDN1J2o1ZPwtxoZUPo2TKCoVE0eHSfk803_Y7VRim-2Fxl9fmAdBRyG05vGZHoQCljkdhUYA-2=
FoqqLzdQ99pG1yOfKEIo9MJB7agwTtnlcxoAvqS-2BDtTTUTOWD7T6SBVYeLQSl638-2Fl8BXfh=
LmGrBb9Xd1yIE5M7TgbMfbvF3Tbswre9yw5CzuyRBh0wEKEyA5bApzoxGHjAPNsTqcnpOwNJh8U=
EScTPqAQmwuak6ixO1HFu3OSQSs1Vt9Cw-3D-3D

  To manage Coverity Scan email notifications for
"smfrench@gmail.com", click
https://u15810271.ct.sendgrid.net/ls/click?upn=3DHRESupC-2F2Czv4BOaCWWCy7my=
0P0qcxCbhZ31OYv50yped04pjJnmXOsUBtKYNIXxgDITOxfLjGd57Ifg09SfMSZeD9rHMtRaJqZ=
q0ctXqp7fRP-2BE8DxRp97FczN2h9FJkLzTHr7qddqCt-2F0SoddBt8k3Bc5cgjF9mAUP8Y7F8M=
A-3DWn7Q_Y7VRim-2Fxl9fmAdBRyG05vGZHoQCljkdhUYA-2FoqqLzdQ99pG1yOfKEIo9MJB7ag=
wTRwlJGtThGaSyOc7gNCDGP8d-2Fv8dqdH7vZ2Rcf363XI43urt-2B6W2PUJtvoQox-2BUv-2By=
441h2k7z7u9E9TtWBaE9dU32vzYmrzG1NktYtHYw1ZDHaIhOxPtqf9t-2B44F9hRmyL3zLHSLj0=
-2BvSRIk6dpiUw-3D-3D



--=20
Thanks,

Steve

--000000000000169d9d05eb3e22a2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-interface-count-displayed-incorrectly.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-interface-count-displayed-incorrectly.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9d1fnab0>
X-Attachment-Id: f_l9d1fnab0

RnJvbSAzZjgyNWI4ZmE5M2JiMzAwZTYwYzkzMjc1M2U4YzUyNzRiMjUzYTc3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTUgT2N0IDIwMjIgMTc6MDI6MzAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBpbnRlcmZhY2UgY291bnQgZGlzcGxheWVkIGluY29ycmVjdGx5CgpUaGUgIlNlcnZlciBp
bnRlcmZhY2VzIiBjb3VudCBpbiAvcHJvYy9mcy9jaWZzL0RlYnVnRGF0YSBpbmNyZWFzZXMKYXMg
dGhlIGludGVyZmFjZXMgYXJlIHJlcXVlcmllZCwgcmF0aGVyIHRoYW4gYmVpbmcgcmVzZXQgdG8g
dGhlIG5ldwp2YWx1ZS4gIFRoaXMgY291bGQgY2F1c2UgYSBwcm9ibGVtIGlmIHRoZSBzZXJ2ZXIg
ZGlzYWJsZWQKbXVsdGljaGFubmVsIGFzIHRoZSBpZmFjZV9jb3VudCBpcyBjaGVja2VkIGluIHRy
eV9hZGRpbmdfY2hhbm5lbHMKdG8gc2VlIGlmIG11bHRpY2hhbm5lbCBzdGlsbCBzdXBwb3J0ZWQu
CgpBbHNvIGZpeGVzIGEgY292ZXJpdHkgd2FybmluZzoKCkFkZHJlc3Nlcy1Db3Zlcml0eTogMTUy
NjM3NCAoIkNvbmN1cnJlbnQgZGF0YSBhY2Nlc3MgdmlvbGF0aW9ucyAgKE1JU1NJTkdfTE9DSyki
KQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5j
aCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJvcHMuYyB8IDMgKyst
CiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCAxN2IyNTE1
M2NiNjguLjRmNTNmYTAxMjkzNiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIv
ZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTUzMCw2ICs1MzAsNyBAQCBwYXJzZV9zZXJ2ZXJfaW50ZXJm
YWNlcyhzdHJ1Y3QgbmV0d29ya19pbnRlcmZhY2VfaW5mb19pb2N0bF9yc3AgKmJ1ZiwKIAlwID0g
YnVmOwogCiAJc3Bpbl9sb2NrKCZzZXMtPmlmYWNlX2xvY2spOworCXNlcy0+aWZhY2VfY291bnQg
PSAwOwogCS8qCiAJICogR28gdGhyb3VnaCBpZmFjZV9saXN0IGFuZCBkbyBrcmVmX3B1dCB0byBy
ZW1vdmUKIAkgKiBhbnkgdW51c2VkIGlmYWNlcy4gaWZhY2VzIGluIHVzZSB3aWxsIGJlIHJlbW92
ZWQKQEAgLTY1MSw5ICs2NTIsOSBAQCBwYXJzZV9zZXJ2ZXJfaW50ZXJmYWNlcyhzdHJ1Y3QgbmV0
d29ya19pbnRlcmZhY2VfaW5mb19pb2N0bF9yc3AgKmJ1ZiwKIAkJCWtyZWZfcHV0KCZpZmFjZS0+
cmVmY291bnQsIHJlbGVhc2VfaWZhY2UpOwogCQl9IGVsc2UKIAkJCWxpc3RfYWRkX3RhaWwoJmlu
Zm8tPmlmYWNlX2hlYWQsICZzZXMtPmlmYWNlX2xpc3QpOwotCQlzcGluX3VubG9jaygmc2VzLT5p
ZmFjZV9sb2NrKTsKIAogCQlzZXMtPmlmYWNlX2NvdW50Kys7CisJCXNwaW5fdW5sb2NrKCZzZXMt
PmlmYWNlX2xvY2spOwogCQlzZXMtPmlmYWNlX2xhc3RfdXBkYXRlID0gamlmZmllczsKIG5leHRf
aWZhY2U6CiAJCW5iX2lmYWNlKys7Ci0tIAoyLjM0LjEKCg==
--000000000000169d9d05eb3e22a2--
