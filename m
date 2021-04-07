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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04105C433B4
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 17:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D173D6105A
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 17:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbhDGRoJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Apr 2021 13:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhDGRoI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Apr 2021 13:44:08 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B20C06175F
        for <linux-cifs@vger.kernel.org>; Wed,  7 Apr 2021 10:43:58 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id l9so6682373ybm.0
        for <linux-cifs@vger.kernel.org>; Wed, 07 Apr 2021 10:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VRfHZTHhPrifBbfGNhbTUl4gwIzGJP264eWnOWC3OPc=;
        b=cUt1K2GvoLaNdbm7JcUMYU9+ZbNwgcYOdltDhr49fGdj0Fyo1BwTqgushFMWikSHa5
         F33MID960dQDgIrdXfhT95cQpubTfHRxvVEklFsmnc1tXwzVr0/DOwoCVGI1u/HcOwaE
         ky2ZYkzESYMebQWSUBb2xHzBKse51nE1rdZKDdnEMRRLzxjLapsCojADbQv/B4DX4Ydj
         RpEEboo3g58G7vh8lI+nwxPxt5Iyn0tdwPWHY3e0269RB2ghgJSTOXPiYL0rCBT9SeH9
         D00vu0z2WV1rJpo6w+eKO9QzO5GZs4cd22dO7we7XjOm2DTj65qPJRtVwSyKu9pOMPWe
         gzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRfHZTHhPrifBbfGNhbTUl4gwIzGJP264eWnOWC3OPc=;
        b=YDf8OC2tpjYlCOsSeYBAxmtN82dAcGWqlt5xVP4vFx4Ptu8kNeMdEskMEgNsjXKsDf
         197re39C8vqgSAxOOsJzPP9OC3dRJqAc1i5KGgujJE1EL6/5Nke6syVb3t4tw3RLVSLf
         pM0wq+28DIFAVIpAa2JAkwC09zz4LA3jrmEaHAO4e5DmEL6QuZrvRdlc2+7wYOA4MUES
         t/1YKWcboMNfFAMK3Ebg8Nkv5paak/Jzm4hle1dB+rYUtVfAyKsR/QYey3Es+vz2hWcY
         CrJz5GlaxLcIaJlsD4DhZEKmkfml56bnYOBPasQnOq1hABr45Sq5G/uCi5tp6WarJKIk
         g1LQ==
X-Gm-Message-State: AOAM53357cfPcuhsTEV8zvEyIkRN7vvWVt7gWoq/35Nr6SzMielh7jF6
        UbzppgqI84o3Wpja7XZSvSqNPChdzQhC/ZI7+vY=
X-Google-Smtp-Source: ABdhPJyTRYV3BE1IdBDq9LdnWdLS5bqFcwuL1fT5lGyA5v87ZVHhscGuqEEZkDTvPiTUAaHEXgl6jJG6U/vAFTsvdrk=
X-Received: by 2002:a5b:1ca:: with SMTP id f10mr1008498ybp.293.1617817437920;
 Wed, 07 Apr 2021 10:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
 <87im50vi9v.fsf@cjr.nz> <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
 <CAKywueSCF-ZgmJZif=kkspk_b8Xp3ARUGHD64nnc5ZbVk3EcxA@mail.gmail.com> <CAH2r5mv1=tpjPOZhq97t+X99dfSDtzWepp5bpqPqjf9Z1t6+sg@mail.gmail.com>
In-Reply-To: <CAH2r5mv1=tpjPOZhq97t+X99dfSDtzWepp5bpqPqjf9Z1t6+sg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 7 Apr 2021 23:13:46 +0530
Message-ID: <CANT5p=rq+jXGyZG-23dpOVOomObXmXEdr9FsO-=-vX9tH+kkCA@mail.gmail.com>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b32d7d05bf6579b9"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b32d7d05bf6579b9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The intel bot identified an issue with the earlier version of the fix,
when not compiled with DFS.
Here's an updated version with that fix too.

