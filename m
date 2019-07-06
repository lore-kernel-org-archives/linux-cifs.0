Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55741C0650E
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 16:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2216020659
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 16:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/etvwM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfGFQez (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Jul 2019 12:34:55 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35439 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfGFQez (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Jul 2019 12:34:55 -0400
Received: by mail-lf1-f67.google.com with SMTP id p197so8182492lfa.2
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jul 2019 09:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2L/BKOCUH/BxqAaoUdyV9miypLog77NEuRxz7kNY9J4=;
        b=d/etvwM42DZagf9atRqu2kMlmy/nxd5tb4dq63AYuugdNax9g0UAeRGsZNcTvFyEdF
         qOtLrlWcKGsb/m6skS+MXLznuWbcJc6PisTfdLCeRAYa+dLZlW6N/56VmISocZ1vB33k
         syMxpQ0QgWzK/l40x/gacBXxfJdgARXvWfnBxxMozNurzDSJO3kxQ/MZGEG0jGfj1bib
         OzOmt3u9APiDQgteskGngcGrB0sRFrzykJX/JanjDrUiBkIdaF6vL1xNzrn2GV28tcWn
         Rd5F4Kh7W1qoakHvCmnA0sgaN0aembgka12xsaY1vLpXLhSfbrIFWrxC6b4qtAqyqOUv
         06Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2L/BKOCUH/BxqAaoUdyV9miypLog77NEuRxz7kNY9J4=;
        b=gK4v/zbf/IAVWpbJqW+8CYpmNkqd/W92zr2A6v1buwuhVtObbqVT1bzDKrghCtLMjZ
         Odq46qpYA+vaviu2wW0WgIZQ/h+X9H/TYFq+aTOxhGCzCe1TTTCY5CnHGSz9+EdS57Il
         3UEf60yee3LoU+Kq67/sUOUXDMDvuGFrJL4bB+CaP+QJHiNETN2rIS/tjQKd5F0Q/TDQ
         NXfuXzrnQ88kVha+h7/Ox/IwSKAV6LH3+P0GvGor6jseeGXmGDeWk7sNyT1yYSCEFzQb
         nPnY1h5QQTrhC4TMfCc5bglTXC+33ohd7PEbLVvneBqwKopL3G9+HDq5XYdBTJp4dPth
         wBKw==
X-Gm-Message-State: APjAAAVtt1CrEoPag8DK7ZGOBh7OxHaMBEs5EerL5NYg6TrOTOxUUtHh
        hOCt3i5gLtR4tID8p4B4qUt4KGD4t9BfM3VtVQ==
X-Google-Smtp-Source: APXvYqwDYi74oX2SkPWZnLY3z8JWBYDcDFLRIZFHI0JBXLG5+Z7+1X4YhP/+DxqyS3p6KkxVxpxA3YAGReQ8vO2wxMA=
X-Received: by 2002:a19:5f46:: with SMTP id a6mr4711827lfj.142.1562430893089;
 Sat, 06 Jul 2019 09:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtb_g1Hx4UPB+5XpSY3Ew_fn=bdjLnpRD=ZQymJxrUw0g@mail.gmail.com>
In-Reply-To: <CAH2r5mtb_g1Hx4UPB+5XpSY3Ew_fn=bdjLnpRD=ZQymJxrUw0g@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Sat, 6 Jul 2019 09:34:41 -0700
Message-ID: <CAKywueQu8idf6120LybjsNwHqy7MOnXMcm=e8ug=UtiU4u0zWA@mail.gmail.com>
Subject: Re: [PATCH] Improve performance of POSIX open - request query disk id
 open context
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Good idea! See some comments below.

When adding new context, the following defines need to be changed:

689 /*
690  * Maximum size of a SMB2_CREATE response is 64 (smb2 header) +
691  * 88 (fixed part of create response) + 520 (path) + 150 (contexts) +
692  * 2 bytes of padding.
693  */
694 #define MAX_SMB2_CREATE_RESPONSE_SIZE 824

and

657 /*
658  * Maximum number of iovs we need for an open/create request.
659  * [0] : struct smb2_create_req
660  * [1] : path
661  * [2] : lease context
662  * [3] : durable context
663  * [4] : posix context
664  * [5] : time warp context
665  * [6] : compound padding
666  */
667 #define SMB2_CREATE_IOV_SIZE 7

+       if (n_iov > 2) {
+               struct create_context *ccontext =3D
+                       (struct create_context *)iov[n_iov-1].iov_base;
+               ccontext->Next =3D cpu_to_le32(iov[n_iov-1].iov_len);
+       }
+       add_query_id_context(iov, &n_iov);

I think we should add a check if iov has enough capacity to keep all
the contexts. Right now it will oops if it wasn't allocated right in
the upper layer.

In general, I think having a complete patch that adds the whole
functionality is better for future git bisect and looks more logical
instead of breaking such small features into parts.

Best regards,
Pavel Shilovskiy

=D0=BF=D1=82, 5 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 23:14, Steve French=
 via samba-technical
<samba-technical@lists.samba.org>:
>
> We can cut the number of roundtrips on open (may also
> help some rename cases as well) by returning the inode
> number in the SMB2 open request itself instead of
> querying it afterwards via a query FILE_INTERNAL_INFO.
> This should significantly improve the performance of
> posix open.
>
> Add SMB2_CREATE_QUERY_ON_DISK_ID create context request
> on open calls so that when server supports this we
> can save a roundtrip for QUERY_INFO on every open.
>
> Follow on patch will add the response processing for
> SMB2_CREATE_QUERY_ON_DISK_ID context and optimize
> smb2_open_file to avoid the extra network roundtrip
> on every posix open. This patch adds the context on
> SMB2/SMB3 open requests.
>
> --
> Thanks,
>
> Steve
