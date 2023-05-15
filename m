Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7C5C7EE24
	for <linux-cifs@archiver.kernel.org>; Mon, 15 May 2023 20:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbjEOUtg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 May 2023 16:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjEOUtf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 15 May 2023 16:49:35 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFB67EDA
        for <linux-cifs@vger.kernel.org>; Mon, 15 May 2023 13:49:34 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-ba724ec3b06so6476845276.2
        for <linux-cifs@vger.kernel.org>; Mon, 15 May 2023 13:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684183773; x=1686775773;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S1e7tWy7LrpqiWScMwgxEKZa+vUpe/ORZ55MwWzEBwA=;
        b=W7yU/CBHV8xQ8xw7RsCp5lgyjlyM6oXnx9X+K4Mg5lT00igJZQjGlA1BshvSFJNw6s
         cE95SGqRu35iG7U8i+BGSKulcOGGzIpfHn3rFZhskSnLLSKVPQrTkc2JDDEDHgzwQ3Tx
         XOucanM5Rn4AfFr2wGcF5PTH3mbRVKTCkJVyt8APKCpPQJp8/ZffMoWe8EfNEymuLFsT
         14GuktA3Rli7d8eAzA8/LcBS3eb7TulWfcak+zjWmoHAFZtMPoR0fPgApT90jT9vV0oy
         Act4ZNqxJ4xTCd9D3mvT4BQFvNrdDbvCycOSk7bY//AE746ZMCD4LXF0NVw6eMTBScRu
         Y+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684183773; x=1686775773;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S1e7tWy7LrpqiWScMwgxEKZa+vUpe/ORZ55MwWzEBwA=;
        b=I8OJlQwbTpw0NcdEno6zcg787YamDIPN+u0cvv4PMZf8sPFsNwnz0Fg/GTPa6ScUfM
         nbDX+958Tb0b95/6SVAWU1IYqmy5efqQDp3NPER3/pC5ky3VJJCWxyLWHcTQaNsJIpYQ
         pnHq3cgnXzYBOy8a4rRMYITlfLp4N4zSVlCQeqiqt9eOwUE8yyQIkGZEB7QB8c1htrK9
         K5t6O61+RNRnSLf3/KsDs4JLOh8D+eEPlxuZg3SsfD0LmHVQCxw5Sp1psV9wkr7xRa0H
         /74sWVza05yKJGvb995XU+nYPUaGW2fKC65fhPX4GX7K7ld9ebaJyFG1lyFxz3cOTekb
         AIHg==
X-Gm-Message-State: AC+VfDwgi2Poa+ZuNJQ0eTDu+urUvWL4Kedm5DtqF9eheUY2+3nvJaj7
        qehOyhje7Kj1xSW4IiqlP/XoYiLLL4iwY93HafY=
X-Google-Smtp-Source: ACHHUZ5kA3vL88oYo6gx2f0Z/SOQpWL68fxA+yeSS/68DDtp8khuQiGDeRVHLfx1VWQCVEDCF3QTHHfuimhUXYtF6Vk=
X-Received: by 2002:a0d:cc4b:0:b0:55a:3420:5adc with SMTP id
 o72-20020a0dcc4b000000b0055a34205adcmr33227729ywd.51.1684183772963; Mon, 15
 May 2023 13:49:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230508190103.601678-1-bharathsm.hsk@gmail.com>
In-Reply-To: <20230508190103.601678-1-bharathsm.hsk@gmail.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Tue, 16 May 2023 02:19:21 +0530
Message-ID: <CAGypqWzMe3SiqQSDPUSvNauXzmzATNyVWzOKyOY1pwU49M=exw@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Close all deferred handles of inode in case of
 handle lease break
To:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        nspmangalore@gmail.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Bharath SM <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000086ac5205fbc197d0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000086ac5205fbc197d0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Attached updated patch with expanded commit message.