Regards,
Shyam

On Wed, Apr 7, 2021 at 9:13 AM Steve French <smfrench@gmail.com> wrote:
>
> merged into cifs-2.6.git for-next
>
> On Tue, Apr 6, 2021 at 11:34 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Looks good!
> >
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> >
> > CC: <stable@vger.kernel.org> # 5.11+
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D0=BF=D0=BD, 5 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 19:07, Shyam Pr=
asad N <nspmangalore@gmail.com>:
> > >
> > > Hi Paulo,
> > >
> > > Thanks for the quick review. And nice catch about CONFIG_CIFS_DFS_UPC=
ALL.
> > > Fixed it, added CC for stable.
> > > Attached updated patch.
> > >
> > > Regards,
> > > Shyam
> > >
> > > On Mon, Apr 5, 2021 at 9:24 PM Paulo Alcantara <pc@cjr.nz> wrote:
> > > >
> > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > >
> > > > > Please consider the attached patch for performing the DNS query a=
gain
> > > > > on reconnect.
> > > > > This is important when connecting to Azure file shares. The UNC
> > > > > generally contains the server name as a FQDN, and the IP address =
which
> > > > > the name resolves to can change over time.
> > > > >
> > > > > After our last conversation about this, I discovered that for the
> > > > > non-DFS scenario, we never do DNS resolutions in cifs.ko, since
> > > > > mount.cifs already resolves the name and passes the "addr=3D" arg=
 during
> > > > > mount.
> > > >
> > > > Yeah, this should happen for both cases.  Good catch!
> > > >
> > > > > I noticed that you had a patch for this long back. But I don't se=
e
> > > > > that call happening in the latest code. Any idea why that was don=
e?
> > > >
> > > > I don't know.  Maybe some other patch broke it.
> > > >
> > > > We should probably mark it for stable as well.
> > > >
> > > > > From 289f7f0fa229ea181094821c309a2ba9358791a3 Mon Sep 17 00:00:00=
 2001
> > > > > From: Shyam Prasad N <sprasad@microsoft.com>
> > > > > Date: Wed, 31 Mar 2021 14:35:24 +0000
> > > > > Subject: [PATCH] cifs: On cifs_reconnect, resolve the hostname ag=
ain.
> > > > >
> > > > > On cifs_reconnect, make sure that DNS resolution happens again.
> > > > > It could be the cause of connection to go dead in the first place=
.
> > > > >
> > > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > > ---
> > > > >  fs/cifs/connect.c | 15 +++++++++++++++
> > > > >  1 file changed, 15 insertions(+)
> > > >
> > > > This patch breaks when CONFIG_CIFS_DFS_UPCALL isn't set.
> > > >
> > > > Please declare reconn_set_ipaddr_from_hostname() outside the "#ifde=
f
> > > > CONFIG_CIFS_DFS_UPCALL" in connect.c.
> > > >
> > > > Otherwise,
> > > >
> > > > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > >
> > >
> > >
> > > --
> > > Regards,
> > > Shyam
>
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam

--000000000000b32d7d05bf6579b9
Content-Type: application/octet-stream; 
	name="0001-cifs-On-cifs_reconnect-resolve-the-hostname-again.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-On-cifs_reconnect-resolve-the-hostname-again.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kn7qocxq0>
X-Attachment-Id: f_kn7qocxq0

