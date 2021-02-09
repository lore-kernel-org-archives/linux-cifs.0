Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55435C433E6
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 21:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD5F64ED0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 21:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbhBIVpA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 16:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbhBIUj1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 15:39:27 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38005C061D7F
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 12:05:48 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y18so25505350edw.13
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 12:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Su+5IoRSTaWgK5th+A0gaCRAs/cDfxaL0peM7c+Qa4=;
        b=G+Rrcl/hkK5BT7c3K/3l/nhMQG3mIebmDE/04C0ZJXZDoCLsAdhiT4c+7CH5vA3OkQ
         RwEeda1bPCBbjBMJdxmmujwpQDXempG/efvAJJa9CtMbbN6CVuAPUfrZF8TMAKq9I56G
         WMWraO6MKbZTMfpXOBBb2V5Tv6SmzhvWo20/2AF1pbAalcieRvwsEwqwxdF54xb+DQea
         pFt3jsw19m5HP7f0+hb1IgYrfdHNDkm+lGvmLSf4E94D1Mn8b4A2pN1IFjQ3slPmtZL0
         ysDkDqb0e3zZjuP34PeTx5aCK0ku4fChboPJGrD+/WofFk4X8RNfcwZvFIAAvprqOPVe
         cD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Su+5IoRSTaWgK5th+A0gaCRAs/cDfxaL0peM7c+Qa4=;
        b=W/zGqluOP1Sk3y6TN+zLTHWSSelFa2Dg+Cw7HU+wYKnFTd6ra4TdV8niFvlGvo4zSj
         EKi3c3Aiv3L2XQ2TYwIF8L7SyKogt78+l5lbdOIJPx6H4pNJa175E53JBwEfppFE5bQa
         KTuE9ce9z5dyzVAPdfkWoODOVf1BlQ4kuXbIMKaOm//05v761rAKnIpw5PtizMweYmRi
         1wN9AOXMIwxRviCD3iLuFALDWjSojJd1BLR3acaS7NUQaDBDT6SlEyyoVAaPLyuN1Kv+
         O9Duvy5q51Ul9BbzUXXcdE71LPSOJSA1eozeNzQK2Fv+ovlUCGfbopH9CKvGqza96gtb
         p7Fg==
X-Gm-Message-State: AOAM532r6/lBHPpKBTBc+THeABnVAZO45yjY3BASHw+ghwXYw8toZfUl
        FZHXEU49Q9RMHqJIdWfCY1rqwADPMWKCHYEOUg==
X-Google-Smtp-Source: ABdhPJy0SbB633fQMZWSwCFmGu4kKfZJ/1bV1LE96sltDO0Xi3wA1q971mTMrOTcYg8VE0Vrm6tCM8bQaHzZJ+Z64yU=
X-Received: by 2002:a50:8b66:: with SMTP id l93mr24291534edl.384.1612901146895;
 Tue, 09 Feb 2021 12:05:46 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=rUagVpf1aKEDVqL-DiY2+ceYUE7mLD1pGrajN-uopRig@mail.gmail.com>
 <CANT5p=og=n36LmWroyomC7nNdJvVHFpSQqLXtH0XGY1OzvVsCQ@mail.gmail.com>
 <CANT5p=pCdVzrPNx2-6wL7_ewGMSo2Q8y8BM2dRD=5aGFk4TrPQ@mail.gmail.com> <CANT5p=qRhFnG1qPsWhinOGE3Y+9ie=gaQ71YQXiEJr5y4v5HBQ@mail.gmail.com>
In-Reply-To: <CANT5p=qRhFnG1qPsWhinOGE3Y+9ie=gaQ71YQXiEJr5y4v5HBQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 9 Feb 2021 12:05:35 -0800
Message-ID: <CAKywueRNLiENE2E5qhaJqgjdsEYYj5c0Br=+YKvnEig7yQtB-w@mail.gmail.com>
Subject: Re: [PATCH 3/4] cifs: Identify a connection by a conn_id.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

108         if (server->tcpStatus =3D=3D CifsNeedReconnect
109             || server->tcpStatus =3D=3D CifsExiting)
110                 return;

If you remove this check then the dmesg log may be populated by below
VFS logs. THe intent of this check was to avoid printing them because
they don't make sense in reconnect/umount situations and may confuse
users.

111
112         switch (rc) {
113         case -1:
114                 /* change_conf hasn't been executed */
115                 break;
116         case 0:
117                 cifs_server_dbg(VFS, "Possible client or server
bug - zero credits\n");
118                 break;
119         case 1:
120                 cifs_server_dbg(VFS, "disabling echoes and oplocks\n");
121                 break;
122         case 2:
123                 cifs_dbg(FYI, "disabling oplocks\n");
124                 break;
125         default:
126                 trace_smb3_add_credits(server->CurrentMid,
127                         server->hostname, rc, add);
128                 cifs_dbg(FYI, "%s: added %u credits total=3D%d\n",
__func__, add, rc);
129         }


I would also suggest to rename sin_flight to just "in_flight" :)

--
Best regards,
Pavel Shilovsky

=D1=81=D0=B1, 6 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 20:18, Shyam =
Prasad N <nspmangalore@gmail.com>:
>
> Forgot to attach again. :)
>
> On Sat, Feb 6, 2021 at 8:18 PM Shyam Prasad N <nspmangalore@gmail.com> wr=
ote:
> >
> > Here's an updated version with some formatting changes per checkpatch.p=
l.
> > @Pavel Shilovsky @ronnie sahlberg Hoping that one of you can review
> > this. Particularly the above point.
> >
> > Regards,
> > Shyam
> >
> > On Thu, Feb 4, 2021 at 12:13 AM Shyam Prasad N <nspmangalore@gmail.com>=
 wrote:
> > >
> > > @@ -97,17 +99,25 @@ smb2_add_credits(struct TCP_Server_Info *server,
> > > -       if (server->tcpStatus =3D=3D CifsNeedReconnect
> > > -           || server->tcpStatus =3D=3D CifsExiting)
> > > -               return;
> > >
> > > @Pavel Shilovsky This check prevented a tracepoint from getting
> > > printed. I do not see much value in these lines, since all we do is
> > > print the tracepoint and exit. Hence removing it. Please let me know
> > > if that is not okay.
> > >
> > > On Thu, Feb 4, 2021 at 12:09 AM Shyam Prasad N <nspmangalore@gmail.co=
m> wrote:
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> > >
> > >
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> >
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Regards,
> Shyam
