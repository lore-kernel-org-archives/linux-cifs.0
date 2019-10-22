Return-Path: <SRS0=KUb6=YP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2EACA9EA0
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 21:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52005214B2
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 21:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gr3GnfIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbfJVVUq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Oct 2019 17:20:46 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:35639 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731573AbfJVVUp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Oct 2019 17:20:45 -0400
Received: by mail-io1-f51.google.com with SMTP id t18so18145348iog.2
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 14:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=92t522wJdEI0cs7jpnLdCP/49d/qv5T21/SqHEph9nw=;
        b=gr3GnfIkpsWdJgwKI6vw6y60XCIKeB+DvUQHhhB8u7lA64F0uEHw+P3FqN1VFjy0G5
         PjUmK2LM8LP+YSOd7/ufLxONca+D6k57Cpb241+X8/vlZd12FR7/xAfVX3gg3c6VSb+f
         xRXPIsR12Vlfou9+us09hHF6IadpewH+pFCwzCH6QbThNRhy7wiuTMyF7p0gy1jbeD14
         CBxDSOuRtUkUkmC3A/75h6YyXs18ikupDKEdHi26oTkaLDAh4N/yeBCcbCUOvorUy//D
         nuhYb8d+ztIGATwn78vbMnwDQjucktc2bRKT57xW76xKDeWn1Lq5GQAwbCgtD9b063G+
         dXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=92t522wJdEI0cs7jpnLdCP/49d/qv5T21/SqHEph9nw=;
        b=Fo9Qia68NnuPWGU+KXkiBXU/Cl9cebhEvhQsC7j+y+U9TCK6lTme99cZl39qDUrnaX
         khZ0WJEwQgH5gSA349ku9h5kmY8NpitW4HQaPbp1h7HftBy1V2Qf694B9oDHDRwow94L
         SnoHSI3AI26inWljdSzzQal2i2LcVJOj6Dn54X1pGv45OXganZP29TudMAOK+OARExSJ
         CkxnWYSGwR24eau2oVINl1jxh5VIRGGTxfNhAiHIb1u5/o1Qw1Z8Sg48fBFFUDsjVHIo
         p9oy28crfUW0vbsJdXOv+wspSUTquXWV+JjVgYWediayBPwwmEredjs16aCjpU25Fb2u
         XwAw==
X-Gm-Message-State: APjAAAVdMd1VJMDRXf1Vs74AG3udMPE3KYgjbvIyXnVaKLC284wdleRO
        olBRYCDXcv32OO2CjRGHoeQnOA5Z07ddZQdad9o=
X-Google-Smtp-Source: APXvYqz+h2vsbYeiHQCNG9DZumvpgKXujElFo8BB3TF+/mCf7cfVYqWobgu05tplyE6F2faguhjjBsxtBFkTw/bpBUg=
X-Received: by 2002:a6b:d61a:: with SMTP id w26mr5577167ioa.159.1571779244633;
 Tue, 22 Oct 2019 14:20:44 -0700 (PDT)
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
 <CAKywueRjL=Ob1jKFyV+ApxZPXWM91aQRD8UJxe0h6kLi-iDmpA@mail.gmail.com> <CALF+zOkji2d7=WJcSmPKhFgm53aCb3Qxy4t1O4=W+4fOR5Qa7A@mail.gmail.com>
In-Reply-To: <CALF+zOkji2d7=WJcSmPKhFgm53aCb3Qxy4t1O4=W+4fOR5Qa7A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 23 Oct 2019 07:20:33 +1000
Message-ID: <CAN05THS6ZqdH2JivPG+-LV-2g-8QROVt5U6rF6FK3UkODO=6BA@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
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

On Wed, Oct 23, 2019 at 4:40 AM David Wysochanski <dwysocha@redhat.com> wro=
te:
>
> On Mon, Oct 21, 2019 at 5:55 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D1=81=D0=B1, 19 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 04:10, David W=
ysochanski <dwysocha@redhat.com>:
> > > Right but look at it this way.  If we conditionally set the state,
> > > then what is preventing a duplicate list_del_init call?  Let's say we
> > > get into the special case that you're not sure it could happen
> > > (mid_entry->mid_state =3D=3D MID_REQUEST_SUBMITTED is false), and so =
the
> > > mid_state does not get set to MID_RETRY_NEEDED inside cifs_reconnect
> > > but yet the mid gets added to retry_list.  In that case both the
> > > cifs_reconnect code path will call list_del_init as well as the other
> > > code paths which we're adding the conditional tests and that will
> > > cause a blowup again because cifs_reconnect retry_list loop will end
> > > up in a singleton list and exhaust the refcount, leading to the same
> > > crash.  This is exactly why the refcount only patch crashed again -
> > > it's erroneous to think it's ok to modify mid_entry->qhead without a)
> > > taking globalMid_Lock and b) checking mid_state is what you think it
> > > should be.  But if you're really concerned about that 'if' condition
> > > and want to leave it, and you want a stable patch, then the extra fla=
g
> > > seems like the way to go.  But that has the downside that it's only
> > > being done for stable, so a later patch will likely remove it
> > > (presumably).  I am not sure what such policy is or if that is even
> > > acceptable or allowed.
> >
> > This is acceptable and it is a good practice to fix the existing issue
> > with the smallest possible patch and then enhance the code/fix for the
> > current master branch if needed. This simplify backporting a lot.
> >
> > Actually looking at the code:
> >
> > cifsglob.h:
> >
> > 1692 #define   MID_DELETED            2 /* Mid has been dequeued/delete=
d */
> >
> >                     ^^^
> > Isn't "deqeueued" what we need? It seems so because it serves the same
> > purpose: to indicate that a request has been deleted from the pending
> > queue. So, I think we need to just make use of this existing flag and
> > mark the mid with MID_DELETED every time we remove the mid from the
> > pending list. Also assume moving mids from the pending lists to the
> > local lists in cleanup_demultiplex_info and cifs_reconnect as a
> > deletion too because those lists are not exposed globally and mids are
> > removed from those lists before the functions exit.
> >
> > I made a patch which is using MID_DELETED logic and merging
> > DeleteMidQEntry and cifs_mid_q_entry_release into one function to
> > avoid possible use-after free of mid->resp_buf.
> >
> > David, could you please test the attached patch in your environment? I
> > only did sanity testing of it.
> >
> I ran 5.4-rc4 plus this patch with the reproducer, and it ran fine for
> over 6 hours.

That is great news and sounds like it is time to get this submitted to for-=
next
and stable.

Can you send this as a proper patch to the list so we can get it into
steves for-next branch.
Please add a CC: Stable <stable@vger.kernel.org> to it.


I think the patch looks good so whomever sends it to the list, please add a
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>


> I verified 5.4-rc4 would still crash too - at first I wasn't sure
> since it took about 30 mins to crash, but it definitely crashes too
> (not surprising).
>
> Your patch seems reasonable to me and is in the spirit of the existing
> code and the flag idea that Ronnie had.
>
> To be honest when I look at the other flag (unrelated to this problem)
> I am also not sure if it should be a state or a flag, but you probably
> know the history on mid_state vs flag better than me.  For purposes of
> this bug, I think your patch is fine and if you're wanting a stable
> patch and this looks better, FWIW this is fine with me.  I think
> probably as your comments earlier there is probably more refactoring
> or work that can be done in this area, but is beyond the scope of a
> stable patch.
>
> Thanks!
