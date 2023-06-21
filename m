Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D82EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 16:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjFUQWC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jun 2023 12:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbjFUQVt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jun 2023 12:21:49 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557F02698
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 09:21:27 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b46f1256bbso51214171fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 09:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687364485; x=1689956485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhVdu322mVAR+Wjnqsml7e/hAjawoN0WcGY+dvMMDVE=;
        b=YMuE5SVm3ykxxoGR929KETiPHu9GPZSWuNR5cZOvN48IPPmGmWPOKwXdgK8Oqpv/el
         7vqU+/q4/BBksoSmAM3v4O6W0ZRq04bh1+oiNpHfjc6K2Vg/kJyweBSG603EXEq3NINV
         uIsAkFtZ24qPLTQf3oCQCUYKOFjPPGxtw9P+O0btWtCv423Ce8C7A1wvBG3yxDkPXXND
         9STCbH7mbR3FAQ8mYz8qZDscCAC0QKHYMnzJ49Ylpt52e7nLNC0KDmw0ZynpyFya6lx7
         9cY0uklNezp0SMRe+BL7QoBhxyJPXniCvDzH//MGzGlZpqLHc0uUBKoiG++r7kS66BO8
         xKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687364485; x=1689956485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UhVdu322mVAR+Wjnqsml7e/hAjawoN0WcGY+dvMMDVE=;
        b=W5dMIc8KtlL1T/JtuKzdPt1TjldMEC5Ln5NLJ+R48miDDL8rbJkDeI4kI4Zu9AE0Mu
         /PySzRUbYCrkUAnmpzuG1gnVbXAUtEfIV3uyyIBEFUvBejF8IoQ5/rGoHzST3eeHQCh5
         KRZwO8Jz7zYXy5zgopVD0tyzauJwsOC79o6LthH2S2m4mt4FowZiwwSc+XvXZKd2TVOA
         UN8dlXEt8s/uxODRlYR7ARvKsgLpGDVq1s7OQQAQNM+Cr3BjUd6trd1c4x+ZcTiZu56E
         wqHnqhswcSVCIU5KsYavUX+/DVhTY4mpEVNiLoYlHVbo860+VZvUECj2XnlSMERDjMVy
         5Tyw==
X-Gm-Message-State: AC+VfDxpP7iydVR2MYs3f6thMmKetKIOYsawEsNKJijtxeJtGP65CBUb
        OAUY1AusRr82dE6qIgkyz+Fo1g3V+UnIdz1zWBl1Qt7L
X-Google-Smtp-Source: ACHHUZ4c881ijTdOJU1pnpVDQ+vuppuygOnpKag3pyuRCsYUXpC4QEhvGZx3yFQQuPAfAae6w9avLAgehzGF7SkjAak=
X-Received: by 2002:a2e:b5cc:0:b0:2b4:7500:3094 with SMTP id
 g12-20020a2eb5cc000000b002b475003094mr3584308ljn.3.1687364485198; Wed, 21 Jun
 2023 09:21:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230619033436.808928-1-bharathsm@microsoft.com>
 <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
 <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com> <CAGypqWyyL-1OU2XZyOPtKdvTi_M+hRdJXO+Y5VizvoE+0pwN7g@mail.gmail.com>
 <793436e4-01ce-a552-03b9-7b45b0a9e020@talpey.com> <CANT5p=p8Cx1AgHZVWDjVLrndXQ=aRymLbQiuERFVZFg=w-LgSA@mail.gmail.com>
 <26be4fc6-ec99-891c-e9e8-1f770847bf2a@talpey.com> <CAH2r5mt=w2uo5Z1Sb0pz4S573nJDQxjrKO23AOpXk5q88BLA-Q@mail.gmail.com>
 <a9eb31cd-fd3e-a399-5325-88bc6d3c85bd@talpey.com>
In-Reply-To: <a9eb31cd-fd3e-a399-5325-88bc6d3c85bd@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Jun 2023 11:21:14 -0500
Message-ID: <CAH2r5muegcmO5WG89X8LhyCipZnyH6i09MWTr_Fu2=PHx80Fyg@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Do not send lease break acknowledgment if all file
 handles have been closed
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>, sfrench@samba.org,
        pc@manguebit.com, lsahlber@redhat.com, sprasad@microsoft.com,
        linux-cifs@vger.kernel.org, bharathsm@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In discussing with Bharath today he reminded me that the message would
