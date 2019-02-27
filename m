Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09166C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 19:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC07D213A2
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 19:39:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkNQpld5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbfB0Tjq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 14:39:46 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35340 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbfB0Tjq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 14:39:46 -0500
Received: by mail-lf1-f68.google.com with SMTP id m73so7780000lfa.2;
        Wed, 27 Feb 2019 11:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=481JWPdvQD4ABxmlLiRK3qPOb3BKyUezI917Cf7u/bk=;
        b=KkNQpld5WRWI8eWr3cCeV3MdwDHJQgZDGFanGme7sE+G48jrx0Jodff1BQ/G8hsYIL
         K6KwVFQtdf+cod5G4KtEvvtwRXt6D2YkxxUiYXZTkAU+sIdw7plzit900LLbpuxbinPr
         qnoGFr7DYTwMLiAqjC0gxoc70folIJkL1bixeEP/yagQCK0d1L7zLGY0LGK6fUV5llfS
         7XjmsjwX8W5nbiO10MRCGuX51pDe9/KY2IqMRRqbxo0yalWhclkG4o13v1zprp6HCvsn
         jvcsR3okkQHFq9/jTmFPhn5KUAkf/TJ8lgy0wQYEHevbmd1gpqsRuNJa4C34OS8GAxpl
         C14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=481JWPdvQD4ABxmlLiRK3qPOb3BKyUezI917Cf7u/bk=;
        b=JzWAcFQm5F2XWPpfgHlZt7qi/yfXtUkGUpO5p3QNlisEEk1SE7J2vFK9gRmNy406A7
         mXG/uwPJODOvcFxnH/sdJtp2/K5iX0JxMCCmQnn8BDlwzTPyqMyxVAJQcBUfTXe48MjX
         K1WceT9haBxaTT/lojihfvdwkivgrHbbSTGzeWWauOZbSVTPQ1UvPsdydWsC0zWtrmE2
         ECb5OWHixbrzkB88m5n4RYvr3NJELNyz2k9sARN3JObzsOy1MAGbXVBLZiK5OCk6PfGt
         ybQ24dWaue4DsO4POcLpnPBdET+4/t5n1Dwgm24i+L+YFfFbhEVdKzZu/FC5OejCadMu
         m/Nw==
X-Gm-Message-State: AHQUAuY0mue8b6VF5gOW3jA41fjrttMIYUjYwDDnppYJ+Ck+hIzu9PG+
        FOO81FhQRHJTDUoAf8mDatbB/BURBYNzBP1JNA==
X-Google-Smtp-Source: AHgI3IavqjK7a3rQPhN7EZ46g+wCNCnRh9fqpRFJsH4BtCGhW5iacmD1tzWXl1ki+VZ7jQgRXEfut2RIRLS0R0IcyNk=
X-Received: by 2002:ac2:4192:: with SMTP id z18mr1834980lfh.39.1551296382720;
 Wed, 27 Feb 2019 11:39:42 -0800 (PST)
MIME-Version: 1.0
References: <20190215020855.176727-1-sashal@kernel.org> <20190215020855.176727-65-sashal@kernel.org>
 <DM5PR21MB0140327178FA380F6D7DCAC5B6600@DM5PR21MB0140.namprd21.prod.outlook.com>
 <20190227175406.GM10616@sasha-vm>
In-Reply-To: <20190227175406.GM10616@sasha-vm>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 27 Feb 2019 11:39:31 -0800
Message-ID: <CAKywueT1fm2F1ggeRZhjGxZgd=k1Hy_1Ns4Eom3hLq-oaRnBvA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.20 65/77] CIFS: Do not assume one credit for
 async responses
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Shilovskiy <pshilov@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steven French <Steven.French@microsoft.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 27 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 09:54, Sasha=
 Levin <sashal@kernel.org>:
