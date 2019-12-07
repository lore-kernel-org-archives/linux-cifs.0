Return-Path: <SRS0=CnDO=Z5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5884FC43603
	for <linux-cifs@archiver.kernel.org>; Sat,  7 Dec 2019 23:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20DD524673
	for <linux-cifs@archiver.kernel.org>; Sat,  7 Dec 2019 23:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="trp1O79M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfLGXrL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 7 Dec 2019 18:47:11 -0500
Received: from mail-il1-f179.google.com ([209.85.166.179]:45382 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfLGXrL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 7 Dec 2019 18:47:11 -0500
Received: by mail-il1-f179.google.com with SMTP id p8so9484962iln.12
        for <linux-cifs@vger.kernel.org>; Sat, 07 Dec 2019 15:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Nqk0dUDHpPmCt/fAzM/abgagXMdxTXpWbAkdZRwn9OA=;
        b=trp1O79MBxCR89vLE7X5cVuZtW+bIN/PiRDoM37lmigPyQ+fPpBia/H1bg880x2/kN
         3KTa5rIpl+cr11MYj67J6VpRYgef8G6sPbDcADcoDK3uVe+PcQ50R2CfmcynWITYhv/c
         qmyU4TJALO7NMxPoHd7hYarRfq5Vc7zr7SomEPKca3kF4sAKwuzWl1+jz/d/Pw99MPW3
         /iNBdjH29Ai0wcZBYZA41okxALcQaqBQzSZ/OZQG4z3OF+z594GN+Z8vaGgt/YUiWXtZ
         6OZs5znwOESw9wcdn3vAPxQHqp/NlcI+EaCCHwuEzApa/Tz5gjr6AabLKcFKuC9YPuCx
         i5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Nqk0dUDHpPmCt/fAzM/abgagXMdxTXpWbAkdZRwn9OA=;
        b=kpOGltrFkOtNNmckx6NLKAxqQjbX9P6cgFcCW4YVj2wg5d5RMBFBnASLWTv8qiAoF0
         0zscqk9RKZbRfuB0CnccyA3nPqi5wNDOcfA34Yg0CzOyh7yekJr6B3xPxWorkY2+HYOl
         pPqqzVauA+Hs9yVFXalS+ZHGuioErDnJeKvPs4TeGAeMn+8jjQuVoWCWMoEuJsLW2IWC
         AlRz/eH73ykhx61fGodiGY8Blo7qfAiBO14buM38bbfHtybctEeBnXc+ogclx5pDGjQj
         pDLeJ7INfQ+rIlBZ+KLntOh+yYdET/NVjcbOLdkJlhH/ZysjuJk0eMCqtiIo7+0AYVX+
         1J9g==
X-Gm-Message-State: APjAAAW7D9z+ZelPVUaCcU313ailUJh8IuK9Cn9DMrLOMZhDwUaGkMC2
        HZn8/5X34z/Gf63LrYchq2Zgtv6vir+45DnqyqDYItFO
X-Google-Smtp-Source: APXvYqyfJkRO7RTXQVhhpqrPTFi7Efrh8+IrGhz6TPf5YYyfft0/I3u6MOmPNRSLQlKAp/Bj/a69eRiiordi057ai94=
X-Received: by 2002:a92:6802:: with SMTP id d2mr21725775ilc.173.1575762430139;
 Sat, 07 Dec 2019 15:47:10 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 7 Dec 2019 17:46:59 -0600
Message-ID: <CAH2r5mtYOS3tDDnE65NZUg+eYV=oMVysO4UCF018eBhVE-CqeA@mail.gmail.com>
Subject: [PATCH][SMB3] Improve check for when we send security descriptor
 context on open
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e6618d059925c71d"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e6618d059925c71d
Content-Type: text/plain; charset="UTF-8"

    We had cases in the modetosid patch where we were sending the security
    descriptor context on SMB3 open (file create) in cases when we hadn't
    mounted with with "modefromsid" mount option.

    Add check for that mount flag before calling ad_sd_context in
    open init.


-- 
Thanks,

Steve

--000000000000e6618d059925c71d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-improve-check-for-when-we-send-the-security-des.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-improve-check-for-when-we-send-the-security-des.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k3w89afu0>
X-Attachment-Id: f_k3w89afu0

RnJvbSAyMzFlMmEwYmE1NjczM2M5NWNiNzdkODkyMGU3NjUwMmIyMTM0ZTcyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgNyBEZWMgMjAxOSAxNzozODoyMiAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGltcHJvdmUgY2hlY2sgZm9yIHdoZW4gd2Ugc2VuZCB0aGUgc2VjdXJpdHkgZGVzY3JpcHRv
cgogY29udGV4dCBvbiBjcmVhdGUKCldlIGhhZCBjYXNlcyBpbiB0aGUgcHJldmlvdXMgcGF0Y2gg
d2hlcmUgd2Ugd2VyZSBzZW5kaW5nIHRoZSBzZWN1cml0eQpkZXNjcmlwdG9yIGNvbnRleHQgb24g
U01CMyBvcGVuIChmaWxlIGNyZWF0ZSkgaW4gY2FzZXMgd2hlbiB3ZSBoYWRuJ3QKbW91bnRlZCB3
aXRoIHdpdGggIm1vZGVmcm9tc2lkIiBtb3VudCBvcHRpb24uCgpBZGQgY2hlY2sgZm9yIHRoYXQg
bW91bnQgZmxhZyBiZWZvcmUgY2FsbGluZyBhZF9zZF9jb250ZXh0IGluCm9wZW4gaW5pdC4KClNp
Z25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KUmV2aWV3
ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2Np
ZnMvc21iMnBkdS5jIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggYjc3
NjQzZTAyMTU3Li4wYWI2YjEyMDAyODggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisr
KyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0yNjMwLDYgKzI2MzAsOCBAQCBTTUIyX29wZW5faW5p
dChzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QsIF9fdTggKm9w
bG9jaywKIAl9CiAKIAlpZiAoKG9wYXJtcy0+ZGlzcG9zaXRpb24gIT0gRklMRV9PUEVOKSAmJgor
CSAgICAob3Bhcm1zLT5jaWZzX3NiKSAmJgorCSAgICAob3Bhcm1zLT5jaWZzX3NiLT5tbnRfY2lm
c19mbGFncyAmIENJRlNfTU9VTlRfTU9ERV9GUk9NX1NJRCkgJiYKIAkgICAgKG9wYXJtcy0+bW9k
ZSAhPSBBQ0xfTk9fTU9ERSkpIHsKIAkJaWYgKG5faW92ID4gMikgewogCQkJc3RydWN0IGNyZWF0
ZV9jb250ZXh0ICpjY29udGV4dCA9Ci0tIAoyLjIzLjAKCg==
--000000000000e6618d059925c71d--
