Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD2FEB64DC
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 21:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjFVVRV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 17:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjFVVRV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 17:17:21 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D97A10F6
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 14:17:18 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f8777caaa1so6151824e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 14:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687468636; x=1690060636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpGuUg33C5OUG18Ty6OUAzRQga1jNLjy+2rugG3sBMg=;
        b=nCPNr1bOxoASMctp/zC45B8mxL+dCkiTeFTLGVDPQeZbIaxa7+/smAAw5QMPIt7cH/
         PkKgbs+bNFtaFiqIuLLn0SpI/awEHyfIrfY3FJ4lrbpqYvxWvtB3ZDoxdkZBHP+kxPt7
         ZU5Cz7CePIT8s7ahqxmTigwhV05hlY8MoNZMwx8k433kQ4zAXF6vZ9E+0I3Da2z2cBZA
         q435X1x9VlXB7q5VBU5f6Zpq0a4F64MczHfOcRoMWcwogW7wVFX7DqezUTDF4iXNpnss
         mNJF+rOlh0gB1AxxVASkVFTANBXaNIIlqBTwUJtozAw3uNIg3aWA+A0oMi+H25TyljiB
         j9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687468636; x=1690060636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RpGuUg33C5OUG18Ty6OUAzRQga1jNLjy+2rugG3sBMg=;
        b=O3yRNJhFyIO3HWLXExtvHssbYnD6/buGQoZ5UCg532l3ibU7PhI122u/ruJLgQk+Tl
         CwzRsO3lCdne4gbexNeqN0ze5AqeLb300bycQoVYw3G8dflNOgPthT4ZGHdb4YEctRPw
         7Pwer1eWFOd+UGj6emDP+nci+66z1d0PzUS1eMpuWRSRRby7cTz04NceDv+0oqOeqz/E
         cEszqQfe4KO0Tg85/2A4DgDYIgHB26jmxgiM2lj9R86rZLTRhmDGQhwLeQl67nPMC0LB
         W+sbbiuTLSPy5fCRBD/Ahux4VOEwIfuTRT7bVz0aVx8/rzbz73qExtzCNXH/UJrTydj/
         3t+g==
X-Gm-Message-State: AC+VfDw8Ph/0P3xj8ZRhZbjtSJMNadX2cTd6SL83O0YHiAYStoVglYmi
        K59THgLCwZARKpgUg4zlGVBtf7LbKgE60O5eKHo=
X-Google-Smtp-Source: ACHHUZ67/j6zgHnVsboqoHBRoJNXpLBvcRzEY9ZvTyLGx4hvi+grv4f9lT7m954DJSr2DPpt9zlunXfpQbDgM8uOAWg=
X-Received: by 2002:a19:8c14:0:b0:4f8:7333:d1fd with SMTP id
 o20-20020a198c14000000b004f87333d1fdmr8267427lfd.34.1687468635921; Thu, 22
 Jun 2023 14:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
 <CANT5p=rO7KX9KJVJ+tQVfdYXtORQbHvbR0zZq2Gjd5nvOmWjvw@mail.gmail.com>
 <CAH2r5mv5ac0eEJ0eYGKmb6AvYXhY2Uq4srt9UjcZ5fn5TWoyog@mail.gmail.com>
 <45a81a0a-8c16-ac04-65e4-b30d522b8912@talpey.com> <CAH2r5muO_zVHFu8trM1uV40poi4G2eVdMXcOGcfABcOfaKNBhg@mail.gmail.com>
 <CANT5p=rsK+a8pgSbMdV59EAEx7EoCe7_irZuUz7mHb+TxkM06w@mail.gmail.com> <6b4aa9b0-eb2a-c8ae-2388-52d561d025e6@talpey.com>
In-Reply-To: <6b4aa9b0-eb2a-c8ae-2388-52d561d025e6@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Jun 2023 16:17:04 -0500
Message-ID: <CAH2r5mv5DAsPG+4jxDJAB3T32HBOBtewuQFmjOjOqCw3+7hgYA@mail.gmail.com>
Subject: Re: [SMB CLIENT][PATCH] do not reserve too many oplock credits
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jun 22, 2023 at 4:07=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/22/2023 2:42 AM, Shyam Prasad N wrote:
> > On Thu, Jun 22, 2023 at 10:26=E2=80=AFAM Steve French <smfrench@gmail.c=
om> wrote:
> >>
> >> On Wed, Jun 21, 2023 at 1:25=E2=80=AFPM Tom Talpey <tom@talpey.com> wr=
ote:
> >>>
> >>> On 6/20/2023 11:57 PM, Steve French wrote:
> >>>>> Why this value of 10? I would go with 1, since we already reserve 1
> >>>> credit for oplocks. If the reasoning is to have enough credits to se=
nd multiple
> >>>> lease/oplock acks, we should change the reserved count altogether.
> >>>>
> >>>> I think there could be some value in sending multiple lease break
> >>>> responses (ie allow oplock credits to be a few more than 1), but my
> >>>> main reasoning for this was to pick some number that was "safe"
> >>>> (allowing 10 oplock/lease-break credits while in flight count is
> >>>> non-zero is unlikely to be a problem) and would be unlikely to chang=
e
> >>>> existing behavior.
> >>>>
> >>>> My thinking was that today's code allows oplock credits to be above =
1
> >>>> (and keep growing in the server scenario you noticed) while multiple
> >>>> requests continue to be in flight - so there could potentially be a
> >>>> performance benefit during this period of high activity in having a
> >>>> few lease breaks in flight at one time and unlikely to hurt anything=
 -
