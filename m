Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87ABEB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 03:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjFUDfE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Jun 2023 23:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFUDfC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Jun 2023 23:35:02 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCEBE2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 20:35:01 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b46773e427so59111571fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 20:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687318500; x=1689910500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMjbBsfpR5dkJ7Trp9uIzubQqD4+q3//lSsV/t2pjNs=;
        b=Bh3hKXXmM1rGgDMEk7sAbk06wKkjNozepCM3wkZtEpw7ZBYwCd2axqy0geL+JmDH1t
         s9bzyzfg12KZFyIdIPfcqAkwfVuExIK+ALsHFH03FO3AyzZpW7WaMlZZfcEQi/bh7PSm
         1DyVFabB+jJ6vawGHlCCzo4fNhJfyVe3+6E1tDyDb5BGss8qkXW9cPL7Su6JfvHbO6T+
         LzAqGdfzz3e5gbQwmCucQCQuR8GnU6LKGTeCKiElOkm0eqMdPfWWSaCGiySO3QPAZXjT
         i0g4lxNEnDq0nO2s9ApdaWX3U+wQw29l0AKFJ7CK9WO3YWVXbYNlsQ/2efhzcQ1sOWL5
         z3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687318500; x=1689910500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KMjbBsfpR5dkJ7Trp9uIzubQqD4+q3//lSsV/t2pjNs=;
        b=LcNhNF6CZbKjPxPCsV5EZHLMloKMSwvSqxMQCM+UgGS8rEO0mNc8Gsa09YhPNXYQJV
         llV+Tu1bYwb3jRJsUrpILn4srZIx2dnE3WBt4tU6QzLOGhK5/scWwilAt+XfHCFxJQyq
         NFRB3b0yq4Uh6aZjUHFV3o7+kz1fwOOzHzwEkajQ/GhRZs6Hnfr78YToZafUwtOS/CK/
         S9bmOWV8FZQpuLYJPDKeky/bW+pR+ZOKLrqPZPN1Ac1WS+Hk/OozUzkhPvcRU4bArQQZ
         r91Z+61JBSnq2UztI3TNduiIxezKmn9Y8rcDtwp5ZublYbXvSuTPlxECctF7lYPsHpxe
         wRiA==
X-Gm-Message-State: AC+VfDz8W77jN76LlZMxKwKrFWG3aT4elyPmQbQwJ2cAPKtgrGGZua/4
        +4zqVCzHAS/VctqmBe5HX/d4K3XG3+WXYPRd368=
X-Google-Smtp-Source: ACHHUZ5IL8xu2XrCOSo4VW4A9eusFhU/ptK8GGAL3mgmmOuDleY4cjr5hYm5d2PNldkpXK9Gg/mNfeZKAP2iHGVVxH0=
X-Received: by 2002:a2e:2d02:0:b0:2b1:ea3d:2625 with SMTP id
 t2-20020a2e2d02000000b002b1ea3d2625mr8870247ljt.31.1687318499350; Tue, 20 Jun
 2023 20:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230619033436.808928-1-bharathsm@microsoft.com>
 <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
 <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com> <CAGypqWyyL-1OU2XZyOPtKdvTi_M+hRdJXO+Y5VizvoE+0pwN7g@mail.gmail.com>
 <793436e4-01ce-a552-03b9-7b45b0a9e020@talpey.com> <CANT5p=p8Cx1AgHZVWDjVLrndXQ=aRymLbQiuERFVZFg=w-LgSA@mail.gmail.com>
 <26be4fc6-ec99-891c-e9e8-1f770847bf2a@talpey.com>
In-Reply-To: <26be4fc6-ec99-891c-e9e8-1f770847bf2a@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 20 Jun 2023 22:34:47 -0500
Message-ID: <CAH2r5mt=w2uo5Z1Sb0pz4S573nJDQxjrKO23AOpXk5q88BLA-Q@mail.gmail.com>
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

We could make the unlikely error condition (lease break race with
umount) log as cifsFYI so no one would see it by default?