RnJvbSA3YjI5MGQ4ZjU3MWJlODNiOGM5NmZjMDhhOTk0MjExMWZmNjQyNTUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMxIE1hciAyMDIxIDE0OjM1OjI0ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogT24gY2lmc19yZWNvbm5lY3QsIHJlc29sdmUgdGhlIGhvc3RuYW1lIGFnYWluLgoKT24g
Y2lmc19yZWNvbm5lY3QsIG1ha2Ugc3VyZSB0aGF0IEROUyByZXNvbHV0aW9uIGhhcHBlbnMgYWdh
aW4uCkl0IGNvdWxkIGJlIHRoZSBjYXVzZSBvZiBjb25uZWN0aW9uIHRvIGdvIGRlYWQgaW4gdGhl
IGZpcnN0IHBsYWNlLgoKVGhpcyBhbHNvIGNvbnRhaW5zIHRoZSBmaXggZm9yIGEgYnVpbGQgaXNz
dWUgaWRlbnRpZmllZCBieSBJbnRlbCBib3QuClJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2Jv
dCA8bGtwQGludGVsLmNvbT4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2Fk
QG1pY3Jvc29mdC5jb20+ClJldmlld2VkLWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFNVU0UpIDxwY0Bj
anIubno+ClJldmlld2VkLWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNv
bT4KQ0M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIDUuMTErClNpZ25lZC1vZmYtYnk6IFN0
ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL01ha2VmaWxl
ICB8ICA1ICsrKy0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDE3ICsrKysrKysrKysrKysrKystCiAy
IGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9NYWtlZmlsZSBiL2ZzL2NpZnMvTWFrZWZpbGUKaW5kZXggNTIxM2IyMDg0
M2I1Li4zZWUzYjdkZTRkZWQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvTWFrZWZpbGUKKysrIGIvZnMv
Y2lmcy9NYWtlZmlsZQpAQCAtMTAsMTMgKzEwLDE0IEBAIGNpZnMteSA6PSB0cmFjZS5vIGNpZnNm
cy5vIGNpZnNzbWIubyBjaWZzX2RlYnVnLm8gY29ubmVjdC5vIGRpci5vIGZpbGUubyBcCiAJICBj
aWZzX3VuaWNvZGUubyBudGVyci5vIGNpZnNlbmNyeXB0Lm8gXAogCSAgcmVhZGRpci5vIGlvY3Rs
Lm8gc2Vzcy5vIGV4cG9ydC5vIHNtYjFvcHMubyB1bmMubyB3aW51Y2FzZS5vIFwKIAkgIHNtYjJv
cHMubyBzbWIybWFwZXJyb3IubyBzbWIydHJhbnNwb3J0Lm8gXAotCSAgc21iMm1pc2MubyBzbWIy
cGR1Lm8gc21iMmlub2RlLm8gc21iMmZpbGUubyBjaWZzYWNsLm8gZnNfY29udGV4dC5vCisJICBz
bWIybWlzYy5vIHNtYjJwZHUubyBzbWIyaW5vZGUubyBzbWIyZmlsZS5vIGNpZnNhY2wubyBmc19j
b250ZXh0Lm8gXAorCSAgZG5zX3Jlc29sdmUubwogCiBjaWZzLSQoQ09ORklHX0NJRlNfWEFUVFIp
ICs9IHhhdHRyLm8KIAogY2lmcy0kKENPTkZJR19DSUZTX1VQQ0FMTCkgKz0gY2lmc19zcG5lZ28u
bwogCi1jaWZzLSQoQ09ORklHX0NJRlNfREZTX1VQQ0FMTCkgKz0gZG5zX3Jlc29sdmUubyBjaWZz
X2Rmc19yZWYubyBkZnNfY2FjaGUubworY2lmcy0kKENPTkZJR19DSUZTX0RGU19VUENBTEwpICs9
IGNpZnNfZGZzX3JlZi5vIGRmc19jYWNoZS5vCiAKIGNpZnMtJChDT05GSUdfQ0lGU19TV05fVVBD
QUxMKSArPSBuZXRsaW5rLm8gY2lmc19zd24ubwogCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5l
Y3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IGVlYzhhMjA1MmRhMi4uMjQ2NjhlYjAwNmM2
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpA
QCAtODcsNyArODcsNiBAQCBzdGF0aWMgdm9pZCBjaWZzX3BydW5lX3RsaW5rcyhzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspOwogICoKICAqIFRoaXMgc2hvdWxkIGJlIGNhbGxlZCB3aXRoIHNlcnZl
ci0+c3J2X211dGV4IGhlbGQuCiAgKi8KLSNpZmRlZiBDT05GSUdfQ0lGU19ERlNfVVBDQUxMCiBz
dGF0aWMgaW50IHJlY29ubl9zZXRfaXBhZGRyX2Zyb21faG9zdG5hbWUoc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyKQogewogCWludCByYzsKQEAgLTEyNCw2ICsxMjMsNyBAQCBzdGF0aWMg
aW50IHJlY29ubl9zZXRfaXBhZGRyX2Zyb21faG9zdG5hbWUoc3RydWN0IFRDUF9TZXJ2ZXJfSW5m
byAqc2VydmVyKQogCXJldHVybiAhcmMgPyAtMSA6IDA7CiB9CiAKKyNpZmRlZiBDT05GSUdfQ0lG
U19ERlNfVVBDQUxMCiAvKiBUaGVzZSBmdW5jdGlvbnMgbXVzdCBiZSBjYWxsZWQgd2l0aCBzZXJ2
ZXItPnNydl9tdXRleCBoZWxkICovCiBzdGF0aWMgdm9pZCByZWNvbm5fc2V0X25leHRfZGZzX3Rh
cmdldChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQkJICAgICAgIHN0cnVjdCBj
aWZzX3NiX2luZm8gKmNpZnNfc2IsCkBAIC0zMjEsMTQgKzMyMSwyOSBAQCBjaWZzX3JlY29ubmVj
dChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAjZW5kaWYKIAogI2lmZGVmIENPTkZJ
R19DSUZTX0RGU19VUENBTEwKKwkJaWYgKGNpZnNfc2IgJiYgY2lmc19zYi0+b3JpZ2luX2Z1bGxw
YXRoKQogCQkJLyoKIAkJCSAqIFNldCB1cCBuZXh0IERGUyB0YXJnZXQgc2VydmVyIChpZiBhbnkp
IGZvciByZWNvbm5lY3QuIElmIERGUwogCQkJICogZmVhdHVyZSBpcyBkaXNhYmxlZCwgdGhlbiB3
ZSB3aWxsIHJldHJ5IGxhc3Qgc2VydmVyIHdlCiAJCQkgKiBjb25uZWN0ZWQgdG8gYmVmb3JlLgog
CQkJICovCiAJCQlyZWNvbm5fc2V0X25leHRfZGZzX3RhcmdldChzZXJ2ZXIsIGNpZnNfc2IsICZ0
Z3RfbGlzdCwgJnRndF9pdCk7CisJCWVsc2UgeworI2VuZGlmCisJCQkvKgorCQkJICogUmVzb2x2
ZSB0aGUgaG9zdG5hbWUgYWdhaW4gdG8gbWFrZSBzdXJlIHRoYXQgSVAgYWRkcmVzcyBpcyB1cC10
by1kYXRlLgorCQkJICovCisJCQlyYyA9IHJlY29ubl9zZXRfaXBhZGRyX2Zyb21faG9zdG5hbWUo
c2VydmVyKTsKKwkJCWlmIChyYykgeworCQkJCWNpZnNfZGJnKEZZSSwgIiVzOiBmYWlsZWQgdG8g
cmVzb2x2ZSBob3N0bmFtZTogJWRcbiIsCisJCQkJCQlfX2Z1bmNfXywgcmMpOworCQkJfQorCisj
aWZkZWYgQ09ORklHX0NJRlNfREZTX1VQQ0FMTAorCQl9CiAjZW5kaWYKIAorCiAjaWZkZWYgQ09O
RklHX0NJRlNfU1dOX1VQQ0FMTAogCQl9CiAjZW5kaWYKLS0gCjIuMjUuMQoK
--000000000000b32d7d05bf6579b9--
