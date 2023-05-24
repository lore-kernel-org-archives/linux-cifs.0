Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E07C77B7E
	for <linux-cifs@archiver.kernel.org>; Wed, 24 May 2023 01:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbjEXBvL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 21:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjEXBvK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 21:51:10 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CED613E
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 18:51:09 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2af189d323fso67292411fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 18:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684893067; x=1687485067;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2yIXC5tSOtGJKY1HQic9gxUeyS3jp5wM1as1E8eHN7U=;
        b=XLHN6qu584YoIdOPvlmbO4zsjKjsfmkH/EVeBjPi/QoKND8lGkE8HYq17c9/2Rhug3
         aJyXbnSc2jDfG2m/ZQNxcGrJ+UOPY/NJA8mdHASA3pDUNGGJv58Z35lX2EEHCr2iegHM
         Lxycfced9OLE3NHCFjOqnL58BatQ/gXde6kB2uqnlkjYjjha10UnEbTONCmDlQqdSYpt
         sithpaWz8dG5TKhdyS2D49CcpPUOWt2RMYwXg051XTqT3KM0nJrYqpdzCrwUR5gQ6eiv
         XNdvexpoi3miE7RA9greBXFurt0nWMZMuxqHgLciZV4g/gG/jVA7qDVtcgmTVuciHAeH
         zZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684893067; x=1687485067;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2yIXC5tSOtGJKY1HQic9gxUeyS3jp5wM1as1E8eHN7U=;
        b=HrvI+ActAKHY4YtIMurvf7RrWHPY/QcY7jvpbQjTWmWqfgu+VdiEEgOnXLpmoP2nZS
         VIy7pZuUYZ4dLQO/6T/1tcDuANQnzE+HpbV+S2BmRakXaam0T17RZAPmT/8kRpPX4ffL
         KQgeppUGfghBJh+wIseTLQZjZ6w4Usjo0XkoQzSlH4zs9+NCeGuqlCGHvKvkfODv9zZj
         ULB4/inT+IonbbKn3GmV3DzS0aq/ugSUPbrAMNKAPp4AkSfwyYipWZwcdGVQR3Q1s0Op
         HLEPijW+SsZbBj1ad4Ek10z9dI77z8dS+BrPzhq7JjmuVAf2GIKFp1uboAN5CWxS4ksq
         sadw==
X-Gm-Message-State: AC+VfDz/dNGTaEcdfMB0Ags1XDraFvm/oqScF7a/acKzBAADEck3T4TV
        HJr6spN8QkiOF7SBkFI5PFXN9fT3PDUQRZJd19I=
X-Google-Smtp-Source: ACHHUZ6v/VHf/SwoYXo0FBGQPrIeogNWBX+FPGJJ2tEQDKhG4oR8fzvs5o/fxJqYg2hZUNZxViSNmQthGXEvdp1Y8cc=
X-Received: by 2002:a2e:9c06:0:b0:2a9:ec7e:8f58 with SMTP id
 s6-20020a2e9c06000000b002a9ec7e8f58mr4970716lji.7.1684893067186; Tue, 23 May
 2023 18:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtuuGd-OR-Ran9XWDzv7pW=pv6xUBGZExE87+NrChsRoQ@mail.gmail.com>
 <CAN05THRgK3isCm49pA9gTOkfbZOabXeJ0c-X3oC-PdJUvg5XRg@mail.gmail.com>
In-Reply-To: <CAN05THRgK3isCm49pA9gTOkfbZOabXeJ0c-X3oC-PdJUvg5XRg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 May 2023 20:50:55 -0500
Message-ID: <CAH2r5muXNOg6jA99bY_W2GUNZp086PLwutvzBOV-8a9CtL19wA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] display debug information better for encryption
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c1340405fc66bcf7"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c1340405fc66bcf7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added trivial update to fix checkpatch warning about seq_puts vs. seq_print=
f

On Tue, May 23, 2023 at 8:44=E2=80=AFPM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> lgtm
>
> acked-by me
>
> On Wed, 24 May 2023 at 11:38, Steve French <smfrench@gmail.com> wrote:
> >
> > Fix /proc/fs/cifs/DebugData to use the same case for "encryption"
> > (ie "Encryption" with init capital letter was used in one place).
> > In addition, if gcm256 encryption (intead of gcm128) is used on
> > a connection to a server, note that in the DebugData as well.
> >
> > It now says (when gcm256 encryption negotiated):
> > Security type: RawNTLMSSP  SessionId: 0x86125800bc000b0d encrypted(gcm2=
56)
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve

--000000000000c1340405fc66bcf7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-display-debug-information-better-for-encryption.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-display-debug-information-better-for-encryption.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_li11tg0t0>
X-Attachment-Id: f_li11tg0t0

