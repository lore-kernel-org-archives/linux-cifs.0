Return-Path: <SRS0=PPE7=UJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5BAC43218
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 19:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BEC9206E0
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 19:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbeyrCeD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfFJTTS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jun 2019 15:19:18 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]:35176 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbfFJTTS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jun 2019 15:19:18 -0400
Received: by mail-lj1-f170.google.com with SMTP id x25so4473352ljh.2
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2019 12:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3c8rhFJE14sMpTTc89Hz57tyhVCoAB2/e1RKeHiyLVI=;
        b=GbeyrCeD+ICYA9A1mM+GsGYjoYY2ApUxmWtx4k5c8rXjgjRrzNDqI/lKQXvGbOvInk
         1Bs5QQZC2oYXrVikNbLPGrjHBYMBnoTP8E+KTBIffL+G4o5b6jEiHqwD3UwmSVWuzbmx
         Du7I5jMhKvcGPgeLxIddG6AF2g1ACr9Lk7yah/5yHzgVhO9D/XLiGkK2PLgYQeR0vPXu
         JLC1ZJ31kNxn+o8+vDZKASKLFkjdLIYfT2p7rFfACXicHbJuS+ewrI5a8M6fzl5rr2wA
         Ij8fW4BrrUnNIwJU3jWc20HiJkHOL45xLFDhSsjbMqtP1exKchpcrjbfWBO8fhWx66QA
         IuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3c8rhFJE14sMpTTc89Hz57tyhVCoAB2/e1RKeHiyLVI=;
        b=Ol3sLa1ff312k4zo4yQDV0ytT4P8KqwKhG/zcIp99R8yVDNXd7OYYnlpfvmZvhS5Us
         s2pZbwpYGyGxwqUJCrSegVoEzygW8fyGcgy4FHMkt8b+5q9tXauNfB+9SCglf95XRaXN
         ZqSGG91Eec2Yr48GC68mGSYkEiLfN3tWFxGUoNlmNeTqSV3CPQWi1C0d7zh1uxQjszwU
         SMvaaBQuf5HX6YYfwCYNxEwB3Bq4OxDiAMXWTQjkkVAvn8lN/xgPmVWLLMejRdVjb/gO
         ouQlYGRH4xzew3LqDX5t+K+N4RMjSF5f8XYMVS4L394uHKdNRdLdpPITBego2z0BkBCJ
         xo7A==
X-Gm-Message-State: APjAAAX+Zl/hMzCMBvZc4Ff9H0r7H4ihJl8yRFwFZQ2KoHLB1gx99Mty
        09tNxxaFYH56OToruC13jOD1/hMZ6AKqQWw9ww==
X-Google-Smtp-Source: APXvYqwrLQ7AV7CFM9xhrtFsTzHPL7DUncCaEc2S0ccmGZviuhfUK+VAeEptKTKO1dAwjUSxc4aufapVYMJkZqawP2c=
X-Received: by 2002:a2e:a318:: with SMTP id l24mr25289379lje.36.1560194356061;
 Mon, 10 Jun 2019 12:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Mon, 10 Jun 2019 12:19:04 -0700
Message-ID: <CAKywueTTp_jQqhND0gpLhffNeXudPUjkWHGEze33+=6oVWhLpw@mail.gmail.com>
Subject: Re: [SMB3.1.1] Faster crypto (GCM) for Linux kernel SMB3.1.1 mounts
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 7 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 13:23, Steve French=
 via samba-technical
<samba-technical@lists.samba.org>:
>
> I am seeing more than double the performance of copy to Samba on
> encrypted mount with this two patch set, and 80%+ faster on copy from
> Samba server (when running Ralph's GCM capable experimental branch of
> Samba)
>
> Patches to update the kernel client (cifs.ko) attached:
>
> --
> Thanks,
>
> Steve


--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3324,7 +3324,7 @@ smb2_dir_needs_close(struct cifsFileInfo *cfile)

 static void
 fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_le=
n,
-                  struct smb_rqst *old_rq)
+                  struct smb_rqst *old_rq, struct TCP_Server_Info *server)
 {
        struct smb2_sync_hdr *shdr =3D
                        (struct smb2_sync_hdr *)old_rq->rq_iov[0].iov_base;
@@ -3333,7 +3333,10 @@ fill_transform_hdr(struct smb2_transform_hdr
*tr_hdr, unsigned int orig_len,
        tr_hdr->ProtocolId =3D SMB2_TRANSFORM_PROTO_NUM;
        tr_hdr->OriginalMessageSize =3D cpu_to_le32(orig_len);
        tr_hdr->Flags =3D cpu_to_le16(0x01);
-       get_random_bytes(&tr_hdr->Nonce, SMB3_AES128CCM_NONCE);
+       if (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES128_GCM)

We only use server->cipher_type here and below. Let's pass just this
integer instead of whole server pointer to fill_transform_hdr then

+               get_random_bytes(&tr_hdr->Nonce, SMB3_AES128GCM_NONCE);
+       else
+               get_random_bytes(&tr_hdr->Nonce, SMB3_AES128CCM_NONCE);
        memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
 }

@@ -3491,8 +3494,13 @@ crypt_message(struct TCP_Server_Info *server,
int num_rqst,
                rc =3D -ENOMEM;
                goto free_sg;
        }
-       iv[0] =3D 3;
-       memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES128CCM_NONCE);
+
+       if (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES128_GCM)
+               memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES128GCM_NONCE);
+       else {
+               iv[0] =3D 3;
+               memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES128CCM_NONCE)=
;
+       }

        aead_request_set_crypt(req, sg, sg, crypt_len, iv);
        aead_request_set_ad(req, assoc_data_len);

Other than the note above looks good.

--
Best regards,
Pavel Shilovskiy
