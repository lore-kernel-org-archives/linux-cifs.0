Return-Path: <SRS0=UyrF=7M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D696CC433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 30 May 2020 22:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B1D206F0
	for <linux-cifs@archiver.kernel.org>; Sat, 30 May 2020 22:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gMoW8EnT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgE3WNv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 May 2020 18:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbgE3WNu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 May 2020 18:13:50 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6127C03E969
        for <linux-cifs@vger.kernel.org>; Sat, 30 May 2020 15:13:49 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y13so1001051ybj.10
        for <linux-cifs@vger.kernel.org>; Sat, 30 May 2020 15:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Xv8kKKg/z6tYKPlyvVwWQTDcY+FWSdDFJ4coDTSzcv0=;
        b=gMoW8EnTlwjDqxHwNw623mFHhPy3vZwdDJcf187l1jH47Zddp2KvSe00ZQRT+Lbaak
         xp5ePrWunc29uB+qJnLqEaZxnkGaWZW8dPgzhHTZJ4y8e0Xipwht/n1H1QDrgEF69HNl
         0HGVvBgIdxmoI2DFHiPLU/L4ARe5POg3wHxqR6wE8CppADsBJyv4/YJgIjhNQDupJXEq
         8YUvIw4mAwxqqxNfG6duN3KBTf65o1hVoUHnhVGNoRt0/GjkQeCQKt4X3IV1N3fRrHKN
         WCIKuqV8vfL4zSKjntEEeFPRHR5xVcBhCbseuZ8XGqyEfudLF9ViulJGqYW0rHxC/XoS
         GJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Xv8kKKg/z6tYKPlyvVwWQTDcY+FWSdDFJ4coDTSzcv0=;
        b=jAUBNqiTR81ugj/e9yjC8yRh488gJUbsaI4ipfKraDYhvtVayRNwrVbejhc6h4P+7o
         rqIUicnOpuszxAWztX7/E2/Mnj2NihGBWtMaXNdFwrt9Lw5aMUYlHbwNpCP2OW9brjND
         LVFIBrVPcKYig33CSz6z7dgMPBekvtanGhio1a1UgIUVyXCMJtiTOKaVLb3f+QhcGZu+
         yJOedOH4XZ1FOsW1/323Sk8VxkRghHSMUp1soF+Yoy3fTvUUW7JBGj4z8FPvmvRq5G1b
         zVc2Ijkp/bJzSquEMg2voc+sVaZ6oUw1frWSCK+p6En/H0n+2QjP2yaxY9HcjDwyFeIc
         bkJw==
X-Gm-Message-State: AOAM5332ZGm7Anlc+UX6pWdPLmPi0tXiBZkXdSfLqUpPWg8chvqoc1D6
        X7skl6SJ0N9deBp6vKLbQ+2h5ZbqgFsvjryc7EC+rNnNCYQ=
X-Google-Smtp-Source: ABdhPJxWkBFE7En1mDyCtp/NW13ukTw3z/JC07L55HgTHhJo3Vp4iBW1mn9kz3GtfAlcP9lofiHnJ2L5aghZg2+5XmI=
X-Received: by 2002:a25:6c6:: with SMTP id 189mr13036293ybg.375.1590876828739;
 Sat, 30 May 2020 15:13:48 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 30 May 2020 17:13:37 -0500
Message-ID: <CAH2r5muo=fPArSDa_8AEk0dT-3zA17N9HL7wCb=jP77RHQQQQQ@mail.gmail.com>
Subject: [PATCH][smb3] minor update to compression header definitions
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="00000000000042446805a6e4e042"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000042446805a6e4e042
Content-Type: text/plain; charset="UTF-8"

MS-SMB2 specification was updated in March.  Make minor additions
    and corrections to compression related definitions in smb2pdu.h

-- 
Thanks,

Steve

--00000000000042446805a6e4e042
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-minor-update-to-compression-header-definitions.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-minor-update-to-compression-header-definitions.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kau6z5wn0>
X-Attachment-Id: f_kau6z5wn0

