Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C50C43460
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Apr 2021 16:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66629613C6
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Apr 2021 16:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbhDEQGv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Apr 2021 12:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238755AbhDEQGv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Apr 2021 12:06:51 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D14C061756
        for <linux-cifs@vger.kernel.org>; Mon,  5 Apr 2021 09:06:44 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id l15so13044544ybm.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Apr 2021 09:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gWc2ApH2C5K/goah+1lEgLRoHZ9/ztXDS+seyeQlVSs=;
        b=Qa2OWxd4vvqGLE7SqVnbnfrZL/utUb3zCHSbv5Y8dzkOwsxrJYn77XXPUQ5+fCnTIV
         TKlOuXeArpN5FvTC9Hw/NFXIxjgRLO2RF3qZdbc2GKYTRzyD55qET5BQxxIk0oct62yD
         JusGtpA57jlEDMP6frTiMCbpXk+wPI28D+DscXo10PAgDPro+Fv+lezHVS3SjfjRtuHI
         DDhHsVAwsvKt3B4aOqeAs/245svjtx2mz7x+uooz1qR6J1IXqZ5wk+Mia/4/7gTydV16
         I00Vz25EphYKgjUIi/9GV80A2uaHWwPQ65PWTrBqhlVgmaXEChI/+JPkqJDpb52UmJIB
         42wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gWc2ApH2C5K/goah+1lEgLRoHZ9/ztXDS+seyeQlVSs=;
        b=Lx7FRPDOJ0ZD2qEXdKSYB+yVuMvN02dQaS+T97qTljOl1oHXv8gdrPl8GPQHlj7+5H
         bcAfo9dknxI7qGACBDoL/f03M/tDUyx3K/PD0yoNyfp6nRpo5nnYIYXTfXwutR6VZpkK
         OK6ZjLClpim6P2nVmQton0lB0tmnIe3QCAK18TlPuKan0FjrfBBo4i3X1PCTvr5ZiS2z
         pexaDkWBq0pMDCfg23wq0pGMR+HYQTnfbi4F2iO21sSB2iJ9Rry6SKJf5U2qJ7M5QDTB
         iyp/apY9PHA0GoScugj/Vx2beHd6E7jvITtGgw2vzj+23Bu2TposZq8hpUgZVSrMOczE
         Fcqw==
X-Gm-Message-State: AOAM530XxuucQDa9EKEfl2fby2XVJRanJePz6602HT1nniL1wMsByS9t
        D6f07TJtDnvri+PhpOjFP6JYms02UjcSMD+Fxw6VLL/I6bCZ+Q==
X-Google-Smtp-Source: ABdhPJy/TlQpByUU4GfFN8e4mMrErSgDNGtEetA9Z2jKPvdacCUE5w5Q3aQaGR/X2Dj2WEymkQNOYOV7FobbSClcwdw=
X-Received: by 2002:a25:3b4d:: with SMTP id i74mr36412345yba.3.1617638803897;
 Mon, 05 Apr 2021 09:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
 <87im50vi9v.fsf@cjr.nz>
In-Reply-To: <87im50vi9v.fsf@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 5 Apr 2021 21:36:33 +0530
Message-ID: <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000481f4f05bf3be27e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000481f4f05bf3be27e
Content-Type: text/plain; charset="UTF-8"

Hi Paulo,

Thanks for the quick review. And nice catch about CONFIG_CIFS_DFS_UPCALL.
Fixed it, added CC for stable.
Attached updated patch.

Regards,
Shyam

On Mon, Apr 5, 2021 at 9:24 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > Please consider the attached patch for performing the DNS query again
> > on reconnect.
> > This is important when connecting to Azure file shares. The UNC
> > generally contains the server name as a FQDN, and the IP address which
> > the name resolves to can change over time.
> >
> > After our last conversation about this, I discovered that for the
> > non-DFS scenario, we never do DNS resolutions in cifs.ko, since
> > mount.cifs already resolves the name and passes the "addr=" arg during
> > mount.
>
> Yeah, this should happen for both cases.  Good catch!
>
> > I noticed that you had a patch for this long back. But I don't see
> > that call happening in the latest code. Any idea why that was done?
>
> I don't know.  Maybe some other patch broke it.
>
> We should probably mark it for stable as well.
>
> > From 289f7f0fa229ea181094821c309a2ba9358791a3 Mon Sep 17 00:00:00 2001
> > From: Shyam Prasad N <sprasad@microsoft.com>
> > Date: Wed, 31 Mar 2021 14:35:24 +0000
> > Subject: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
> >
> > On cifs_reconnect, make sure that DNS resolution happens again.
> > It could be the cause of connection to go dead in the first place.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/cifs/connect.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
>
> This patch breaks when CONFIG_CIFS_DFS_UPCALL isn't set.
>
> Please declare reconn_set_ipaddr_from_hostname() outside the "#ifdef
> CONFIG_CIFS_DFS_UPCALL" in connect.c.
>
> Otherwise,
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Regards,
Shyam

--000000000000481f4f05bf3be27e
Content-Type: application/octet-stream; 
	name="0001-cifs-On-cifs_reconnect-resolve-the-hostname-again.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-On-cifs_reconnect-resolve-the-hostname-again.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kn4scz9k0>