RnJvbSBiYTY4YjY4NTQ1YTUyN2FhZmQzYWQxYjFkNzU3OTAxZDc3NzJhYjZlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjMgTWF5IDIwMjMgMjA6MjU6NDcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkaXNwbGF5IGRlYnVnIGluZm9ybWF0aW9uIGJldHRlciBmb3IgZW5jcnlwdGlvbgoKRml4
IC9wcm9jL2ZzL2NpZnMvRGVidWdEYXRhIHRvIHVzZSB0aGUgc2FtZSBjYXNlIGZvciAiZW5jcnlw
dGlvbiIKKGllICJFbmNyeXB0aW9uIiB3aXRoIGluaXQgY2FwaXRhbCBsZXR0ZXIgd2FzIHVzZWQg
aW4gb25lIHBsYWNlKS4KSW4gYWRkaXRpb24sIGlmIGdjbTI1NiBlbmNyeXB0aW9uIChpbnRlYWQg
b2YgZ2NtMTI4KSBpcyB1c2VkIG9uCmEgY29ubmVjdGlvbiB0byBhIHNlcnZlciwgbm90ZSB0aGF0
IGluIHRoZSBEZWJ1Z0RhdGEgYXMgd2VsbC4KCkl0IG5vdyBkaXNwbGF5cyAod2hlbiBnY20yNTYg
bmVnb3RpYXRlZCk6CiBTZWN1cml0eSB0eXBlOiBSYXdOVExNU1NQICBTZXNzaW9uSWQ6IDB4ODYx
MjU4MDBiYzAwMGIwZCBlbmNyeXB0ZWQoZ2NtMjU2KQoKQWNrZWQtYnk6IFJvbm5pZSBTYWhsYmVy
ZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZy
ZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc19kZWJ1Zy5jIHwgOCArKysrKyst
LQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9mcy9jaWZzL2NpZnNfZGVidWcuYyBiL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jCmluZGV4
IGQ0ZWQyMDBhOTQ3MS4uNTAzNGI4NjJjZWMyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNfZGVi
dWcuYworKysgYi9mcy9jaWZzL2NpZnNfZGVidWcuYwpAQCAtMTA4LDcgKzEwOCw3IEBAIHN0YXRp
YyB2b2lkIGNpZnNfZGVidWdfdGNvbihzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24pCiAJaWYgKCh0Y29uLT5zZWFsKSB8fAogCSAgICAodGNvbi0+c2VzLT5zZXNzaW9u
X2ZsYWdzICYgU01CMl9TRVNTSU9OX0ZMQUdfRU5DUllQVF9EQVRBKSB8fAogCSAgICAodGNvbi0+
c2hhcmVfZmxhZ3MgJiBTSEkxMDA1X0ZMQUdTX0VOQ1JZUFRfREFUQSkpCi0JCXNlcV9wcmludGYo
bSwgIiBFbmNyeXB0ZWQiKTsKKwkJc2VxX3B1dHMobSwgIiBlbmNyeXB0ZWQiKTsKIAlpZiAodGNv
bi0+bm9jYXNlKQogCQlzZXFfcHJpbnRmKG0sICIgbm9jYXNlIik7CiAJaWYgKHRjb24tPnVuaXhf
ZXh0KQpAQCAtNDE1LDggKzQxNSwxMiBAQCBzdGF0aWMgaW50IGNpZnNfZGVidWdfZGF0YV9wcm9j
X3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2KQogCiAJCQkvKiBkdW1wIHNlc3Npb24g
aWQgaGVscGZ1bCBmb3IgdXNlIHdpdGggbmV0d29yayB0cmFjZSAqLwogCQkJc2VxX3ByaW50Ziht
LCAiIFNlc3Npb25JZDogMHglbGx4Iiwgc2VzLT5TdWlkKTsKLQkJCWlmIChzZXMtPnNlc3Npb25f
ZmxhZ3MgJiBTTUIyX1NFU1NJT05fRkxBR19FTkNSWVBUX0RBVEEpCisJCQlpZiAoc2VzLT5zZXNz
aW9uX2ZsYWdzICYgU01CMl9TRVNTSU9OX0ZMQUdfRU5DUllQVF9EQVRBKSB7CiAJCQkJc2VxX3B1
dHMobSwgIiBlbmNyeXB0ZWQiKTsKKwkJCQkvKiBjYW4gaGVscCBpbiBkZWJ1Z2dpbmcgdG8gc2hv
dyBlbmNyeXB0aW9uIHR5cGUgKi8KKwkJCQlpZiAoc2VydmVyLT5jaXBoZXJfdHlwZSA9PSBTTUIy
X0VOQ1JZUFRJT05fQUVTMjU2X0dDTSkKKwkJCQkJc2VxX3B1dHMobSwgIihnY20yNTYpIik7CisJ
CQl9CiAJCQlpZiAoc2VzLT5zaWduKQogCQkJCXNlcV9wdXRzKG0sICIgc2lnbmVkIik7CiAKLS0g
CjIuMzQuMQoK
--000000000000c1340405fc66bcf7--
