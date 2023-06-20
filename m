Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E59EB64D8
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Jun 2023 07:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjFTHoW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Jun 2023 03:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjFTHoE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Jun 2023 03:44:04 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5986A19B6
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 00:43:46 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f849a0e371so5608139e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 00:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687247024; x=1689839024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pn9INY888qfu49qxiUk2N9RkspKhh1JKufeJdU1o29Q=;
        b=sT5W0fxs9QI6/MWDEJw6cxBGg3W0PRXztVhAkC6qoKG62nB5oVkzIf3IBRgbEw5JiB
         W1V/LTESiVHXYhHi3Ay3dSaSMQiIgiRlPTZiZ9dB+9IWGdNAj4wvSYPzho/IGyojLbrx
         98S85XcX6BVWWQkXyE/nmBiri01YEQGKVUkEICkD7mmheRwU9+sK+UPY+6ePVtcfqcU6
         FjczwhM6bKXNy95zhyyO0jBMgMMammNT70laykupEvw1A1pr7KWKORuO8h+JU2Ns4soY
         91cMBG61QGNyzV1t6vQf7T9yu47tBh+mxSfMspch/B3sMUsPzRUE0UwvpX2Xyt8LKWqr
         Ia8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687247024; x=1689839024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pn9INY888qfu49qxiUk2N9RkspKhh1JKufeJdU1o29Q=;
        b=lh1Jsee2/9Qzq1xsayKegE25JYCmIJMp2gxUiqDSG7xNsQcN4Z9kHVOulPDo32IAU4
         boaOELsERxLqpxT98L1dWNyPWT5pAouJWcIVfMQ6tZYlpgPX3qGewr2KKDkRARKIWYVe
         FwPkIiNH92/WgRn8SNtzNA2g1TlFqlsRTJI8qDJOGVSWW9OmSSHMAALvxJ9rlxoYhA2j
         q8I1jc21XmLbRshh6zSvVk8UZaBODfpHGeJAL9LEnuK3++8jbQ23DiaSbaVBGeY1gAIe
         OEP818GiDXdcbeSnHosdOtzFpeY+6df7m0bHI6GyxuBfYPpGafed0THXfnizL368V18a
         xfyA==
X-Gm-Message-State: AC+VfDz5V36yxguF6SpfyztMe+z19uNiL2SusRgXJO1vdTZsURZWyIml
        0s+EsqXm9qazUPo4dk+hV9/t83DNrWEOk+p4Da4=
X-Google-Smtp-Source: ACHHUZ7CvPc9Z9zvxMnl3brNhuUVU761I9XvtzaxuQ7kGGGQRMW/Ebq1S/ZvMEjzAnOiJYd3aPzMbka7PfE0mVtSnW4=
X-Received: by 2002:a2e:99cf:0:b0:2b4:6dbf:e6fe with SMTP id
 l15-20020a2e99cf000000b002b46dbfe6femr4045424ljj.51.1687247024094; Tue, 20
 Jun 2023 00:43:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230619033436.808928-1-bharathsm@microsoft.com>
 <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
 <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com> <CAGypqWyyL-1OU2XZyOPtKdvTi_M+hRdJXO+Y5VizvoE+0pwN7g@mail.gmail.com>
 <793436e4-01ce-a552-03b9-7b45b0a9e020@talpey.com>
In-Reply-To: <793436e4-01ce-a552-03b9-7b45b0a9e020@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 20 Jun 2023 13:13:32 +0530
Message-ID: <CANT5p=p8Cx1AgHZVWDjVLrndXQ=aRymLbQiuERFVZFg=w-LgSA@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Do not send lease break acknowledgment if all file
 handles have been closed
To:     Tom Talpey <tom@talpey.com>
Cc:     Bharath SM <bharathsm.hsk@gmail.com>,
        Steve French <smfrench@gmail.com>, sfrench@samba.org,
        pc@manguebit.com, lsahlber@redhat.com, sprasad@microsoft.com,
        linux-cifs@vger.kernel.org, bharathsm@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 19, 2023 at 11:11=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/19/2023 1:27 PM, Bharath SM wrote:
