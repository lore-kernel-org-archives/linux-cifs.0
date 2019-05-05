Return-Path: <SRS0=LKAl=TF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159D8C004C9
	for <linux-cifs@archiver.kernel.org>; Sun,  5 May 2019 23:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDFB420651
	for <linux-cifs@archiver.kernel.org>; Sun,  5 May 2019 23:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gqmRPWDM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfEEXNj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 May 2019 19:13:39 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:42456 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbfEEXNj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 May 2019 19:13:39 -0400
Received: by mail-pl1-f174.google.com with SMTP id x15so5395918pln.9
        for <linux-cifs@vger.kernel.org>; Sun, 05 May 2019 16:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rtEr4Z4/F6xDzDZmrJp0hI+Nyv9z0edEnVTpgaYBJJo=;
        b=gqmRPWDMUToc+O7KKy0hCJL62wDqwtWhTRschHgtFjHWqkNVz5EGbO5EPbBeWahFYV
         Zz9WjqUC0o0xNtGN+RvMEgt3ME3+cgH06qsLaACb8AiisFa96nc2o43EYhXSRBjN/rmJ
         TSkRaxaEOeIEKil8gEJJNIYtjaeV12wubSRFnTiXmtMjzM2pAID2DVuthjxN1L5ubF6E
         qC3qDBfbn+ENt2lmuAnVZZ2u/h1ClMI9KZgS0W9eBNk3NunyvYTpiuK3vbekoI5rUhVo
         45nlPZtnv4kqYMEU2uSse50VgwSNAvs4aU6shRc+tnpstgPK4O6s5Inbjlcb54/bKOuT
         wnfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rtEr4Z4/F6xDzDZmrJp0hI+Nyv9z0edEnVTpgaYBJJo=;
        b=QVducw2zS5k+RDoUJMquVJIH6PY6otiDPMvrI3+UXeC1rj6xd1zbTcNH3PS5uJ/xcB
         guSnX4fp7qQns3U8tgzupigVrNkkutVmhmBVLxs27a71QDR/3jv0scGYliEKAE93Rmcz
         fILNTayV3ifw7bpWvntCAV1asPWkaaSKZr/348VGZU12YHw6adKTW/Et9+/F9bJVWsTr
         PK4Bq/Wtihan2EVipK9ZBnwUdE8qThG/f3xsNceEKHaeDaG/QhD+T6/v3glGt3zHPSHs
         bkYsLs2g3nYRQz4VuWd6nrwnzgzcFii/DK6i3SLKWw007gpOpj15OqgtymJbewY29FQ8
         oM0g==
X-Gm-Message-State: APjAAAUjug/kKyyjwIUvyv3D5KWjD1uw7iGiD7QJ/1vhUBG7WHNaHmVs
        nj1O+s1vi830ldTdzskoiFl17cPRnnDYOZ95YIPvUQ==
X-Google-Smtp-Source: APXvYqxLgiGSwNHT4rc6ZwfrNUyT4G4HgGa7Fw0hfwe6S9s2BUI5f5P//lePEMmktlvKx5+t/z7eIM/zaCsaFgo5NuU=
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr27055937plo.32.1557098017882;
 Sun, 05 May 2019 16:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt+ogjdc9w+ppvu+GwWfojFOK_izStTkOgjs07bXVbO2A@mail.gmail.com>
In-Reply-To: <CAH2r5mt+ogjdc9w+ppvu+GwWfojFOK_izStTkOgjs07bXVbO2A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 5 May 2019 18:13:26 -0500
Message-ID: <CAH2r5mthh7UjwN+PFnR-TZC_8fNtPkoqWwwt_iaSZxybr2ebmw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add SMB3 protocol flags and structs for change notify
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000003cb09a05882c222b"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003cb09a05882c222b
Content-Type: text/plain; charset="UTF-8"

Minor update with feedback from Ronnie


On Sun, May 5, 2019 at 5:28 PM Steve French <smfrench@gmail.com> wrote:
>
> See MS-FSCC 2.6 and MS-SMB2 2.2.35
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000003cb09a05882c222b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Add-protocol-structs-for-change-notify-support.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-protocol-structs-for-change-notify-support.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jvbjy5hg0>
X-Attachment-Id: f_jvbjy5hg0

