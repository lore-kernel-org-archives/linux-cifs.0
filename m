Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E62C6FD1C
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Mar 2023 01:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCYBOu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 21:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCYBOt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 21:14:49 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765D6166D9
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 18:14:47 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id q16so4353105lfe.10
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 18:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679706886;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OltyK/NIqOeATBwfKQrnmwnbHMhXY2dXbVIAs8Ln9DY=;
        b=KwOKRj4XUZWJd295jZ1I0uq0y1SOl9uv1TI9cJKo49onR+6QIuVW+g5tWjonquvIis
         C63r0dlAhuW28cWLho45jPG6b4vTj2vnJX+7huHg6Cfej235n6+Q81cKPbuK4DyiPNK8
         LqFiM11uVwRlZUazePIQSFWviZ9wtPYyjY24ZQWRIQFVvCyj5KQrYBJzCX8UWPSY7sqo
         Du5gUjCTiIuPk4AnnPUotiROG0E2aBWBeezRqQaLT+deQmTH5WSoE+Ot9AIl/jAMWWff
         f+jynECk/X7jrdeRkP0Lmk7YQfDKIC/iy9izP50ZlA0EMTfpYxzqTO5LAgsnk0kwKDhr
         0Paw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679706886;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OltyK/NIqOeATBwfKQrnmwnbHMhXY2dXbVIAs8Ln9DY=;
        b=P9LomJktYAjpv+I71AQRJJodXjmb707fCgQDWAeKI8mOXGqhmPrhxl8nZoO95Q8rSf
         YAnsfMcGvVbuLz6YhHb26/Ol5Aj2yTVB2Z7HUZieJ8QkD1aKKP+4HV6Ot/R6bvH4NVdn
         utodv5VOpnjGantLbknG2/YnLG6gqBBxQfWHiPEZFHtO/jseDlvNr/LsqWtVFu06nfvW
         +pr4ABfgo8T5cxrNAL3XNgS3+11bJMNH+PPoWIN57yiC4hwTLBnrOMTYNAl7ehysEbGr
         8yxmM3tIuiAHhPdoYwRmTdXMYy9phs1mlmMNF8OILqmJFG1Bqrv8ALl9F8w9RpIVK4kT
         oWqQ==
X-Gm-Message-State: AAQBX9cQBI2bpezOhVshJQ/0p3rXZaL0g92dZa7nFjH50SDV7HIg5KFZ
        MZEncfQTQ0LqXt9jZnrtLlOmerARLqaizz6rTt0=
X-Google-Smtp-Source: AKy350ZzAddTWUcToMxl12wbd2wAXQKPWSRWWWQPMmjI80WPRhfcW4uMNyzH4Rs5A/M5bUxmhDnSPzoGKjBXSy4L9pA=
X-Received: by 2002:ac2:55a2:0:b0:4ea:f9d4:93a1 with SMTP id
 y2-20020ac255a2000000b004eaf9d493a1mr1295197lfg.10.1679706885401; Fri, 24 Mar
 2023 18:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230323190500.1684832-1-bharathsm.hsk@gmail.com> <CAH2r5mtbT2pEY=-r-RpKW-YSkhbeqxx9dBk0et8tJd6AsD66gA@mail.gmail.com>
In-Reply-To: <CAH2r5mtbT2pEY=-r-RpKW-YSkhbeqxx9dBk0et8tJd6AsD66gA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 24 Mar 2023 20:14:34 -0500
Message-ID: <CAH2r5mvuONpJ0Ms632kfv2egSx7E2YsodwCDTyb2ghim0VQVOQ@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Close deferred file handles if we get handle lease break
To:     bharathsm.hsk@gmail.com
Cc:     pc@cjr.nz, lsahlber@redhat.com, sprasad@microsoft.com,
        tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000003b6ea105f7af3c60"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003b6ea105f7af3c60
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

paulo spotted some problems with it (missing spinlocks around calls to
cifs_del_deferred_close() e.g.)  which I have fixed up - updated
version attached.

There was one additional question in fs/cifs/file.c change.  Is this
patch now doing a double call to cifsFileInfo_put()  (see snippet
below)

@@ -4921,6 +4924,24 @@ void cifs_oplock_break(struct work_struct *work)
                cifs_dbg(VFS, "Push locks rc =3D %d\n", rc);

 oplock_break_ack:
