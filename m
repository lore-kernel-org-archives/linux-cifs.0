Return-Path: <SRS0=Kcr7=RG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B303FC43381
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Mar 2019 19:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60B0520842
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Mar 2019 19:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uYhWN+W+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfCCTGM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Mar 2019 14:06:12 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:35671 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfCCTGM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Mar 2019 14:06:12 -0500
Received: by mail-pg1-f181.google.com with SMTP id e17so1435292pgd.2
        for <linux-cifs@vger.kernel.org>; Sun, 03 Mar 2019 11:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6MOynt0IufqdDBBRhNHG+AeIheXJttMv9z2TVOJQR9k=;
        b=uYhWN+W+55SoXqBdFJdlgGyCNSWaF7fMkT1Q6r+we8VevYkeAD8aUZRGp5ENaSWIWH
         mWkZYjNJIsTaveJyKJrRl/cMOTY/mb/+FLJC+fbVxlVORVBfL+15VgaFqb5KWtPBil5n
         BB6LuzSTo8Di81Q2yo/LgrHIaAayBNKYjrQmHihJINbi/In7pdStUbgErBciCDhuB9Br
         Kd+NhDvnhbCClv44KixAxvKgPn7VvKIKhNKIMfC01wywNqkPMb3h5mu1HazM9de61GqO
         RCf+iQNzloe8M93WeCPIWg1KKjVhccF7Im1KxHN6Y9OM64gIIqMgRXtsTtGmB+yP+LVc
         ydNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6MOynt0IufqdDBBRhNHG+AeIheXJttMv9z2TVOJQR9k=;
        b=N/LDuhEG0CXCW5KkHyJumgjK/r4zN643dBkEBj0JeAfGgNkOKhOLSU51WVyNg6VlzV
         uD9Ysmc8poqitQKJXJU8UbR9EfHRei/l3utCp9YHGQ96uYCtQJKZptBDNf1YROu+o8uI
         fYL8B1ONj8XA/SpZdHLd24ciGr80kNZRrx0dm85KjWHgLNQp+zv9wxz2xfm5Yc/dHfvP
         lTTXku4NSF2Df14Xgbi0io/znqjvdm24cI+AWMVbDYnp15QdfhnpCK8YdeHlKaMKWW6a
         4m70bM5DsOpr5IkYKyck3CnIG9NqwNIBOTCs6fFE9b4D6qhhdwUeMyybJm17ntNJw+Tz
         KdDQ==
X-Gm-Message-State: AHQUAuY7l9LfNbKKNJVV1z83NuA0B8Y19hR2bzLLLGNfWp1Qxz0cCfWd
        MJpfoT3ln9GCYV3oooBss34G/ziPyVUfeIn+CdyGLQ==
X-Google-Smtp-Source: APXvYqxjHS7QhEyAEYD19SA0K+tU1V+PPTdoeS7LeZwfU3TxmH6Ujaoa8LrLwvaxNRvTspD6c11MWvprLjWmEUWPpMs=
X-Received: by 2002:aa7:8d42:: with SMTP id s2mr16421690pfe.116.1551639971207;
 Sun, 03 Mar 2019 11:06:11 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 3 Mar 2019 13:06:00 -0600
Message-ID: <CAH2r5muf6csp6Y=dN=P8iLLkj7bUniUgUE=duyg9pkZrQQsVtQ@mail.gmail.com>
Subject: [PATCH] Display cruid on krb5 mounts
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004dc60d0583355523"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004dc60d0583355523
Content-Type: text/plain; charset="UTF-8"

Can be helpful to tell which users we have gotten tickets for for
multiuser krb5 mounts



-- 
Thanks,

Steve

--0000000000004dc60d0583355523
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0041-smb3-for-kerberos-mounts-display-the-credential-uid-.patch"
Content-Disposition: attachment; 
	filename="0041-smb3-for-kerberos-mounts-display-the-credential-uid-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jstadagf0>
X-Attachment-Id: f_jstadagf0

RnJvbSBkMzg3MWY2ZGRkN2YwM2I0MTdjNmUxNjJjZDRiZjcwZDY2NDY4YWI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMiBNYXIgMjAxOSAwNjo1Njo1NCAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggNDEv
NDFdIHNtYjM6IGZvciBrZXJiZXJvcyBtb3VudHMgZGlzcGxheSB0aGUgY3JlZGVudGlhbCB1aWQK
IHVzZWQKCkZvciBrZXJiZXJvcyBtb3VudHMsIHRoZSBjcnVpZCBpcyBoZWxwZnVsIHRvIGRpc3Bs
YXkgaW4KL3Byb2MvbW91bnRzIGluIG9yZGVyIHRvIHRlbGwgd2hpY2ggdWlkJ3Mga3JiNSBjYWNo
ZSB3ZQpnb3QgdGhlIHRpY2tldCBmb3IgYW5kIHRvIHRlbGwgaW4gdGhlIG11bHRpdXNlciBrcmI1
IGNhc2UKd2hpY2ggbG9jYWwgdXNlcnMgKHVpZHMpIHdlIGhhdmUgS2VyYmVyb3MgYXV0aGVudGlj
IHNlc3Npb25zCmZvci4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWlj
cm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0
LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNmcy5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBi
L2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggZjJjMGQ4NjNmYjUyLi4yMTcyNzZiOGI5NDIgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMuYwpAQCAtMzgxLDcg
KzM4MSw3IEBAIGNpZnNfc2hvd19zZWN1cml0eShzdHJ1Y3Qgc2VxX2ZpbGUgKnMsIHN0cnVjdCBj
aWZzX3NlcyAqc2VzKQogCQlzZXFfcHV0cyhzLCAibnRsbSIpOwogCQlicmVhazsKIAljYXNlIEtl
cmJlcm9zOgotCQlzZXFfcHV0cyhzLCAia3JiNSIpOworCQlzZXFfcHJpbnRmKHMsICJrcmI1LGNy
dWlkPSV1IiwgZnJvbV9rdWlkX211bmdlZCgmaW5pdF91c2VyX25zLHNlcy0+Y3JlZF91aWQpKTsK
IAkJYnJlYWs7CiAJY2FzZSBSYXdOVExNU1NQOgogCQlzZXFfcHV0cyhzLCAibnRsbXNzcCIpOwot
LSAKMi4xNy4xCgo=
--0000000000004dc60d0583355523--
