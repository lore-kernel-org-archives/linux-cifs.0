Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08D619C540
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 01:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758159222; cv=none; b=HL/e6U+u26G5IQ+d/E68H3DlBmakrJJ0nV5Voi349Ol/XoMFaH5TtpVCX6JafKbh/QLHyprkpWQWnWbj1ZssH2sge5Wta8X7sI1KOGNDHg8l6ho9OA2jauaQ+qMR1H8ypAcTKrjE+cgbkMvClHzQkq0X349SPeM4sfBMQi+KXXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758159222; c=relaxed/simple;
	bh=Y+otRbwkmtdYzCb/n6Y6Kzush3FkUWIoYjvoGyzNyrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GEYjfGC4yyfb2mCdbDtBmEHxTDSrb3xmDI2XbmjynFE+95g/kr9LXAxNfbPRNcofGUOwRR9a+chp8VaZqh23ddk4XNKyAyANaFL8zbGnSqEL4DIdvIquDGAS7Sx/7oDFn4gbC82VQ0ZMcjiaY2gZNBdm8lsb8+j4FaTBJx0zslo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bkoHrFCR; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bkoHrFCR"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-78f15d58576so4021226d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 18:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758159219; x=1758764019; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ejxGiJ0ePdOcIF/IuZRVLnZmXoSE2ga7hE6Vn7tYQ6I=;
        b=bkoHrFCR8R6VqH7rIgn7RUWWx26OQcEXXPwg1PnsuLAR00uibluvK0aB36pqwlEg6I
         6QqhxtKnUOMu69V9q+JTL3+vQ/qns08iTS2Hpma9g8eIODJC4r2PP31mHBnm3K+6Zl/y
         oUPpS7F9t8f4gKRcnYDvYudakIOcb9DQ3nO1llnXvB4G1wOkHKI5Kx1ByUMeBOkh+Re/
         itcQf4hJFQUBq5wbI1WeceFbFGYRjCVVlvaauSpZlVMr2rzpDI5X8XDcgDNivROKLeOp
         aX7RZZ+w8JANvkc4O5BpY7EPa2agcIhZoipc2NZRwMWpHxHQt+Rrtx6Z2GJ55fsgxUa1
         P4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758159219; x=1758764019;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejxGiJ0ePdOcIF/IuZRVLnZmXoSE2ga7hE6Vn7tYQ6I=;
        b=uWZIdgDSApr/O3aJj4+7pbiXjJ5llUAGgzev37DobJma+PdPu0am+FLBpA9BETzxxp
         Ho1Wdo696LXZJt0fhES6VmMnvfuSNIxsTAcMoso9CqXaGRZXgT7ILQvW9uwJ1eAXAoOQ
         y0x/hSf5Na8Nx7BlWkMYnZXPjLxBS2hHXiaJ5W175decfbJx1cJkuXNkN81Zdc+KEmOJ
         S9WJIRmJFwwIlY7sNuVcldBNrJNy1SZ+eOpOmigwKWUwaB5XP5wFTs4JHwRULhcrSY8e
         s5iKo3iUp/8dDGotmSKP54aOjcWHoDX9Af5MhxOFKMvZuj65ps5LZOspp6IghNMGSZqi
         MawQ==
X-Forwarded-Encrypted: i=1; AJvYcCVK66FLmTgCv1KB7iDSUi/pY2Lu3iWp8OzsAFepJWArZzYKzYiCPSUGwI/8mDKFtryuLKSu1F9SVnae@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0+CWXgFwGfae2OWL5Wjtj+j3YjL5697ryUpapI3OkMphKgg+b
	POTA80sWQYFk5eEwzmpq84894DggfJ6l+ZwQ5nz9+zcXwNhZcQMsEgNTs/XiegaoVhMj5bTjQKf
	FPnvhdUXZBZaEaY5IPXzuQF5c5vmYUDo=
X-Gm-Gg: ASbGncv0ccEEQrj3gwE82jEIZDvGwoxMhYyDlpcV0ezODUjcmQsPCl+J+Kv1XsljBZZ
	BhyDk1MDfRuGIR4qJbMosChDPSVhs4POrrqi4rlPAdWoD8i3p1/RauCi4eLzrukoPk6i2aLie7b
	dF3scxjVjpNne4REhxa3AwaUzWaTn0TTgWfu3muzGuxMfAzO55dNmn2Rq3I5YGjo8SvFu0iisk+
	H45rBZyUG1w+I+ki10cwPEl7DSvaZwkQ5I3MU4WChc+R8p/KNAAUAnTmQoq9LjVnjBVXyvmNa0y
	52MNGzbAJMnjk/NfKxZHL5hRxjo1DvenKGrk38dYgcVvB9M=