> > Please find the attached patch with suggested changes.
>
> LGTM, feel free to add my previous R-B.
>
> Tom.
>
> > On Mon, Jun 19, 2023 at 5:40=E2=80=AFPM Tom Talpey <tom@talpey.com> wro=
te:
> >>
> >> On 6/19/2023 12:54 AM, Steve French wrote:
> >>> tentatively merged into cifs-2.6.git for-next pending more testing
> >>>
> >>> On Sun, Jun 18, 2023 at 10:57=E2=80=AFPM Bharath SM <bharathsm.hsk@gm=
ail.com> wrote:
> >>>>
> >>>> In case if all existing file handles are deferred handles and if all=
 of
> >>>> them gets closed due to handle lease break then we dont need to send
> >>>> lease break acknowledgment to server, because last handle close will=
 be
> >>>> considered as lease break ack.
> >>>> After closing deferred handels, we check for openfile list of inode,
> >>>> if its empty then we skip sending lease break ack.
> >>>>
> >>>> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending o=
plock break")
> >>>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >>>> ---
> >>>>    fs/smb/client/file.c | 7 +++++--
> >>>>    1 file changed, 5 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> >>>> index 051283386e22..b8a3d60e7ac4 100644
> >>>> --- a/fs/smb/client/file.c
> >>>> +++ b/fs/smb/client/file.c
> >>>> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *wor=
k)
> >>>>            * not bother sending an oplock release if session to serv=
er still is
> >>>>            * disconnected since oplock already released by the serve=
r
> >>>>            */
> >>
> >> The comment just above is a woefully incorrect SMB1 artifact, and
> >> it's even worse now.
> >>
> >> Here's what it currently says:
> >>
> >>>        /*
> >>>         * releasing stale oplock after recent reconnect of smb sessio=
n using
> >>>         * a now incorrect file handle is not a data integrity issue b=
ut do
> >>>         * not bother sending an oplock release if session to server s=
till is
> >>>         * disconnected since oplock already released by the server
> >>>         */
> >>
> >> One option is deleting it entirely, but I suggest:
> >>
> >> "MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not requi=
re
> >>    an acknowledgement to be sent when the file has already been closed=
."
> >>
> >>>> -       if (!oplock_break_cancelled) {
> >>>> +       spin_lock(&cinode->open_file_lock);
> >>>> +       if (!oplock_break_cancelled && !list_empty(&cinode->openFile=
List)) {
> >>>> +               spin_unlock(&cinode->open_file_lock);
> >>>>                   /* check for server null since can race with kill_=
sb calling tree disconnect */
> >>>>                   if (tcon->ses && tcon->ses->server) {
> >>>>                           rc =3D tcon->ses->server->ops->oplock_resp=
onse(tcon, persistent_fid,
> >>>> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *wor=
k)
> >>>>                           cifs_dbg(FYI, "Oplock release rc =3D %d\n"=
, rc);
> >>>>                   } else
> >>>>                           pr_warn_once("lease break not sent for unm=
ounted share\n");
> >>
> >> Also, I think this warning is entirely pointless, in addition to
> >> being similarly incorrect post-SMB1. Delete it. You will be able
> >> to refactor the if/else branches more clearly in this case too.
> >>
> >> With those changes considered,
> >> Reviewed-by: Tom Talpey <tom@talpey.com>
> >>

Hi Tom,

I'm leaning towards having the warning statement here. Although with
more useful details about the inode/lease etc.
If this condition is reached, it means that the cifs_inode still has
at least one handle open.
If that is the case, can the tcon/ses/server ever be NULL?

Regards,
Shyam

> >> Tom.
> >>
> >>>> -       }
> >>>> +       } else
> >>>> +               spin_unlock(&cinode->open_file_lock);
> >>>>
> >>>>           cifs_done_oplock_break(cinode);
> >>>>    }
> >>>> --
> >>>> 2.34.1
> >>>>
> >>>
> >>>



--=20
Regards,
Shyam