> >>>> but more importantly if we change the code to never allow oplock/lea=
se
> >>>> credits to be above one we could (unlikely but possible) have subtle
> >>>> behavior changes that trigger a bug (since we would then have cases =
to
> >>>> at least some servers where we never have two lease breaks in flight=
).
> >>>> It seemed harmless to set the threshold to something slightly more
> >>>> than one (so multiple lease breaks in flight would still be possible
> >>>> and thus behavior would not change - but risk of credit starvation i=
s
> >>>> gone).    If you prefer - I could pick a number like 2 or 3 credits
> >>>> instead of 10.  My intent was just to make it extremely unlikely tha=
t
> >>>> any behavior would change (but would still fix the possible credit
> >>>> starvation scenario) - so 2 or 3 would also probably be fine.
> >>>
> >>> What do you mean by "oplock credits"? There's no such field in the
> >>> protocol. Is this some sort of reserved pool
> >>
> >> The client divides the total credits granted by the server into three
> >> buckets (see struct TCP_Server_Info)
> >>          int echo_credits;  /* echo reserved slots */
> >>          int oplock_credits;  /* lease/oplock break reserved slots */
> >>          int credits;  /* credits reserved for all other operation typ=
es */
> >>
> >> If we run low on credits we can disable (temporarily) leases and
> >> sending echo requests so we can continue to send other requests (open,
> >> read, write, close etc.).    As an example, if the server has granted
> >> us 512 credits (total) if there were 4 large writes that were
> >> responded to very slowly (and used up all of our credits), we could
> >> time out if the write responses were very slow - since we would have
> >> no way of sending an echo request periodically to see if the server
> >> were still alive) - since we have 1 credit reserved for echo requests
> >> though, even if the responses to the writes were slow, we would be
> >> able to ping the server with an echo request to make sure it is still
> >> alive.   Similarly (and this can be very important with some servers
> >> who could hold up granting credits if a lease break is pending) - we
> >> have to be able to respond to a lease break even if all of our credits
> >> are used up with large reads or writes so we reserve at least one
> >> credit for sending lease break responses.
> >>
> >> The easiest way to think about this is that we reserve 1 credit for
> >> echo and 1 credit for leases (although it can grow larger as we saw in
> >> some server scenarios when they grant us more credits on lease break
> >> responses than we asked for), but all the reset (all other remaining
> >> credits) are available to send read or write or open or close (etc.).
> >>    When requests in flight goes back to zero we rebalance credits to
> >> make sure we still have 1 reserved for echo and 1 reserved for
> >> oplock/lease break responses (and everything else for the other
> >> operation types).
> >>
> >> The scenario we were having a problem with though was one in which
> >> requests inflight stayed above 0 for a long time and the server often
> >> granted more credits than we asked for on lease break responses - this
> >> caused the number of oplock/lease credits reserved to be larger than
> >> the amount of credits for everything else and eventually starved the
> >> client credits needed for normal operations (this would normally not
> >> be an issue but the number of requests in flight stayed above zero for
> >> a long time which kept us from rebalancing credits, and moving credits
> >> back into the main credit pool from the oplock/lease break reserved
> >> category - which could significantly hurt performance).
> >>
> >> There is normally not a problem with having more than one credit in
> >> the lease break pool, but when it grows particularly large it could
> >> hurt performance (or even hang).
> >>
> >>
> >>
> >>
> >>
> >>> If so, I really don't think any constant is appropriate. If the clien=
t
> >>> can't calculate an expected number, we should keep it quite small.
> >
> > Hi Steve,
> >
> > During response handling, in case oplock_credits reach 0, we anyhow
> > have it stealing one credit from regular credits today...
> >          else if (server->in_flight > 0 && server->oplock_credits =3D=
=3D 0 &&
> >                   server->oplocks) {
> >                  if (server->credits > 1) {
> >                          server->credits--;
> >                          server->oplock_credits++;
> >                  }
> >          }
> >
> > So I don't think we need to reserve more than 1 credits for
> > oplock_credits at all.
> > I think the behaviour would not be affected by restricting oplock_credi=
ts to 1.

Current version of the patch in for-next has the threshold at 3 not 1
for the maximum
oplock/lease credits - presumably that is low enough, and current
behavior won't change much
but we avoid the credit starvation.

> Good! And I really really hope we don't ever set echo_credits higher
> than 1 either. I see no point in parallelizing the nearly-useless echo
> procedure.

I am not aware of any cases (or reported bugs) where echo credits
would go higher.
echo is just to periodically check if server is unresponsive/hung and
to reduce chance of reconnect issues.
It is rarely sent (every 60 seconds on inactive connections, and echo
interval can be set higher on mount if you prefer)


--=20
Thanks,

Steve
