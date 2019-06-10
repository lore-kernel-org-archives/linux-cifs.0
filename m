Return-Path: <SRS0=PPE7=UJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4733EC43218
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 22:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C6F2086A
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 22:34:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQ4y7H8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390301AbfFJWeX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jun 2019 18:34:23 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40632 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388328AbfFJWeW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jun 2019 18:34:22 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so4212895pla.7
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2019 15:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LltCkFa1Ze/Y4zpwPdj13U8xPludj7nW69ZTQKnjQ/c=;
        b=DQ4y7H8NAoFD1uMt0X6/xqy9D9T856vOQJUZBX8kJkf4swAypCn0w+VqY5un+ITg9X
         vNJknlUEfDK89i7bKKWTtVd9e8EEhqgYU3nbbHTU4wmsYFrTtCQ4dtDD0V6m+1aG1arY
         4ZkdCTIfoJ89EoW9/BEIlNdj7YT/u5aL2oELQMKjRyipeXQaQuki3yIcz17QhrsNjk9n
         cXnRkCZ2THQP91+vDUgzYrI8rHL6EjpYP7U9OFFwRJmtrrGLFzJjXHsxKJomh0es0MW8
         NARuhGfH9mYOFa6UUHBZhGgIsoVtPs8ffbVUGKscsS+JKF5wbUnk+3kwYKfoGUjmbdRc
         TG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LltCkFa1Ze/Y4zpwPdj13U8xPludj7nW69ZTQKnjQ/c=;
        b=DhghvzyUL3Sf5IvUCe8dxj2RWkXuQ+Lfb9Y1RDSbVNLyHbe3wzIXdf7BtT+T1cgoVk
         3M4hnPiXpIeDuDIlqXDlpom8eMw1TNvVX3ddptr1HmB1tu7L71VZtfA+dK0+QQzwRQkh
         EX8PvVVnrabJ8hGhY+lQAe75ODwHyMrvn1PXw3SoLf9mKKL0Vb63J0ZuBN6JDjNTGGNW
         9gl9S41INHtvEGgeftUcnSvXxA9PGNqS4n7a0zb5AJuMwWhnKREK9FhTJj1w1vqW7zPQ
         TPqXrAxnyGWITy1kpQMGaNaLBRmvhpCeLPM7C9obZR7tceoUe4GV00gydx2IoSzi2249
         hYdg==
X-Gm-Message-State: APjAAAUMkwvDxuZY6VWX/4ADoto1jMt5DBwnk5qGQ6/PRnS9uoMfWNEg
        s6hhtUrFEE4Uzk4EwhZ9siPsTX/Lli5dX7q0qVA=
X-Google-Smtp-Source: APXvYqw4d3HTRzqmMNVNij6rrvTWf9IaW5h2WQFQYqGWufziPztL/xWqsl2ETT6Z4nKxlXzA0ycmZ+3+sj6/avkZOrY=
X-Received: by 2002:a17:902:f087:: with SMTP id go7mr46693130plb.330.1560206061580;
 Mon, 10 Jun 2019 15:34:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
 <CAKywueTTp_jQqhND0gpLhffNeXudPUjkWHGEze33+=6oVWhLpw@mail.gmail.com>
In-Reply-To: <CAKywueTTp_jQqhND0gpLhffNeXudPUjkWHGEze33+=6oVWhLpw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 Jun 2019 17:34:09 -0500
Message-ID: <CAH2r5mvo5YbDd5Pqu6XcMBAW+4rPX0ZZU9RBj=NWLEFTp4L+-w@mail.gmail.com>
Subject: Re: [SMB3.1.1] Faster crypto (GCM) for Linux kernel SMB3.1.1 mounts
To:     Pavel Shilovsky <pavel.shilovsky@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000146d99058affc878"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000146d99058affc878
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated the patch with Pavel's suggestion and added reviewed by and
repushed to cifs-2.6.git for-next.