X-Attachment-Id: f_kn4scz9k0

RnJvbSA0OWU4ZGY3MDdiNDQ2NGQ0N2RlYjZiZTczZDEyNTJiMDc3NWFiMDJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMxIE1hciAyMDIxIDE0OjM1OjI0ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogT24gY2lmc19yZWNvbm5lY3QsIHJlc29sdmUgdGhlIGhvc3RuYW1lIGFnYWluLgoKT24g
Y2lmc19yZWNvbm5lY3QsIG1ha2Ugc3VyZSB0aGF0IEROUyByZXNvbHV0aW9uIGhhcHBlbnMgYWdh
aW4uCkl0IGNvdWxkIGJlIHRoZSBjYXVzZSBvZiBjb25uZWN0aW9uIHRvIGdvIGRlYWQgaW4gdGhl
IGZpcnN0IHBsYWNlLgoKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWlj
cm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFBhdWxvIEFsY2FudGFyYSAoU1VTRSkgPHBjQGNqci5u
ej4KQ0M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwg
MTcgKysrKysrKysrKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nv
bm5lY3QuYwppbmRleCBlZWM4YTIwNTJkYTIuLjI0NjY4ZWIwMDZjNiAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTg3LDcgKzg3LDYgQEAg
c3RhdGljIHZvaWQgY2lmc19wcnVuZV90bGlua3Moc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsK
ICAqCiAgKiBUaGlzIHNob3VsZCBiZSBjYWxsZWQgd2l0aCBzZXJ2ZXItPnNydl9tdXRleCBoZWxk
LgogICovCi0jaWZkZWYgQ09ORklHX0NJRlNfREZTX1VQQ0FMTAogc3RhdGljIGludCByZWNvbm5f
c2V0X2lwYWRkcl9mcm9tX2hvc3RuYW1lKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikK
IHsKIAlpbnQgcmM7CkBAIC0xMjQsNiArMTIzLDcgQEAgc3RhdGljIGludCByZWNvbm5fc2V0X2lw
YWRkcl9mcm9tX2hvc3RuYW1lKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAlyZXR1
cm4gIXJjID8gLTEgOiAwOwogfQogCisjaWZkZWYgQ09ORklHX0NJRlNfREZTX1VQQ0FMTAogLyog
VGhlc2UgZnVuY3Rpb25zIG11c3QgYmUgY2FsbGVkIHdpdGggc2VydmVyLT5zcnZfbXV0ZXggaGVs
ZCAqLwogc3RhdGljIHZvaWQgcmVjb25uX3NldF9uZXh0X2Rmc190YXJnZXQoc3RydWN0IFRDUF9T
ZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQkJCSAgICAgICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZz
X3NiLApAQCAtMzIxLDE0ICszMjEsMjkgQEAgY2lmc19yZWNvbm5lY3Qoc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyKQogI2VuZGlmCiAKICNpZmRlZiBDT05GSUdfQ0lGU19ERlNfVVBDQUxM
CisJCWlmIChjaWZzX3NiICYmIGNpZnNfc2ItPm9yaWdpbl9mdWxscGF0aCkKIAkJCS8qCiAJCQkg
KiBTZXQgdXAgbmV4dCBERlMgdGFyZ2V0IHNlcnZlciAoaWYgYW55KSBmb3IgcmVjb25uZWN0LiBJ
ZiBERlMKIAkJCSAqIGZlYXR1cmUgaXMgZGlzYWJsZWQsIHRoZW4gd2Ugd2lsbCByZXRyeSBsYXN0
IHNlcnZlciB3ZQogCQkJICogY29ubmVjdGVkIHRvIGJlZm9yZS4KIAkJCSAqLwogCQkJcmVjb25u
X3NldF9uZXh0X2Rmc190YXJnZXQoc2VydmVyLCBjaWZzX3NiLCAmdGd0X2xpc3QsICZ0Z3RfaXQp
OworCQllbHNlIHsKKyNlbmRpZgorCQkJLyoKKwkJCSAqIFJlc29sdmUgdGhlIGhvc3RuYW1lIGFn
YWluIHRvIG1ha2Ugc3VyZSB0aGF0IElQIGFkZHJlc3MgaXMgdXAtdG8tZGF0ZS4KKwkJCSAqLwor
CQkJcmMgPSByZWNvbm5fc2V0X2lwYWRkcl9mcm9tX2hvc3RuYW1lKHNlcnZlcik7CisJCQlpZiAo
cmMpIHsKKwkJCQljaWZzX2RiZyhGWUksICIlczogZmFpbGVkIHRvIHJlc29sdmUgaG9zdG5hbWU6
ICVkXG4iLAorCQkJCQkJX19mdW5jX18sIHJjKTsKKwkJCX0KKworI2lmZGVmIENPTkZJR19DSUZT
X0RGU19VUENBTEwKKwkJfQogI2VuZGlmCiAKKwogI2lmZGVmIENPTkZJR19DSUZTX1NXTl9VUENB
TEwKIAkJfQogI2VuZGlmCi0tIAoyLjI1LjEKCg==
--000000000000481f4f05bf3be27e--
