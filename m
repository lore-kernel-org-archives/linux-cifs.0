Return-Path: <SRS0=KUb6=YP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC920CA9EA0
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 21:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB8D2054F
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 21:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tHz0S/+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbfJVVcQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Oct 2019 17:32:16 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44377 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731588AbfJVVcP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Oct 2019 17:32:15 -0400
Received: by mail-io1-f66.google.com with SMTP id w12so22280909iol.11
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 14:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n2yUER7U0VljazAr6XxIEtdo7bLHU2D2U4CmHDe8uEo=;
        b=tHz0S/+dgXFKocVMpLJjrvYe3MqJs1nIn8bDtDB6192fxE55PDy19bIOcXAslnjKWa
         ggvRxbIzHmO/f7SHbffF8JqxUElqUi3jtxdNYuYNToDhPGhJhSIoVzHqGhwGkhQzKh6+
         UCKQBabXqW1xmMWP8oyN+zVZCz5Sy34V79vdp5KbOTMYpN5VGekxYjS6hS/pCNaAdr7G
         Eyq+R6y0ULzH7+K6zXoT7dDzAlDl89SEegP0WbPnwjBdk1dgBS1cGI2i6dxoUR8GXcPT
         2rfgKwMOcGP5U4xkEBcAMU+7shHhx2JpZOkYcQspfQ82GHVqRYOxqghOB3wZAtJ6hN82
         4XpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n2yUER7U0VljazAr6XxIEtdo7bLHU2D2U4CmHDe8uEo=;
        b=Pp9NFmkjwEGDzh1IQev78TCVXfN8sYispfhfEcqg2iGQMxIi19ZrGsq0lWTcPvrqY/
         lqShje8VFWCzavHlKYX7dL6QlQEnAIKtypXsgJy4ILQLN9WSjEjiY0HY68hHLe1WWk7r
         ZVFQOfL3TiSJI/SkWa/unvlSxz01CJhy6xUkdqOv1cAHTmNBQiOx1tXDcxE2VUpCQsDP
         bwa4pjJkCFQSV4eREHNNdiDRcRExm51k86aiTS+l6ZnLnJvzUrieRj9yI0Yh/j1bU583
         FIaZ7kRaFgdq8FjuwGhhbk+RPC1Ih6euRt2juqxt6IrlEdnQifHU+DQYToL6JBppTRR5
         goXw==
X-Gm-Message-State: APjAAAUSAQLAZQnOWp/2arot6LHdyVMcuqYWUDXmEAvHVdLYA4IqgMlS
        Ne/36dizM6QCcgyOQHmoJTMXnDMqGO16EuQQl28=
X-Google-Smtp-Source: APXvYqya8t6jMoM0oRFGMXKV0phzKBJslJAC5O+jNw1H0bwtZzH9axYT1kFilK8L0TVywqI7mfDzPsydaIoaIDXiwF0=
X-Received: by 2002:a5d:8b49:: with SMTP id c9mr5798905iot.209.1571779934585;
 Tue, 22 Oct 2019 14:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
 <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com>
 <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
 <58429039.7213410.1571348691819.JavaMail.zimbra@redhat.com>
 <DM5PR21MB0185FD6A138A5682BB9DE310B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <106934753.7215598.1571352823170.JavaMail.zimbra@redhat.com>
 <CALF+zOn-J9KyDDTL6dJ23RbQ9Gh+V3ti+4-O051zqOur6Fv-PA@mail.gmail.com>
 <1884745525.7250940.1571390858862.JavaMail.zimbra@redhat.com>
 <CALF+zOkmFMtxsnrUR-anXOdMzUFxtAWG+VYLAQuq3DJuH=eDMw@mail.gmail.com>
 <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zO=heBJSLW4ELPAwKegL3rJQiSebCLAh=4syEtPYoaevgA@mail.gmail.com>
 <CALF+zO=BUC2pCcz=n6hBx7ZPsL8gABLqx_hBQXVC=OOLJ-DDig@mail.gmail.com>
 <DM5PR21MB01851871D57ABCF685712C76B66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOkTwetUsL0he3nqjvTO4QPJm6bgk2CnEbcjihW2h4CZNw@mail.gmail.com>
 <CAKywueRjL=Ob1jKFyV+ApxZPXWM91aQRD8UJxe0h6kLi-iDmpA@mail.gmail.com>
 <CALF+zOkji2d7=WJcSmPKhFgm53aCb3Qxy4t1O4=W+4fOR5Qa7A@mail.gmail.com>
 <CAN05THS6ZqdH2JivPG+-LV-2g-8QROVt5U6rF6FK3UkODO=6BA@mail.gmail.com> <CAKywueQAb2GQqgHhV5nMmfzc=8Qp7Hxr8UWL+w=6nE5iz58v3w@mail.gmail.com>