On Mon, Jun 10, 2019 at 2:19 PM Pavel Shilovsky
<pavel.shilovsky@gmail.com> wrote:
>
> =D0=BF=D1=82, 7 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 13:23, Steve Fren=
ch via samba-technical
> <samba-technical@lists.samba.org>:
> >
> > I am seeing more than double the performance of copy to Samba on
> > encrypted mount with this two patch set, and 80%+ faster on copy from
> > Samba server (when running Ralph's GCM capable experimental branch of
> > Samba)
> >
> > Patches to update the kernel client (cifs.ko) attached:
> >
> > --
> > Thanks,
> >
> > Steve
>
>
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3324,7 +3324,7 @@ smb2_dir_needs_close(struct cifsFileInfo *cfile)
>
>  static void
>  fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_=
len,
> -                  struct smb_rqst *old_rq)
> +                  struct smb_rqst *old_rq, struct TCP_Server_Info *serve=
r)
>  {
>         struct smb2_sync_hdr *shdr =3D
>                         (struct smb2_sync_hdr *)old_rq->rq_iov[0].iov_bas=
e;
> @@ -3333,7 +3333,10 @@ fill_transform_hdr(struct smb2_transform_hdr
> *tr_hdr, unsigned int orig_len,
>         tr_hdr->ProtocolId =3D SMB2_TRANSFORM_PROTO_NUM;
>         tr_hdr->OriginalMessageSize =3D cpu_to_le32(orig_len);
>         tr_hdr->Flags =3D cpu_to_le16(0x01);
> -       get_random_bytes(&tr_hdr->Nonce, SMB3_AES128CCM_NONCE);
> +       if (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES128_GCM)
>
> We only use server->cipher_type here and below. Let's pass just this
> integer instead of whole server pointer to fill_transform_hdr then
>
> +               get_random_bytes(&tr_hdr->Nonce, SMB3_AES128GCM_NONCE);
> +       else
> +               get_random_bytes(&tr_hdr->Nonce, SMB3_AES128CCM_NONCE);
>         memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
>  }
>
> @@ -3491,8 +3494,13 @@ crypt_message(struct TCP_Server_Info *server,
> int num_rqst,
>                 rc =3D -ENOMEM;
>                 goto free_sg;
>         }
> -       iv[0] =3D 3;
> -       memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES128CCM_NONCE);
> +
> +       if (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES128_GCM)
> +               memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES128GCM_NONCE);
> +       else {
> +               iv[0] =3D 3;
> +               memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES128CCM_NONC=
E);
> +       }
>
>         aead_request_set_crypt(req, sg, sg, crypt_len, iv);
>         aead_request_set_ad(req, assoc_data_len);
>
> Other than the note above looks good.
>
> --
> Best regards,
> Pavel Shilovskiy



--=20
Thanks,

Steve

--000000000000146d99058affc878
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0006-Add-SMB3.1.1-GCM-crypto-to-the-encrypt-and-decrypt-f.patch"
Content-Disposition: attachment; 
	filename="0006-Add-SMB3.1.1-GCM-crypto-to-the-encrypt-and-decrypt-f.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jwqydzbw0>
X-Attachment-Id: f_jwqydzbw0

