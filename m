Return-Path: <SRS0=frs6=XI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4925C49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 21:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9445F20692
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 21:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbGH3hIM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390012AbfIMVwN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Sep 2019 17:52:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46527 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389992AbfIMVwN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Sep 2019 17:52:13 -0400
Received: by mail-io1-f67.google.com with SMTP id d17so43945381ios.13
        for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2019 14:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQXCij7p1IOwTylOihi+RbfbQJGFM7gV75fK8wdtcXQ=;
        b=WbGH3hIMsfDu5tdg1m4X92DF/CO84QQZVYbEmF7fSByah7d39ZASmEXtoS0oNbCTcy
         L8bXZEIqp+tbYkEM8AoeOAbVl4rIyxP4iUjuLW5RDHQgVq3AIlLEMGXhqw7f3YRqeUmd
         Z/xgHBy5wByoWTifTdtedc2zo6+9uuYIdAlO+R9+1h1U7l/rtK0BBjYrDQA31jb0Jg+G
         LZh1lYRIkgizBtjJ6DJGXrq6jNKxCUHGpVcVEO2hn/z3W19bEIuLfnsGAjN0uU/J5Hue
         HOvt9Y17Dehwp68k9sBlCMJjIm9rIsmx+N1Yg0wRL11C5pNPDsXpkzJWWDOXctj8OObF
         2YYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQXCij7p1IOwTylOihi+RbfbQJGFM7gV75fK8wdtcXQ=;
        b=eYc2e7cXL3Beptnzto3g/oAGkvIUc508aMdB8FLtXLF+uTH6T2XAaHOVAVBPjhq6kV
         a66Ywps4pL/BWnI08DJqIfnWP6UBxJncBZRVjntAmGgzHmaguPedrW2OUHh39ux7uGst
         hxgm+4hJ9tjYPoJivoEr3KJPU8aGJJEHGZw/6s//gV/S4kyPgJ5nqZdPs9SM4vg/U64l
         ZCPcwJctJMEnkQcwL+9yl5Jv7x7xPyVl8noewDI/RzVQqiVFCMElU74l0NTQB45+ZOcT
         OiDYzj6zcA9iJEfhFzrDgn9hgTCP4I94HOrJLx3t21P0O7xziGfe7iSPFEdkvuBik9cf
         kuRg==
X-Gm-Message-State: APjAAAUf/bmQIf4D7bGIqXdQGUFj9NJwizOPvzS5zQ3oQRgrasB5X5NT
        ulMAx6s2pDybbmXJocboL9MUQ1ARjo4yc30cZKo=
X-Google-Smtp-Source: APXvYqy3NoeI4WCIM8NJ7L90lX4Az/h7QHPNASX58paoVITibHgY+5jdjtJHi4/Iv3ZCKEHj/0jQLbrjknlpRwuDGds=
X-Received: by 2002:a02:3786:: with SMTP id r128mr24282578jar.76.1568411531726;
 Fri, 13 Sep 2019 14:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190913134634.GR20699@kadam> <CAKywueTGT9=G-uYAdK8VY4P2a4TC8PsOKfz78n8tc0rngMWc7Q@mail.gmail.com>
In-Reply-To: <CAKywueTGT9=G-uYAdK8VY4P2a4TC8PsOKfz78n8tc0rngMWc7Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 13 Sep 2019 16:52:00 -0500
Message-ID: <CAH2r5mtahgXfrKA2hyiDWBm9wVOh-QUv+Y=9Bn6s95zYxm6x8Q@mail.gmail.com>
Subject: Re: [cifs:for-next 24/31] fs/cifs/smb2ops.c:4056 smb2_decrypt_offload()
 error: we previously assumed 'mid' could be null (see line 4045)
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>, kbuild@01.org,
        kbuild-all@01.org, Steve French <stfrench@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000035f1660592764452"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000035f1660592764452
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fix attached.  Tentatively merged into cifs-2.6.git for-next pending
review and the usual "buildbot" automated regression testing

