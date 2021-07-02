Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D74DC07E95
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 23:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D914C61410
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 23:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhGBXlH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Jul 2021 19:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhGBXlH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Jul 2021 19:41:07 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA926C061762
        for <linux-cifs@vger.kernel.org>; Fri,  2 Jul 2021 16:38:33 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id k10so20878632lfv.13
        for <linux-cifs@vger.kernel.org>; Fri, 02 Jul 2021 16:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YS37Pl0EQPVtetT3mASJPuyFomXppAVJcrXPXQiC0yM=;
        b=R3yk0IY4/ORnFpIN2pAdQxF0+ADVoKpjiLQLWhJ/w7l78Fm58BSShJcK8hPsQCu0VJ
         Bv8cPZv+AW+/w6CdMhPE8huKyjTI0EzITNutWvdj+mxzElA7MnXpYP+RaOsFHVLbgiiN
         0t9Wie4JNkfzeuqN5fQxMasX07GCZAwvaRZgIWL46GdXNfFY2459RK55RbQP2HmEj5SJ
         3x+5d1uz5WhPLbmG7tGPD/aL5p7kHH5NEMwb1WC9uoUVQnpfezw4BtVMZ6pTTECvrSZ2
         kUF8atJJsaAK9KU+omEKLu9juR5MoJZGZVDfEBqBGE+uCcdoi61dhnb4A6rty1SEyrn+
         aFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YS37Pl0EQPVtetT3mASJPuyFomXppAVJcrXPXQiC0yM=;
        b=nn5nJRZtq2JTyxfyPz4YVmGSR6U1sm2c97Vm7Fie+mRRZ77jbBvmPh0uqnLN0g16r1
         5PwHC5xWsx79tO0EQoEUE4mRospnEoMdZE1FpehtpLMIN7dQVEWHXRwPYDRolGX4r751
         o/oLL0MQhLn0OV7tNmo3m8FiUbHTQPmtdoJ5BMTaQPyUy57rzpqMzp3ftHK3vl/OVyGv
         WsGTvPHfF5e2HCEPxYgAuh2Qw5Qwb1qRd0qHiTUR68sazlu7H08DsW1XC6prRDl9/8QL
         Eya+dQWAb4xRnR975JNpPCsHjyliu8tox07x0h5wczIaDQ1eKE8I9MiqHfcm+rhmiwQE
         j3Og==
X-Gm-Message-State: AOAM532AhqTdS+48YMjJw45RRLfnmI8c1LsUtNON65xuIdXEI5iTLbv5
        fBw/Q/rtwcTHfDTh2x2XogwVqnhRa/8zmz7Nwxc=
X-Google-Smtp-Source: ABdhPJxpwymjPcYTkFUehlRbuWFZRqi95jjx4rCJFue9CLHqgHf2niKoik0RCT9j/v6QejjJ+ljJqg3rLLsiaquKgsU=
X-Received: by 2002:ac2:546b:: with SMTP id e11mr1577680lfn.282.1625269111873;
 Fri, 02 Jul 2021 16:38:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muOpGHkvPyxJy_Qbp7gLC4ssL4eBOcY59U9+7KAjFHzcQ@mail.gmail.com>
 <87o8blou30.fsf@suse.com> <CAH2r5muiCHsa1bXZZPcP825phsS=djYWqBmpKPBYHF0JVNhCxQ@mail.gmail.com>
In-Reply-To: <CAH2r5muiCHsa1bXZZPcP825phsS=djYWqBmpKPBYHF0JVNhCxQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 2 Jul 2021 18:38:19 -0500
Message-ID: <CAH2r5mv==-jHDeoLfrHPv=7CQC=dzmgvLHyPT8FpnNkm1==KmQ@mail.gmail.com>
Subject: Re: [PATCH][CIFS] make locking consistent around the server session status
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000013f6c205c62c7425"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000013f6c205c62c7425
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

lightly updated with Paulo's suggestion.