X-Google-Smtp-Source: AGHT+IFG54A5SGzXMAhuj9eDYtETfpNbHHsZqbPzL16W2c7AVw/snztIHDo22JS1fByPBPabX23wU+vb60efARYErv8=
X-Received: by 2002:a05:6214:c8e:b0:782:ef53:7d41 with SMTP id
 6a1803df08f44-7927c7b3776mr13683816d6.33.1758159219443; Wed, 17 Sep 2025
 18:33:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917190322.765293-1-pc@manguebit.org> <v4g2cku4itpiqvfiy6aktcey5rjc2jt5kcoknf36hm45p3nxgu@wb5ho6aoy6dc>
In-Reply-To: <v4g2cku4itpiqvfiy6aktcey5rjc2jt5kcoknf36hm45p3nxgu@wb5ho6aoy6dc>
From: Steve French <smfrench@gmail.com>
Date: Wed, 17 Sep 2025 20:33:26 -0500
X-Gm-Features: AS18NWCKEDDedkPemdzjCtLi3Fl3pO-BWeHqXgSRnEBwe1KumIA8sbFTl1gZSvA
Message-ID: <CAH2r5mu3fyGd11tf983tvYiKB_Yn8FS3tTQL97HzQKybspgUXA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: fix filename matching of deferred files
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Paulo Alcantara <pc@manguebit.org>, Frank Sorenson <sorenson@redhat.com>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000bbf2c6063f095796"

--000000000000bbf2c6063f095796
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

minor cosmetic change done to the patch (see attached)