On Fri, Sep 13, 2019 at 12:09 PM Pavel Shilovsky via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Yes, this is a bug.
>
> Steve, let's move
>
> +       mid->callback(mid);
> +
> +       cifs_mid_q_entry_release(mid);
>
> under ELSE {} block above.
>
> We should probably move
>
> +       dw->server->lstrp =3D jiffies;
>
> before we looking for a mid.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D1=82, 13 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 06:47, Dan=
 Carpenter <dan.carpenter@oracle.com>:
> >
> > tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> > head:   5fc321fb644fc787710353be11129edadd313f3a
> > commit: a091c5f67c994d154e8faf95ab774644be2f4dd7 [24/31] smb3: allow pa=
rallelizing decryption of reads
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >
> > New smatch warnings:
> > fs/cifs/smb2ops.c:4056 smb2_decrypt_offload() error: we previously assu=
med 'mid' could be null (see line 4045)
> >
> > git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
> > git remote update cifs
> > git checkout a091c5f67c994d154e8faf95ab774644be2f4dd7
> > vim +/mid +4056 fs/cifs/smb2ops.c
> >
> > a091c5f67c994d Steve French 2019-09-07  4030  static void smb2_decrypt_=
offload(struct work_struct *work)
> > a091c5f67c994d Steve French 2019-09-07  4031  {
> > a091c5f67c994d Steve French 2019-09-07  4032    struct smb2_decrypt_wor=
k *dw =3D container_of(work,
> > a091c5f67c994d Steve French 2019-09-07  4033                           =
 struct smb2_decrypt_work, decrypt);
> > a091c5f67c994d Steve French 2019-09-07  4034    int i, rc;
> > a091c5f67c994d Steve French 2019-09-07  4035    struct mid_q_entry *mid=
;
> > a091c5f67c994d Steve French 2019-09-07  4036
> > a091c5f67c994d Steve French 2019-09-07  4037    rc =3D decrypt_raw_data=
(dw->server, dw->buf, dw->server->vals->read_rsp_size,
> > a091c5f67c994d Steve French 2019-09-07  4038                          d=
w->ppages, dw->npages, dw->len);
> > a091c5f67c994d Steve French 2019-09-07  4039    if (rc) {
> > a091c5f67c994d Steve French 2019-09-07  4040            cifs_dbg(VFS, "=
error decrypting rc=3D%d\n", rc);
> > a091c5f67c994d Steve French 2019-09-07  4041            goto free_pages=
;
> > a091c5f67c994d Steve French 2019-09-07  4042    }
> > a091c5f67c994d Steve French 2019-09-07  4043
> > a091c5f67c994d Steve French 2019-09-07  4044    mid =3D smb2_find_mid(d=
w->server, dw->buf);
> > a091c5f67c994d Steve French 2019-09-07 @4045    if (mid =3D=3D NULL)
> > a091c5f67c994d Steve French 2019-09-07  4046            cifs_dbg(FYI, "=
mid not found\n");
> >
> > Return here?
> >
> > a091c5f67c994d Steve French 2019-09-07  4047    else {
> > a091c5f67c994d Steve French 2019-09-07  4048            mid->decrypted =
=3D true;
> > a091c5f67c994d Steve French 2019-09-07  4049            rc =3D handle_r=
ead_data(dw->server, mid, dw->buf,
> > a091c5f67c994d Steve French 2019-09-07  4050                           =
       dw->server->vals->read_rsp_size,
> > a091c5f67c994d Steve French 2019-09-07  4051                           =
       dw->ppages, dw->npages, dw->len);
> > a091c5f67c994d Steve French 2019-09-07  4052    }
> > a091c5f67c994d Steve French 2019-09-07  4053
> > a091c5f67c994d Steve French 2019-09-07  4054    dw->server->lstrp =3D j=
iffies;
> > a091c5f67c994d Steve French 2019-09-07  4055
> > a091c5f67c994d Steve French 2019-09-07 @4056    mid->callback(mid);
> >                                                 ^^^^^^^^^^^^^
> > Potential NULL derference.
> >
> > a091c5f67c994d Steve French 2019-09-07  4057
> > a091c5f67c994d Steve French 2019-09-07  4058    cifs_mid_q_entry_releas=
e(mid);
> > a091c5f67c994d Steve French 2019-09-07  4059
> > a091c5f67c994d Steve French 2019-09-07  4060  free_pages:
> > a091c5f67c994d Steve French 2019-09-07  4061    for (i =3D dw->npages-1=
; i >=3D 0; i--)
> > a091c5f67c994d Steve French 2019-09-07  4062            put_page(dw->pp=
ages[i]);
> > a091c5f67c994d Steve French 2019-09-07  4063
> > a091c5f67c994d Steve French 2019-09-07  4064    kfree(dw->ppages);
> > a091c5f67c994d Steve French 2019-09-07  4065    cifs_small_buf_release(=
dw->buf);
> > a091c5f67c994d Steve French 2019-09-07  4066  }
> >
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology =
Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corpo=
ration
>


--=20
Thanks,

Steve

--00000000000035f1660592764452
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-potential-null-dereference-in-decrypt-offlo.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-potential-null-dereference-in-decrypt-offlo.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0inpdcv0>
X-Attachment-Id: f_k0inpdcv0

RnJvbSA5YjZlY2YzMjQ5OWIzMjI1OWVhMzA2ZmMzZTE1MGNlMjMzN2E4YjdiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTMgU2VwIDIwMTkgMTY6NDc6MzEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggcG90ZW50aWFsIG51bGwgZGVyZWZlcmVuY2UgaW4gZGVjcnlwdCBvZmZsb2FkCgpj
b21taXQgYTA5MWM1ZjY3Yzk5ICgic21iMzogYWxsb3cgcGFyYWxsZWxpemluZyBkZWNyeXB0aW9u
IG9mIHJlYWRzIikKaGFkIGEgcG90ZW50aWFsIG51bGwgZGVyZWZlcmVuY2UKClJlcG9ydGVkLWJ5
OiBrYnVpbGQgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4KUmVwb3J0ZWQtYnk6IERhbiBDYXJw
ZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4KU3VnZ2VzdGVkLWJ5OiBQYXZlbCBTaGls
b3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNo
IDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMm9wcy5jIHwgOSArKyst
LS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCA1
Nzc2ZDdiMGE5N2UuLmVhZWQxODA2MTMxNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMK
KysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTQwNTUsNiArNDA1NSw3IEBAIHN0YXRpYyB2b2lk
IHNtYjJfZGVjcnlwdF9vZmZsb2FkKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJZ290byBm
cmVlX3BhZ2VzOwogCX0KIAorCWR3LT5zZXJ2ZXItPmxzdHJwID0gamlmZmllczsKIAltaWQgPSBz
bWIyX2ZpbmRfbWlkKGR3LT5zZXJ2ZXIsIGR3LT5idWYpOwogCWlmIChtaWQgPT0gTlVMTCkKIAkJ
Y2lmc19kYmcoRllJLCAibWlkIG5vdCBmb3VuZFxuIik7CkBAIC00MDYzLDE0ICs0MDY0LDEwIEBA
IHN0YXRpYyB2b2lkIHNtYjJfZGVjcnlwdF9vZmZsb2FkKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykKIAkJcmMgPSBoYW5kbGVfcmVhZF9kYXRhKGR3LT5zZXJ2ZXIsIG1pZCwgZHctPmJ1ZiwKIAkJ
CQkgICAgICBkdy0+c2VydmVyLT52YWxzLT5yZWFkX3JzcF9zaXplLAogCQkJCSAgICAgIGR3LT5w
cGFnZXMsIGR3LT5ucGFnZXMsIGR3LT5sZW4pOworCQltaWQtPmNhbGxiYWNrKG1pZCk7CisJCWNp
ZnNfbWlkX3FfZW50cnlfcmVsZWFzZShtaWQpOwogCX0KIAotCWR3LT5zZXJ2ZXItPmxzdHJwID0g
amlmZmllczsKLQotCW1pZC0+Y2FsbGJhY2sobWlkKTsKLQotCWNpZnNfbWlkX3FfZW50cnlfcmVs
ZWFzZShtaWQpOwotCiBmcmVlX3BhZ2VzOgogCWZvciAoaSA9IGR3LT5ucGFnZXMtMTsgaSA+PSAw
OyBpLS0pCiAJCXB1dF9wYWdlKGR3LT5wcGFnZXNbaV0pOwotLSAKMi4yMC4xCgo=
--00000000000035f1660592764452--
