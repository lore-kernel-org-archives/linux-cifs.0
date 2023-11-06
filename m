Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4138C4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Nov 2023 17:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjKFREp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjKFREo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Nov 2023 12:04:44 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16357D67
        for <linux-cifs@vger.kernel.org>; Mon,  6 Nov 2023 09:04:41 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2c51682fddeso60382351fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 06 Nov 2023 09:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699290279; x=1699895079; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mu1fhFVy6Gd+DwiKoZDRS/xiti+Kw3A61zVT8Kiq+/4=;
        b=LSsqU+Bpm1jkJBBu8HX/mgJqsr+Kbi9siQlX1F45j4Et4KGM7fmuH6RSLu0seZTio6
         +107K/LjirtAQ9rErwhhIfWlow//hOawPldUCIV4BAZeL2OfhLloIaa6+6TtmQZ82cFR
         Gjj27m/g+npvSFgId/0kWg+ZH6+s/fOsCAVn4y3lau/c+hKezC9eaNnnduQJ9XSbLs3h
         yT2ULzgkiP+yVf7MSq5MHo4y4LhVMLvcP4PlzwwDuvfAlmoGSHL15yfhzgXA3EYlFpB0
         RAQaBpoOx7UyzScvO/f2JuS8zLjdpCI163JsxRzorKMpQ+8LOjl+Y507To216bhM3Xl0
         1I5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699290279; x=1699895079;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mu1fhFVy6Gd+DwiKoZDRS/xiti+Kw3A61zVT8Kiq+/4=;
        b=pJg7/TFnDkrVdmN3Z522tY8C8r0oEMA0EQIiyNbE6WdtvB1JVLXlRSoK3amZtGXz1U
         rzBwTSBrqwTZNqGO6FtCD/bo+15d2JPIoXfOLEvIuBlYUQWK5GSyFkyl3kuq1E5bFmHV
         4dg033zMJ9I8MCJMTFOtkbC7zVqZQSIb1wQVUozEqzl/EVFYWAZ4WiCzR1d+AwdlwCkn
         PEQxbuYWD3Y7hr8TOtHr60YXqc+we6nd7GgHPe1ZWhdzuBzMd889EUq1TACjndKdFZKA
         38q/l21O0Kuetn7cPvry3PBtyGgU6WvVH074V8LGurLYYYKqnO9sZw1e67u1hbVAttIK
         xqwQ==
X-Gm-Message-State: AOJu0YzDJc32HSs2PM7YgbhfKvjuaLa+VE3+It+FRoF9tF3Uo/UWCSyj
        TsN+XTkxxAeD9QCeAg8/AHKvxZmVHX03Tv2UrZo=
X-Google-Smtp-Source: AGHT+IF4rH82lzSvo86ERNSMFeed11YAUhEF80YfrG1KcnxYDciFWE7n/PFI7b3Ye+6oBcpW+s8/Pi7YfrTR2viJMeg=
X-Received: by 2002:a2e:7809:0:b0:2c0:13d5:e463 with SMTP id
 t9-20020a2e7809000000b002c013d5e463mr31630ljc.7.1699290278878; Mon, 06 Nov
 2023 09:04:38 -0800 (PST)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-9-sprasad@microsoft.com>
 <ffa541bac7417c9dea79c73e22de1eda.pc@manguebit.com> <CANT5p=ph84SkoXf-2q7oa1nQdfjw4q7jzzWOtU-mWMtg2=TxnA@mail.gmail.com>
