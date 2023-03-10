Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4901C6FD1E
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 22:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjCJWke (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 17:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjCJWk2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 17:40:28 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7430312DDEB
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 14:40:22 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id h3so6885414lja.12
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 14:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678488020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQ30MQ4yY5YUYoWouORbDVE/2nWJy7oFFlrgCBgwRSo=;
        b=R05xGF+gcHQ049jV05vhZFfxIXqE37kn2wpJTckIivLodCobqgiihz0IjTLOi5Skab
         EgN07h1710R4tndS8UZOOx0Xq0AN+lPbzbFU4YRQ6BwKzOmZ9Jm27gJkJhPklrjqay9O
         jZXcajUwG6/dQ41lv40fHzX827CmE2Ma9xdFJM9RhhHLVa+++Ra6SV3ewFS+EZXSF+96
         hzzC5HpGp/YGlz11mkW6PUkn5L58rkMwyA+yCxUKDrdHt28wC7cg8OYgXqYSQxqfxxnI
         XExSDc5uL+hDFmAlliEbXdFKh7IAT64DKGro+JudJBCuFB9YsNA9XacRC6u4WVm7ZvM/
         XGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678488020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQ30MQ4yY5YUYoWouORbDVE/2nWJy7oFFlrgCBgwRSo=;
        b=pj/PCXBwasArCv/0r6sTdVfXg2+xwCDaWOo3f70tQroy97GuAyTfmqQK0/HTlZkrUx
         GfwucPhBq34GXjqE+2+KSM2Flh2qPiHYy1hy9YR4VOrUFcpv+6/lXxpVVh5I1frhL93Y
         rpAeebToXWVdISy7PFXwyzS2If9zShLmS7kuaIRaKzqWimqxWoZoLTtnwetZgVbSgI9F
         j61JI2CwscqHrauyrJTwwBBDM4uunfGTygNb9csGoXujpAKA9Qe9c54jJFdEtMUJxDnh
         fL9nU9yKL3RRT6ENiaMWNgANLvzmb24lsDKl7UHVYwoPUMRVtXYoi0WQPMQ5g0oLFyVm
         kFSw==
X-Gm-Message-State: AO0yUKVb+hyiDhpD3lgxALD5s5GrOVVmhtjG9PgMoc4sHT0ZFBoyJAU1
        vP2anfJUkoPJvOqcfkMm1mqEIPQwMbQ7JDVxai3sBrwk66M=
X-Google-Smtp-Source: AK7set/CWkXAYIe4On6wbF/JeRLVHsquugsEdZmqWaCJ2xQUJX3Gp+isxWPPFRU7mZEAcO6VLfV1/6iHHTsG3CG0qcg=
X-Received: by 2002:a05:651c:124e:b0:295:c458:da98 with SMTP id
 h14-20020a05651c124e00b00295c458da98mr8464590ljh.5.1678488019876; Fri, 10 Mar
 2023 14:40:19 -0800 (PST)
MIME-Version: 1.0
References: <20230310153211.10982-1-sprasad@microsoft.com> <20230310153211.10982-4-sprasad@microsoft.com>
In-Reply-To: <20230310153211.10982-4-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 10 Mar 2023 16:40:08 -0600
Message-ID: <CAH2r5mtR9neaTB4OiDfb6XVUpz9unmzxpfqkere4PEh4AF0VpQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] cifs: serialize channel reconnects
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     bharathsm.hsk@gmail.com, pc@cjr.nz, tom@talpey.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paulo had a few comments on patch 3 of the series, so have applied the
first two, and will wait on patch 3 and 4, but tentatively merged the
first two:

a7c73e3d5842 (HEAD -> for-next, origin/for-next) cifs: generate
signkey for the channel that's reconnecting
d169aadd50c7 cifs: fix tcon status change after tree connect

On Fri, Mar 10, 2023 at 9:33=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> Parallel session reconnects are prone to race conditions
> that are difficult to avoid cleanly. The changes so far do
> ensure that parallel reconnects eventually go through.
> But that can take multiple session setups on the same channel.
>
> Avoiding that by serializing the session setups on parallel
> channels. In doing so, we should avoid such issues.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/cifs/connect.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7b103f69432e..4ea1e51c3fa5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -222,6 +222,11 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Ser=
ver_Info *server,
>                 else
>                         cifs_chan_set_need_reconnect(ses, server);
>
> +               cifs_dbg(FYI, "%s: channel connect bitmaps: 0x%lx 0x%lx\n=
",
> +                        __func__,
> +                        ses->chans_need_reconnect,
> +                        ses->chans_in_reconnect);
> +
>                 /* If all channels need reconnect, then tcon needs reconn=
ect */
>                 if (!mark_smb_session && !CIFS_ALL_CHANS_NEED_RECONNECT(s=
es)) {
>                         spin_unlock(&ses->chan_lock);
> @@ -3744,6 +3749,11 @@ cifs_setup_session(const unsigned int xid, struct =
cifs_ses *ses,
>         retries =3D 5;
>
>         spin_lock(&ses->ses_lock);
> +       cifs_dbg(FYI, "%s: channel connect bitmaps: 0x%lx 0x%lx\n",
> +                __func__,
> +                ses->chans_need_reconnect,
> +                ses->chans_in_reconnect);
> +
>         if (ses->ses_status !=3D SES_GOOD &&
>             ses->ses_status !=3D SES_NEW &&
>             ses->ses_status !=3D SES_NEED_RECON) {
> @@ -3762,11 +3772,11 @@ cifs_setup_session(const unsigned int xid, struct=
 cifs_ses *ses,
>         }
>
>         /* another process is in the processs of sess setup */
> -       while (cifs_chan_in_reconnect(ses, server)) {
> +       while (ses->chans_in_reconnect) {
>                 spin_unlock(&ses->chan_lock);
>                 spin_unlock(&ses->ses_lock);
>                 rc =3D wait_event_interruptible_timeout(ses->reconnect_q,
> -                                                     (!cifs_chan_in_reco=
nnect(ses, server)),
> +                                                     (!ses->chans_in_rec=
onnect),
>                                                       HZ);
>                 if (rc < 0) {
>                         cifs_dbg(FYI, "%s: aborting sess setup due to a r=
eceived signal by the process\n",
> @@ -3776,8 +3786,8 @@ cifs_setup_session(const unsigned int xid, struct c=
ifs_ses *ses,
>                 spin_lock(&ses->ses_lock);
>                 spin_lock(&ses->chan_lock);
>
> -               /* are we still trying to reconnect? */
> -               if (!cifs_chan_in_reconnect(ses, server)) {
> +               /* did the bitmask change? */
> +               if (!ses->chans_in_reconnect) {
>                         spin_unlock(&ses->chan_lock);
>                         spin_unlock(&ses->ses_lock);
>                         goto check_again;
> --
> 2.34.1
>


--=20
Thanks,

Steve