On Tue, May 9, 2023 at 12:32=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Oplock break may occur for different file handle than the deferred handle=
.
> Check for inode deferred closes list, if it's not empty then close all th=
e
> deferred handles of inode.
>
> Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferre=
d close handles for the same file.")
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/cifs/file.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 791a12575109..260d5ec878e8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4886,8 +4886,6 @@ void cifs_oplock_break(struct work_struct *work)
>         struct TCP_Server_Info *server =3D tcon->ses->server;
>         int rc =3D 0;
>         bool purge_cache =3D false;
> -       struct cifs_deferred_close *dclose;
> -       bool is_deferred =3D false;
>
>         wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
>                         TASK_UNINTERRUPTIBLE);
> @@ -4928,14 +4926,9 @@ void cifs_oplock_break(struct work_struct *work)
>          * file handles but cached, then schedule deferred close immediat=
ely.
>          * So, new open will not use cached handle.
>          */
> -       spin_lock(&CIFS_I(inode)->deferred_lock);
> -       is_deferred =3D cifs_is_deferred_close(cfile, &dclose);
> -       spin_unlock(&CIFS_I(inode)->deferred_lock);
>
> -       if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
> -                       cfile->deferred_close_scheduled && delayed_work_p=
ending(&cfile->deferred)) {
> +       if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_c=
loses))
>                 cifs_close_deferred_file(cinode);
> -       }
>
>         /*
>          * releasing stale oplock after recent reconnect of smb session u=
sing
> --
> 2.34.1
>

--00000000000086ac5205fbc197d0
Content-Type: application/octet-stream; 
	name="0001-SMB3-Close-all-deferred-handles-of-inode-in-case-of-.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Close-all-deferred-handles-of-inode-in-case-of-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lhpbgsvb0>
X-Attachment-Id: f_lhpbgsvb0

RnJvbSAzOTg2ZGJlZmNhNmJkNWJmN2Y1MjE3MjdlYzlmNjk1OWRjY2FhN2QwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogV2VkLCAzIE1heSAyMDIzIDE0OjM4OjM1ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gU01C
MzogQ2xvc2UgYWxsIGRlZmVycmVkIGhhbmRsZXMgb2YgaW5vZGUgaW4gY2FzZSBvZiBoYW5kbGUK
IGxlYXNlIGJyZWFrCgpPcGxvY2sgYnJlYWsgbWF5IG9jY3VyIGZvciBkaWZmZXJlbnQgZmlsZSBo
YW5kbGUgdGhhbiB0aGUgZGVmZXJyZWQKaGFuZGxlLiBDaGVjayBmb3IgaW5vZGUgZGVmZXJyZWQg
Y2xvc2VzIGxpc3QsIGlmIGl0J3Mgbm90IGVtcHR5IHRoZW4KY2xvc2UgYWxsIHRoZSBkZWZlcnJl
ZCBoYW5kbGVzIG9mIGlub2RlIGJlY2F1c2Ugd2Ugc2hvdWxkIG5vdCBjYWNoZQpoYW5kbGVzIGlm
IHdlIGRvbnQgaGF2ZSBoYW5kbGUgbGVhc2UuCgpFZzogSWYgb3BlbmZpbGVsaXN0IGhhcyBvbmUg
ZGVmZXJyZWQgZmlsZSBoYW5kbGUgYW5kIGFub3RoZXIgb3BlbiBmaWxlCmhhbmRsZSBmcm9tIGFw
cCBmb3IgYSBzYW1lIGZpbGUsIHRoZW4gb24gYSBsZWFzZSBicmVhayB3ZSBjaG9vc2UgdGhlCmZp
cnN0IGhhbmRsZSBpbiBvcGVuZmlsZSBsaXN0LiBUaGUgZmlyc3QgaGFuZGxlIGluIGxpc3QgY2Fu
IGJlIGRlZmVycmVkCmhhbmRsZSBvciBhY3R1YWwgb3BlbiBmaWxlIGhhbmRsZSBmcm9tIGFwcC4g
SW4gY2FzZSBpZiBpdCBpcyBhY3R1YWwgb3BlbgpoYW5kbGUgdGhlbiB0b2RheSwgd2UgZG9uJ3Qg
Y2xvc2UgZGVmZXJyZWQgaGFuZGxlcyBpZiB3ZSBsb3NlIGhhbmRsZSBsZWFzZQpvbiBhIGZpbGUu
IFByb2JsZW0gd2l0aCB0aGlzIGlzLCBsYXRlciBpZiBhcHAgZGVjaWRlcyB0byBjbG9zZSB0aGUg
ZXhpc3RpbmcKb3BlbiBoYW5kbGUgdGhlbiB3ZSBzdGlsbCBiZSBjYWNoaW5nIGRlZmVycmVkIGhh
bmRsZXMgdW50aWwgZGVmZXJyZWQgY2xvc2UKdGltZW91dC4gTGVhdmluZyBvcGVuIGhhbmRsZSBt
YXkgcmVzdWx0IGluIHNoYXJpbmcgdmlvbGF0aW9uIHdoZW4gd2luZG93cwpjbGllbnQgdHJpZXMg
dG8gb3BlbiBhIGZpbGUgd2l0aCBsaW1pdGVkIGZpbGUgc2hhcmUgYWNjZXNzLgoKU28gd2Ugc2hv
dWxkIGNoZWNrIGZvciBkZWZlcnJlZCBsaXN0IG9mIGlub2RlIGFuZCB3YWxrIHRocm91Z2ggdGhl
IGxpc3Qgb2YKZGVmZXJyZWQgZmlsZXMgaW4gaW5vZGUgYW5kIGNsb3NlIGFsbCBkZWZlcnJlZCBm
aWxlcy4KCkZpeGVzOiA5ZTMxNjc4ZmI0MDMgKCJTTUIzOiBmaXggbGVhc2UgYnJlYWsgdGltZW91
dCB3aGVuIG11bHRpcGxlIGRlZmVycmVkIGNsb3NlIGhhbmRsZXMgZm9yIHRoZSBzYW1lIGZpbGUu
IikKU2lnbmVkLW9mZi1ieTogQmhhcmF0aCBTTSA8YmhhcmF0aHNtQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvY2lmcy9maWxlLmMgfCA5ICstLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMv
Y2lmcy9maWxlLmMKaW5kZXggNzkxYTEyNTc1MTA5Li4yNjBkNWVjODc4ZTggMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmlsZS5jCkBAIC00ODg2LDggKzQ4ODYsNiBA
QCB2b2lkIGNpZnNfb3Bsb2NrX2JyZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAlzdHJ1
Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSB0Y29uLT5zZXMtPnNlcnZlcjsKIAlpbnQgcmMg
PSAwOwogCWJvb2wgcHVyZ2VfY2FjaGUgPSBmYWxzZTsKLQlzdHJ1Y3QgY2lmc19kZWZlcnJlZF9j
bG9zZSAqZGNsb3NlOwotCWJvb2wgaXNfZGVmZXJyZWQgPSBmYWxzZTsKIAogCXdhaXRfb25fYml0
KCZjaW5vZGUtPmZsYWdzLCBDSUZTX0lOT0RFX1BFTkRJTkdfV1JJVEVSUywKIAkJCVRBU0tfVU5J
TlRFUlJVUFRJQkxFKTsKQEAgLTQ5MjgsMTQgKzQ5MjYsOSBAQCB2b2lkIGNpZnNfb3Bsb2NrX2Jy
ZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkgKiBmaWxlIGhhbmRsZXMgYnV0IGNhY2hl
ZCwgdGhlbiBzY2hlZHVsZSBkZWZlcnJlZCBjbG9zZSBpbW1lZGlhdGVseS4KIAkgKiBTbywgbmV3
IG9wZW4gd2lsbCBub3QgdXNlIGNhY2hlZCBoYW5kbGUuCiAJICovCi0Jc3Bpbl9sb2NrKCZDSUZT
X0koaW5vZGUpLT5kZWZlcnJlZF9sb2NrKTsKLQlpc19kZWZlcnJlZCA9IGNpZnNfaXNfZGVmZXJy
ZWRfY2xvc2UoY2ZpbGUsICZkY2xvc2UpOwotCXNwaW5fdW5sb2NrKCZDSUZTX0koaW5vZGUpLT5k
ZWZlcnJlZF9sb2NrKTsKIAotCWlmICghQ0lGU19DQUNIRV9IQU5ETEUoY2lub2RlKSAmJiBpc19k
ZWZlcnJlZCAmJgotCQkJY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZCAmJiBkZWxheWVk
X3dvcmtfcGVuZGluZygmY2ZpbGUtPmRlZmVycmVkKSkgeworCWlmICghQ0lGU19DQUNIRV9IQU5E
TEUoY2lub2RlKSAmJiAhbGlzdF9lbXB0eSgmY2lub2RlLT5kZWZlcnJlZF9jbG9zZXMpKQogCQlj
aWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoY2lub2RlKTsKLQl9CiAKIAkvKgogCSAqIHJlbGVhc2lu
ZyBzdGFsZSBvcGxvY2sgYWZ0ZXIgcmVjZW50IHJlY29ubmVjdCBvZiBzbWIgc2Vzc2lvbiB1c2lu
ZwotLSAKMi4zNC4xCgo=
--00000000000086ac5205fbc197d0--