RnJvbSBiNzk5ZjhmZDcyYmI0OTE5MjgwYmFiOTg4ZjllNWU5YzljYzdiMjFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMzAgTWF5IDIwMjAgMTc6MTA6MTYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBtaW5vciB1cGRhdGUgdG8gY29tcHJlc3Npb24gaGVhZGVyIGRlZmluaXRpb25zCgpNUy1T
TUIyIHNwZWNpZmljYXRpb24gd2FzIHVwZGF0ZWQgaW4gTWFyY2guICBNYWtlIG1pbm9yIGFkZGl0
aW9ucwphbmQgY29ycmVjdGlvbnMgdG8gY29tcHJlc3Npb24gcmVsYXRlZCBkZWZpbml0aW9ucyBp
biBzbWIycGR1LmgKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9z
b2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJwZHUuaCB8IDEzICsrKysrKysrKysrLS0KIDEgZmls
ZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvc21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgKaW5kZXggMTBhY2Y5MGY4NThk
Li4zYjBlNmFjZjlkN2QgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5oCisrKyBiL2ZzL2Np
ZnMvc21iMnBkdS5oCkBAIC0xNDMsOCArMTQzLDE3IEBAIHN0cnVjdCBzbWIyX3RyYW5zZm9ybV9o
ZHIgewogCV9fdTY0ICBTZXNzaW9uSWQ7CiB9IF9fcGFja2VkOwogCisvKiBTZWUgTVMtU01CMiAy
LjIuNDIgKi8KK3N0cnVjdCBzbWIyX2NvbXByZXNzaW9uX3RyYW5zZm9ybV9oZHIgeworCV9fbGUz
MiBQcm90b2NvbElkOwkvKiAweEZDICdTJyAnTScgJ0InICovCisJX19sZTMyIE9yaWdpbmFsQ29t
cHJlc3NlZFNlZ21lbnRTaXplOworCV9fbGUxNiBDb21wcmVzc2lvbkFsZ29yaXRobTsKKwlfX2xl
MTYgRmxhZ3M7CisJX19sZTE2IExlbmd0aDsgLyogaWYgY2hhaW5lZCBpdCBpcyBsZW5ndGgsIGVs
c2Ugb2Zmc2V0ICovCit9IF9fcGFja2VkOworCiAvKiBTZWUgTVMtU01CMiAyLjIuNDIuMSAqLwot
c3RydWN0IGNvbXByZXNzaW9uX3BsYXlsb2FkX2hlYWRlciB7CitzdHJ1Y3QgY29tcHJlc3Npb25f
cGF5bG9hZF9oZWFkZXIgewogCV9fbGUxNglBbGdvcml0aG1JZDsKIAlfX2xlMTYJUmVzZXJ2ZWQ7
CiAJX19sZTMyCUxlbmd0aDsKQEAgLTMzMyw3ICszNDIsNyBAQCBzdHJ1Y3Qgc21iMl9lbmNyeXB0
aW9uX25lZ19jb250ZXh0IHsKICNkZWZpbmUgU01CM19DT01QUkVTU19MWjc3CWNwdV90b19sZTE2
KDB4MDAwMikKICNkZWZpbmUgU01CM19DT01QUkVTU19MWjc3X0hVRkYJY3B1X3RvX2xlMTYoMHgw
MDAzKQogLyogUGF0dGVybiBzY2FubmluZyBhbGdvcml0aG0gU2VlIE1TLVNNQjIgMy4xLjQuNC4x
ICovCi0jZGVmaW5lIFNNQjNfQ09NUFJFU1NfUEFUVEVSTgljcHVfdG9fbGUxNigweDAwMDQpCisj
ZGVmaW5lIFNNQjNfQ09NUFJFU1NfUEFUVEVSTgljcHVfdG9fbGUxNigweDAwMDQpIC8qIFBhdHRl
cm5fVjEgKi8KIAogLyogQ29tcHJlc3Npb24gRmxhZ3MgKi8KICNkZWZpbmUgU01CMl9DT01QUkVT
U0lPTl9DQVBBQklMSVRJRVNfRkxBR19OT05FCQljcHVfdG9fbGUzMigweDAwMDAwMDAwKQotLSAK
Mi4yNS4xCgo=
--00000000000042446805a6e4e042--