In-Reply-To: <CAKywueQAb2GQqgHhV5nMmfzc=8Qp7Hxr8UWL+w=6nE5iz58v3w@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 23 Oct 2019 07:32:03 +1000
Message-ID: <CAN05THT50f55Vj4z-fpkYiNAN-BdbF8F=4bA7o94WASFYB4D6Q@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     David Wysochanski <dwysocha@redhat.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 23, 2019 at 7:25 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Hi Ronnie,
>
> Thanks for reviewing the patch, I will add your Reviewed-by.
>
> The mainline version (5.4-rc4) of the patch doesn't apply cleanly to
> any active stable kernel. Do you think it still needs the Stable tag?
> I was going to prepare a stable version and mention all dependencies
> anyway.

Ok, in that case we won't need the stable tag.
Thanks.


>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=B2=D1=82, 22 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 14:20, ronnie sa=
hlberg <ronniesahlberg@gmail.com>:
> >
> > On Wed, Oct 23, 2019 at 4:40 AM David Wysochanski <dwysocha@redhat.com>=
 wrote:
> > >
> > > On Mon, Oct 21, 2019 at 5:55 PM Pavel Shilovsky <piastryyy@gmail.com>=
 wrote:
> > > >
> > > > =D1=81=D0=B1, 19 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 04:10, Dav=
id Wysochanski <dwysocha@redhat.com>:
> > > > > Right but look at it this way.  If we conditionally set the state=
,
> > > > > then what is preventing a duplicate list_del_init call?  Let's sa=
y we
> > > > > get into the special case that you're not sure it could happen
> > > > > (mid_entry->mid_state =3D=3D MID_REQUEST_SUBMITTED is false), and=
 so the
> > > > > mid_state does not get set to MID_RETRY_NEEDED inside cifs_reconn=
ect
> > > > > but yet the mid gets added to retry_list.  In that case both the
> > > > > cifs_reconnect code path will call list_del_init as well as the o=
ther
> > > > > code paths which we're adding the conditional tests and that will
> > > > > cause a blowup again because cifs_reconnect retry_list loop will =
end
> > > > > up in a singleton list and exhaust the refcount, leading to the s=
ame
> > > > > crash.  This is exactly why the refcount only patch crashed again=
 -
> > > > > it's erroneous to think it's ok to modify mid_entry->qhead withou=
t a)
> > > > > taking globalMid_Lock and b) checking mid_state is what you think=
 it
> > > > > should be.  But if you're really concerned about that 'if' condit=
ion
> > > > > and want to leave it, and you want a stable patch, then the extra=
 flag
> > > > > seems like the way to go.  But that has the downside that it's on=
ly
> > > > > being done for stable, so a later patch will likely remove it
> > > > > (presumably).  I am not sure what such policy is or if that is ev=
en
> > > > > acceptable or allowed.
> > > >
> > > > This is acceptable and it is a good practice to fix the existing is=
sue
> > > > with the smallest possible patch and then enhance the code/fix for =
the
> > > > current master branch if needed. This simplify backporting a lot.
> > > >
> > > > Actually looking at the code:
> > > >
> > > > cifsglob.h:
> > > >
> > > > 1692 #define   MID_DELETED            2 /* Mid has been dequeued/de=
leted */
> > > >
> > > >                     ^^^
> > > > Isn't "deqeueued" what we need? It seems so because it serves the s=
ame
> > > > purpose: to indicate that a request has been deleted from the pendi=
ng
> > > > queue. So, I think we need to just make use of this existing flag a=
nd
> > > > mark the mid with MID_DELETED every time we remove the mid from the
> > > > pending list. Also assume moving mids from the pending lists to the
> > > > local lists in cleanup_demultiplex_info and cifs_reconnect as a
> > > > deletion too because those lists are not exposed globally and mids =
are
> > > > removed from those lists before the functions exit.
> > > >
> > > > I made a patch which is using MID_DELETED logic and merging
> > > > DeleteMidQEntry and cifs_mid_q_entry_release into one function to
> > > > avoid possible use-after free of mid->resp_buf.
> > > >
> > > > David, could you please test the attached patch in your environment=
? I
> > > > only did sanity testing of it.
> > > >
> > > I ran 5.4-rc4 plus this patch with the reproducer, and it ran fine fo=
r
> > > over 6 hours.
> >
> > That is great news and sounds like it is time to get this submitted to =
for-next
> > and stable.
> >
> > Can you send this as a proper patch to the list so we can get it into
> > steves for-next branch.
> > Please add a CC: Stable <stable@vger.kernel.org> to it.
> >
> >
> > I think the patch looks good so whomever sends it to the list, please a=
dd a
> > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >
> >
> > > I verified 5.4-rc4 would still crash too - at first I wasn't sure
> > > since it took about 30 mins to crash, but it definitely crashes too
> > > (not surprising).
> > >
> > > Your patch seems reasonable to me and is in the spirit of the existin=
g
> > > code and the flag idea that Ronnie had.
> > >
> > > To be honest when I look at the other flag (unrelated to this problem=
)
> > > I am also not sure if it should be a state or a flag, but you probabl=
y
> > > know the history on mid_state vs flag better than me.  For purposes o=
f
> > > this bug, I think your patch is fine and if you're wanting a stable
> > > patch and this looks better, FWIW this is fine with me.  I think
> > > probably as your comments earlier there is probably more refactoring
> > > or work that can be done in this area, but is beyond the scope of a
> > > stable patch.
> > >
> > > Thanks!
