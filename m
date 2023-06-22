Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563A5EB64DA
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 06:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjFVGnF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 02:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjFVGnE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 02:43:04 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BDD19AF
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 23:43:03 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f640e48bc3so9092052e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 23:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687416181; x=1690008181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rasUK8QR+lE0eEySEkdU5EceSE3VvMHa9PV42uuJeHE=;
        b=douzIY53y57I8YQ/K2p/MZAIGWfE6YrPuMHsW8YJqjJFTsAns5+gi97usE3cMfCBij
         rCSU1viehXbPvAFKrulfIDQGq1pWHuYIQdLO8Fkz/Pgm+1ROPmgF9eHnhDcBZLGo3p9c
         7SICWkeomObJ5P/opQ6pHzEaH7OVQCqbKJrff/d68FpEXe9FqG7KIQhxCollfn201myI
         Szhq1mhj4uqP9c6tkExqVy7i2KFRgfTd93kHGUsGy7BeaKUEJ/sPHDvv3FopfIM5xGQb
         z7MUWm2aUbPKboYECK0kUCaXjXMjucBntSK03OtMJQDPrt/yoksS6FypvWLTco8eeUTh
         A0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687416181; x=1690008181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rasUK8QR+lE0eEySEkdU5EceSE3VvMHa9PV42uuJeHE=;
        b=FTljjkTKKSz8Qjggq6j8wM2hZXTu6aaW8UPrg1H0cE68OB6AMKyhqduI7bsSK8HJjQ
         PjbGy0Je83ybVrM7zeggF4+q1H1A9CJ7rklk7o6Y7s3MQAafAshZqM4fZQAI9ooA2KId
         Z7F1IB1LFvcnfCAJG2FbxWHwCYgU8Zcfjby5YRAwSc9kEQJh/OE+0Um/KHDWYjYgFDPW
         ZxCUVQmgmcKWBVNFoWXLtXrVM4Vq6j6+jCr5qada04G2rPSHdRckuDmH0N8ywOWu856y
         qzhFJ8YZvBogybwoQETFo4XdgcBvWWnqCkToHbRqiaKJmx1krCAZWHxn1KYPoZ+7EQX6
         rv4A==
X-Gm-Message-State: AC+VfDx2cgFAJQgCr6KL5lGpBPiJQIrQjq0C7inmWffAtfnk7rdF2Pud
        fqS5sCs5A/a3SoTOdv5Ua8198U/NSAjF56AQxqw=
X-Google-Smtp-Source: ACHHUZ58t4+0w5UCmTzzSI8hLKMgJnacUa7/wCNs1jruCbV2ggBpDvftDL3D7y/rkLiayzChbkU3meYxE7kk4l85S8c=
X-Received: by 2002:ac2:5b46:0:b0:4f7:55e4:4665 with SMTP id
 i6-20020ac25b46000000b004f755e44665mr10388775lfp.56.1687416180808; Wed, 21
 Jun 2023 23:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
 <CANT5p=rO7KX9KJVJ+tQVfdYXtORQbHvbR0zZq2Gjd5nvOmWjvw@mail.gmail.com>
 <CAH2r5mv5ac0eEJ0eYGKmb6AvYXhY2Uq4srt9UjcZ5fn5TWoyog@mail.gmail.com>
 <45a81a0a-8c16-ac04-65e4-b30d522b8912@talpey.com> <CAH2r5muO_zVHFu8trM1uV40poi4G2eVdMXcOGcfABcOfaKNBhg@mail.gmail.com>