from:
   if (cfile->dentry =3D=3D dentry &&
to:
   if ((cfile->dentry =3D=3D dentry) &&

On Wed, Sep 17, 2025 at 2:15=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 09/17, Paulo Alcantara wrote:
> >Fix the following case where the client would end up closing both
> >deferred files (foo.tmp & foo) after unlink(foo) due to strstr() call
> >in cifs_close_deferred_file_under_dentry():
> >
> >  fd1 =3D openat(AT_FDCWD, "foo", O_WRONLY|O_CREAT|O_TRUNC, 0666);
> >  fd2 =3D openat(AT_FDCWD, "foo.tmp", O_WRONLY|O_CREAT|O_TRUNC, 0666);
> >  close(fd1);
> >  close(fd2);
> >  unlink("foo");
> >
> >Fixes: e3fc065682eb ("cifs: Deferred close performance improvements")
> >Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> >Cc: Enzo Matsumiya <ematsumiya@suse.de>
> >Cc: Frank Sorenson <sorenson@redhat.com>
> >Cc: David Howells <dhowells@redhat.com>
> >Cc: linux-cifs@vger.kernel.org
> >---
> > fs/smb/client/cifsproto.h |  4 ++--
> > fs/smb/client/inode.c     |  6 +++---
> > fs/smb/client/misc.c      | 36 +++++++++++++++---------------------
> > 3 files changed, 20 insertions(+), 26 deletions(-)
> >
> >diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> >index c34c533b2efa..e8fba98690ce 100644
> >--- a/fs/smb/client/cifsproto.h
> >+++ b/fs/smb/client/cifsproto.h
> >@@ -312,8 +312,8 @@ extern void cifs_close_deferred_file(struct cifsInod=
eInfo *cifs_inode);
> >
> > extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
> >
> >-extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cif=
s_tcon,
> >-                              const char *path);
> >+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
> >+                                         struct dentry *dentry);
> >
> > extern void cifs_mark_open_handles_for_deleted_file(struct inode *inode=
,
> >                               const char *path);
> >diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> >index 11d442e8b3d6..1703f1285d36 100644
> >--- a/fs/smb/client/inode.c
> >+++ b/fs/smb/client/inode.c
> >@@ -1984,7 +1984,7 @@ static int __cifs_unlink(struct inode *dir, struct=
 dentry *dentry, bool sillyren
> >       }
> >
> >       netfs_wait_for_outstanding_io(inode);
> >-      cifs_close_deferred_file_under_dentry(tcon, full_path);
> >+      cifs_close_deferred_file_under_dentry(tcon, dentry);
> > #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> >       if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
> >                               le64_to_cpu(tcon->fsUnixInfo.Capability))=
) {
> >@@ -2538,10 +2538,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct ino=
de *source_dir,
> >               goto cifs_rename_exit;
> >       }
> >
> >-      cifs_close_deferred_file_under_dentry(tcon, from_name);
> >+      cifs_close_deferred_file_under_dentry(tcon, source_dentry);
> >       if (d_inode(target_dentry) !=3D NULL) {
> >               netfs_wait_for_outstanding_io(d_inode(target_dentry));
> >-              cifs_close_deferred_file_under_dentry(tcon, to_name);
> >+              cifs_close_deferred_file_under_dentry(tcon, target_dentry=
);
> >       }
> >
> >       rc =3D cifs_do_rename(xid, source_dentry, from_name, target_dentr=
y,
> >diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> >index da23cc12a52c..350542d57249 100644
> >--- a/fs/smb/client/misc.c
> >+++ b/fs/smb/client/misc.c
> >@@ -832,33 +832,28 @@ cifs_close_all_deferred_files(struct cifs_tcon *tc=
on)
> >               kfree(tmp_list);
> >       }
> > }
> >-void
> >-cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const cha=
r *path)
> >+
> >+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
> >+                                         struct dentry *dentry)
> > {
> >-      struct cifsFileInfo *cfile;
> >       struct file_list *tmp_list, *tmp_next_list;
> >-      void *page;
> >-      const char *full_path;
> >+      struct cifsFileInfo *cfile;
> >       LIST_HEAD(file_head);
> >
> >-      page =3D alloc_dentry_path();
> >       spin_lock(&tcon->open_file_lock);
> >       list_for_each_entry(cfile, &tcon->openFileList, tlist) {
> >-              full_path =3D build_path_from_dentry(cfile->dentry, page)=
;
> >-              if (strstr(full_path, path)) {
> >-                      if (delayed_work_pending(&cfile->deferred)) {
> >-                              if (cancel_delayed_work(&cfile->deferred)=
) {
> >-                                      spin_lock(&CIFS_I(d_inode(cfile->=
dentry))->deferred_lock);
> >-                                      cifs_del_deferred_close(cfile);
> >-                                      spin_unlock(&CIFS_I(d_inode(cfile=
->dentry))->deferred_lock);
> >+              if (cfile->dentry =3D=3D dentry &&
> >+                  delayed_work_pending(&cfile->deferred) &&
> >+                  cancel_delayed_work(&cfile->deferred)) {
> >+                      spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferr=
ed_lock);
> >+                      cifs_del_deferred_close(cfile);
> >+                      spin_unlock(&CIFS_I(d_inode(cfile->dentry))->defe=
rred_lock);
> >
> >-                                      tmp_list =3D kmalloc(sizeof(struc=
t file_list), GFP_ATOMIC);
> >-                                      if (tmp_list =3D=3D NULL)
> >-                                              break;
> >-                                      tmp_list->cfile =3D cfile;
> >-                                      list_add_tail(&tmp_list->list, &f=
ile_head);
> >-                              }
> >-                      }
> >+                      tmp_list =3D kmalloc(sizeof(struct file_list), GF=
P_ATOMIC);
> >+                      if (tmp_list =3D=3D NULL)
> >+                              break;
> >+                      tmp_list->cfile =3D cfile;
> >+                      list_add_tail(&tmp_list->list, &file_head);
> >               }
> >       }
> >       spin_unlock(&tcon->open_file_lock);
> >@@ -868,7 +863,6 @@ cifs_close_deferred_file_under_dentry(struct cifs_tc=
on *tcon, const char *path)
> >               list_del(&tmp_list->list);
> >               kfree(tmp_list);
> >       }
> >-      free_dentry_path(page);
> > }
> >
> > /*
>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>
>
> Cheers,
>
> Enzo



--=20
Thanks,

Steve

--000000000000bbf2c6063f095796
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb-client-fix-filename-matching-of-deferred-files.patch"
Content-Disposition: attachment; 
	filename="0002-smb-client-fix-filename-matching-of-deferred-files.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mfoqkfe10>
X-Attachment-Id: f_mfoqkfe10

RnJvbSA0MGNkZDViMWM4YzExMzQyNDY3ZGNiMzkyZTNjODYwZDJmNGVlZmU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5vcmc+CkRh
dGU6IFdlZCwgMTcgU2VwIDIwMjUgMTY6MDM6MjIgLTAzMDAKU3ViamVjdDogW1BBVENIIDIvOF0g
c21iOiBjbGllbnQ6IGZpeCBmaWxlbmFtZSBtYXRjaGluZyBvZiBkZWZlcnJlZCBmaWxlcwoKRml4
IHRoZSBmb2xsb3dpbmcgY2FzZSB3aGVyZSB0aGUgY2xpZW50IHdvdWxkIGVuZCB1cCBjbG9zaW5n
IGJvdGgKZGVmZXJyZWQgZmlsZXMgKGZvby50bXAgJiBmb28pIGFmdGVyIHVubGluayhmb28pIGR1
ZSB0byBzdHJzdHIoKSBjYWxsCmluIGNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZV91bmRlcl9kZW50
cnkoKToKCiAgZmQxID0gb3BlbmF0KEFUX0ZEQ1dELCAiZm9vIiwgT19XUk9OTFl8T19DUkVBVHxP
X1RSVU5DLCAwNjY2KTsKICBmZDIgPSBvcGVuYXQoQVRfRkRDV0QsICJmb28udG1wIiwgT19XUk9O
TFl8T19DUkVBVHxPX1RSVU5DLCAwNjY2KTsKICBjbG9zZShmZDEpOwogIGNsb3NlKGZkMik7CiAg
dW5saW5rKCJmb28iKTsKCkZpeGVzOiBlM2ZjMDY1NjgyZWIgKCJjaWZzOiBEZWZlcnJlZCBjbG9z
ZSBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudHMiKQpTaWduZWQtb2ZmLWJ5OiBQYXVsbyBBbGNhbnRh
cmEgKFJlZCBIYXQpIDxwY0BtYW5ndWViaXQub3JnPgpSZXZpZXdlZC1ieTogRW56byBNYXRzdW1p
eWEgPGVtYXRzdW1peWFAc3VzZS5kZT4KQ2M6IEZyYW5rIFNvcmVuc29uIDxzb3JlbnNvbkByZWRo
YXQuY29tPgpDYzogRGF2aWQgSG93ZWxscyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4KQ2M6IGxpbnV4
LWNpZnNAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVu
Y2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2NpZnNwcm90by5oIHwgIDQgKyst
LQogZnMvc21iL2NsaWVudC9pbm9kZS5jICAgICB8ICA2ICsrKy0tLQogZnMvc21iL2NsaWVudC9t
aXNjLmMgICAgICB8IDM4ICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAz
IGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDI3IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmggYi9mcy9zbWIvY2xpZW50L2NpZnNwcm90
by5oCmluZGV4IGMzNGM1MzNiMmVmYS4uZThmYmE5ODY5MGNlIDEwMDY0NAotLS0gYS9mcy9zbWIv
Y2xpZW50L2NpZnNwcm90by5oCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmgKQEAgLTMx
Miw4ICszMTIsOCBAQCBleHRlcm4gdm9pZCBjaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3RydWN0
IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUpOwogCiBleHRlcm4gdm9pZCBjaWZzX2Nsb3NlX2Fs
bF9kZWZlcnJlZF9maWxlcyhzdHJ1Y3QgY2lmc190Y29uICpjaWZzX3Rjb24pOwogCi1leHRlcm4g
dm9pZCBjaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGVfdW5kZXJfZGVudHJ5KHN0cnVjdCBjaWZzX3Rj
b24gKmNpZnNfdGNvbiwKLQkJCQljb25zdCBjaGFyICpwYXRoKTsKK3ZvaWQgY2lmc19jbG9zZV9k
ZWZlcnJlZF9maWxlX3VuZGVyX2RlbnRyeShzdHJ1Y3QgY2lmc190Y29uICpjaWZzX3Rjb24sCisJ
CQkJCSAgIHN0cnVjdCBkZW50cnkgKmRlbnRyeSk7CiAKIGV4dGVybiB2b2lkIGNpZnNfbWFya19v
cGVuX2hhbmRsZXNfZm9yX2RlbGV0ZWRfZmlsZShzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCQkJCWNv
bnN0IGNoYXIgKnBhdGgpOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9pbm9kZS5jIGIvZnMv
c21iL2NsaWVudC9pbm9kZS5jCmluZGV4IDExZDQ0MmU4YjNkNi4uMTcwM2YxMjg1ZDM2IDEwMDY0
NAotLS0gYS9mcy9zbWIvY2xpZW50L2lub2RlLmMKKysrIGIvZnMvc21iL2NsaWVudC9pbm9kZS5j
CkBAIC0xOTg0LDcgKzE5ODQsNyBAQCBzdGF0aWMgaW50IF9fY2lmc191bmxpbmsoc3RydWN0IGlu
b2RlICpkaXIsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSwgYm9vbCBzaWxseXJlbgogCX0KIAogCW5l
dGZzX3dhaXRfZm9yX291dHN0YW5kaW5nX2lvKGlub2RlKTsKLQljaWZzX2Nsb3NlX2RlZmVycmVk
X2ZpbGVfdW5kZXJfZGVudHJ5KHRjb24sIGZ1bGxfcGF0aCk7CisJY2lmc19jbG9zZV9kZWZlcnJl
ZF9maWxlX3VuZGVyX2RlbnRyeSh0Y29uLCBkZW50cnkpOwogI2lmZGVmIENPTkZJR19DSUZTX0FM
TE9XX0lOU0VDVVJFX0xFR0FDWQogCWlmIChjYXBfdW5peCh0Y29uLT5zZXMpICYmIChDSUZTX1VO
SVhfUE9TSVhfUEFUSF9PUFNfQ0FQICYKIAkJCQlsZTY0X3RvX2NwdSh0Y29uLT5mc1VuaXhJbmZv
LkNhcGFiaWxpdHkpKSkgewpAQCAtMjUzOCwxMCArMjUzOCwxMCBAQCBjaWZzX3JlbmFtZTIoc3Ry
dWN0IG1udF9pZG1hcCAqaWRtYXAsIHN0cnVjdCBpbm9kZSAqc291cmNlX2RpciwKIAkJZ290byBj
aWZzX3JlbmFtZV9leGl0OwogCX0KIAotCWNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZV91bmRlcl9k
ZW50cnkodGNvbiwgZnJvbV9uYW1lKTsKKwljaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGVfdW5kZXJf
ZGVudHJ5KHRjb24sIHNvdXJjZV9kZW50cnkpOwogCWlmIChkX2lub2RlKHRhcmdldF9kZW50cnkp
ICE9IE5VTEwpIHsKIAkJbmV0ZnNfd2FpdF9mb3Jfb3V0c3RhbmRpbmdfaW8oZF9pbm9kZSh0YXJn
ZXRfZGVudHJ5KSk7Ci0JCWNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZV91bmRlcl9kZW50cnkodGNv
biwgdG9fbmFtZSk7CisJCWNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZV91bmRlcl9kZW50cnkodGNv
biwgdGFyZ2V0X2RlbnRyeSk7CiAJfQogCiAJcmMgPSBjaWZzX2RvX3JlbmFtZSh4aWQsIHNvdXJj
ZV9kZW50cnksIGZyb21fbmFtZSwgdGFyZ2V0X2RlbnRyeSwKZGlmZiAtLWdpdCBhL2ZzL3NtYi9j
bGllbnQvbWlzYy5jIGIvZnMvc21iL2NsaWVudC9taXNjLmMKaW5kZXggZGEyM2NjMTJhNTJjLi4z
NTA1NDJkNTcyNDkgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvbWlzYy5jCisrKyBiL2ZzL3Nt
Yi9jbGllbnQvbWlzYy5jCkBAIC04MzIsMzMgKzgzMiwyOCBAQCBjaWZzX2Nsb3NlX2FsbF9kZWZl
cnJlZF9maWxlcyhzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQogCQlrZnJlZSh0bXBfbGlzdCk7CiAJ
fQogfQotdm9pZAotY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlX3VuZGVyX2RlbnRyeShzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLCBjb25zdCBjaGFyICpwYXRoKQorCit2b2lkIGNpZnNfY2xvc2VfZGVm
ZXJyZWRfZmlsZV91bmRlcl9kZW50cnkoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKKwkJCQkJICAg
c3RydWN0IGRlbnRyeSAqZGVudHJ5KQogewotCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlOwog
CXN0cnVjdCBmaWxlX2xpc3QgKnRtcF9saXN0LCAqdG1wX25leHRfbGlzdDsKLQl2b2lkICpwYWdl
OwotCWNvbnN0IGNoYXIgKmZ1bGxfcGF0aDsKKwlzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZTsK
IAlMSVNUX0hFQUQoZmlsZV9oZWFkKTsKIAotCXBhZ2UgPSBhbGxvY19kZW50cnlfcGF0aCgpOwog
CXNwaW5fbG9jaygmdGNvbi0+b3Blbl9maWxlX2xvY2spOwogCWxpc3RfZm9yX2VhY2hfZW50cnko
Y2ZpbGUsICZ0Y29uLT5vcGVuRmlsZUxpc3QsIHRsaXN0KSB7Ci0JCWZ1bGxfcGF0aCA9IGJ1aWxk
X3BhdGhfZnJvbV9kZW50cnkoY2ZpbGUtPmRlbnRyeSwgcGFnZSk7Ci0JCWlmIChzdHJzdHIoZnVs
bF9wYXRoLCBwYXRoKSkgewotCQkJaWYgKGRlbGF5ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+ZGVm
ZXJyZWQpKSB7Ci0JCQkJaWYgKGNhbmNlbF9kZWxheWVkX3dvcmsoJmNmaWxlLT5kZWZlcnJlZCkp
IHsKLQkJCQkJc3Bpbl9sb2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVy
cmVkX2xvY2spOwotCQkJCQljaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShjZmlsZSk7Ci0JCQkJCXNw
aW5fdW5sb2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2sp
OwotCi0JCQkJCXRtcF9saXN0ID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IGZpbGVfbGlzdCksIEdG
UF9BVE9NSUMpOwotCQkJCQlpZiAodG1wX2xpc3QgPT0gTlVMTCkKLQkJCQkJCWJyZWFrOwotCQkJ
CQl0bXBfbGlzdC0+Y2ZpbGUgPSBjZmlsZTsKLQkJCQkJbGlzdF9hZGRfdGFpbCgmdG1wX2xpc3Qt
Pmxpc3QsICZmaWxlX2hlYWQpOwotCQkJCX0KLQkJCX0KKwkJaWYgKChjZmlsZS0+ZGVudHJ5ID09
IGRlbnRyeSkgJiYKKwkJICAgIGRlbGF5ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJyZWQp
ICYmCisJCSAgICBjYW5jZWxfZGVsYXllZF93b3JrKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CisJCQlz
cGluX2xvY2soJkNJRlNfSShkX2lub2RlKGNmaWxlLT5kZW50cnkpKS0+ZGVmZXJyZWRfbG9jayk7
CisJCQljaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShjZmlsZSk7CisJCQlzcGluX3VubG9jaygmQ0lG
U19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpLT5kZWZlcnJlZF9sb2NrKTsKKworCQkJdG1wX2xp
c3QgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgZmlsZV9saXN0KSwgR0ZQX0FUT01JQyk7CisJCQlp
ZiAodG1wX2xpc3QgPT0gTlVMTCkKKwkJCQlicmVhazsKKwkJCXRtcF9saXN0LT5jZmlsZSA9IGNm
aWxlOworCQkJbGlzdF9hZGRfdGFpbCgmdG1wX2xpc3QtPmxpc3QsICZmaWxlX2hlYWQpOwogCQl9
CiAJfQogCXNwaW5fdW5sb2NrKCZ0Y29uLT5vcGVuX2ZpbGVfbG9jayk7CkBAIC04NjgsNyArODYz
LDYgQEAgY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlX3VuZGVyX2RlbnRyeShzdHJ1Y3QgY2lmc190
Y29uICp0Y29uLCBjb25zdCBjaGFyICpwYXRoKQogCQlsaXN0X2RlbCgmdG1wX2xpc3QtPmxpc3Qp
OwogCQlrZnJlZSh0bXBfbGlzdCk7CiAJfQotCWZyZWVfZGVudHJ5X3BhdGgocGFnZSk7CiB9CiAK
IC8qCi0tIAoyLjQ4LjEKCg==
--000000000000bbf2c6063f095796--
