Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE377C83F01
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Aug 2023 15:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjH0Pck (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Aug 2023 11:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjH0Pca (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Aug 2023 11:32:30 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5A4EC
        for <linux-cifs@vger.kernel.org>; Sun, 27 Aug 2023 08:32:28 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-d743a5fe05aso2339094276.2
        for <linux-cifs@vger.kernel.org>; Sun, 27 Aug 2023 08:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693150347; x=1693755147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2mO0qrUD5MSFc1zYHTV1bESvJA5ZYnTSuX5uZplBzuo=;
        b=WnCMxDVw1wC2AIXpFUDwlJIWBZ09Grle6of/dTw4F4rLsuYhN5Tc6isiWfb05/zTwE
         IHa5nVfH+QR0sF6iMAZvTXc3NMNvX8vnTPzNClNqHylNPeD56URy54cpRjPIFiMxP8//
         lGFbxiEQ69UxTTCA4K17xs4DMZ5PJx1P/jb6B8hw//l9fIREcrSTMT+9RhJRXIt56xjy
         q13Nnw6mJa9LtVUe4KqB81nbbAe1XICPaDCV72EM3LJAH3kSZUCNLT0MnLC76sjLFSaf
         6hPDX2uX3ZuXKrmrdD28BibewG5S5fqAEF/HFYT3aIyamSJlhQoXS3hxXZxonSaL6Oeq
         JBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693150347; x=1693755147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mO0qrUD5MSFc1zYHTV1bESvJA5ZYnTSuX5uZplBzuo=;
        b=EpVW3qUuau6Ndh6uO9hoP0UtCELzbg91o5Ul5KcBGnIiRLV97mXU5fEOkO02Gdy7h3
         6w5mU4swuHd56Rb1XCmJ9H6zTNMhFKg6LcR0Tr/DBN72KNGA+KNI7/PT4HP9HhbdvuZh
         TcnmuPowFY3a7ICuklW1UrXmHxHhbIG/QM1U+FGHL3gBDeZu+6DxM/J6m7S9z+BYI181
         BxMYTGRCGqh9mg5Av8VQr8SoHIC23mWEg8zUAH5zSeb0J+zlOKEJOgTWiwy6iJAgRakj
         /K3c9iKe8bGYmd4wSx/X7l9jj6EVFdFjqvDdaBA1rsxEp+wCFYb17xMkrwoU7AauMLFN
         3KKw==
X-Gm-Message-State: AOJu0YwVOQxNOzrwE66fQLFQ/0iIKl4g3+kzpWFGHw4ppjjI5nRffh6H
        12e6qyKp6sFCbV5b1+cFNCJapqNLVL/sHhf0klTDauErAFs=
X-Google-Smtp-Source: AGHT+IFB5pVAZsz+zhh1JJMbE3Hn7keYS6kqT/nZnuSDAmlqpmY2pMj2LQRQW6GoN3nVNI9UcCGVIiX9GEkTfQTsesQ=
X-Received: by 2002:a25:ad1f:0:b0:d62:6838:74b9 with SMTP id
 y31-20020a25ad1f000000b00d62683874b9mr24878882ybi.55.1693150346828; Sun, 27
 Aug 2023 08:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mviQ_UEwqwvaz33dgZwzsqJxYT-xXccNmjW-GvuYokgbA@mail.gmail.com>
In-Reply-To: <CAH2r5mviQ_UEwqwvaz33dgZwzsqJxYT-xXccNmjW-GvuYokgbA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 27 Aug 2023 11:32:07 -0400
Message-ID: <CADvbK_djw8qB5kfBH6W1-qDtAWqhqc=VSXxe3LdkXkmgvuq-Bw@mail.gmail.com>
Subject: Re: SMB3.1.1 QUIC mounts from Linux kernel
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 25, 2023 at 9:08=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Xin Long,
> I am very interested in trying out LInux kernel SMB3.1.1 mounts using
> QUIC but wasn't sure how far along your kernel code was.   Do you have
> an update on it?   There was at least one other server type that
> implements SMB3.1.1 over QUIC, but probably easiest to test to Windows
> server (e.g. in Azure).
Got it.

As for https://github.com/lxin/quic, it has implemented the basic support
for most main features, but still some important ones are missing, like
Streams and Connection IDs Managements. I'm recently doing interoperability
testing with other C implementations like picoquic.

It still has a long way to go to get into the upstream kernel, but I'm pret=
ty
sure the need by kernel SMB and NFS will speed this up. I think at the same
time, some work can be done in fs/smb to move things forward.

>
> The SMB3.1.1 changes are small to support QUIC, and I could do those
> (or review yours if you have already done it).
>
Cool.

I don't really have patches and don't know much detail of fs/smb. So it wil=
l
be great if you can try this out on fs/smb.

For the test to Windows server, I will let you know once the basic support
of the rest features is done in the QUIC implementation, maybe in 1-2 month=
s.
Meanwhile, on fs/smb side, I think checking tls_server/client_hello_x509()
API use in net/sunrpc might be helpful for you to design the code in fs/smb=
.

Thanks.
