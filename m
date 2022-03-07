Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11054C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 19:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiCGTeh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Mar 2022 14:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242089AbiCGTeg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Mar 2022 14:34:36 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DBB3FBFE
        for <linux-cifs@vger.kernel.org>; Mon,  7 Mar 2022 11:33:41 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id n19so7000654lfh.8
        for <linux-cifs@vger.kernel.org>; Mon, 07 Mar 2022 11:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kXlIqAptowl2egI3kyAJJrxGU+aPFLThtXDsOSJu9tQ=;
        b=pnmCv1E5LUi9rzLZpoJFfm0Eo+cd0xJqE5eku/IWIxBDG/GmTuyTBzUjA15X9VU+wf
         58GDqrNfjiA0mJjWOARB9wG5MPYrA6zfziVs4cM11WwDn1rZzyJKc/1h7NTpXIpwSxrG
         CPbhsfPsasbW/Mb9S7/lhjh40wWuzwqxsvp90WIzPAN2zm/lx2cseDi/jo51aTy9n4zY
         0LQ+27sjdVr6HHEq88bQESLYKa+hEdL0UIbee9T1EiGssfLs484abaoz9hXR1LT9rcUr
         gMRz4kPDTxDdb62MaXv32xnLKJbKaX4U20TRaER/K8Zi/rVey69LW9WDZjsVwa+gpzGr
         yBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXlIqAptowl2egI3kyAJJrxGU+aPFLThtXDsOSJu9tQ=;
        b=ACDbSEWndGY2gYfX6xwAJOw2a/uJmIbqqU56QiiXOtBvK2UXxUY/Nb0e2hVIsAaInM
         VJKAlN128r7ChuHJq8b/irV5Nm0qVcTdoAnHqMr3ngbHJ3HD8djfEDP5rkGl7Q7sfO3x
         vw3TPKBypvJGDCV3FK87CEpGUwnFp9Xnqd8XKz9aPBZjOlgYQKGNxTjjgUGASxoUAGlh
         g77NaVOl3NC/ivjmuN2f5yZmKvJjqP29PxhmavtKxO4bSMiE39yuF0MgVWssSmyAgyXh
         OXff3Mxemyha04cU7J3NVK6dAEYkX//awI4anRtxyphWtV8XENl4QVKRS/hzmbrdB/Qd
         pKkA==
X-Gm-Message-State: AOAM530jazCTGd3FIf3wkmQ+T8+ay/P/vYtXlHweE9PJCS5BPg40nN1N
        Bj7aVcEdSxUACc2mpAVh7+7LH/mY4fyNVSKtNss=
X-Google-Smtp-Source: ABdhPJyRLezPtD+6sum0KA9Ihc6OGifL7X8Eq3NpTScoqQ51lPKssm8w8hZ4shbcxjnnT6XB3VS/uaT8dedIdzw9I60=
X-Received: by 2002:ac2:4145:0:b0:448:273a:7697 with SMTP id
 c5-20020ac24145000000b00448273a7697mr6988691lfi.601.1646681619259; Mon, 07
 Mar 2022 11:33:39 -0800 (PST)
MIME-Version: 1.0
References: <CACdtm0ad+byeGwcpAmLCJWoyyXjJeu=6ZX=QODa0fgxs4X-iyA@mail.gmail.com>
 <87h789bndd.fsf@cjr.nz>
In-Reply-To: <87h789bndd.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 7 Mar 2022 13:33:28 -0600
Message-ID: <CAH2r5mtKCuiXEZLtK-TBwNSGwwYucaNKX-g8+2b1JhCsfwrd5g@mail.gmail.com>
Subject: Re: [PATCH][SMB3]Adjust cifssb maximum read size
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000f9c62905d9a5f0f5"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f9c62905d9a5f0f5
Content-Type: text/plain; charset="UTF-8"

Lightly updated to fix checkpatch warnings about line length and to
add Paulo's acked-by. See attached.

And tentatively merged to cifs-2.6.git for-next pending testing

On Mon, Mar 7, 2022 at 12:59 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Rohith Surabattula <rohiths.msft@gmail.com> writes:
>
> > Hi All,
> >
> > When session gets reconnected during mount then read size in super
> > block fs context gets set to zero and after negotiate, rsize is not
> > modified which results in incorrect read with requested bytes as zero.
> >
> > Attaching 2 patches, one for releases before 5.17 and other for latest.
> > Please take a look.
>
> LGTM.  Thanks Rohith!
>
> Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve

--000000000000f9c62905d9a5f0f5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Adjust-cifssb-maximum-read-size.patch"
Content-Disposition: attachment; 
	filename="0001-Adjust-cifssb-maximum-read-size.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l0h3p0zw0>
X-Attachment-Id: f_l0h3p0zw0

