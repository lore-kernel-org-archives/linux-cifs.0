Return-Path: <SRS0=36sk=AU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1372FC433DF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 05:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4DA206A5
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 05:50:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MI/bZ9DJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgGIFur (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jul 2020 01:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgGIFur (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jul 2020 01:50:47 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25162C061A0B
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2020 22:50:47 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o4so505655ybp.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2020 22:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQsam0sqlo8tSz55VA3h5Lfm5nsIwBrxLVlWQiMzzw4=;
        b=MI/bZ9DJZRXWZRPo1twKnQ4y1uy7KZNPvrgVoloPfbI2Pw4+xFc6hvjirrrhS+N4f+
         FtXw0Z3IQ+7DLls44+7pQ5AcSq+/DBm9QkG11UntMiSR9dA5iwsxz52PBiSzmX3fIsxQ
         sDsRTvMK1497WttLz+CkKM4+mZMVJOBgQ7YNKGvqnv3OUQd4kZq/jWlKOkgC5z1B96UF
         ea9FDOIH4lhdBpk/qKfs3Orc59pP1WJUeD7KRx59PgMJMz7sCSmp8KTD8LRfkAoh5PLD
         cAEl0wudEewW0lmms31gt/5qgJjmBnYeTdTrkSDjSMdGgWCXcQFYMnqYtXoty9HAWiin
         V4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQsam0sqlo8tSz55VA3h5Lfm5nsIwBrxLVlWQiMzzw4=;
        b=sJc/3pRLAKBkdxpQQcJJPIG+swC4Fbd3cBZha8jbyMoIl1fW+yaZISq+nUT2wB98Nn
         Gpuo8KEv4+/vK8VCUZ1IhZXgsCTaZbWDrRyhiVFcQzhucExSWjTh5fF+oz4sDJJovS/Z
         SV95AO5jP1Y5C0pQLEhpwI2SPtO6HgOZIcHEbuLLBHUbYddO8zPjYroFXeOWdKA9rWes
         ldw0qcNTFzGuz5GqUF27d1btSs0sEM+80c1Do71M2iOZsEbbWJolktP9JEn3kbj819wy
         lx2HM8RhNS5NAbNI0fulcVyEYmzQQQPUAArWrLc5Hi4n5CQUtyDP93VgTakoKqSwqYP5
         96BQ==
X-Gm-Message-State: AOAM531uvLLUSJyQYfLFZl3K7SU2l471oGKURquS2cftQpay1xl5k3ny
        Ht5LFeaB9N/3DlPjAPtIJlFgUV0GlT6bFq7upJE=
X-Google-Smtp-Source: ABdhPJwpZG8gFMRvUPkFWSKsGsRVI6gEubkpjyryDh7iB3cgltuOezK/YKmgR28wwht1diBOnhYHmPHgjp/Ib7JHVqc=
X-Received: by 2002:a25:afd1:: with SMTP id d17mr9760011ybj.91.1594273845492;
 Wed, 08 Jul 2020 22:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200703092932.18967-1-rbergant@redhat.com> <CAN05THT0tgcOVj=_Ky_=_AUSLim8ngBvzxAQ27qNg4CLRUjY9Q@mail.gmail.com>
In-Reply-To: <CAN05THT0tgcOVj=_Ky_=_AUSLim8ngBvzxAQ27qNg4CLRUjY9Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Jul 2020 00:50:34 -0500
Message-ID: <CAH2r5mvNP2R3Kin94yMQdLTPJJJET00PweFa9J9qL8TSQA4pgg@mail.gmail.com>
Subject: Re: [PATCH] cifs : handle ERRBaduid for SMB1
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next for when 5.9 kernel opens up

On Thu, Jul 9, 2020 at 12:20 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> On Fri, Jul 3, 2020 at 7:30 PM Roberto Bergantinos Corpas
> <rbergant@redhat.com> wrote:
> >
> > If server returns ERRBaduid but does not reset transport connection,
> > we'll keep sending command with a non-valid UID for the server as long
> > as transport is healthy, without actually recovering. This have been
> > observed on the field.
> >
> > This patch adds ERRBaduid handling so that we set CifsNeedReconnect.
> >
> > map_and_check_smb_error() can be modified to extend use cases.
> >
> > Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> > ---
> >  fs/cifs/cifsproto.h |  1 +
> >  fs/cifs/netmisc.c   | 27 +++++++++++++++++++++++++++
> >  fs/cifs/transport.c |  2 +-
> >  3 files changed, 29 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index 948bf3474db1..d72cf20ab048 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -149,6 +149,7 @@ extern int decode_negTokenInit(unsigned char *security_blob, int length,
> >  extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
> >  extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
> >  extern int map_smb_to_linux_error(char *buf, bool logErr);
> > +extern int map_and_check_smb_error(struct mid_q_entry *mid, bool logErr);
> >  extern void header_assemble(struct smb_hdr *, char /* command */ ,
> >                             const struct cifs_tcon *, int /* length of
> >                             fixed section (word count) in two byte units */);
> > diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> > index 9b41436fb8db..ae9679a27181 100644
> > --- a/fs/cifs/netmisc.c
> > +++ b/fs/cifs/netmisc.c
> > @@ -881,6 +881,33 @@ map_smb_to_linux_error(char *buf, bool logErr)
> >         return rc;
> >  }
> >
> > +int
> > +map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
> > +{
> > +       int rc;
> > +       struct smb_hdr *smb = (struct smb_hdr *)mid->resp_buf;
> > +
> > +       rc = map_smb_to_linux_error((char *)smb, logErr);
> > +       if (rc == -EACCES && !(smb->Flags2 & SMBFLG2_ERR_STATUS)) {
> > +               /* possible ERRBaduid */
> > +               __u8 class = smb->Status.DosError.ErrorClass;
> > +               __u16 code = le16_to_cpu(smb->Status.DosError.Error);
> > +
> > +               /* switch can be used to handle different errors */
> > +               if (class == ERRSRV && code == ERRbaduid) {
> > +                       cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
> > +                               code);
> > +                       spin_lock(&GlobalMid_Lock);
> > +                       if (mid->server->tcpStatus != CifsExiting)
> > +                               mid->server->tcpStatus = CifsNeedReconnect;
> > +                       spin_unlock(&GlobalMid_Lock);
> > +               }
> > +       }
> > +
> > +       return rc;
> > +}
> > +
> > +
> >  /*
> >   * calculate the size of the SMB message based on the fixed header
> >   * portion, the number of word parameters and the data portion of the message
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index cb3ee916f527..e8dbd6b55559 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -935,7 +935,7 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
> >         }
> >
> >         /* BB special case reconnect tid and uid here? */
> > -       return map_smb_to_linux_error(mid->resp_buf, log_error);
> > +       return map_and_check_smb_error(mid, log_error);
> >  }
> >
> >  struct mid_q_entry *
> > --
> > 2.21.0
> >



-- 
Thanks,

Steve
