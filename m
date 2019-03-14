Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6D8C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA0612087C
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvXM+imU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfCNHEz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 03:04:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36748 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfCNHEz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 03:04:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id n22so3223527pfa.3;
        Thu, 14 Mar 2019 00:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GAnkE7uTGWOj/qtWamMd9e/0Ms9Nc3Bb4p1S+Xkzpi0=;
        b=DvXM+imU8fFVAkj1Qsizcp+eYaJAJBK27um/HlcezBR7wS0NSkvge6Sd/BXQ7d3kkO
         xhHZKDiw65qZFgnSapApofBdCUHAEejXMsUOiGSSfZx2p6aBV+mCmopn8UIveDj0kL4a
         l61+I5GhX83epXQvLW5GTOKGmKOdio5bK5vqX8sVroS511y/I1DzjIrzyBeQ2AVUNZcr
         GZmXsmsipSNWgUiGhKJKamuukq48Ir/kNr4L9gAGgCZCgQhwynxVgvmarXQE72+u8NHB
         MsPzvZhCAKDy+jUJBBJijDaaqa63yo6qyNgHKFSgxRVJ1XavYhljGOOpDgQdlw7Gq02J
         aTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GAnkE7uTGWOj/qtWamMd9e/0Ms9Nc3Bb4p1S+Xkzpi0=;
        b=DEYbrQuVjTkq+NKkgz+9JSwe3QHvZ76xOedgtL74z8+CEXool76cqnXOUzahOdtP1Y
         GjCQtSyjrQnqAWDYS00kWuKZLkOrifJJGkSwjTRQS5++gmHk9eFgL0PL6DRYq/hNR8XH
         KvTE4qyO/SMKBdjMH0gw2om1nnEII3p35tDmQpgQLkmU5OOlwFfJPiJlpG3Rz73y0iot
         fQDdR4xUkYTDACEOY++z1r0tPYeTAjs29tZ+0lFln/sShrNzP/3EAuy4pRFxG6Ir06YW
         x/HbH2dyKO0jXWieM8pwngIsSZtRwbXFX3Pvx6U5JVVXT6ni9bvImhym+ui3/22Cw5Vv
         C2JA==
X-Gm-Message-State: APjAAAUYZUMJfYfuMO4aOEurUb2YIRVgaut+re1NlkNGRy+8GpKcHLUG
        VtJekLfDvk6CLlvlTMl3MQu3kB1HgceF1FvrnsEEgA==
X-Google-Smtp-Source: APXvYqwFOj46Zi1mmsKQxNxInbmhNpACHMmnMDrh+vwaatDDpq4kRURSYcVamLIexCmKqN770iUxO/Iv4J0Hq3MhG+Q=
X-Received: by 2002:a17:902:1744:: with SMTP id i62mr49311619pli.24.1552547093941;
 Thu, 14 Mar 2019 00:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com> <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
In-Reply-To: <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Mar 2019 02:04:42 -0500
Message-ID: <CAH2r5msCs5ks3FUi_GhV2REsUR8t2h1=ybgLS6FyBEyka7Qb9g@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: remove unused status severity defines
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000000833b80584088a80"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000833b80584088a80
Content-Type: text/plain; charset="UTF-8"

updated it to fix the spelling mistake


