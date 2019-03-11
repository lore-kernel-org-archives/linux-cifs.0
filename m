Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2B2C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 22:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B4B420657
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 22:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TYOECY1a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfCKWSV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:18:21 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46347 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfCKWSV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Mar 2019 18:18:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id v16so481882ljg.13
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 15:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qg70LvOaQ6FJ/gthd8GdxIquw1l59EBp+dUuxRhwibk=;
        b=TYOECY1a8C0Ow8NXiHPKAR/jz4DrzhBHVO3ennAv1cIJtJFtaovubCGjCIBtyNFQjm
         8NYEg4N7SzOEAeDMJlzO0NPb7Gr+sjeOUe5cO8iJIFvkq25PJo3uxWNzM1OA7cy2cEhz
         HJeIKGmIIETm6LgiB6g9SVJr+RjL+wA0UAjitUf6IkwclZMmiUpwBkDNqWQBSkZ3WYhk
         CRUxoBGWUbv5tZmB8sac62dAY88ijs/tiCMJWFmG/ZAcjHcFqge0lnvJNaATTHCKtKAd
         yoPVPkTgVxK5NwlpN4yNeHw7TunkqdswFmwIPMIDXVefkFKvkvvD2Mv1I4TlUPMpufL4
         aF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qg70LvOaQ6FJ/gthd8GdxIquw1l59EBp+dUuxRhwibk=;
        b=J2BLI0C7YTytk40+W7p/nRcl6uzYPppRjbZFRXFDJqbtHtGF1WQ10mdrfdeFAqP4o0
         Iyh2jZ4DsesiUU9x6Fh4+DO+BxZIVVf5O4mirZmWi8K2KW7l2Bj7orgjKBP3d/3Pep3j
         4B0BB/eIy5DKnVOA5axS33hBZo9eFl+Z3z3+Gd8Iwx4SCIfXcJPbOHFP5YEfTJcqE9hi
         gw1x6QmysCoNDiboR3gXjnnJOmTL7qDR1L3zyUVbltK1dVR6S4ACZuH8Xu6ixBZMAWdZ
         40ykeOQhIDF5Bq/RY06MqkHCVeVyKr3H2oqMw3E49pnqwjh6cKPdk4ghlSeyiJokZS+E
         Z68A==
X-Gm-Message-State: APjAAAX93r+Mr4CmXLtH9rVpwrCG/AoqauTsMV2XSMfEB8FkX6DuszZl
        yzCj1ypKWcBXxn/+pbcCKul/fxA9hH54T7pPPQ==
X-Google-Smtp-Source: APXvYqyknZW38ZZhTftID5s19UQHs2RqwXg0dkkza0E5LxcW8ZukoIutfMvKTsikzYBTB07QH0kcgMvdJrN4cAwdcQk=
X-Received: by 2002:a2e:8644:: with SMTP id i4mr16724176ljj.192.1552342698582;
 Mon, 11 Mar 2019 15:18:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
