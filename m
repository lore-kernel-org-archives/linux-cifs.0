Return-Path: <SRS0=CwqD=5A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55227C10DCE
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 23:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D5F320674
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Mar 2020 23:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOn1+ESP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgCOXHP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Mar 2020 19:07:15 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:35794 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbgCOXHP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Mar 2020 19:07:15 -0400
Received: by mail-qk1-f175.google.com with SMTP id d8so23095006qka.2
        for <linux-cifs@vger.kernel.org>; Sun, 15 Mar 2020 16:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Wf1kZg8JHvWKhlG2DR9z0kO5EKLkK+UvZOrDdO+UlSQ=;
        b=UOn1+ESPUV9oo0HgXMYrjUDp5fQvsSgvVyEOSIn8IYIEzNFGa3Tl9/HAq93xUNrLLK
         KXIevfdgBsuxTLEuGZtNewguc7mtpwxbWbvK4lso/awa/nlQPUjcpficPFTvKEu8K0OX
         mEIse8bYmT5+rOr5RbcI96QWPOqp0I/ud/FN+9rakoieMVEhrfBezd1U0UYstF/WL949
         2GX1SdYFdVULK9IzBNIK7lb9scdD6M2R/PTu2bT6O0HN2hSVsUaZKT3kpfKHiHaZRNKN
         wE8TLeEnrKNhgCuqKlgtd6oyB2bPvp0pi1tln/kyKb4mE0UwADbPrG5fCxTLr1d1Qk6Q
         lhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Wf1kZg8JHvWKhlG2DR9z0kO5EKLkK+UvZOrDdO+UlSQ=;
        b=CcX0477k2hs7Ipx3tyGPVEKjB40jdzt8ODA2OSN/mUGGdW4dh7tuaQQDHugc3GZQ1s
         10kA2qWQyBcvqTzh5SWczBhVVSta3Qzw5y7Gga8Nn/Gl/wP9Wwk3CJKjvr77kPf+xb2r
         KkJmfKGYsllULOQlDK3lHt8kUEqKgd/x251/6yOG/JGAGOGL4YBfk3BcmPS3m+AgXJ8j
         MTpaX6yV0kVSbp8WdjoT+D3cqbeDTDO5ZOYRm0CyeNrmPhhDadVPUFFzxVvYeMYtSoM8
         Y5rm6p5g9tRrwcjC+vt/Wud2IxobSC9nVeFXJTWYA0SZ2BrP+59QTnVid9HiMEVh2vQO
         2Hiw==
X-Gm-Message-State: ANhLgQ0do4hrODhpC8SVC0B7At5ytiat6hMMuOMG3Fes918KM0O79s8F
        wMCtGCdenAxTx34RUzqByE0l4WD6bmT814VXJWw79D/G
X-Google-Smtp-Source: ADFU+vs55TzVS4OS7NrxkGuoLBBUeweGw0Z2M6iyPGNNTinjzfdvo/CtOZ6ggrYie7eV8n9Cdgtswjr9b+2BB9D7T7Q=
X-Received: by 2002:a25:f20f:: with SMTP id i15mr30636068ybe.364.1584313633297;
 Sun, 15 Mar 2020 16:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms_oxqwHm56nzabM-x2XMR1Ni-WD1_LEYYxOW_NkswsOQ@mail.gmail.com>
In-Reply-To: <CAH2r5ms_oxqwHm56nzabM-x2XMR1Ni-WD1_LEYYxOW_NkswsOQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 15 Mar 2020 18:07:02 -0500
Message-ID: <CAH2r5mvN5ri_7x3dVah8tUft6Xxbjia9MSANZV04TkVwtqY9Tw@mail.gmail.com>
Subject: Re: [SMB3] New compression flags
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000005376cf05a0ecc32b"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005376cf05a0ecc32b
Content-Type: text/plain; charset="UTF-8"

And one more small set of structures for the updated transform header.
See MS-SMB2 2.2.42.1 and 2.2.42.2