On Fri, Jul 2, 2021 at 11:39 AM Steve French <smfrench@gmail.com> wrote:
>
> I removed the chunk you noted - whether it is worth updating the other
> 50+ where we check, not sure it is worth doing that if Coverity
> doesn't complain and it isn't an issue in practice why change the
> other 50 (if on the other hand there is much risk then it would be
> worth making the bigger change)?
>
> Many of the checks are like:
>
> if (tcon->ses->server->tcpStatus !=3D CifsExiting)
> or
> if (server->tcpStatus =3D=3D CifsNeedReconnect)
> or
> if ((server->tcpStatus =3D=3D CifsGood)...
>
> so they are unlikely to be a problem if we end up with an unknown
> value briefly while a read overlaps an update to tcpStatus
>
> If you are in favor of the bigger change I am ok with it - but my goal
> in this was more to "remove distracting coverity messages" so we can
> spot the dangerous ones more quickly (it has spotted a few serious
> problems this year so it is worth checking - but the old warnings were
> distracting)
>
>
> > @@ -1358,7 +1358,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
> >   * to the struct since the kernel thread not created yet
> >   * no need to spinlock this init of tcpStatus or srv_count
> >   */
> > + spin_lock(&GlobalMid_Lock);
> >   tcp_ses->tcpStatus =3D CifsNew;
> > + spin_unlock(&GlobalMid_Lock);
> >   ++tcp_ses->srv_count;
>
> On Fri, Jul 2, 2021 at 6:04 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> > Steve French <smfrench@gmail.com> writes:
> > > There were three places where we were not taking the spinlock
> > > around updates to server->tcpStatus when it was being modified.
> > > To be consistent (also removes Coverity warning) and to remove
> > > possibility of race best to lock all places where it is updated.
> >
> > If we lock for writing we also need to lock for reading otherwise the
> > locking isn't protecting anything.
> > > --- a/fs/cifs/connect.c
> > > +++ b/fs/cifs/connect.c
> > > @@ -1358,7 +1358,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ct=
x)
> > >   * to the struct since the kernel thread not created yet
> > >   * no need to spinlock this init of tcpStatus or srv_count
> >
> >     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > There is comment just on top saying no need to spinlock.
> >
> > >   */
> > > + spin_lock(&GlobalMid_Lock);
> > >   tcp_ses->tcpStatus =3D CifsNew;
> > > + spin_unlock(&GlobalMid_Lock);
> > >   ++tcp_ses->srv_count;
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--00000000000013f6c205c62c7425
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-make-locking-consistent-around-the-server-sessi.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-make-locking-consistent-around-the-server-sessi.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqmz9a070>
X-Attachment-Id: f_kqmz9a070