In-Reply-To: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 11 Mar 2019 15:18:06 -0700
Message-ID: <CAKywueR9-_yYVA4YfycxfH_jog0xQKhgoQeFG6nhLws4TLC8Tg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add various dynamic tracepoints for compounded operations
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 11 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 14:25, Steve Frenc=
h <smfrench@gmail.com>:
>
> Sample output from tracing various newly added dynamic trace points
> (with this patch)
>
> (trace-cmd  record -e *query_info_co* -e smb3_hardlink* -e
> smb3_rename* -e smb3_set_eof* -e smb3_set_info_co* -e smb3_mkdir* -e
> smb3_delete*)
>
> # entries-in-buffer/entries-written: 44/44   #P:8
> #
> #                              _-----=3D> irqs-off
> #                             / _----=3D> need-resched
> #                            | / _---=3D> hardirq/softirq
> #                            || / _--=3D> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>      gvfsd-trash-2224  [004] .... 333095.401381:
> smb3_query_info_compound_enter: xid=3D5 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>      gvfsd-trash-2224  [002] .... 333095.402056:
> smb3_query_info_compound_err: xid=3D5 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>      gvfsd-trash-2224  [002] .... 333095.402189:
> smb3_query_info_compound_enter: xid=3D6 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>      gvfsd-trash-2224  [002] .... 333095.402688:
> smb3_query_info_compound_err: xid=3D6 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>            mkdir-16324 [002] .... 333123.559043:
> smb3_query_info_compound_enter: xid=3D7 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16324 [003] .... 333123.559654:
> smb3_query_info_compound_err: xid=3D7 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>            mkdir-16324 [003] .... 333123.559673: smb3_mkdir_enter:
> xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16324 [003] .... 333123.560748: smb3_mkdir_done:
> xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16324 [003] .... 333123.560763:
> smb3_query_info_compound_enter: xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16324 [003] .... 333123.561516:
> smb3_query_info_compound_done: xid=3D8 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16325 [002] .... 333126.841897:
> smb3_query_info_compound_enter: xid=3D9 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16325 [003] .... 333126.842580:
> smb3_query_info_compound_err: xid=3D9 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>            mkdir-16325 [003] .... 333126.842601: smb3_mkdir_enter:
> xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16325 [003] .... 333126.843513: smb3_mkdir_done:
> xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16325 [003] .... 333126.843529:
> smb3_query_info_compound_enter: xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>            mkdir-16325 [003] .... 333126.844251:
> smb3_query_info_compound_done: xid=3D10 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            mkdir-16326 [000] .... 333129.858413:
> smb3_query_info_compound_enter: xid=3D11 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>            mkdir-16326 [000] .... 333129.859193:
> smb3_query_info_compound_done: xid=3D11 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            rmdir-16328 [007] .... 333138.828049:
> smb3_query_info_compound_enter: xid=3D12 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>            rmdir-16328 [007] .... 333138.828827:
> smb3_query_info_compound_done: xid=3D12 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            rmdir-16329 [006] .... 333141.388154:
> smb3_query_info_compound_enter: xid=3D14 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>            rmdir-16329 [006] .... 333141.388813:
> smb3_query_info_compound_err: xid=3D14 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>               rm-16340 [006] .... 333157.935975:
> smb3_query_info_compound_enter: xid=3D15 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>               rm-16340 [006] .... 333157.936607:
> smb3_query_info_compound_err: xid=3D15 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>               rm-16340 [006] .... 333157.936652:
> smb3_query_info_compound_enter: xid=3D16 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>               rm-16340 [006] .... 333157.937146:
> smb3_query_info_compound_err: xid=3D16 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>            touch-16349 [005] .... 333184.932302:
> smb3_set_info_compound_enter: xid=3D18 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            touch-16349 [005] .... 333184.938303:
> smb3_set_info_compound_done: xid=3D18 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>               rm-16350 [003] .... 333187.920309:
> smb3_query_info_compound_enter: xid=3D20 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>               rm-16350 [003] .... 333187.920999:
> smb3_query_info_compound_done: xid=3D20 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>               rm-16350 [003] .... 333187.921043: smb3_delete_enter:
> xid=3D21 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>               rm-16350 [003] .... 333187.921870: smb3_delete_done:
> xid=3D21 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            touch-16361 [005] .... 333237.447252:
> smb3_set_info_compound_enter: xid=3D23 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            touch-16361 [005] .... 333237.448044:
> smb3_set_info_compound_done: xid=3D23 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>               ln-16366 [000] .... 333250.734035:
> smb3_query_info_compound_enter: xid=3D25 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>               ln-16366 [001] .... 333250.734689:
> smb3_query_info_compound_err: xid=3D25 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>               ln-16366 [001] .... 333250.734735:
> smb3_query_info_compound_enter: xid=3D26 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>               ln-16366 [001] .... 333250.735368:
> smb3_query_info_compound_done: xid=3D26 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>               ln-16366 [001] .... 333250.735413:
> smb3_query_info_compound_enter: xid=3D27 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>               ln-16366 [001] .... 333250.735947:
> smb3_query_info_compound_err: xid=3D27 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
> rc=3D-2
>               ln-16366 [001] .... 333250.735973: smb3_hardlink_enter:
> xid=3D28 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>               ln-16366 [001] .... 333250.736679: smb3_hardlink_done:
> xid=3D28 sid=3D0xbb2583e9 tid=3D0xe7ab49dc
>            gmain-2225  [000] .... 333250.736855:
> smb3_query_info_compound_enter: xid=3D29 sid=3D0xbb2583e9 tid=3D0xe7ab49d=
c
>            gmain-2225  [001] .... 333250.737527:
> smb3_query_info_compound_done: xid=3D29 sid=3D0xbb2583e9 tid=3D0xe7ab49dc

Let's add full paths to the logs to increase usability - this way we
can match logs with particular actions in the user space.

Also please don't remove the blank line - the 2nd change in the patch:

@@ -104,7 +114,6 @@ smb2_compound_op(const unsigned int xid, struct
cifs_tcon *tcon,
  memset(&qi_iov, 0, sizeof(qi_iov));
  rqst[num_rqst].rq_iov =3D qi_iov;
  rqst[num_rqst].rq_nvec =3D 1;
-
  rc =3D SMB2_query_info_init(tcon, &rqst[num_rqst], COMPOUND_FID,
  COMPOUND_FID, FILE_ALL_INFORMATION,
  SMB2_O_INFO_FILE, 0,

--
Best regards,
Pavel Shilovsky