On Sun, Mar 15, 2020 at 5:50 PM Steve French <smfrench@gmail.com> wrote:
>
> Some compression related flags I noticed were added in the latest MS-SMB2
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

--0000000000005376cf05a0ecc32b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Additional-compression-structures.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Additional-compression-structures.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k7tnf80b0>
X-Attachment-Id: f_k7tnf80b0

RnJvbSBlZWI2NzJmYzVlMGVjMDdkMzU1YTBkNzgyYTIwZjljZDI4ZjM0YmU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMTUgTWFyIDIwMjAgMTg6MDQ6MTMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBBZGRpdGlvbmFsIGNvbXByZXNzaW9uIHN0cnVjdHVyZXMKCk5ldyB0cmFuc2Zvcm0gaGVh
ZGVyIHN0cnVjdHVyZXMuIFNlZSByZWNlbnQgdXBkYXRlcwp0byBNUy1TTUIyIGFkZGluZyBzZWN0
aW9uIDIuMi40Mi4xIGFuZCAyLjIuNDIuMgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5oIHwgMTcgKysrKysr
KysrKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUuaApp
bmRleCA0YTdkMTU0ZmZmYWUuLjhiOGZiYmM0NjRjNyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIy
cGR1LmgKKysrIGIvZnMvY2lmcy9zbWIycGR1LmgKQEAgLTEzNyw2ICsxMzcsMjEgQEAgc3RydWN0
IHNtYjJfdHJhbnNmb3JtX2hkciB7CiAJX191NjQgIFNlc3Npb25JZDsKIH0gX19wYWNrZWQ7CiAK
Ky8qIFNlZSBNUy1TTUIyIDIuMi40Mi4xICovCitzdHJ1Y3QgY29tcHJlc3Npb25fcGxheWxvYWRf
aGVhZGVyIHsKKwlfX2xlMTYJQWxnb3JpdGhtSWQ7CisJX19sZTE2CVJlc2VydmVkOworCV9fbGUz
MglMZW5ndGg7Cit9IF9fcGFja2VkOworCisvKiBTZWUgTVMtU01CMiAyLjIuNDIuMiAqLworc3Ry
dWN0IGNvbXByZXNzaW9uX3BhdHRlcm5fcGF5bG9hZF92MSB7CisJX19sZTE2CVBhdHRlcm47CisJ
X19sZTE2CVJlc2VydmVkMTsKKwlfX2xlMTYJUmVzZXJ2ZWQyOworCV9fbGUzMglSZXBpdGl0aW9u
czsKK30gX19wYWNrZWQ7CisKIC8qCiAgKglTTUIyIGZsYWcgZGVmaW5pdGlvbnMKICAqLwpAQCAt
MTE4Niw3ICsxMjAxLDcgQEAgc3RydWN0IHNtYjJfd3JpdGVfcmVxIHsKIAlfX2xlNjQgT2Zmc2V0
OwogCV9fdTY0ICBQZXJzaXN0ZW50RmlsZUlkOyAvKiBvcGFxdWUgZW5kaWFubmVzcyAqLwogCV9f
dTY0ICBWb2xhdGlsZUZpbGVJZDsgLyogb3BhcXVlIGVuZGlhbm5lc3MgKi8KLQlfX2xlMzIgQ2hh
bm5lbDsgLyogUmVzZXJ2ZWQgTUJaICovCisJX19sZTMyIENoYW5uZWw7IC8qIE1CWiB1bmxlc3Mg
U01CMy4wMiBvciBsYXRlciAqLwogCV9fbGUzMiBSZW1haW5pbmdCeXRlczsKIAlfX2xlMTYgV3Jp
dGVDaGFubmVsSW5mb09mZnNldDsKIAlfX2xlMTYgV3JpdGVDaGFubmVsSW5mb0xlbmd0aDsKLS0g
CjIuMjAuMQoK
--0000000000005376cf05a0ecc32b--