>
> On Fri, Feb 15, 2019 at 08:10:47PM +0000, Pavel Shilovskiy wrote:
> >=D1=87=D1=82, 14 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 18:40, Sa=
sha Levin <sashal@kernel.org>:
> >>
> >> From: Pavel Shilovsky <pshilov@microsoft.com>
> >>
> >> [ Upstream commit 0fd1d37b0501efc6e295f56ab55cdaff784aa50c ]
> >>
> >> If we don't receive a response we can't assume that the server
> >> granted one credit. Assume zero credits in such cases.
> >>
> >> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> >> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >> Signed-off-by: Steve French <stfrench@microsoft.com>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> ---
> >>  fs/cifs/smb2pdu.c | 15 +++++++++++----
> >>  1 file changed, 11 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> >> index d1ae7cdb236d..3c44c51310c4 100644
> >> --- a/fs/cifs/smb2pdu.c
> >> +++ b/fs/cifs/smb2pdu.c
> >> @@ -2834,9 +2834,10 @@ smb2_echo_callback(struct mid_q_entry *mid)
> >>  {
> >>         struct TCP_Server_Info *server =3D mid->callback_data;
> >>         struct smb2_echo_rsp *rsp =3D (struct smb2_echo_rsp *)mid->res=
p_buf;
> >> -       unsigned int credits_received =3D 1;
> >> +       unsigned int credits_received =3D 0;
> >>
> >> -       if (mid->mid_state =3D=3D MID_RESPONSE_RECEIVED)
> >> +       if (mid->mid_state =3D=3D MID_RESPONSE_RECEIVED
> >> +           || mid->mid_state =3D=3D MID_RESPONSE_MALFORMED)
> >>                 credits_received =3D le16_to_cpu(rsp->sync_hdr.CreditR=
equest);
> >>
> >>         DeleteMidQEntry(mid);
> >> @@ -3093,7 +3094,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
> >>         struct TCP_Server_Info *server =3D tcon->ses->server;
> >>         struct smb2_sync_hdr *shdr =3D
> >>                                 (struct smb2_sync_hdr *)rdata->iov[0].=
iov_base;
> >> -       unsigned int credits_received =3D 1;
> >> +       unsigned int credits_received =3D 0;
> >>         struct smb_rqst rqst =3D { .rq_iov =3D rdata->iov,
> >>                                  .rq_nvec =3D 2,
> >>                                  .rq_pages =3D rdata->pages,
> >> @@ -3132,6 +3133,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
> >>                 task_io_account_read(rdata->got_bytes);
> >>                 cifs_stats_bytes_read(tcon, rdata->got_bytes);
> >>                 break;
> >> +       case MID_RESPONSE_MALFORMED:
> >> +               credits_received =3D le16_to_cpu(shdr->CreditRequest);
> >> +               /* fall through */
> >>         default:
> >>                 if (rdata->result !=3D -ENODATA)
> >>                         rdata->result =3D -EIO;
> >> @@ -3325,7 +3329,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
> >>         struct cifs_tcon *tcon =3D tlink_tcon(wdata->cfile->tlink);
> >>         unsigned int written;
> >>         struct smb2_write_rsp *rsp =3D (struct smb2_write_rsp *)mid->r=
esp_buf;
> >> -       unsigned int credits_received =3D 1;
> >> +       unsigned int credits_received =3D 0;
> >>
> >>         switch (mid->mid_state) {
> >>         case MID_RESPONSE_RECEIVED:
> >> @@ -3353,6 +3357,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
> >>         case MID_RETRY_NEEDED:
> >>                 wdata->result =3D -EAGAIN;
> >>                 break;
> >> +       case MID_RESPONSE_MALFORMED:
> >> +               credits_received =3D le16_to_cpu(rsp->sync_hdr.CreditR=
equest);
> >> +               /* fall through */
> >>         default:
> >>                 wdata->result =3D -EIO;
> >>                 break;
> >> --
> >> 2.19.1
> >>
> >
> >Can you also apply the following patch to 4.20.y and 4.19.y, please?
> >
> >https://patchwork.ozlabs.org/patch/1030180/
>
> I'll queue it up for the next cycle as it has dependencies on stable@
> commits that didn't make it in yet and I don't want to mess up with
> Greg's flow. Thanks you!

It seems that this one has already been merged to 4.20.11:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-4.20.y&id=3D7cb453e5a88169b2a5cec1e00778fc969efd1a77

So, between those two stable kernels only 4.19 doesn't have the patch.

--
Best regards,
Pavel Shilovsky
