Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECE9C77B7A
	for <linux-cifs@archiver.kernel.org>; Tue, 16 May 2023 06:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjEPGwO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 May 2023 02:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjEPGwN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 May 2023 02:52:13 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D560E1BD0
        for <linux-cifs@vger.kernel.org>; Mon, 15 May 2023 23:51:49 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f13ef4ad91so16434008e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 15 May 2023 23:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684219904; x=1686811904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2F1gwMxrfjkwsyoBRKdQXaXGc0bK9+BZDmqFs/Bu8Qs=;
        b=TTn87gNv+V+mnxsH30YpSVLMYD1eQLZ2w6RTCMnp88DKhRPPNMQJa58e+wpMDbETI1
         ARRdFVZ30A3bbNZCdxOzlGqQ2esi5n5gHc4Tv5WLhJACA0cs9Rr2HNTvZMu/Ai6/3kGe
         6j3FkMfvCShU1rvO/7DqltzgCM4w6EOg+ysdNVtj8quwGDQLDtHG3+6tK75QHr9my1d3
         LohUgpGfLM4s4u7pXeBvaO8VWHWK5Gb1akXoFkZI8CnOvmVc5WVHw0kMbuG2XISN6+/r
         v/hlnBzMRsNhx3hZigI57IkNXdgZwku6mF4ruSNlfrv3TkoX6FXU3wGITZrj+I2FoVuF
         EPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684219904; x=1686811904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2F1gwMxrfjkwsyoBRKdQXaXGc0bK9+BZDmqFs/Bu8Qs=;
        b=D2yuEFv6t8OOwgXgKf2lGSSB2kwjuQgfXSQvAofN8YqF7d4VVtIvJ1NTk0Yj/eFrsr
         Pnp3hJVcEUMuCVDBW3PowXysLSD4XI3+fZ/F6w2W62RmkMv1FqYOZ/t4CuoyEzHAytAy
         scjyaH8lk8uMuBnXmM2ijo5J4mutBsYz7jzd30MML/ULGuYqdN74Be+2xbu2PIJrBEc2
         1J8DbFJh+Ng1nVg34aAfPGclwAbH3Wytu7fn4xEKy7Ss+aJ4z3oNyVYhqE/H5f00ZNgU
         P+R/z49d7/+cKQXeLK+AkvjVCFAv1jx736/lc2pqz8HSqIvT4zAUlJmlsk6WMnAPux08
         hjcA==
X-Gm-Message-State: AC+VfDzmjuwnmk9UzVFHwOkQMpdKFEMNkXJ0ZlNTirEkiy/je3WiBhu2
        WdbMpGBHOskzUyFCjh99T80fm/N02TGWxzYf154=
X-Google-Smtp-Source: ACHHUZ5IyH+e3X3mLtOBe4zHkKZml8U1LWNoE72o6ikg5Jbd+X+9qEDW83SyEcSr9D0r1weajQlakkyRStSRL3jLQTw=
X-Received: by 2002:ac2:5318:0:b0:4f2:4f26:3e5a with SMTP id
 c24-20020ac25318000000b004f24f263e5amr5609215lfh.41.1684219903508; Mon, 15
 May 2023 23:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvqK0CkcR_DOwUfDVzsWco-SXb4rTt14b-YF5CpqCNrZQ@mail.gmail.com>
 <CAGypqWyuCdiEmuFzefEY05zDiBhP+g7y2e0p-9nts4rM5keRpg@mail.gmail.com>
In-Reply-To: <CAGypqWyuCdiEmuFzefEY05zDiBhP+g7y2e0p-9nts4rM5keRpg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 16 May 2023 12:21:32 +0530
Message-ID: <CANT5p=pWYfn-CGTn3QdgVo4JWh85vqjJQoeZCbmPOOCaYogPXw@mail.gmail.com>
Subject: Re: [PATCH] SMB3: force unmount was failing to close deferred close files
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Bharath S M <bharathsm@microsoft.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 9, 2023 at 1:03=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com>=
 wrote:
>
> Ack by me.
>
> On Tue, May 9, 2023 at 12:05=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > In investigating a failure with xfstest generic/392 it
> > was noticed that mounts were reusing a superblock that should
> > already have been freed. This turned out to be related to
> > deferred close files keeping a reference count until the
> > closetimeo expired.
> >
> > Currently the only way an fs knows that mount is beginning is
> > when force unmount is called, but when this, ie umount_begin(),
> > is called all deferred close files on the share (tree
> > connection) should be closed immediately (unless shared by
> > another mount) to avoid using excess resources on the server
> > and to avoid reusing a superblock which should already be freed.
> >
> > In umount_begin, close all deferred close handles for that
> > share if this is the last mount using that share on this
> > client (ie send the SMB3 close request over the wire for those
> > that have been already closed by the app but that we have
> > kept a handle lease open for and have not sent closes to the
> > server for yet).
> >
> > Reported-by: David Howells <dhowells@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 78c09634f7dc ("Cifs: Fix kernel oops caused by deferred close
> > for files.")
> >
> > See attached
> > --
> > Thanks,
> >
> > Steve

cifs_put_tcon sounds like a more logical place to do this. When the
ref count has dropped to 0.

--=20
Regards,
Shyam
