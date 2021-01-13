Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84831C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 17:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 257822343B
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 17:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbhAMRDo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jan 2021 12:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbhAMRDo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jan 2021 12:03:44 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2C9C061575
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 09:03:03 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id p13so3381418ljg.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 09:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=61NBSmgTtguuP1AjCozzBjCyCWdacE4t4rIG6G6x+4o=;
        b=qng3uqmj5POzJtTQXKUSEgVpll7iiSX8sEqjj3PyW8dyoYasjQ+ktsTpKGlZ4meN8Z
         51VIFqTsAkWD3aRNhTcy5IeENRTjTOYb1wTKPBBUYCsrPYVJN0V4Gyvckg3WvGxaYpqo
         G4giIGROYqFYnSdtsRGN1yKMJODOOFThob5lhvEc1Vr7EF9seG/6RsS5olZttFRbM5f7
         oP97BsTuLlChHKhind8HKg0Hvmbgg2Hf5eNaIdAadSQDYISu+lzbJP1XtkGAJ6lxvAW6
         A5Ff5oyI5k6G1Da8oWg/CoJTsiNl7Ip0TKaDg5MYMI5uEfwPSWOCpg8WxVN4hw6YS8G5
         2CCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=61NBSmgTtguuP1AjCozzBjCyCWdacE4t4rIG6G6x+4o=;
        b=GiBRTBraPP/umvLQuSR5aOIAALrt6L0QIsj5JvIM2iMq3pGsATCNwv26cvw9iE8TC+
         60T4IcagtdYOE4DWZGRkfF4iCkRuYcrEQh5qxaQQpx98QdVQXAcHxqufQ8GLltgG6pb2
         N2K68ivduIDRKkwG0hYG0CEUSkcyBzkucz2cjJ4jnEfr17tyTKQeBn0kPPuT7Hgcushk
         mMuAT64MOLZ2bjrzlOcRK1C3QvJUE0TifS5Fhfim2cFU6IEEAs1zTpLG6IOB9XR9WApS
         LmQdej7iFVVzUxgO3wW8N2jQVAvp1XpVXSoLPJM3QrWeNzTzhd5Z4j3cam4htLAxp4AW
         I1ow==
X-Gm-Message-State: AOAM5310K/PqcwRBv5cJK0v1dFomfD1Jf6GaRq/4aJZI8w06g2uBVk63
        Yrlb5pabM0a54TdRHo6BJcHQCTlmawbt9aVqpOg=
X-Google-Smtp-Source: ABdhPJxXNmL+pznHlYhmTu+P0ign6GtcPJMnaj9vJzoNqTJ4P1fFqTELkx5FY89f0JJSea3QRaUIPoCAylZCb4wsZng=
X-Received: by 2002:a2e:87cb:: with SMTP id v11mr1301334ljj.218.1610557382298;
 Wed, 13 Jan 2021 09:03:02 -0800 (PST)
MIME-Version: 1.0
References: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
 <87ft35kojo.fsf@suse.com> <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
 <87h7nk6art.fsf@cjr.nz>
In-Reply-To: <87h7nk6art.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Jan 2021 11:02:51 -0600
Message-ID: <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
Subject: Re: [bug report] Inconsistent state with CIFS mount after interrupted
 process in Linux 5.10
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Duncan Findlay <duncf@duncf.ca>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jan 13, 2021 at 10:51 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Pavel Shilovsky <piastryyy@gmail.com> writes:
>
> > Thanks for reporting the issue.
> >
> > The problem is with the recent fix which changes the error code from
> > -EINTR to -ERESTARTSYS:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/cifs/transport.c?id=6988a619f5b79e4efadea6e19dcfe75fbcd350b5
> >
> > and this problem happens here:
> >
> > https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=blob;f=fs/cifs/smb2pdu.c;h=067eb44c7baa863c1e7ccd2c2f599be0b067f320;hb=236237ab6de1cde004b0ab3e348fc530334270d5#l3251
> >
> > So, interrupted close commands don't get restarted by the client and
> > the client leaks open handles on the server. The offending patch was
> > tagged stable, so the fix seems quite urgent. The fix itself should be
> > simple: replace -EINTR with -ERESTARTSYS in the IF condition or even
> > amend it with "||".
>
> Yes, makes sense.
>
> Maybe we should do something like below
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 067eb44c7baa..794fc3b68b4f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3248,7 +3248,7 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>         free_rsp_buf(resp_buftype, rsp);
>
>         /* retry close in a worker thread if this one is interrupted */
> -       if (rc == -EINTR) {
> +       if (is_interrupt_error(rc)) {
>                 int tmp_rc;
>
>                 tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,

Seems reasonable, the other two conditions (ERESTARTRNOHAND e.g.) are
not explicitly set by cifs.ko but may come back from other libraries
so could be worth checking for, and it seems a little safer to use
is_interrupt_error.

Paulo,
If you can do a patch quickly I will run the buildbot on it and the
other two patches currently in for-next and try to send in the next
couple days.

(I do have a fourth patch, not currently in for-next, that I am
debugging ... the '\' handling patch ... which I can send if we can
figure out what is missing in it).  I may also include the two trivial
one line style patches recently submitted to list.

-- 
Thanks,

Steve