+       /*
+        * When oplock break is received and there are no active file handl=
es
+        * but cached file handles, then schedule deferred close immediatel=
y.
+        * So, new open will not use cached handle.
+        */
+       spin_lock(&CIFS_I(inode)->deferred_lock);
+       is_deferred =3D cifs_is_deferred_close(cfile, &dclose);
+       if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
+                       cfile->deferred_close_scheduled &&
delayed_work_pending(&cfile->deferred)) {
+               spin_unlock(&CIFS_I(inode)->deferred_lock);
+               if (cancel_delayed_work(&cfile->deferred)) {
+                       _cifsFileInfo_put(cfile, false, false);
+                       cifs_close_deferred_file(cinode, false);
+                       goto oplock_break_done;
+               }
+       } else
+               spin_unlock(&CIFS_I(inode)->deferred_lock);
+
        /*
         * releasing stale oplock after recent reconnect of smb session usi=
ng
         * a now incorrect file handle is not a data integrity issue but do
@@ -4933,6 +4954,7 @@ void cifs_oplock_break(struct work_struct *work)
                cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
        }

+oplock_break_done:
        _cifsFileInfo_put(cfile, false /* do not wait for ourself */, false=
);
        cifs_done_oplock_break(cinode);
 }

On Thu, Mar 23, 2023 at 2:48=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> This looks like a very important patch (I could repro some of the problem=
s
> he mentioned in other threads) - tentatively merged into cifs-2.6.git for=
-next
>
> Am testing now - but let me know if anyone sees any problems with this.
>
> On Thu, Mar 23, 2023 at 2:07=E2=80=AFPM <bharathsm.hsk@gmail.com> wrote:
> >
> > From: Bharath SM <bharathsm@microsoft.com>
> >
> > We should not cache deferred file handles if we dont have
> > handle lease on a file. And we should immediately close all
> > deferred handles in case of handle lease break.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple defer=
red close handles for the same file.")
> > ---
> >  fs/cifs/cifsproto.h |  3 ++-
> >  fs/cifs/file.c      | 21 +++++++++++++++++++++
> >  fs/cifs/misc.c      |  4 ++--
> >  3 files changed, 25 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index e2eff66eefab..d2819d449f05 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -278,7 +278,8 @@ extern void cifs_add_deferred_close(struct cifsFile=
Info *cfile,
> >
> >  extern void cifs_del_deferred_close(struct cifsFileInfo *cfile);
> >
> > -extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)=
;
> > +extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode,
> > +                                    bool wait_oplock_handler);
> >
> >  extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon)=
;
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 4d4a2d82636d..ce75d8c1e3fe 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -4884,6 +4884,9 @@ void cifs_oplock_break(struct work_struct *work)
> >         struct cifsInodeInfo *cinode =3D CIFS_I(inode);
> >         struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
> >         struct TCP_Server_Info *server =3D tcon->ses->server;
> > +       bool is_deferred =3D false;
> > +       struct cifs_deferred_close *dclose;
> > +
> >         int rc =3D 0;
> >         bool purge_cache =3D false;
> >
> > @@ -4921,6 +4924,23 @@ void cifs_oplock_break(struct work_struct *work)
> >                 cifs_dbg(VFS, "Push locks rc =3D %d\n", rc);
> >
> >  oplock_break_ack:
> > +       /*
> > +        * When oplock break is received and there are no active file h=
andles
> > +        * but cached file handles, then schedule deferred close immedi=
ately.
> > +        * So, new open will not use cached handle.
> > +        */
> > +       spin_lock(&CIFS_I(inode)->deferred_lock);
> > +       is_deferred =3D cifs_is_deferred_close(cfile, &dclose);
> > +       spin_unlock(&CIFS_I(inode)->deferred_lock);
> > +       if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
> > +                       cfile->deferred_close_scheduled && delayed_work=
_pending(&cfile->deferred)) {
> > +               if (cancel_delayed_work(&cfile->deferred)) {
> > +                       _cifsFileInfo_put(cfile, false, false);
> > +                       cifs_close_deferred_file(cinode, false);
> > +                       goto oplock_break_done;
> > +               }
> > +       }
> > +
> >         /*
> >          * releasing stale oplock after recent reconnect of smb session=
 using
> >          * a now incorrect file handle is not a data integrity issue bu=
t do
> > @@ -4933,6 +4953,7 @@ void cifs_oplock_break(struct work_struct *work)
> >                 cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
> >         }
> >
> > +oplock_break_done:
> >         _cifsFileInfo_put(cfile, false /* do not wait for ourself */, f=
alse);
> >         cifs_done_oplock_break(cinode);
> >  }
> > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > index a0d286ee723d..fd9d6b1ee1e2 100644
> > --- a/fs/cifs/misc.c
> > +++ b/fs/cifs/misc.c
> > @@ -728,7 +728,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
> >  }
> >
> >  void
> > -cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
> > +cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode, bool wait_o=
plock_handler)
> >  {
> >         struct cifsFileInfo *cfile =3D NULL;
> >         struct file_list *tmp_list, *tmp_next_list;
> > @@ -755,7 +755,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs=
_inode)
> >         spin_unlock(&cifs_inode->open_file_lock);
> >
> >         list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, l=
ist) {
> > -               _cifsFileInfo_put(tmp_list->cfile, true, false);
> > +               _cifsFileInfo_put(tmp_list->cfile, wait_oplock_handler,=
 false);
> >                 list_del(&tmp_list->list);
> >                 kfree(tmp_list);
> >         }
> > --
> > 2.25.1
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

