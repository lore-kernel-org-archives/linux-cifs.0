Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD52FEB64DC
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Jul 2023 11:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjGULNx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjGULNu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 Jul 2023 07:13:50 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D090273F
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jul 2023 04:13:20 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4fba86f069bso2840361e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jul 2023 04:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689937997; x=1690542797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3trm+ZPl8f8HhvSqu1Md5yn/y7KLrH2Nj+roDeummA=;
        b=UYvzzQSEJHOpTXkBx1mkir894kRl/3jtMCEdjjp5kZeogeIF21pjTRxiFd+5YxlZP+
         NvwagJjZTj3oXKa37hR1g80NQr4evkhYQbSxfugDV/MGnArzAsQo9Z6yBIL36o/AZHYh
         RsWe6PpCxc7plqKrB/OHZhz9LYuMXZusJzzsdq7gPiDFYNUN2MF4QUa32FSp755cAlK/
         yql7Jlcs5tnxDnGU1khVl+rzUteMe8UEYXdut+7OG0Cnq4YUkPjNeV+HJubJLDd1V5g8
         Ia4yfXGhCyFjiaWZr0dwQLnhqo+8V+2KyQ/lMw3rQKosEHwnqIdtjCabLTEKkXJytH1t
         OUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689937997; x=1690542797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3trm+ZPl8f8HhvSqu1Md5yn/y7KLrH2Nj+roDeummA=;
        b=Y0mlDcKPMFMRfQISV0/JKj93ssg6xHm5RwFMydTwG6sJ7w1Q5wgeVQ5UY8UyryXIW6
         Gkt5hOycDIpuoXnWdzqnS1GJcPclQDYHXBDMnQed4KauCYv7n3NutQZQVGxDXGsZD9hz
         Q4KCerB+terL9ONDXLaVSalmEOWK+DC+h9B+u1ucPyXAQ4QPGjHrBbQ1fz+5Fbla7gX2
         5NT059LzTy5v4A1FpPPeqvnGF2uYEhJRVx7rVKOX3i1Tp8r3siA2HV/c7Wwdjhyblp6E
         2LHsmkg51C+bA41Hjbx1jBSs+KmEDGeNcs9kSrwRGK7xRZF58bFdTKHJBhyqJCZmlKmS
         ODVw==
X-Gm-Message-State: ABy/qLakCENlEYZiEnN2SP5vdKYziFfJrIe/UYAqe4N/D7/defbeEyM0
        zuf/VJ/mj5hTQ9gFJGS7BIWe/bLPdIZ3+0VJEdI=
X-Google-Smtp-Source: APBJJlGNARY8cUW2auMA1QOJ9MghzAFV9Qq2JDtWl/gY4PizyCxTubuNi5yqSR2n48PJMNFRZW3DNfimDeDiGvL+T5I=
X-Received: by 2002:a05:6512:1114:b0:4fb:8987:734e with SMTP id
 l20-20020a056512111400b004fb8987734emr1206380lfg.68.1689937997135; Fri, 21
 Jul 2023 04:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=po=GSwj+bD_-uFWZ0r_ww5XbaV1pAauZecbmuzShmcpw@mail.gmail.com>
 <d14f85d1-ff05-94da-24bb-6a1e1afe29f6@talpey.com>
In-Reply-To: <d14f85d1-ff05-94da-24bb-6a1e1afe29f6@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 21 Jul 2023 16:43:05 +0530
Message-ID: <CANT5p=omTgEfjiXcpWjhg7h8GcBwGa7jOqHyjc5OmaeHQtMPEg@mail.gmail.com>
Subject: Re: Potential leak in file put
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Tom,

Thanks for these points.

On Thu, Jul 20, 2023 at 8:21=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 7/19/2023 8:10 AM, Shyam Prasad N wrote:
> > Hi all,
> >
> > cifs.ko seems to be leaking handles occasionally when put under some
> > stress testing.
> > I was scanning the code for potential places where we could be
> > leaking, and one particular instance caught my attention.
> >
> > In _cifsFileInfo_put, when the ref count of a cifs_file reaches 0, we
> > remove it from the lists and then send the close request over the
> > wire...
> >          if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
> >                  struct TCP_Server_Info *server =3D tcon->ses->server;
> >                  unsigned int xid;
> >
> >                  xid =3D get_xid();
> >                  if (server->ops->close_getattr)
> >                          server->ops->close_getattr(xid, tcon, cifs_fil=
e);
> >                  else if (server->ops->close)
> >                          server->ops->close(xid, tcon, &cifs_file->fid)=
;
> >                  _free_xid(xid);
> >          }
> >
> > But as you can see above, we do not have return value from the above ha=
ndlers.
>
> Yeah, that's a problem. The most obvious is if the network becomes
> partitioned and the close(s) fail. Are you injecting that kind of
> error?

So this was revealed with a stress testing setup where the mount was
done against a server that gave out only 512 credits per connection.
The connection was pretty much starved for credits, which threw up
out-of-credits errors occasionally.
I've confirmed that when it happens for close, there are handle leaks.

>
> Still, the logic is going to grow some serious hair if we start
> retrying every error. What will bound the retries, and what kind
> of error(s) might be considered fatal? Tying up credits, message
> id's, handles, etc can be super problematic.
>
> Also, have you considered using some sort of laundromat? Or is it
> critical that these closes happen before proceeding?
>

Steve and I discussed this yesterday. One option that came out was...
We could cleanup the handle locally and then keep retrying the server
close as a delayed work a fixed number of times.
If a specified limit is exceeded, reconnect the session so that we start af=
resh.
I guess this is what you meant by laundromat?

> Tom.
>
> > What would happen if the above close_getattr or close calls fail?
> > Particularly, what would happen if the failure happens even before the
> > request is put in flight?
> > In this stress testing we have the server giving out lesser credits.
> > So with the testing, the credit counters on the active connections are
> > expected to be low in general.
> > I'm assuming that the above condition will leak handles.
> >
> > I was thinking about making a change to let the above handlers return
> > rc rather than void. And then to check the status.
> > If failure, create a delayed work for closing the remote handle. But
> > I'm not convinced that this is the right approach.
> > I'd like to know more comments on this.
> >



--=20
Regards,
Shyam