RnJvbSAxMjBhZTg1YzBlMDQxZDVjNmVkMmNhNWFkYjM3MDIyNmJkZDk4NGUxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgNyBKdW4gMjAxOSAxNToxNjoxMCAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggNi83
XSBBZGQgU01CMy4xLjEgR0NNIGNyeXB0byB0byB0aGUgZW5jcnlwdCBhbmQgZGVjcnlwdAogZnVu
Y3Rpb25zCgpTTUIzLjEuMSBHQ00gcGVyZm9ybXMgbXVjaCBiZXR0ZXIgdGhhbiB0aGUgb2xkZXIg
Q0NNIGRlZmF1bHQ6Cm1vcmUgdGhhbiB0d2ljZSBhcyBmYXN0IGluIHRoZSB3cml0ZSBwYXRjaCAo
Y29weSB0byB0aGUgU2FtYmEKc2VydmVyIG9uIGxvY2FsaG9zdCBmb3IgZXhhbXBsZSkgYW5kIDgw
JSBmYXN0ZXIgb24gdGhlIHJlYWQKcGF0Y2ggKGNvcHkgZnJvbSB0aGUgc2VydmVyKS4KClNpZ25l
ZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQt
Ynk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IFBh
dmVsIFNoaWxvdnNreSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMm9w
cy5jICAgICAgIHwgMTggKysrKysrKysrKysrKy0tLS0tCiBmcy9jaWZzL3NtYjJ0cmFuc3BvcnQu
YyB8IDEwICsrKysrKysrLS0KIDIgZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgNyBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21i
Mm9wcy5jCmluZGV4IDdmYTk1OTI5YzhmYy4uYThlMjhiOTU1YzY5IDEwMDY0NAotLS0gYS9mcy9j
aWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMzMyNCw3ICszMzI0LDcg
QEAgc21iMl9kaXJfbmVlZHNfY2xvc2Uoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUpCiAKIHN0
YXRpYyB2b2lkCiBmaWxsX3RyYW5zZm9ybV9oZHIoc3RydWN0IHNtYjJfdHJhbnNmb3JtX2hkciAq
dHJfaGRyLCB1bnNpZ25lZCBpbnQgb3JpZ19sZW4sCi0JCSAgIHN0cnVjdCBzbWJfcnFzdCAqb2xk
X3JxKQorCQkgICBzdHJ1Y3Qgc21iX3Jxc3QgKm9sZF9ycSwgX19sZTE2IGNpcGhlcl90eXBlKQog
ewogCXN0cnVjdCBzbWIyX3N5bmNfaGRyICpzaGRyID0KIAkJCShzdHJ1Y3Qgc21iMl9zeW5jX2hk
ciAqKW9sZF9ycS0+cnFfaW92WzBdLmlvdl9iYXNlOwpAQCAtMzMzMyw3ICszMzMzLDEwIEBAIGZp
bGxfdHJhbnNmb3JtX2hkcihzdHJ1Y3Qgc21iMl90cmFuc2Zvcm1faGRyICp0cl9oZHIsIHVuc2ln
bmVkIGludCBvcmlnX2xlbiwKIAl0cl9oZHItPlByb3RvY29sSWQgPSBTTUIyX1RSQU5TRk9STV9Q
Uk9UT19OVU07CiAJdHJfaGRyLT5PcmlnaW5hbE1lc3NhZ2VTaXplID0gY3B1X3RvX2xlMzIob3Jp
Z19sZW4pOwogCXRyX2hkci0+RmxhZ3MgPSBjcHVfdG9fbGUxNigweDAxKTsKLQlnZXRfcmFuZG9t
X2J5dGVzKCZ0cl9oZHItPk5vbmNlLCBTTUIzX0FFUzEyOENDTV9OT05DRSk7CisJaWYgKGNpcGhl
cl90eXBlID09IFNNQjJfRU5DUllQVElPTl9BRVMxMjhfR0NNKQorCQlnZXRfcmFuZG9tX2J5dGVz
KCZ0cl9oZHItPk5vbmNlLCBTTUIzX0FFUzEyOEdDTV9OT05DRSk7CisJZWxzZQorCQlnZXRfcmFu
ZG9tX2J5dGVzKCZ0cl9oZHItPk5vbmNlLCBTTUIzX0FFUzEyOENDTV9OT05DRSk7CiAJbWVtY3B5
KCZ0cl9oZHItPlNlc3Npb25JZCwgJnNoZHItPlNlc3Npb25JZCwgOCk7CiB9CiAKQEAgLTM0OTEs
OCArMzQ5NCwxMyBAQCBjcnlwdF9tZXNzYWdlKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZl
ciwgaW50IG51bV9ycXN0LAogCQlyYyA9IC1FTk9NRU07CiAJCWdvdG8gZnJlZV9zZzsKIAl9Ci0J
aXZbMF0gPSAzOwotCW1lbWNweShpdiArIDEsIChjaGFyICopdHJfaGRyLT5Ob25jZSwgU01CM19B
RVMxMjhDQ01fTk9OQ0UpOworCisJaWYgKHNlcnZlci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNS
WVBUSU9OX0FFUzEyOF9HQ00pCisJCW1lbWNweShpdiwgKGNoYXIgKil0cl9oZHItPk5vbmNlLCBT
TUIzX0FFUzEyOEdDTV9OT05DRSk7CisJZWxzZSB7CisJCWl2WzBdID0gMzsKKwkJbWVtY3B5KGl2
ICsgMSwgKGNoYXIgKil0cl9oZHItPk5vbmNlLCBTTUIzX0FFUzEyOENDTV9OT05DRSk7CisJfQog
CiAJYWVhZF9yZXF1ZXN0X3NldF9jcnlwdChyZXEsIHNnLCBzZywgY3J5cHRfbGVuLCBpdik7CiAJ
YWVhZF9yZXF1ZXN0X3NldF9hZChyZXEsIGFzc29jX2RhdGFfbGVuKTsKQEAgLTM1OTIsNyArMzYw
MCw3IEBAIHNtYjNfaW5pdF90cmFuc2Zvcm1fcnEoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2Vy
dmVyLCBpbnQgbnVtX3Jxc3QsCiAJfQogCiAJLyogZmlsbCB0aGUgMXN0IGlvdiB3aXRoIGEgdHJh
bnNmb3JtIGhlYWRlciAqLwotCWZpbGxfdHJhbnNmb3JtX2hkcih0cl9oZHIsIG9yaWdfbGVuLCBv
bGRfcnEpOworCWZpbGxfdHJhbnNmb3JtX2hkcih0cl9oZHIsIG9yaWdfbGVuLCBvbGRfcnEsIHNl
cnZlci0+Y2lwaGVyX3R5cGUpOwogCiAJcmMgPSBjcnlwdF9tZXNzYWdlKHNlcnZlciwgbnVtX3Jx
c3QsIG5ld19ycSwgMSk7CiAJY2lmc19kYmcoRllJLCAiRW5jcnlwdCBtZXNzYWdlIHJldHVybmVk
ICVkXG4iLCByYyk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYyBiL2ZzL2Np
ZnMvc21iMnRyYW5zcG9ydC5jCmluZGV4IGQxMTgxNTcyNzU4Yi4uMWNjYmNmOWMyYzNiIDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3NtYjJ0cmFuc3Bv
cnQuYwpAQCAtNzM0LDcgKzczNCwxMCBAQCBzbWIzX2NyeXB0b19hZWFkX2FsbG9jYXRlKHN0cnVj
dCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAlzdHJ1Y3QgY3J5cHRvX2FlYWQgKnRmbTsKIAog
CWlmICghc2VydmVyLT5zZWNtZWNoLmNjbWFlc2VuY3J5cHQpIHsKLQkJdGZtID0gY3J5cHRvX2Fs
bG9jX2FlYWQoImNjbShhZXMpIiwgMCwgMCk7CisJCWlmIChzZXJ2ZXItPmNpcGhlcl90eXBlID09
IFNNQjJfRU5DUllQVElPTl9BRVMxMjhfR0NNKQorCQkJdGZtID0gY3J5cHRvX2FsbG9jX2FlYWQo
ImdjbShhZXMpIiwgMCwgMCk7CisJCWVsc2UKKwkJCXRmbSA9IGNyeXB0b19hbGxvY19hZWFkKCJj
Y20oYWVzKSIsIDAsIDApOwogCQlpZiAoSVNfRVJSKHRmbSkpIHsKIAkJCWNpZnNfZGJnKFZGUywg
IiVzOiBGYWlsZWQgdG8gYWxsb2MgZW5jcnlwdCBhZWFkXG4iLAogCQkJCSBfX2Z1bmNfXyk7CkBA
IC03NDQsNyArNzQ3LDEwIEBAIHNtYjNfY3J5cHRvX2FlYWRfYWxsb2NhdGUoc3RydWN0IFRDUF9T
ZXJ2ZXJfSW5mbyAqc2VydmVyKQogCX0KIAogCWlmICghc2VydmVyLT5zZWNtZWNoLmNjbWFlc2Rl
Y3J5cHQpIHsKLQkJdGZtID0gY3J5cHRvX2FsbG9jX2FlYWQoImNjbShhZXMpIiwgMCwgMCk7CisJ
CWlmIChzZXJ2ZXItPmNpcGhlcl90eXBlID09IFNNQjJfRU5DUllQVElPTl9BRVMxMjhfR0NNKQor
CQkJdGZtID0gY3J5cHRvX2FsbG9jX2FlYWQoImdjbShhZXMpIiwgMCwgMCk7CisJCWVsc2UKKwkJ
CXRmbSA9IGNyeXB0b19hbGxvY19hZWFkKCJjY20oYWVzKSIsIDAsIDApOwogCQlpZiAoSVNfRVJS
KHRmbSkpIHsKIAkJCWNyeXB0b19mcmVlX2FlYWQoc2VydmVyLT5zZWNtZWNoLmNjbWFlc2VuY3J5
cHQpOwogCQkJc2VydmVyLT5zZWNtZWNoLmNjbWFlc2VuY3J5cHQgPSBOVUxMOwotLSAKMi4yMC4x
Cgo=
--000000000000146d99058affc878--