be noisier than for unmount races - so I lean toward leaving it as is
(ie no extra debug message for this path - ie the current version of
the patch in for-next, which matches Tom's suggestion)

On Wed, Jun 21, 2023 at 11:08=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/20/2023 11:34 PM, Steve French wrote:
> > We could make the unlikely error condition (lease break race with
> > umount) log as cifsFYI so no one would see it by default?
>
> You guys obviously want the noise to stay. So, yes I'd agree that
> a cifsFYI is better than a pr_warn_once. The FYI is silenced by
> default, and it will appear every time if wanted.
>
> Tom.
>
> > On Tue, Jun 20, 2023 at 9:02=E2=80=AFAM Tom Talpey <tom@talpey.com> wro=
te:
> >>
> >> On 6/20/2023 3:43 AM, Shyam Prasad N wrote:
> >>> On Mon, Jun 19, 2023 at 11:11=E2=80=AFPM Tom Talpey <tom@talpey.com> =
wrote:
> >>>>
> >>>> On 6/19/2023 1:27 PM, Bharath SM wrote:
> >>>>> Please find the attached patch with suggested changes.
> >>>>
> >>>> LGTM, feel free to add my previous R-B.
> >>>>
> >>>> Tom.
> >>>>
> >>>>> On Mon, Jun 19, 2023 at 5:40=E2=80=AFPM Tom Talpey <tom@talpey.com>=
 wrote:
> >>>>>>
> >>>>>> On 6/19/2023 12:54 AM, Steve French wrote:
> >>>>>>> tentatively merged into cifs-2.6.git for-next pending more testin=
g
> >>>>>>>
> >>>>>>> On Sun, Jun 18, 2023 at 10:57=E2=80=AFPM Bharath SM <bharathsm.hs=
k@gmail.com> wrote:
> >>>>>>>>
> >>>>>>>> In case if all existing file handles are deferred handles and if=
 all of
> >>>>>>>> them gets closed due to handle lease break then we dont need to =
send
> >>>>>>>> lease break acknowledgment to server, because last handle close =
will be
> >>>>>>>> considered as lease break ack.
> >>>>>>>> After closing deferred handels, we check for openfile list of in=
ode,
> >>>>>>>> if its empty then we skip sending lease break ack.
> >>>>>>>>
> >>>>>>>> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sendi=
ng oplock break")
> >>>>>>>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >>>>>>>> ---
> >>>>>>>>      fs/smb/client/file.c | 7 +++++--
> >>>>>>>>      1 file changed, 5 insertions(+), 2 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> >>>>>>>> index 051283386e22..b8a3d60e7ac4 100644
> >>>>>>>> --- a/fs/smb/client/file.c
> >>>>>>>> +++ b/fs/smb/client/file.c
> >>>>>>>> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct =
*work)
> >>>>>>>>              * not bother sending an oplock release if session t=
o server still is
> >>>>>>>>              * disconnected since oplock already released by the=
 server
> >>>>>>>>              */
> >>>>>>
> >>>>>> The comment just above is a woefully incorrect SMB1 artifact, and
> >>>>>> it's even worse now.
> >>>>>>
> >>>>>> Here's what it currently says:
> >>>>>>
> >>>>>>>          /*
> >>>>>>>           * releasing stale oplock after recent reconnect of smb =
session using
> >>>>>>>           * a now incorrect file handle is not a data integrity i=
ssue but do
> >>>>>>>           * not bother sending an oplock release if session to se=
rver still is
> >>>>>>>           * disconnected since oplock already released by the ser=
ver
> >>>>>>>           */
> >>>>>>
> >>>>>> One option is deleting it entirely, but I suggest:
> >>>>>>
> >>>>>> "MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not r=
equire
> >>>>>>      an acknowledgement to be sent when the file has already been =
closed."
> >>>>>>
> >>>>>>>> -       if (!oplock_break_cancelled) {
> >>>>>>>> +       spin_lock(&cinode->open_file_lock);
> >>>>>>>> +       if (!oplock_break_cancelled && !list_empty(&cinode->open=
FileList)) {
> >>>>>>>> +               spin_unlock(&cinode->open_file_lock);
> >>>>>>>>                     /* check for server null since can race with=
 kill_sb calling tree disconnect */
> >>>>>>>>                     if (tcon->ses && tcon->ses->server) {
> >>>>>>>>                             rc =3D tcon->ses->server->ops->oploc=
k_response(tcon, persistent_fid,
> >>>>>>>> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct =
*work)
> >>>>>>>>                             cifs_dbg(FYI, "Oplock release rc =3D=
 %d\n", rc);
> >>>>>>>>                     } else
> >>>>>>>>                             pr_warn_once("lease break not sent f=
or unmounted share\n");
> >>>>>>
> >>>>>> Also, I think this warning is entirely pointless, in addition to
> >>>>>> being similarly incorrect post-SMB1. Delete it. You will be able
> >>>>>> to refactor the if/else branches more clearly in this case too.
> >>>>>>
> >>>>>> With those changes considered,
> >>>>>> Reviewed-by: Tom Talpey <tom@talpey.com>
> >>>>>>
> >>>
> >>> Hi Tom,
> >>>
> >>> I'm leaning towards having the warning statement here. Although with
> >>> more useful details about the inode/lease etc.
> >>> If this condition is reached, it means that the cifs_inode still has
> >>> at least one handle open.
> >>> If that is the case, can the tcon/ses/server ever be NULL?
> >>
> >> I don't agree, my reading is that this is a race condition with
> >> an unmount, and the tree connect and/or session is being torn
> >> down. So I don't see the point in whining to the syslog.
> >>
> >> Besides, there's nothing the client can do to recover, or prevent
> >> the situation. Why alarm the admin? What "useful" details would
> >> impact this?
> >>
> >> Tom.
> >>
> >>>
> >>> Regards,
> >>> Shyam
> >>>
> >>>>>> Tom.
> >>>>>>
> >>>>>>>> -       }
> >>>>>>>> +       } else
> >>>>>>>> +               spin_unlock(&cinode->open_file_lock);
> >>>>>>>>
> >>>>>>>>             cifs_done_oplock_break(cinode);
> >>>>>>>>      }
> >>>>>>>> --
> >>>>>>>> 2.34.1
> >>>>>>>>
> >>>>>>>
> >>>>>>>
> >>>
> >>>
> >>>
> >
> >
> >



--=20
Thanks,

Steve
