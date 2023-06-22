Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F4DEB64D8
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 04:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjFVE4m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 00:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjFVE4i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 00:56:38 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D0819AB
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 21:56:30 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b46a06c553so79095681fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 21:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687409788; x=1690001788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yWjTsSgR8MWZ9BzV2fih7c+71k4EuhX/RNJ6M9K6Fbc=;
        b=TFbLD/I4foHiliw2EOhZktsQMV+MPan1uwq6rvey3CXi1RdVcOlTj5lP1jzE7agIT7
         IL/ITVQQRpDdSyWcGOnssLlflGqdVlR+Q9/knDbSQJ5OkJh3nPadBeJ3uKtjDxG/Ag65
         w3Myj5S3QhliA+/QY7UmhG7HcmmQRFt152BYJWpAJqE56EHrQxO9yaPOOkACGrbBfADa
         KU74TQMcQjLVK3oiPy6Fk3Ce/bJDQPsjPqn1FKZsHGQbuxza0Lb7Qiah31NkURwjvynd
         ycOhpsQFUtyNBwVes4Y320DUCFnzWYRlO1kKmjXOb3IZ5Vwbk8ux8Hb8G/CpAdtCqj0r
         dySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687409788; x=1690001788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yWjTsSgR8MWZ9BzV2fih7c+71k4EuhX/RNJ6M9K6Fbc=;
        b=CLSYlOYIFGmE2IJXoCKuxx7NIT28avQQj82MK3gQkP0GyGMmgo6IWwzMY6pLtH/qwO
         dA9ToVItucHXCrePRneptwp6KdBYCR0XD6g3WVLsamyEz4maBj24rAxxqZsXXQcs/4R9
         SnAR6EbOE4JJofMQgKWcM6+Kt1srMyLHrc8hQ1fEHSQMl3xXR1T+Bvt2wiLtvaoPYc4Q
         JbRmjQXn16eEXKFbu2Ai2NSLQVQoM6LhrB9QNFXOjjudmpOKQlwhUqZ6pS1wQMRPI0xf
         +wmfvVEKrqrTGQGkN/0DxZmx3ytVlm4tYgDKp4gsmNKGGazNuj2ovwdU3Tw6sMNU/I8k
         +dVg==
X-Gm-Message-State: AC+VfDzcXsa3lxL4B4zsQtSbA3yfkqCvHCPOwDjRx4L+m9p6LazGmdV9
        FOvQx1L+XOjEinGxXuk7qPhN0qRNfBY6kqViJneV9eXfxeo=
X-Google-Smtp-Source: ACHHUZ7HsV+lePqJjgOFjxkP+52cwFdzhaRCv2KC0r6Q5X9s+S/sqN1dtro94T+beT7wTwkHkc3oby7LvxCXT6sMTfs=
X-Received: by 2002:a2e:380b:0:b0:2b4:74ca:baf7 with SMTP id
 f11-20020a2e380b000000b002b474cabaf7mr6520817lja.52.1687409788117; Wed, 21
 Jun 2023 21:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
 <CANT5p=rO7KX9KJVJ+tQVfdYXtORQbHvbR0zZq2Gjd5nvOmWjvw@mail.gmail.com>
 <CAH2r5mv5ac0eEJ0eYGKmb6AvYXhY2Uq4srt9UjcZ5fn5TWoyog@mail.gmail.com> <45a81a0a-8c16-ac04-65e4-b30d522b8912@talpey.com>
In-Reply-To: <45a81a0a-8c16-ac04-65e4-b30d522b8912@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Jun 2023 23:56:16 -0500
Message-ID: <CAH2r5muO_zVHFu8trM1uV40poi4G2eVdMXcOGcfABcOfaKNBhg@mail.gmail.com>
Subject: Re: [SMB CLIENT][PATCH] do not reserve too many oplock credits
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jun 21, 2023 at 1:25=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/20/2023 11:57 PM, Steve French wrote:
> >> Why this value of 10? I would go with 1, since we already reserve 1
> > credit for oplocks. If the reasoning is to have enough credits to send =
multiple
> > lease/oplock acks, we should change the reserved count altogether.
> >
> > I think there could be some value in sending multiple lease break
> > responses (ie allow oplock credits to be a few more than 1), but my
> > main reasoning for this was to pick some number that was "safe"
> > (allowing 10 oplock/lease-break credits while in flight count is
> > non-zero is unlikely to be a problem) and would be unlikely to change
> > existing behavior.
> >
> > My thinking was that today's code allows oplock credits to be above 1
> > (and keep growing in the server scenario you noticed) while multiple
> > requests continue to be in flight - so there could potentially be a
> > performance benefit during this period of high activity in having a
> > few lease breaks in flight at one time and unlikely to hurt anything -
> > but more importantly if we change the code to never allow oplock/lease
> > credits to be above one we could (unlikely but possible) have subtle
> > behavior changes that trigger a bug (since we would then have cases to
> > at least some servers where we never have two lease breaks in flight).
> > It seemed harmless to set the threshold to something slightly more
> > than one (so multiple lease breaks in flight would still be possible
> > and thus behavior would not change - but risk of credit starvation is
> > gone).    If you prefer - I could pick a number like 2 or 3 credits
> > instead of 10.  My intent was just to make it extremely unlikely that
> > any behavior would change (but would still fix the possible credit
> > starvation scenario) - so 2 or 3 would also probably be fine.
>
> What do you mean by "oplock credits"? There's no such field in the
> protocol. Is this some sort of reserved pool

The client divides the total credits granted by the server into three
buckets (see struct TCP_Server_Info)
        int echo_credits;  /* echo reserved slots */
        int oplock_credits;  /* lease/oplock break reserved slots */
        int credits;  /* credits reserved for all other operation types */

If we run low on credits we can disable (temporarily) leases and
sending echo requests so we can continue to send other requests (open,
read, write, close etc.).    As an example, if the server has granted
us 512 credits (total) if there were 4 large writes that were
responded to very slowly (and used up all of our credits), we could
time out if the write responses were very slow - since we would have
no way of sending an echo request periodically to see if the server
were still alive) - since we have 1 credit reserved for echo requests
though, even if the responses to the writes were slow, we would be
able to ping the server with an echo request to make sure it is still
alive.   Similarly (and this can be very important with some servers
who could hold up granting credits if a lease break is pending) - we
have to be able to respond to a lease break even if all of our credits
are used up with large reads or writes so we reserve at least one
credit for sending lease break responses.

The easiest way to think about this is that we reserve 1 credit for
echo and 1 credit for leases (although it can grow larger as we saw in
some server scenarios when they grant us more credits on lease break
responses than we asked for), but all the reset (all other remaining
credits) are available to send read or write or open or close (etc.).
  When requests in flight goes back to zero we rebalance credits to
make sure we still have 1 reserved for echo and 1 reserved for
oplock/lease break responses (and everything else for the other
operation types).

The scenario we were having a problem with though was one in which
requests inflight stayed above 0 for a long time and the server often
granted more credits than we asked for on lease break responses - this
caused the number of oplock/lease credits reserved to be larger than
the amount of credits for everything else and eventually starved the
client credits needed for normal operations (this would normally not
be an issue but the number of requests in flight stayed above zero for
a long time which kept us from rebalancing credits, and moving credits
back into the main credit pool from the oplock/lease break reserved
category - which could significantly hurt performance).

There is normally not a problem with having more than one credit in
the lease break pool, but when it grows particularly large it could
hurt performance (or even hang).





> If so, I really don't think any constant is appropriate. If the client
> can't calculate an expected number, we should keep it quite small.
