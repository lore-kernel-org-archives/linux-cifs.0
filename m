Return-Path: <SRS0=TF3n=VP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECB9C7618F
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 17:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5055C2083B
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 17:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jyyVhdY1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfGRRhP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Jul 2019 13:37:15 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38717 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRRhO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Jul 2019 13:37:14 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so28175799ljg.5
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jul 2019 10:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zvmK4oo7UnZcq1oY+8Vc0sIfpk/4xoEF0mrsMnZnEw8=;
        b=jyyVhdY1qGbvbJgQcBEcWktTO8sQjc1vMefUshoSF00IFFWQ1vj52M2bF6WjFwbJKT
         PSJF97LDbN5l/NSrA2f8V04lYjm4frXXdtJUZIdBiLWoLrqT1prRvagiNSUev0n/zXfC
         r/8KoWGjPGTg3AFT8pi1chsbdG3hGeRBO06o3tSbn1GObCfa50GC/BHIgwcZguQKPy0m
         wnPak9zRjsPw1Xy7ahJ1cpzT/HOsRc7dC+GZJfsmglJwZxdVYeFJ9m9zoYCkgdZnKZcT
         Q7efLwDimY0kAEHtGu3fv7Vjcevwafcg5sXmo5BipmIzzv9HCG2EMmOhQrp0ayPfGZG+
         dHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zvmK4oo7UnZcq1oY+8Vc0sIfpk/4xoEF0mrsMnZnEw8=;
        b=S6YiJkUwLDoOsHO0NvdyDb06hFOnb2aznfn2/ZPqTugXoSjoWvNeTB9U19kq2eirQa
         Judrm3BfKcc86I5nQA222iDst2vU9f8QqKgL386Mw8GwfUgUkxyiS/RCBPqhKz+aTemz
         LeWiY5vhGOH7zc778DE06cf/tn6FSYzADVd+YI7c/rVO63U5UxOXU/ZmKP4X1TaiI3GW
         zmMSzQXs8knUh5Shw0qhutlv/AjVwj50F9mTo1DwyuSy4muMMOohjchQRF709cTy4zfC
         nFcx98m9cL9h9jw5N+SZ15s3S1CRC8FvxEW8SkCJHtTWFchJGjklZIC0DnNuGGTkM6z8
         RuIw==
X-Gm-Message-State: APjAAAUOtzzvaChI22gP8y2/cBD+n/0DMGhezxic9qiNZdnTniX6ev58
        5MUIUOD9gNM4RsbG6/JmK3wEZxIlUic4ZwrfYQ==
X-Google-Smtp-Source: APXvYqwY5NELv0ogOElNbG3TOwFSrm84E6qf5D2pYxqwKkJOaxzod5q3T6KGG29WZeZBEeJx1ap3JbuDl6gGIO5+pdQ=
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr17369880ljq.184.1563471432791;
 Thu, 18 Jul 2019 10:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtn5SyUao9Y3f-_ubqgSV8t3RSj2fzAR9bE5ZQQ5dFcRQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtn5SyUao9Y3f-_ubqgSV8t3RSj2fzAR9bE5ZQQ5dFcRQ@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Thu, 18 Jul 2019 10:37:00 -0700
Message-ID: <CAKywueQEk84q-3PNNvGQNYLc9DXfygy+75LNBfyTKRo-iFvmGw@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Speed up open by skipping query FILE_INTERNAL_INFORMATION
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

index 54bffb2a1786..e6a1fc72018f 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -88,14 +88,20 @@ smb2_open_file(const unsigned int xid, struct
cifs_open_parms *oparms,
  }

  if (buf) {
- /* open response does not have IndexNumber field - get it */
- rc =3D SMB2_get_srv_num(xid, oparms->tcon, fid->persistent_fid,
+ /* if open response does not have IndexNumber field - get it */
+ if (smb2_data->IndexNumber =3D=3D 0) {

What's about a server returning 0 for the IndexNumber?

- if (rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
- *oplock =3D smb2_parse_lease_state(server, rsp,
- &oparms->fid->epoch,
- oparms->fid->lease_key);
- else
+
+ *oplock =3D smb2_parse_contexts(server, rsp, &oparms->fid->epoch,
+       oparms->fid->lease_key,
+       buf);
+ if (*oplock =3D=3D 0) /* no lease open context found */
  *oplock =3D rsp->OplockLevel;

oplock being 0 here probably means that the lease state which is
granted is NONE. You still need to keep if (rsp->OplockLevel =3D=3D
SMB2_OPLOCK_LEVEL_LEASE) gate.

 /* See MS-SMB2 2.2.14.2.9 */
 struct on_disk_id {

Please prefix the structure name with "create_".

Best regards,
Pavel Shilovskiy

=D1=87=D1=82, 18 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 00:43, Steve Frenc=
h via samba-technical
<samba-technical@lists.samba.org>:
>
> Now that we have the qfid context returned on open we can cut 1/3 of
> the traffic on open by not sending the query FILE_INTERNAL_INFORMATION
>
>
>
> --
> Thanks,
>
> Steve
