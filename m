Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81F8C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 01:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CFBE64E2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 01:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhBKBR7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Feb 2021 20:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbhBKBR5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Feb 2021 20:17:57 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AD2C06174A
        for <linux-cifs@vger.kernel.org>; Wed, 10 Feb 2021 17:17:17 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id q2so5262735edi.4
        for <linux-cifs@vger.kernel.org>; Wed, 10 Feb 2021 17:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aDdlJyg06GeXrfYXqRwjawG89GLivl8W3uB2MKBfgzg=;
        b=FOxfz+MECNb/7/0GWW79HeUfPVkoBUATxrsOheFIX/cAHaB1EB3w9p4Ug4AhKuOKSg
         IZWGljli/02rhKIbXGJSv+zLTZJZK5S+sSweyAvgTASqo0g5/kTsuCwxhBREZ/zBmdMk
         TY8UgAWRrt8YULonSRkhPpxrF3sAo+gMEJ1gKNgLlJTKxV46k5q7KwY3fQLzeiybzHBO
         oWVzbxurN3DVeARtRzNwMP0MFAMMKmmXTPrEKVu67f3ZXMoAg8ZfOXursl8djSAVDGOw
         3ep2javMwcfcErMYZlDLQyJaD7sMCOTIiIAUP9SdGG3h1QDqNpb1G1rtnYaGqBIeCVLC
         Bmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aDdlJyg06GeXrfYXqRwjawG89GLivl8W3uB2MKBfgzg=;
        b=El2w3F69xxZ+81tkoWk0Y8A0UKM1CChsMUt8BB6pVR54UPIlDKEAMK8eO22PakVdQ6
         YuhXvgeSd1w5q7oJNdKK3hFf+NFXVVEGmGBp4hqLEQNBQHqdVF4Kc6gJnoHs27R2eTUe
         tQtYEsRHtYq/HiYlSyneK7ZX88pYFqQO7XNKcewuBXtlG86mkvW+1NlPFKlwIebknQbx
         RmGAgn2+V7x0Xp5GIyS2hw0d9WwycpNjZxv+889PpSvAn8h9GzLVJJ73Q6JTDkS0ZO0C
         rq2ieWyhN771+6ZJvyAETYnzGotqAYhhah2N0eDlxFL9TU73hrb6AWuiZnrT58uDv1dJ
         ieFA==
X-Gm-Message-State: AOAM530wYoGMq3xbHdQlwHCo1nXUgvUnYcZ3vrRiFlayqhsAwdy3UDN7
        erlWBzyrb0I0BHDjWGxISgPSLNJVsZBPlthZKw==
X-Google-Smtp-Source: ABdhPJxLYwZ7t5e18nyCCz4HUfYuDJespnxRF9bbc3uAVfCmQuqVZe/0F0eZ+ZRifma5FvIMJ1jhhUSRIrT5dCkqltA=
X-Received: by 2002:a50:fa93:: with SMTP id w19mr5845960edr.211.1613006236212;
 Wed, 10 Feb 2021 17:17:16 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=rUagVpf1aKEDVqL-DiY2+ceYUE7mLD1pGrajN-uopRig@mail.gmail.com>
 <CANT5p=og=n36LmWroyomC7nNdJvVHFpSQqLXtH0XGY1OzvVsCQ@mail.gmail.com>
 <CANT5p=pCdVzrPNx2-6wL7_ewGMSo2Q8y8BM2dRD=5aGFk4TrPQ@mail.gmail.com>
 <CANT5p=qRhFnG1qPsWhinOGE3Y+9ie=gaQ71YQXiEJr5y4v5HBQ@mail.gmail.com>
 <CAKywueRNLiENE2E5qhaJqgjdsEYYj5c0Br=+YKvnEig7yQtB-w@mail.gmail.com> <CANT5p=o0dV1SK2caUYUq_5_R9a=V7WqrkuCxqinTP=iSAbKcGQ@mail.gmail.com>