In-Reply-To: <CANT5p=ph84SkoXf-2q7oa1nQdfjw4q7jzzWOtU-mWMtg2=TxnA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 6 Nov 2023 22:34:27 +0530
Message-ID: <CANT5p=qhjFzZJMC8i9Qt6zHomZvCCRdNiQ0koFTdQirO6GBgHQ@mail.gmail.com>
Subject: Re: [PATCH 09/14] cifs: add a back pointer to cifs_sb from tcon
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000071819d06097ed9db"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000071819d06097ed9db
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 9:42=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> On Sat, Nov 4, 2023 at 2:33=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
> >
> > nspmangalore@gmail.com writes:
> >
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > Today, we have no way to access the cifs_sb when we
> > > just have pointers to struct tcon. This is very
> > > limiting as many functions deal with cifs_sb, and
> > > these calls do not directly originate from VFS.
> > >
> > > This change introduces a new cifs_sb field in cifs_tcon
> > > that points to the cifs_sb for the tcon. The assumption
> > > here is that a tcon will always map to this cifs_sb and
> > > will never change.
> > >
> > > Also, refcounting should not be necessary, since cifs_sb
> > > will never be freed before tcon.
> > >
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > ---
> > >  fs/smb/client/cifsglob.h | 1 +
> > >  fs/smb/client/connect.c  | 2 ++
> > >  2 files changed, 3 insertions(+)
> >
> > This is wrong as a single tcon may be shared among different
> > superblocks.  You can, however, map those superblocks to a tcon by usin=
g
> > the cifs_sb_master_tcon() helper.
> >
> > If you do something like this
> >
> >         mount.cifs //srv/share /mnt/1 -o ...
> >         mount.cifs //srv/share /mnt/1 -o ... -> -EBUSY
> >
> > tcon->cifs_sb will end up with the already freed superblock pointer tha=
t
> > was compared to the existing one.  So, you'll get an use-after-free whe=
n
> > you dereference tcon->cifs_sb as in patch 11/14.
>
> Hi Steve,
> I discussed this one with Paulo separately. You can drop this patch.
> I'll have another patch in place of this one. And then send you an
> updated patch for the patch which depends on it.
>
> --
> Regards,
> Shyam

Here's the replacement patch for "cifs: add a back pointer to cifs_sb from =
tcon"

--=20
Regards,
Shyam

--00000000000071819d06097ed9db
Content-Type: application/octet-stream; 
	name="0004-cifs-do-not-pass-cifs_sb-when-trying-to-add-channels.patch"
Content-Disposition: attachment; 
	filename="0004-cifs-do-not-pass-cifs_sb-when-trying-to-add-channels.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lon5jq4g0>
X-Attachment-Id: f_lon5jq4g0