RnJvbSBmYjk4M2EwZjJkZjViZjFkZDJhNGE5YmFkNGJiZWMxYTlmOTMzOWMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCA3IE1hciAyMDIyIDE4OjM3OjIyICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gQWRqdXN0IGNpZnNzYiBtYXhpbXVtIHJlYWQgc2l6ZQoKV2hlbiBzZXNzaW9uIGdldHMgcmVj
b25uZWN0ZWQgZHVyaW5nIG1vdW50IHRoZW4gcmVhZCBzaXplIGluIHN1cGVyIGJsb2NrIGZzIGNv
bnRleHQKZ2V0cyBzZXQgdG8gemVybyBhbmQgYWZ0ZXIgbmVnb3RpYXRlLCByc2l6ZSBpcyBub3Qg
bW9kaWZpZWQgd2hpY2ggcmVzdWx0cyBpbgppbmNvcnJlY3QgcmVhZCB3aXRoIHJlcXVlc3RlZCBi
eXRlcyBhcyB6ZXJvLgoKTm90ZSB0aGF0IHN0YWJsZSByZXF1aXJlcyBhIGRpZmZlcmVudCB2ZXJz
aW9uIG9mIHRoaXMgcGF0Y2ggd2hpY2ggd2lsbCBiZQpzZW50IHRvIHRoZSBzdGFibGUgbWFpbGlu
ZyBsaXN0LgoKU2lnbmVkLW9mZi1ieTogUm9oaXRoIFN1cmFiYXR0dWxhIDxyb2hpdGhzQG1pY3Jv
c29mdC5jb20+CkFja2VkLWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFNVU0UpIDxwY0BjanIubno+ClNp
Z25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBm
cy9jaWZzL2NpZnNmcy5jIHwgIDMgKysrCiBmcy9jaWZzL2ZpbGUuYyAgIHwgMTAgKysrKysrKysr
KwogMiBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggYTYxYmI1ZDY4M2M2Li42NzdjMDJh
YTg3MzEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMu
YwpAQCAtMjEwLDYgKzIxMCw5IEBAIGNpZnNfcmVhZF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sg
KnNiKQogCWlmIChyYykKIAkJZ290byBvdXRfbm9fcm9vdDsKIAkvKiB0dW5lIHJlYWRhaGVhZCBh
Y2NvcmRpbmcgdG8gcnNpemUgaWYgcmVhZGFoZWFkIHNpemUgbm90IHNldCBvbiBtb3VudCAqLwor
CWlmIChjaWZzX3NiLT5jdHgtPnJzaXplID09IDApCisJCWNpZnNfc2ItPmN0eC0+cnNpemUgPQor
CQkJdGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+bmVnb3RpYXRlX3JzaXplKHRjb24sIGNpZnNfc2It
PmN0eCk7CiAJaWYgKGNpZnNfc2ItPmN0eC0+cmFzaXplKQogCQlzYi0+c19iZGktPnJhX3BhZ2Vz
ID0gY2lmc19zYi0+Y3R4LT5yYXNpemUgLyBQQUdFX1NJWkU7CiAJZWxzZQpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCBlN2FmODAyZGNmYTYuLmEyNzIz
ZjdjYjVlOSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxlLmMK
QEAgLTM3NDAsNiArMzc0MCwxMSBAQCBjaWZzX3NlbmRfYXN5bmNfcmVhZChsb2ZmX3Qgb2Zmc2V0
LCBzaXplX3QgbGVuLCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpvcGVuX2ZpbGUsCiAJCQkJYnJlYWs7
CiAJCX0KIAorCQlpZiAoY2lmc19zYi0+Y3R4LT5yc2l6ZSA9PSAwKQorCQkJY2lmc19zYi0+Y3R4
LT5yc2l6ZSA9CisJCQkJc2VydmVyLT5vcHMtPm5lZ290aWF0ZV9yc2l6ZSh0bGlua190Y29uKG9w
ZW5fZmlsZS0+dGxpbmspLAorCQkJCQkJCSAgICAgY2lmc19zYi0+Y3R4KTsKKwogCQlyYyA9IHNl
cnZlci0+b3BzLT53YWl0X210dV9jcmVkaXRzKHNlcnZlciwgY2lmc19zYi0+Y3R4LT5yc2l6ZSwK
IAkJCQkJCSAgICZyc2l6ZSwgY3JlZGl0cyk7CiAJCWlmIChyYykKQEAgLTQ0NzQsNiArNDQ3OSwx
MSBAQCBzdGF0aWMgdm9pZCBjaWZzX3JlYWRhaGVhZChzdHJ1Y3QgcmVhZGFoZWFkX2NvbnRyb2wg
KnJhY3RsKQogCQkJfQogCQl9CiAKKwkJaWYgKGNpZnNfc2ItPmN0eC0+cnNpemUgPT0gMCkKKwkJ
CWNpZnNfc2ItPmN0eC0+cnNpemUgPQorCQkJCXNlcnZlci0+b3BzLT5uZWdvdGlhdGVfcnNpemUo
dGxpbmtfdGNvbihvcGVuX2ZpbGUtPnRsaW5rKSwKKwkJCQkJCQkgICAgIGNpZnNfc2ItPmN0eCk7
CisKIAkJcmMgPSBzZXJ2ZXItPm9wcy0+d2FpdF9tdHVfY3JlZGl0cyhzZXJ2ZXIsIGNpZnNfc2It
PmN0eC0+cnNpemUsCiAJCQkJCQkgICAmcnNpemUsIGNyZWRpdHMpOwogCQlpZiAocmMpCi0tIAoy
LjMyLjAKCg==
--000000000000f9c62905d9a5f0f5--