RnJvbSAwMWNmMzA4MjVjODcyOTg4NDA5MDE1MWFiOTdmMWM5YzVkMTRhOGJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMSBKdWwgMjAyMSAxMjoyMjo0NyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IG1ha2UgbG9ja2luZyBjb25zaXN0ZW50IGFyb3VuZCB0aGUgc2VydmVyIHNlc3Npb24KIHN0
YXR1cwoKVGhlcmUgd2VyZSB0aHJlZSBwbGFjZXMgd2hlcmUgd2Ugd2VyZSBub3QgdGFraW5nIHRo
ZSBzcGlubG9jawphcm91bmQgdXBkYXRlcyB0byBzZXJ2ZXItPnRjcFN0YXR1cyB3aGVuIGl0IHdh
cyBiZWluZyBtb2RpZmllZC4KVG8gYmUgY29uc2lzdGVudCAoYWxzbyByZW1vdmVzIENvdmVyaXR5
IHdhcm5pbmcpIGFuZCB0byByZW1vdmUKcG9zc2liaWxpdHkgb2YgcmFjZSBiZXN0IHRvIGxvY2sg
YWxsIHBsYWNlcyB3aGVyZSBpdCBpcyB1cGRhdGVkLgpUd28gb2YgdGhlIHRocmVlIHdlcmUgaW4g
aW5pdGlhbGl6YXRpb24gb2YgdGhlIGZpZWxkIGFuZCBjYW4ndApyYWNlIC0gYnV0IGFkZGVkIGxv
Y2sgYXJvdW5kIHRoZSBvdGhlci4KCkFkZHJlc3Nlcy1Db3Zlcml0eTogMTM5OTUxMiAoIkRhdGEg
cmFjZSBjb25kaXRpb24iKQpSZXZpZXdlZC1ieTogUGF1bG8gQWxjYW50YXJhIChTVVNFKSA8cGNA
Y2pyLm56PgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oICB8IDMgKystCiBmcy9jaWZzL2Nvbm5lY3QuYyAg
IHwgNSArKysrKwogZnMvY2lmcy90cmFuc3BvcnQuYyB8IDIgKysKIDMgZmlsZXMgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZz
Z2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IDMxMDBmOGI2NmU2MC4uOTIxNjgwZmI3
OTMxIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xv
Yi5oCkBAIC01NzcsNiArNTc3LDcgQEAgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyB7CiAJY2hhciBz
ZXJ2ZXJfUkZDMTAwMV9uYW1lW1JGQzEwMDFfTkFNRV9MRU5fV0lUSF9OVUxMXTsKIAlzdHJ1Y3Qg
c21iX3ZlcnNpb25fb3BlcmF0aW9ucwkqb3BzOwogCXN0cnVjdCBzbWJfdmVyc2lvbl92YWx1ZXMJ
KnZhbHM7CisJLyogdXBkYXRlcyB0byB0Y3BTdGF0dXMgcHJvdGVjdGVkIGJ5IEdsb2JhbE1pZF9M
b2NrICovCiAJZW51bSBzdGF0dXNFbnVtIHRjcFN0YXR1czsgLyogd2hhdCB3ZSB0aGluayB0aGUg
c3RhdHVzIGlzICovCiAJY2hhciAqaG9zdG5hbWU7IC8qIGhvc3RuYW1lIHBvcnRpb24gb2YgVU5D
IHN0cmluZyAqLwogCXN0cnVjdCBzb2NrZXQgKnNzb2NrZXQ7CkBAIC0xNzg1LDcgKzE3ODYsNyBA
QCByZXF1aXJlIHVzZSBvZiB0aGUgc3Ryb25nZXIgcHJvdG9jb2wgKi8KICAqCWxpc3Qgb3BlcmF0
aW9ucyBvbiBwZW5kaW5nX21pZF9xIGFuZCBvcGxvY2tRCiAgKiAgICAgIHVwZGF0ZXMgdG8gWElE
IGNvdW50ZXJzLCBtdWx0aXBsZXggaWQgIGFuZCBTTUIgc2VxdWVuY2UgbnVtYmVycwogICogICAg
ICBsaXN0IG9wZXJhdGlvbnMgb24gZ2xvYmFsIERub3RpZnlSZXFMaXN0Ci0gKiAgICAgIHVwZGF0
ZXMgdG8gc2VzLT5zdGF0dXMKKyAqICAgICAgdXBkYXRlcyB0byBzZXMtPnN0YXR1cyBhbmQgVENQ
X1NlcnZlcl9JbmZvLT50Y3BTdGF0dXMKICAqICAgICAgdXBkYXRlcyB0byBzZXJ2ZXItPkN1cnJl
bnRNaWQKICAqICB0Y3Bfc2VzX2xvY2sgcHJvdGVjdHM6CiAgKglsaXN0IG9wZXJhdGlvbnMgb24g
dGNwIGFuZCBTTUIgc2Vzc2lvbiBsaXN0cwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMg
Yi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCA1ZDI2OWY1ODNkYWMuLjAxZGM0NTE3OGY2NiAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTE0
MDMsNiArMTQwMywxMSBAQCBjaWZzX2dldF90Y3Bfc2Vzc2lvbihzdHJ1Y3Qgc21iM19mc19jb250
ZXh0ICpjdHgpCiAJCWdvdG8gb3V0X2Vycl9jcnlwdG9fcmVsZWFzZTsKIAl9CiAJdGNwX3Nlcy0+
bWluX29mZmxvYWQgPSBjdHgtPm1pbl9vZmZsb2FkOworCS8qCisJICogYXQgdGhpcyBwb2ludCB3
ZSBhcmUgdGhlIG9ubHkgb25lcyB3aXRoIHRoZSBwb2ludGVyCisJICogdG8gdGhlIHN0cnVjdCBz
aW5jZSB0aGUga2VybmVsIHRocmVhZCBub3QgY3JlYXRlZCB5ZXQKKwkgKiBubyBuZWVkIHRvIHNw
aW5sb2NrIHRoaXMgdXBkYXRlIG9mIHRjcFN0YXR1cworCSAqLwogCXRjcF9zZXMtPnRjcFN0YXR1
cyA9IENpZnNOZWVkTmVnb3RpYXRlOwogCiAJaWYgKChjdHgtPm1heF9jcmVkaXRzIDwgMjApIHx8
IChjdHgtPm1heF9jcmVkaXRzID4gNjAwMDApKQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy90cmFuc3Bv
cnQuYyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMKaW5kZXggZjY1ZjlhNjkyY2EyLi43NWE5NWRlMzIw
Y2YgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhbnNwb3J0LmMKKysrIGIvZnMvY2lmcy90cmFuc3Bv
cnQuYwpAQCAtNDMxLDcgKzQzMSw5IEBAIF9fc21iX3NlbmRfcnFzdChzdHJ1Y3QgVENQX1NlcnZl
cl9JbmZvICpzZXJ2ZXIsIGludCBudW1fcnFzdCwKIAkJICogYmUgdGFrZW4gYXMgdGhlIHJlbWFp
bmRlciBvZiB0aGlzIG9uZS4gV2UgbmVlZCB0byBraWxsIHRoZQogCQkgKiBzb2NrZXQgc28gdGhl
IHNlcnZlciB0aHJvd3MgYXdheSB0aGUgcGFydGlhbCBTTUIKIAkJICovCisJCXNwaW5fbG9jaygm
R2xvYmFsTWlkX0xvY2spOwogCQlzZXJ2ZXItPnRjcFN0YXR1cyA9IENpZnNOZWVkUmVjb25uZWN0
OworCQlzcGluX3VubG9jaygmR2xvYmFsTWlkX0xvY2spOwogCQl0cmFjZV9zbWIzX3BhcnRpYWxf
c2VuZF9yZWNvbm5lY3Qoc2VydmVyLT5DdXJyZW50TWlkLAogCQkJCQkJICBzZXJ2ZXItPmNvbm5f
aWQsIHNlcnZlci0+aG9zdG5hbWUpOwogCX0KLS0gCjIuMzAuMgoK
--00000000000013f6c205c62c7425--