RnJvbSBiNzA3NzRmODU3ZjdlZjY5YjNhYTA1NjRlMTlmNzA5NjI1MWUwNjY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgNSBNYXkgMjAxOSAxNzoyNToxMiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IEFkZCBwcm90b2NvbCBzdHJ1Y3RzIGZvciBjaGFuZ2Ugbm90aWZ5IHN1cHBvcnQKCkFkZCB0
aGUgU01CMyBwcm90b2NvbCBmbGFnIGRlZmluaXRpb25zIGFuZCBzdHJ1Y3RzIGZvcgpjaGFuZ2Ug
bm90aWZ5LiAgRnV0dXJlIHBhdGNoZXMgd2lsbCBhZGQgdGhlIGhvb2tzIHRvCmFsbG93IGl0IHRv
IGJlIGludm9rZWQgZnJvbSB0aGUgY2xpZW50LgoKU2VlIE1TLUZTQ0MgMi42IGFuZCBNUy1TTUIy
IDIuMi4zNQoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgpSZXZpZXdlZC1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgot
LS0KIGZzL2NpZnMvc21iMnBkdS5oIHwgMzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvc21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgKaW5kZXggODY4YjAwNTY4MDhjLi5k
MjkwY2RlZmFkY2EgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5oCisrKyBiL2ZzL2NpZnMv
c21iMnBkdS5oCkBAIC0xMTQ4LDYgKzExNDgsNDIgQEAgc3RydWN0IHNtYjJfd3JpdGVfcnNwIHsK
IAlfX3U4ICAgQnVmZmVyWzFdOwogfSBfX3BhY2tlZDsKIAorLyogbm90aWZ5IGZsYWdzICovCisj
ZGVmaW5lIFNNQjJfV0FUQ0hfVFJFRQkJCTB4MDAwMQorCisvKiBub3RpZnkgY29tcGxldGlvbiBm
aWx0ZXIgZmxhZ3MuIFNlZSBNUy1GU0NDIDIuNiBhbmQgTVMtU01CMiAyLjIuMzUgKi8KKyNkZWZp
bmUgRklMRV9OT1RJRllfQ0hBTkdFX0ZJTEVfTkFNRQkJMHgwMDAwMDAwMQorI2RlZmluZSBGSUxF
X05PVElGWV9DSEFOR0VfRElSX05BTUUJCTB4MDAwMDAwMDIKKyNkZWZpbmUgRklMRV9OT1RJRllf
Q0hBTkdFX0FUVFJJQlVURVMJCTB4MDAwMDAwMDQKKyNkZWZpbmUgRklMRV9OT1RJRllfQ0hBTkdF
X1NJWkUJCQkweDAwMDAwMDA4CisjZGVmaW5lIEZJTEVfTk9USUZZX0NIQU5HRV9MQVNUX1dSSVRF
CQkweDAwMDAwMDEwCisjZGVmaW5lIEZJTEVfTk9USUZZX0NIQU5HRV9MQVNUX0FDQ0VTUwkJMHgw
MDAwMDAyMAorI2RlZmluZSBGSUxFX05PVElGWV9DSEFOR0VfQ1JFQVRJT04JCTB4MDAwMDAwNDAK
KyNkZWZpbmUgRklMRV9OT1RJRllfQ0hBTkdFX0VBCQkJMHgwMDAwMDA4MAorI2RlZmluZSBGSUxF
X05PVElGWV9DSEFOR0VfU0VDVVJJVFkJCTB4MDAwMDAxMDAKKyNkZWZpbmUgRklMRV9OT1RJRllf
Q0hBTkdFX1NUUkVBTV9OQU1FCQkweDAwMDAwMjAwCisjZGVmaW5lIEZJTEVfTk9USUZZX0NIQU5H
RV9TVFJFQU1fU0laRQkJMHgwMDAwMDQwMAorI2RlZmluZSBGSUxFX05PVElGWV9DSEFOR0VfU1RS
RUFNX1dSSVRFCQkweDAwMDAwODAwCisKK3N0cnVjdCBzbWIyX2NoYW5nZV9ub3RpZnlfcmVxIHsK
KwlzdHJ1Y3Qgc21iMl9zeW5jX2hkciBzeW5jX2hkcjsKKwlfX2xlMTYJU3RydWN0dXJlU2l6ZTsK
KwlfX2xlMTYJRmxhZ3M7CisJX19sZTMyCU91dHB1dEJ1ZmZlckxlbmd0aDsKKwlfX3U2NAlQZXJz
aXN0ZW50RmlsZUlkOyAvKiBvcGFxdWUgZW5kaWFubmVzcyAqLworCV9fdTY0CVZvbGF0aWxlRmls
ZUlkOyAvKiBvcGFxdWUgZW5kaWFubmVzcyAqLworCV9fbGUzMglDb21wbGV0aW9uRmlsdGVyOwor
CV9fdTMyCVJlc2VydmVkOworfSBfX3BhY2tlZDsKKworc3RydWN0IHNtYjJfY2hhbmdlX25vdGlm
eV9yc3AgeworCXN0cnVjdCBzbWIyX3N5bmNfaGRyIHN5bmNfaGRyOworCV9fbGUxNglTdHJ1Y3R1
cmVTaXplOyAgLyogTXVzdCBiZSA5ICovCisJX19sZTE2CU91dHB1dEJ1ZmZlck9mZnNldDsKKwlf
X2xlMzIJT3V0cHV0QnVmZmVyTGVuZ3RoOworCV9fdTgJQnVmZmVyWzFdOyAvKiBhcnJheSBvZiBm
aWxlIG5vdGlmeSBzdHJ1Y3RzICovCit9IF9fcGFja2VkOworCiAjZGVmaW5lIFNNQjJfTE9DS0ZM
QUdfU0hBUkVEX0xPQ0sJMHgwMDAxCiAjZGVmaW5lIFNNQjJfTE9DS0ZMQUdfRVhDTFVTSVZFX0xP
Q0sJMHgwMDAyCiAjZGVmaW5lIFNNQjJfTE9DS0ZMQUdfVU5MT0NLCQkweDAwMDQKLS0gCjIuMjAu
MQoK
--0000000000003cb09a05882c222b--