In-Reply-To: <CANT5p=o0dV1SK2caUYUq_5_R9a=V7WqrkuCxqinTP=iSAbKcGQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 10 Feb 2021 17:17:04 -0800
Message-ID: <CAKywueRgvKrw4iB0=jGHRg6Wgv3NG3QdsH9SqG635EW_ed+eEQ@mail.gmail.com>
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

Thanks for making the changes. Please avoid unnecessary changes like:

  if (server->tcpStatus =3D=3D CifsNeedReconnect
-     || server->tcpStatus =3D=3D CifsExiting)
+ || server->tcpStatus =3D=3D CifsExiting)
  return;

as they don't bring any logic but complicate further backporting.

Other than that the patch and the whole series look good:

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 9 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 22:09, Shyam =
Prasad N <nspmangalore@gmail.com>:


>
> Hi Pavel,
>
> Thanks for the review. Attaching updated patch.
>
> Regards,
> Shyam
>
> On Tue, Feb 9, 2021 at 12:05 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > 108         if (server->tcpStatus =3D=3D CifsNeedReconnect
> > 109             || server->tcpStatus =3D=3D CifsExiting)
> > 110                 return;
> >
> > If you remove this check then the dmesg log may be populated by below
> > VFS logs. THe intent of this check was to avoid printing them because
> > they don't make sense in reconnect/umount situations and may confuse
> > users.
> >
> > 111
> > 112         switch (rc) {
> > 113         case -1:
> > 114                 /* change_conf hasn't been executed */
> > 115                 break;
> > 116         case 0:
> > 117                 cifs_server_dbg(VFS, "Possible client or server
> > bug - zero credits\n");
> > 118                 break;
> > 119         case 1:
> > 120                 cifs_server_dbg(VFS, "disabling echoes and oplocks\=
n");
> > 121                 break;
> > 122         case 2:
> > 123                 cifs_dbg(FYI, "disabling oplocks\n");
> > 124                 break;
> > 125         default:
> > 126                 trace_smb3_add_credits(server->CurrentMid,
> > 127                         server->hostname, rc, add);
> > 128                 cifs_dbg(FYI, "%s: added %u credits total=3D%d\n",
> > __func__, add, rc);
> > 129         }
> >
> >
> > I would also suggest to rename sin_flight to just "in_flight" :)
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D1=81=D0=B1, 6 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 20:18, Sh=
yam Prasad N <nspmangalore@gmail.com>:
> > >
> > > Forgot to attach again. :)
> > >
> > > On Sat, Feb 6, 2021 at 8:18 PM Shyam Prasad N <nspmangalore@gmail.com=
> wrote:
> > > >
> > > > Here's an updated version with some formatting changes per checkpat=
ch.pl.
> > > > @Pavel Shilovsky @ronnie sahlberg Hoping that one of you can review
> > > > this. Particularly the above point.
> > > >
> > > > Regards,
> > > > Shyam
> > > >
> > > > On Thu, Feb 4, 2021 at 12:13 AM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
> > > > >
> > > > > @@ -97,17 +99,25 @@ smb2_add_credits(struct TCP_Server_Info *serv=
er,
> > > > > -       if (server->tcpStatus =3D=3D CifsNeedReconnect
> > > > > -           || server->tcpStatus =3D=3D CifsExiting)
> > > > > -               return;
> > > > >
> > > > > @Pavel Shilovsky This check prevented a tracepoint from getting
> > > > > printed. I do not see much value in these lines, since all we do =
is
> > > > > print the tracepoint and exit. Hence removing it. Please let me k=
now
> > > > > if that is not okay.
> > > > >
> > > > > On Thu, Feb 4, 2021 at 12:09 AM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> > > > > >
> > > > > > --
> > > > > > Regards,
> > > > > > Shyam
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Regards,
> > > > > Shyam
> > > >
> > > >
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
>
>
>
> --
> Regards,
> Shyam