On Thu, Mar 14, 2019 at 1:54 AM Steve French <smfrench@gmail.com> wrote:
>
> Since this file (smb2status.h) is intended to track the official
> protocol documentation (albeit smb2status.h probably needs to be
> updated), in this case the protocol document MS-ERREF.  I would prefer
> to keep it closer to MS-ERREF and leave definitions in even if unused
> (if nothing else it helps some of us when debugging to recognize what
> these errors on the wire mean).  There is a real danger that we have
> run into in the past that in removing some protocol definitions
> (flags, etc.) from the code or forgetting to update our headers to
> match newer versions of the protocol specifications, that  with future
> code changes we can forget to handle flags (for example) or misparse
> responses due to not realizing that there are additional flags that
> need to be parsed.
>
> On Thu, Mar 14, 2019 at 1:17 AM Sergey Senozhatsky
> <sergey.senozhatsky.work@gmail.com> wrote:
> >
> > STATUS_SEVERITY_* do not appear to be used by anyone, so
> > drop them. Besides, the name of __constant_cpu_to_le32()
> > is misspelled there: __constanst_cpu_to_le32().
> >
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> >  fs/cifs/smb2status.h | 5 -----
> >  1 file changed, 5 deletions(-)
> >
> > diff --git a/fs/cifs/smb2status.h b/fs/cifs/smb2status.h
> > index 3d5f62150de4..e9da9c6da277 100644
> > --- a/fs/cifs/smb2status.h
> > +++ b/fs/cifs/smb2status.h
> > @@ -29,11 +29,6 @@
> >   *  C is set if "customer defined" error, N bit is reserved and MBZ
> >   */
> >
> > -#define STATUS_SEVERITY_SUCCESS __constant_cpu_to_le32(0x0000)
> > -#define STATUS_SEVERITY_INFORMATIONAL __constanst_cpu_to_le32(0x0001)
> > -#define STATUS_SEVERITY_WARNING __constanst_cpu_to_le32(0x0002)
> > -#define STATUS_SEVERITY_ERROR __constanst_cpu_to_le32(0x0003)
> > -
> >  struct ntstatus {
> >         /* Facility is the high 12 bits of the following field */
> >         __le32 Facility; /* low 2 bits Severity, next is Customer, then rsrvd */
> > --
> > 2.21.0
> >
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000000833b80584088a80
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb2-fix-typo-in-definition-of-a-few-error-flags.patch"
Content-Disposition: attachment; 
	filename="0001-smb2-fix-typo-in-definition-of-a-few-error-flags.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt8ag0ku0>
X-Attachment-Id: f_jt8ag0ku0

RnJvbSBjMWQwNjFkMmQ0N2Q1MzZkNzY3NGExNjI5MzdiNTFkOGRkN2FjN2RjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTQgTWFyIDIwMTkgMDE6NTY6MzQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIyOiBmaXggdHlwbyBpbiBkZWZpbml0aW9uIG9mIGEgZmV3IGVycm9yIGZsYWdzCgpBcyBTZXJn
ZXkgU2Vub3poYXRza3kgcG9pbnRlZCBvdXQgX19jb25zdGFudF9jcHVfdG9fbGUzMigpCmlzIG1p
c3NwZWxsZWQgaW4gYSBmZXcgZGVmaW5pdGlvbnMgaW4gdGhlIGxpc3Qgb2Ygc3RhdHVzCmNvZGVz
IHNtYjJzdGF0dXMuaCBhcyBfX2NvbnN0YW5zdF9jcHVfdG9fbGUzMigpCgpTaWduZWQtb2ZmLWJ5
OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+CkNDOiBTZXJnZXkgU2Vub3po
YXRza3kgPHNlcmdleS5zZW5vemhhdHNreUBnbWFpbC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyc3Rh
dHVzLmggfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJzdGF0dXMuaCBiL2ZzL2NpZnMvc21i
MnN0YXR1cy5oCmluZGV4IDNkNWY2MjE1MGRlNC4uZjU0MjljOGJmYjBkIDEwMDY0NAotLS0gYS9m
cy9jaWZzL3NtYjJzdGF0dXMuaAorKysgYi9mcy9jaWZzL3NtYjJzdGF0dXMuaApAQCAtMzAsOSAr
MzAsOSBAQAogICovCiAKICNkZWZpbmUgU1RBVFVTX1NFVkVSSVRZX1NVQ0NFU1MgX19jb25zdGFu
dF9jcHVfdG9fbGUzMigweDAwMDApCi0jZGVmaW5lIFNUQVRVU19TRVZFUklUWV9JTkZPUk1BVElP
TkFMIF9fY29uc3RhbnN0X2NwdV90b19sZTMyKDB4MDAwMSkKLSNkZWZpbmUgU1RBVFVTX1NFVkVS
SVRZX1dBUk5JTkcgX19jb25zdGFuc3RfY3B1X3RvX2xlMzIoMHgwMDAyKQotI2RlZmluZSBTVEFU
VVNfU0VWRVJJVFlfRVJST1IgX19jb25zdGFuc3RfY3B1X3RvX2xlMzIoMHgwMDAzKQorI2RlZmlu
ZSBTVEFUVVNfU0VWRVJJVFlfSU5GT1JNQVRJT05BTCBjcHVfdG9fbGUzMigweDAwMDEpCisjZGVm
aW5lIFNUQVRVU19TRVZFUklUWV9XQVJOSU5HIGNwdV90b19sZTMyKDB4MDAwMikKKyNkZWZpbmUg
U1RBVFVTX1NFVkVSSVRZX0VSUk9SIGNwdV90b19sZTMyKDB4MDAwMykKIAogc3RydWN0IG50c3Rh
dHVzIHsKIAkvKiBGYWNpbGl0eSBpcyB0aGUgaGlnaCAxMiBiaXRzIG9mIHRoZSBmb2xsb3dpbmcg
ZmllbGQgKi8KLS0gCjIuMTcuMQoK
--0000000000000833b80584088a80--