--0000000000003b6ea105f7af3c60
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Close-deferred-file-handles-if-we-get-handle-le.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Close-deferred-file-handles-if-we-get-handle-le.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lfna37ot0>
X-Attachment-Id: f_lfna37ot0

RnJvbSA3ODIzMGRlZmRiYjc4MDI0Nzg1ZDVkOTc2YTJkYzE0MTUyY2RhNmFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogVGh1LCAyMyBNYXIgMjAyMyAxOTowNTowMCArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjM6IENsb3NlIGRlZmVycmVkIGZpbGUgaGFuZGxlcyBpZiB3ZSBnZXQgaGFuZGxlIGxlYXNlIGJy
ZWFrCgpXZSBzaG91bGQgbm90IGNhY2hlIGRlZmVycmVkIGZpbGUgaGFuZGxlcyBpZiB3ZSBkb250
IGhhdmUKaGFuZGxlIGxlYXNlIG9uIGEgZmlsZS4gQW5kIHdlIHNob3VsZCBpbW1lZGlhdGVseSBj
bG9zZSBhbGwKZGVmZXJyZWQgaGFuZGxlcyBpbiBjYXNlIG9mIGhhbmRsZSBsZWFzZSBicmVhay4g
VGhpcyBpcwp2ZXJ5IGltcG9ydGFudCBlLmcuIHRvIHByZXZlbnQgYWNjZXNzIGRlbmllZCBlcnJv
cnMKaW4gd3JpdGluZyB0byB0aGUgc2FtZSBmaWxlIGZyb20gYSBkaWZmZXJlbnQgY2xpZW50IChk
dXJpbmcKdGhpcyBpbnRlcnZhbCB3aGlsZSB0aGUgY2xvc2UgaXMgZGVmZXJyZWQpLgoKU2lnbmVk
LW9mZi1ieTogQmhhcmF0aCBTTSA8YmhhcmF0aHNtQG1pY3Jvc29mdC5jb20+CkZpeGVzOiA5ZTMx
Njc4ZmI0MDMgKCJTTUIzOiBmaXggbGVhc2UgYnJlYWsgdGltZW91dCB3aGVuIG11bHRpcGxlIGRl
ZmVycmVkIGNsb3NlIGhhbmRsZXMgZm9yIHRoZSBzYW1lIGZpbGUuIikKQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcgIyA2LjArClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hA
bWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNwcm90by5oIHwgIDMgKystCiBmcy9jaWZz
L2ZpbGUuYyAgICAgIHwgMjIgKysrKysrKysrKysrKysrKysrKysrKwogZnMvY2lmcy9taXNjLmMg
ICAgICB8IDE5ICsrKysrKysrKysrKysrLS0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgMzggaW5zZXJ0
aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNwcm90by5o
IGIvZnMvY2lmcy9jaWZzcHJvdG8uaAppbmRleCBlMmVmZjY2ZWVmYWIuLmQyODE5ZDQ0OWYwNSAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzcHJvdG8uaAorKysgYi9mcy9jaWZzL2NpZnNwcm90by5o
CkBAIC0yNzgsNyArMjc4LDggQEAgZXh0ZXJuIHZvaWQgY2lmc19hZGRfZGVmZXJyZWRfY2xvc2Uo
c3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUsCiAKIGV4dGVybiB2b2lkIGNpZnNfZGVsX2RlZmVy
cmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlKTsKIAotZXh0ZXJuIHZvaWQgY2lm
c19jbG9zZV9kZWZlcnJlZF9maWxlKHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZzX2lub2RlKTsK
K2V4dGVybiB2b2lkIGNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShzdHJ1Y3QgY2lmc0lub2RlSW5m
byAqY2lmc19pbm9kZSwKKwkJCQkgICAgIGJvb2wgd2FpdF9vcGxvY2tfaGFuZGxlcik7CiAKIGV4
dGVybiB2b2lkIGNpZnNfY2xvc2VfYWxsX2RlZmVycmVkX2ZpbGVzKHN0cnVjdCBjaWZzX3Rjb24g
KmNpZnNfdGNvbik7CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxl
LmMKaW5kZXggNjgzMWE5OTQ5YzQzLi44ZTQyMGZkOTdmYWYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
ZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmlsZS5jCkBAIC00ODg0LDYgKzQ4ODQsOSBAQCB2b2lkIGNp
ZnNfb3Bsb2NrX2JyZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAlzdHJ1Y3QgY2lmc0lu
b2RlSW5mbyAqY2lub2RlID0gQ0lGU19JKGlub2RlKTsKIAlzdHJ1Y3QgY2lmc190Y29uICp0Y29u
ID0gdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspOwogCXN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNl
cnZlciA9IHRjb24tPnNlcy0+c2VydmVyOworCWJvb2wgaXNfZGVmZXJyZWQgPSBmYWxzZTsKKwlz
dHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSAqZGNsb3NlOworCiAJaW50IHJjID0gMDsKIAlib29s
IHB1cmdlX2NhY2hlID0gZmFsc2U7CiAKQEAgLTQ5MjEsNiArNDkyNCwyNCBAQCB2b2lkIGNpZnNf
b3Bsb2NrX2JyZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJY2lmc19kYmcoVkZTLCAi
UHVzaCBsb2NrcyByYyA9ICVkXG4iLCByYyk7CiAKIG9wbG9ja19icmVha19hY2s6CisJLyoKKwkg
KiBXaGVuIG9wbG9jayBicmVhayBpcyByZWNlaXZlZCBhbmQgdGhlcmUgYXJlIG5vIGFjdGl2ZSBm
aWxlIGhhbmRsZXMKKwkgKiBidXQgY2FjaGVkIGZpbGUgaGFuZGxlcywgdGhlbiBzY2hlZHVsZSBk
ZWZlcnJlZCBjbG9zZSBpbW1lZGlhdGVseS4KKwkgKiBTbywgbmV3IG9wZW4gd2lsbCBub3QgdXNl
IGNhY2hlZCBoYW5kbGUuCisJICovCisJc3Bpbl9sb2NrKCZDSUZTX0koaW5vZGUpLT5kZWZlcnJl
ZF9sb2NrKTsKKwlpc19kZWZlcnJlZCA9IGNpZnNfaXNfZGVmZXJyZWRfY2xvc2UoY2ZpbGUsICZk
Y2xvc2UpOworCWlmICghQ0lGU19DQUNIRV9IQU5ETEUoY2lub2RlKSAmJiBpc19kZWZlcnJlZCAm
JgorCQkJY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZCAmJiBkZWxheWVkX3dvcmtfcGVu
ZGluZygmY2ZpbGUtPmRlZmVycmVkKSkgeworCQlzcGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+
ZGVmZXJyZWRfbG9jayk7CisJCWlmIChjYW5jZWxfZGVsYXllZF93b3JrKCZjZmlsZS0+ZGVmZXJy
ZWQpKSB7CisJCQlfY2lmc0ZpbGVJbmZvX3B1dChjZmlsZSwgZmFsc2UsIGZhbHNlKTsKKwkJCWNp
ZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShjaW5vZGUsIGZhbHNlKTsKKwkJCWdvdG8gb3Bsb2NrX2Jy
ZWFrX2RvbmU7CisJCX0KKwl9IGVsc2UKKwkJc3Bpbl91bmxvY2soJkNJRlNfSShpbm9kZSktPmRl
ZmVycmVkX2xvY2spOworCiAJLyoKIAkgKiByZWxlYXNpbmcgc3RhbGUgb3Bsb2NrIGFmdGVyIHJl
Y2VudCByZWNvbm5lY3Qgb2Ygc21iIHNlc3Npb24gdXNpbmcKIAkgKiBhIG5vdyBpbmNvcnJlY3Qg
ZmlsZSBoYW5kbGUgaXMgbm90IGEgZGF0YSBpbnRlZ3JpdHkgaXNzdWUgYnV0IGRvCkBAIC00OTMz
LDYgKzQ5NTQsNyBAQCB2b2lkIGNpZnNfb3Bsb2NrX2JyZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAq
d29yaykKIAkJY2lmc19kYmcoRllJLCAiT3Bsb2NrIHJlbGVhc2UgcmMgPSAlZFxuIiwgcmMpOwog
CX0KIAorb3Bsb2NrX2JyZWFrX2RvbmU6CiAJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIGZhbHNl
IC8qIGRvIG5vdCB3YWl0IGZvciBvdXJzZWxmICovLCBmYWxzZSk7CiAJY2lmc19kb25lX29wbG9j
a19icmVhayhjaW5vZGUpOwogfQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9taXNjLmMgYi9mcy9jaWZz
L21pc2MuYwppbmRleCBiNDRmYjUxOTY4YmYuLjJlYWI5ZDVjNzRmYyAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9taXNjLmMKKysrIGIvZnMvY2lmcy9taXNjLmMKQEAgLTczNSw3ICs3MzUsNyBAQCBjaWZz
X2RlbF9kZWZlcnJlZF9jbG9zZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSkKIH0KIAogdm9p
ZAotY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlKHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZzX2lu
b2RlKQorY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlKHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZz
X2lub2RlLCBib29sIHdhaXRfb3Bsb2NrX2hhbmRsZXIpCiB7CiAJc3RydWN0IGNpZnNGaWxlSW5m
byAqY2ZpbGUgPSBOVUxMOwogCXN0cnVjdCBmaWxlX2xpc3QgKnRtcF9saXN0LCAqdG1wX25leHRf
bGlzdDsKQEAgLTc0NywyMiArNzQ3LDI2IEBAIGNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShzdHJ1
Y3QgY2lmc0lub2RlSW5mbyAqY2lmc19pbm9kZSkKIAlJTklUX0xJU1RfSEVBRCgmZmlsZV9oZWFk
KTsKIAlzcGluX2xvY2soJmNpZnNfaW5vZGUtPm9wZW5fZmlsZV9sb2NrKTsKIAlsaXN0X2Zvcl9l
YWNoX2VudHJ5KGNmaWxlLCAmY2lmc19pbm9kZS0+b3BlbkZpbGVMaXN0LCBmbGlzdCkgeworCQlz
cGluX2xvY2soJmNpZnNfaW5vZGUtPmRlZmVycmVkX2xvY2spOwogCQlpZiAoZGVsYXllZF93b3Jr
X3BlbmRpbmcoJmNmaWxlLT5kZWZlcnJlZCkpIHsKIAkJCWlmIChjYW5jZWxfZGVsYXllZF93b3Jr
KCZjZmlsZS0+ZGVmZXJyZWQpKSB7CiAJCQkJY2lmc19kZWxfZGVmZXJyZWRfY2xvc2UoY2ZpbGUp
OwogCiAJCQkJdG1wX2xpc3QgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgZmlsZV9saXN0KSwgR0ZQ
X0FUT01JQyk7Ci0JCQkJaWYgKHRtcF9saXN0ID09IE5VTEwpCisJCQkJaWYgKHRtcF9saXN0ID09
IE5VTEwpIHsKKwkJCQkJc3Bpbl91bmxvY2soJmNpZnNfaW5vZGUtPmRlZmVycmVkX2xvY2spOwog
CQkJCQlicmVhazsKKwkJCQl9CiAJCQkJdG1wX2xpc3QtPmNmaWxlID0gY2ZpbGU7CiAJCQkJbGlz
dF9hZGRfdGFpbCgmdG1wX2xpc3QtPmxpc3QsICZmaWxlX2hlYWQpOwogCQkJfQogCQl9CisJCXNw
aW5fdW5sb2NrKCZjaWZzX2lub2RlLT5kZWZlcnJlZF9sb2NrKTsKIAl9CiAJc3Bpbl91bmxvY2so
JmNpZnNfaW5vZGUtPm9wZW5fZmlsZV9sb2NrKTsKIAogCWxpc3RfZm9yX2VhY2hfZW50cnlfc2Fm
ZSh0bXBfbGlzdCwgdG1wX25leHRfbGlzdCwgJmZpbGVfaGVhZCwgbGlzdCkgewotCQlfY2lmc0Zp
bGVJbmZvX3B1dCh0bXBfbGlzdC0+Y2ZpbGUsIHRydWUsIGZhbHNlKTsKKwkJX2NpZnNGaWxlSW5m
b19wdXQodG1wX2xpc3QtPmNmaWxlLCB3YWl0X29wbG9ja19oYW5kbGVyLCBmYWxzZSk7CiAJCWxp
c3RfZGVsKCZ0bXBfbGlzdC0+bGlzdCk7CiAJCWtmcmVlKHRtcF9saXN0KTsKIAl9CkBAIC03ODAs
OCArNzg0LDkgQEAgY2lmc19jbG9zZV9hbGxfZGVmZXJyZWRfZmlsZXMoc3RydWN0IGNpZnNfdGNv
biAqdGNvbikKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNmaWxlLCAmdGNvbi0+b3BlbkZpbGVMaXN0
LCB0bGlzdCkgewogCQlpZiAoZGVsYXllZF93b3JrX3BlbmRpbmcoJmNmaWxlLT5kZWZlcnJlZCkp
IHsKIAkJCWlmIChjYW5jZWxfZGVsYXllZF93b3JrKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CisJCQkJ
c3Bpbl9sb2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2sp
OwogCQkJCWNpZnNfZGVsX2RlZmVycmVkX2Nsb3NlKGNmaWxlKTsKLQorCQkJCXNwaW5fdW5sb2Nr
KCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOwogCQkJCXRt
cF9saXN0ID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IGZpbGVfbGlzdCksIEdGUF9BVE9NSUMpOwog
CQkJCWlmICh0bXBfbGlzdCA9PSBOVUxMKQogCQkJCQlicmVhazsKQEAgLTgxMywxNyArODE4LDIx
IEBAIGNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZV91bmRlcl9kZW50cnkoc3RydWN0IGNpZnNfdGNv
biAqdGNvbiwgY29uc3QgY2hhciAqcGF0aCkKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNmaWxlLCAm
dGNvbi0+b3BlbkZpbGVMaXN0LCB0bGlzdCkgewogCQlmdWxsX3BhdGggPSBidWlsZF9wYXRoX2Zy
b21fZGVudHJ5KGNmaWxlLT5kZW50cnksIHBhZ2UpOwogCQlpZiAoc3Ryc3RyKGZ1bGxfcGF0aCwg
cGF0aCkpIHsKKwkJCXNwaW5fbG9jaygmQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpLT5k
ZWZlcnJlZF9sb2NrKTsKIAkJCWlmIChkZWxheWVkX3dvcmtfcGVuZGluZygmY2ZpbGUtPmRlZmVy
cmVkKSkgewogCQkJCWlmIChjYW5jZWxfZGVsYXllZF93b3JrKCZjZmlsZS0+ZGVmZXJyZWQpKSB7
CiAJCQkJCWNpZnNfZGVsX2RlZmVycmVkX2Nsb3NlKGNmaWxlKTsKIAogCQkJCQl0bXBfbGlzdCA9
IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBmaWxlX2xpc3QpLCBHRlBfQVRPTUlDKTsKLQkJCQkJaWYg
KHRtcF9saXN0ID09IE5VTEwpCisJCQkJCWlmICh0bXBfbGlzdCA9PSBOVUxMKSB7CisJCQkJCQlz
cGluX3VubG9jaygmQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpLT5kZWZlcnJlZF9sb2Nr
KTsKIAkJCQkJCWJyZWFrOworCQkJCQl9CiAJCQkJCXRtcF9saXN0LT5jZmlsZSA9IGNmaWxlOwog
CQkJCQlsaXN0X2FkZF90YWlsKCZ0bXBfbGlzdC0+bGlzdCwgJmZpbGVfaGVhZCk7CiAJCQkJfQog
CQkJfQorCQkJc3Bpbl91bmxvY2soJkNJRlNfSShkX2lub2RlKGNmaWxlLT5kZW50cnkpKS0+ZGVm
ZXJyZWRfbG9jayk7CiAJCX0KIAl9CiAJc3Bpbl91bmxvY2soJnRjb24tPm9wZW5fZmlsZV9sb2Nr
KTsKLS0gCjIuMzQuMQoK
--0000000000003b6ea105f7af3c60--