On Tue, Jun 20, 2023 at 9:02=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/20/2023 3:43 AM, Shyam Prasad N wrote:
> > On Mon, Jun 19, 2023 at 11:11=E2=80=AFPM Tom Talpey <tom@talpey.com> wr=
ote:
> >>
> >> On 6/19/2023 1:27 PM, Bharath SM wrote:
> >>> Please find the attached patch with suggested changes.
> >>
> >> LGTM, feel free to add my previous R-B.
> >>
> >> Tom.
> >>
> >>> On Mon, Jun 19, 2023 at 5:40=E2=80=AFPM Tom Talpey <tom@talpey.com> w=
rote:
> >>>>
> >>>> On 6/19/2023 12:54 AM, Steve French wrote:
> >>>>> tentatively merged into cifs-2.6.git for-next pending more testing
> >>>>>
> >>>>> On Sun, Jun 18, 2023 at 10:57=E2=80=AFPM Bharath SM <bharathsm.hsk@=
gmail.com> wrote:
> >>>>>>
> >>>>>> In case if all existing file handles are deferred handles and if a=
ll of
> >>>>>> them gets closed due to handle lease break then we dont need to se=
nd
> >>>>>> lease break acknowledgment to server, because last handle close wi=
ll be
> >>>>>> considered as lease break ack.
> >>>>>> After closing deferred handels, we check for openfile list of inod=
e,
> >>>>>> if its empty then we skip sending lease break ack.
> >>>>>>
> >>>>>> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending=
 oplock break")
> >>>>>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >>>>>> ---
> >>>>>>     fs/smb/client/file.c | 7 +++++--
> >>>>>>     1 file changed, 5 insertions(+), 2 deletions(-)
> >>>>>>
> >>>>>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> >>>>>> index 051283386e22..b8a3d60e7ac4 100644
> >>>>>> --- a/fs/smb/client/file.c
> >>>>>> +++ b/fs/smb/client/file.c
> >>>>>> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *w=
ork)
> >>>>>>             * not bother sending an oplock release if session to s=
erver still is
> >>>>>>             * disconnected since oplock already released by the se=
rver
> >>>>>>             */
> >>>>
> >>>> The comment just above is a woefully incorrect SMB1 artifact, and
> >>>> it's even worse now.
> >>>>
> >>>> Here's what it currently says:
> >>>>
> >>>>>         /*
> >>>>>          * releasing stale oplock after recent reconnect of smb ses=
sion using
> >>>>>          * a now incorrect file handle is not a data integrity issu=
e but do
> >>>>>          * not bother sending an oplock release if session to serve=
r still is
> >>>>>          * disconnected since oplock already released by the server
> >>>>>          */
> >>>>
> >>>> One option is deleting it entirely, but I suggest:
> >>>>
> >>>> "MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not req=
uire
> >>>>     an acknowledgement to be sent when the file has already been clo=
sed."
> >>>>
> >>>>>> -       if (!oplock_break_cancelled) {
> >>>>>> +       spin_lock(&cinode->open_file_lock);
> >>>>>> +       if (!oplock_break_cancelled && !list_empty(&cinode->openFi=
leList)) {
> >>>>>> +               spin_unlock(&cinode->open_file_lock);
> >>>>>>                    /* check for server null since can race with ki=
ll_sb calling tree disconnect */
> >>>>>>                    if (tcon->ses && tcon->ses->server) {
> >>>>>>                            rc =3D tcon->ses->server->ops->oplock_r=
esponse(tcon, persistent_fid,
> >>>>>> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *w=
ork)
> >>>>>>                            cifs_dbg(FYI, "Oplock release rc =3D %d=
\n", rc);
> >>>>>>                    } else
> >>>>>>                            pr_warn_once("lease break not sent for =
unmounted share\n");
> >>>>
> >>>> Also, I think this warning is entirely pointless, in addition to
> >>>> being similarly incorrect post-SMB1. Delete it. You will be able
> >>>> to refactor the if/else branches more clearly in this case too.
> >>>>
> >>>> With those changes considered,
> >>>> Reviewed-by: Tom Talpey <tom@talpey.com>
> >>>>
> >
> > Hi Tom,
> >
> > I'm leaning towards having the warning statement here. Although with
> > more useful details about the inode/lease etc.
> > If this condition is reached, it means that the cifs_inode still has
> > at least one handle open.
> > If that is the case, can the tcon/ses/server ever be NULL?
>
> I don't agree, my reading is that this is a race condition with
> an unmount, and the tree connect and/or session is being torn
> down. So I don't see the point in whining to the syslog.
>
> Besides, there's nothing the client can do to recover, or prevent
> the situation. Why alarm the admin? What "useful" details would
> impact this?
>
> Tom.
>
> >
> > Regards,
> > Shyam
> >
> >>>> Tom.
> >>>>
> >>>>>> -       }
> >>>>>> +       } else
> >>>>>> +               spin_unlock(&cinode->open_file_lock);
> >>>>>>
> >>>>>>            cifs_done_oplock_break(cinode);
> >>>>>>     }
> >>>>>> --
> >>>>>> 2.34.1
> >>>>>>
> >>>>>
> >>>>>
> >
> >
> >



--=20
Thanks,

Steve