In-Reply-To: <CAH2r5muO_zVHFu8trM1uV40poi4G2eVdMXcOGcfABcOfaKNBhg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 22 Jun 2023 12:12:49 +0530
Message-ID: <CANT5p=rsK+a8pgSbMdV59EAEx7EoCe7_irZuUz7mHb+TxkM06w@mail.gmail.com>
Subject: Re: [SMB CLIENT][PATCH] do not reserve too many oplock credits
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jun 22, 2023 at 10:26=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> On Wed, Jun 21, 2023 at 1:25=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote=
:
> >
> > On 6/20/2023 11:57 PM, Steve French wrote:
> > >> Why this value of 10? I would go with 1, since we already reserve 1
> > > credit for oplocks. If the reasoning is to have enough credits to sen=
d multiple
> > > lease/oplock acks, we should change the reserved count altogether.
> > >
> > > I think there could be some value in sending multiple lease break
> > > responses (ie allow oplock credits to be a few more than 1), but my
> > > main reasoning for this was to pick some number that was "safe"
> > > (allowing 10 oplock/lease-break credits while in flight count is
> > > non-zero is unlikely to be a problem) and would be unlikely to change
> > > existing behavior.
> > >
> > > My thinking was that today's code allows oplock credits to be above 1
> > > (and keep growing in the server scenario you noticed) while multiple
> > > requests continue to be in flight - so there could potentially be a
> > > performance benefit during this period of high activity in having a
> > > few lease breaks in flight at one time and unlikely to hurt anything =
-
> > > but more importantly if we change the code to never allow oplock/leas=
e
> > > credits to be above one we could (unlikely but possible) have subtle
> > > behavior changes that trigger a bug (since we would then have cases t=
o
> > > at least some servers where we never have two lease breaks in flight)=
.
> > > It seemed harmless to set the threshold to something slightly more
> > > than one (so multiple lease breaks in flight would still be possible
> > > and thus behavior would not change - but risk of credit starvation is
> > > gone).    If you prefer - I could pick a number like 2 or 3 credits
> > > instead of 10.  My intent was just to make it extremely unlikely that
> > > any behavior would change (but would still fix the possible credit
> > > starvation scenario) - so 2 or 3 would also probably be fine.
> >
> > What do you mean by "oplock credits"? There's no such field in the
> > protocol. Is this some sort of reserved pool
>
> The client divides the total credits granted by the server into three
> buckets (see struct TCP_Server_Info)
>         int echo_credits;  /* echo reserved slots */
>         int oplock_credits;  /* lease/oplock break reserved slots */
>         int credits;  /* credits reserved for all other operation types *=
/
>
> If we run low on credits we can disable (temporarily) leases and
> sending echo requests so we can continue to send other requests (open,
> read, write, close etc.).    As an example, if the server has granted
> us 512 credits (total) if there were 4 large writes that were
> responded to very slowly (and used up all of our credits), we could
> time out if the write responses were very slow - since we would have
> no way of sending an echo request periodically to see if the server
> were still alive) - since we have 1 credit reserved for echo requests
> though, even if the responses to the writes were slow, we would be
> able to ping the server with an echo request to make sure it is still
> alive.   Similarly (and this can be very important with some servers
> who could hold up granting credits if a lease break is pending) - we
> have to be able to respond to a lease break even if all of our credits
> are used up with large reads or writes so we reserve at least one
> credit for sending lease break responses.
>
> The easiest way to think about this is that we reserve 1 credit for
> echo and 1 credit for leases (although it can grow larger as we saw in
> some server scenarios when they grant us more credits on lease break
> responses than we asked for), but all the reset (all other remaining
> credits) are available to send read or write or open or close (etc.).
>   When requests in flight goes back to zero we rebalance credits to
> make sure we still have 1 reserved for echo and 1 reserved for
> oplock/lease break responses (and everything else for the other
> operation types).
>
> The scenario we were having a problem with though was one in which
> requests inflight stayed above 0 for a long time and the server often
> granted more credits than we asked for on lease break responses - this
> caused the number of oplock/lease credits reserved to be larger than
> the amount of credits for everything else and eventually starved the
> client credits needed for normal operations (this would normally not
> be an issue but the number of requests in flight stayed above zero for
> a long time which kept us from rebalancing credits, and moving credits
> back into the main credit pool from the oplock/lease break reserved
> category - which could significantly hurt performance).
>
> There is normally not a problem with having more than one credit in
> the lease break pool, but when it grows particularly large it could
> hurt performance (or even hang).
>
>
>
>
>
> > If so, I really don't think any constant is appropriate. If the client
> > can't calculate an expected number, we should keep it quite small.

Hi Steve,

During response handling, in case oplock_credits reach 0, we anyhow
have it stealing one credit from regular credits today...
        else if (server->in_flight > 0 && server->oplock_credits =3D=3D 0 &=
&
                 server->oplocks) {
                if (server->credits > 1) {
                        server->credits--;
                        server->oplock_credits++;
                }
        }

So I don't think we need to reserve more than 1 credits for
oplock_credits at all.
I think the behaviour would not be affected by restricting oplock_credits t=
o 1.

--=20
Regards,
Shyam