RnJvbSA4MzNlNTQ3MTIxMjA1NmUxMDc3NTdmMWRmOTA4ZTA5ODBjY2Q5MTEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBNb24sIDYgTm92IDIwMjMgMTY6MjI6MTEgKzAwMDAKU3ViamVjdDogW1BBVENIIDQv
OV0gY2lmczogZG8gbm90IHBhc3MgY2lmc19zYiB3aGVuIHRyeWluZyB0byBhZGQgY2hhbm5lbHMK
ClRoZSBvbmx5IHJlYXNvbiB3aHkgY2lmc19zYiBnZXRzIHBhc3NlZCB0b2RheSB0byBjaWZzX3Ry
eV9hZGRpbmdfY2hhbm5lbHMKaXMgdG8gcGFzcyB0aGUgbG9jYWxfbmxzIGZpZWxkIGZvciB0aGUg
bmV3IGNoYW5uZWxzIGFuZCBiaW5kaW5nIHNlc3Npb24uCkhvd2V2ZXIsIHRoZSBzZXMgc3RydWN0
IGFscmVhZHkgaGFzIGxvY2FsX25scyBmaWVsZCB0aGF0IGlzIHNldHVwIGR1cmluZwp0aGUgZmly
c3QgY2lmc19zZXR1cF9zZXNzaW9uLiBTbyB0aGVyZSBpcyBubyBuZWVkIHRvIHBhc3MgY2lmc19z
Yi4KClRoaXMgY2hhbmdlIHJlbW92ZXMgY2lmc19zYiBmcm9tIHRoZSBhcmcgbGlzdCBmb3IgdGhp
cyBhbmQgdGhlIGZ1bmN0aW9ucwp0aGF0IGl0IGNhbGxzIGFuZCB1c2VzIHNlcy0+bG9jYWxfbmxz
IGluc3RlYWQuCgpTaWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3Nv
ZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmggfCAgMiArLQogZnMvc21iL2Ns
aWVudC9jb25uZWN0LmMgICB8ICAyICstCiBmcy9zbWIvY2xpZW50L3Nlc3MuYyAgICAgIHwgMTIg
KysrKysrLS0tLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNwcm90by5oIGIvZnMvc21iL2Ns
aWVudC9jaWZzcHJvdG8uaAppbmRleCBjMWY3MWM2YmU3ZTMuLmVlZDhkYmI2YjJmYiAxMDA2NDQK
LS0tIGEvZnMvc21iL2NsaWVudC9jaWZzcHJvdG8uaAorKysgYi9mcy9zbWIvY2xpZW50L2NpZnNw
cm90by5oCkBAIC02MTAsNyArNjEwLDcgQEAgdm9pZCBjaWZzX2ZyZWVfaGFzaChzdHJ1Y3Qgc2hh
c2hfZGVzYyAqKnNkZXNjKTsKIAogc3RydWN0IGNpZnNfY2hhbiAqCiBjaWZzX3Nlc19maW5kX2No
YW4oc3RydWN0IGNpZnNfc2VzICpzZXMsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcik7
Ci1pbnQgY2lmc190cnlfYWRkaW5nX2NoYW5uZWxzKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNf
c2IsIHN0cnVjdCBjaWZzX3NlcyAqc2VzKTsKK2ludCBjaWZzX3RyeV9hZGRpbmdfY2hhbm5lbHMo
c3RydWN0IGNpZnNfc2VzICpzZXMpOwogYm9vbCBpc19zZXJ2ZXJfdXNpbmdfaWZhY2Uoc3RydWN0
IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQkJICAgc3RydWN0IGNpZnNfc2VydmVyX2lmYWNl
ICppZmFjZSk7CiBib29sIGlzX3Nlc191c2luZ19pZmFjZShzdHJ1Y3QgY2lmc19zZXMgKnNlcywg
c3RydWN0IGNpZnNfc2VydmVyX2lmYWNlICppZmFjZSk7CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xp
ZW50L2Nvbm5lY3QuYyBiL2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCmluZGV4IDNmZjgyZjBhYTAw
ZS4uOTQ3ZTNjMzYyYmViIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYworKysg
Yi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwpAQCAtMzU2NCw3ICszNTY0LDcgQEAgaW50IGNpZnNf
bW91bnQoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IHNtYjNfZnNfY29udGV4
dCAqY3R4KQogCWN0eC0+cHJlcGF0aCA9IE5VTEw7CiAKIG91dDoKLQljaWZzX3RyeV9hZGRpbmdf
Y2hhbm5lbHMoY2lmc19zYiwgbW50X2N0eC5zZXMpOworCWNpZnNfdHJ5X2FkZGluZ19jaGFubmVs
cyhtbnRfY3R4LnNlcyk7CiAJcmMgPSBtb3VudF9zZXR1cF90bGluayhjaWZzX3NiLCBtbnRfY3R4
LnNlcywgbW50X2N0eC50Y29uKTsKIAlpZiAocmMpCiAJCWdvdG8gZXJyb3I7CmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L3Nlc3MuYyBiL2ZzL3NtYi9jbGllbnQvc2Vzcy5jCmluZGV4IGY0NTRl
ZTFkZTllZi4uYjRlNjBkY2YzYTk0IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3Nlc3MuYwor
KysgYi9mcy9zbWIvY2xpZW50L3Nlc3MuYwpAQCAtMjQsNyArMjQsNyBAQAogI2luY2x1ZGUgImZz
X2NvbnRleHQuaCIKIAogc3RhdGljIGludAotY2lmc19zZXNfYWRkX2NoYW5uZWwoc3RydWN0IGNp
ZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfc2VzICpzZXMsCitjaWZzX3Nlc19hZGRf
Y2hhbm5lbChzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkJICAgICBzdHJ1Y3QgY2lmc19zZXJ2ZXJf
aWZhY2UgKmlmYWNlKTsKIAogYm9vbApAQCAtMTcxLDcgKzE3MSw3IEBAIGNpZnNfY2hhbl9pc19p
ZmFjZV9hY3RpdmUoc3RydWN0IGNpZnNfc2VzICpzZXMsCiB9CiAKIC8qIHJldHVybnMgbnVtYmVy
IG9mIGNoYW5uZWxzIGFkZGVkICovCi1pbnQgY2lmc190cnlfYWRkaW5nX2NoYW5uZWxzKHN0cnVj
dCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIHN0cnVjdCBjaWZzX3NlcyAqc2VzKQoraW50IGNpZnNf
dHJ5X2FkZGluZ19jaGFubmVscyhzdHJ1Y3QgY2lmc19zZXMgKnNlcykKIHsKIAlzdHJ1Y3QgVENQ
X1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSBzZXMtPnNlcnZlcjsKIAlpbnQgb2xkX2NoYW5fY291bnQs
IG5ld19jaGFuX2NvdW50OwpAQCAtMjUzLDcgKzI1Myw3IEBAIGludCBjaWZzX3RyeV9hZGRpbmdf
Y2hhbm5lbHMoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfc2VzICpz
ZXMpCiAJCQlrcmVmX2dldCgmaWZhY2UtPnJlZmNvdW50KTsKIAogCQkJc3Bpbl91bmxvY2soJnNl
cy0+aWZhY2VfbG9jayk7Ci0JCQlyYyA9IGNpZnNfc2VzX2FkZF9jaGFubmVsKGNpZnNfc2IsIHNl
cywgaWZhY2UpOworCQkJcmMgPSBjaWZzX3Nlc19hZGRfY2hhbm5lbChzZXMsIGlmYWNlKTsKIAkJ
CXNwaW5fbG9jaygmc2VzLT5pZmFjZV9sb2NrKTsKIAogCQkJaWYgKHJjKSB7CkBAIC00NDksNyAr
NDQ5LDcgQEAgY2lmc19zZXNfZmluZF9jaGFuKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBzdHJ1Y3Qg
VENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiB9CiAKIHN0YXRpYyBpbnQKLWNpZnNfc2VzX2FkZF9j
aGFubmVsKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIHN0cnVjdCBjaWZzX3NlcyAqc2Vz
LAorY2lmc19zZXNfYWRkX2NoYW5uZWwoc3RydWN0IGNpZnNfc2VzICpzZXMsCiAJCSAgICAgc3Ry
dWN0IGNpZnNfc2VydmVyX2lmYWNlICppZmFjZSkKIHsKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZv
ICpjaGFuX3NlcnZlcjsKQEAgLTUyOCw3ICs1MjgsNyBAQCBjaWZzX3Nlc19hZGRfY2hhbm5lbChz
dHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkgKiBU
aGlzIHdpbGwgYmUgdXNlZCBmb3IgZW5jb2RpbmcvZGVjb2RpbmcgdXNlci9kb21haW4vcHcKIAkg
KiBkdXJpbmcgc2VzcyBzZXR1cCBhdXRoLgogCSAqLwotCWN0eC0+bG9jYWxfbmxzID0gY2lmc19z
Yi0+bG9jYWxfbmxzOworCWN0eC0+bG9jYWxfbmxzID0gc2VzLT5sb2NhbF9ubHM7CiAKIAkvKiBV
c2UgUkRNQSBpZiBwb3NzaWJsZSAqLwogCWN0eC0+cmRtYSA9IGlmYWNlLT5yZG1hX2NhcGFibGU7
CkBAIC01NzQsNyArNTc0LDcgQEAgY2lmc19zZXNfYWRkX2NoYW5uZWwoc3RydWN0IGNpZnNfc2Jf
aW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfc2VzICpzZXMsCiAKIAlyYyA9IGNpZnNfbmVnb3Rp
YXRlX3Byb3RvY29sKHhpZCwgc2VzLCBjaGFuLT5zZXJ2ZXIpOwogCWlmICghcmMpCi0JCXJjID0g
Y2lmc19zZXR1cF9zZXNzaW9uKHhpZCwgc2VzLCBjaGFuLT5zZXJ2ZXIsIGNpZnNfc2ItPmxvY2Fs
X25scyk7CisJCXJjID0gY2lmc19zZXR1cF9zZXNzaW9uKHhpZCwgc2VzLCBjaGFuLT5zZXJ2ZXIs
IHNlcy0+bG9jYWxfbmxzKTsKIAogCW11dGV4X3VubG9jaygmc2VzLT5zZXNzaW9uX211dGV4KTsK
IAotLSAKMi4zNC4xCgo=
--00000000000071819d06097ed9db--
