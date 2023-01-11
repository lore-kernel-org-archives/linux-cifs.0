Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DE6C5479D
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 17:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbjAKR5l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 12:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbjAKR5b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 12:57:31 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCAA164BC
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 09:57:30 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id bp15so24710967lfb.13
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 09:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pSSITpOVilT50pWOA/L+xmqhX1LpN5UwfnOwt+TJt4Q=;
        b=nq5Z7XhFXo5dBBtfdQ4YjMz5QVrhC7THWk7Jtm9X/B2WFVR8D5QcObW2d4KWHRo06V
         LrEnLag3VbbO9+bpOBZqz91myrUNqSPqZbEbA+yGMllnScQBBvhsMv2YZb13lWRG/LKq
         SM5t4ZjiIcFfmq6sLGEb9lUOUyZgJlvqr/Sdd8blbC60s97KCtreYi5Ji6Enf1yfPxSi
         o1lQ/HUYLXGlNmkHmD/zUzIF0V/H0riu+3ojJf3S1nLuRaj4kSGwD3vbY5Ex/H4vWJwU
         4NJ1TimWCa4gMlzlzqKMmYyuVkdbQS2VrOrcKjjoBtqbd94LBunVPNDc5rBd5IaqbM0q
         hQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pSSITpOVilT50pWOA/L+xmqhX1LpN5UwfnOwt+TJt4Q=;
        b=nu7crSmpkyXlrKzWGOeUu4HqInabPK6qB+oOuNWdLYvLlNrPw98HJGFwXDfiFj6oLS
         I/m2ya2dbdmXiimVlL5fWPwg7lRYaOeAcdWyEniv+fetflzNfCX+KdPmAj7iMf7HQUIO
         Jr72i3Qxb0orAnX/mibnH8Z7jt0i/rlSf2Tpj+vL44kkdAKA03TMwsqutDDmiYwnxckB
         itA8UYQdij1ebymR6TnZuzKvr63UQ8WE2fhwD44woljPeZpNXVAec+mEIp9hDDUZWwta
         hEG56mmRNP7195dpD+yYLI1HlQ0XOcGQOx2azrP2pPjcJ6odYOe/cIeouKPMx6TQknhw
         ivCg==
X-Gm-Message-State: AFqh2krYSdWw0or8Pqc7IQbbjqKA5m0Q7oCNLtFCnBszEHGsU4yFtxpj
        YV4RiQ1cGKdiOcyUNKtFa01rMkjX0oPjZ7aPDrt+rNjEcMIZ4g==
X-Google-Smtp-Source: AMrXdXv5gvMJKJ7c9Baxm6mCmPpiJBy4KkYnmrSXNHBtCsxrHoWpe+wxkraxHQEgan3d6Evua04EbG4JtCN7wvCUTxo=
X-Received: by 2002:a19:550b:0:b0:4cc:573b:2008 with SMTP id
 n11-20020a19550b000000b004cc573b2008mr2618769lfe.535.1673459848276; Wed, 11
 Jan 2023 09:57:28 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
 <73c34084-7302-0739-4356-a3abf55e6894@talpey.com>
In-Reply-To: <73c34084-7302-0739-4356-a3abf55e6894@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 11 Jan 2023 23:27:16 +0530
Message-ID: <CANT5p=rdOnd6-XS+zFYQNS3nt=FpU837Gk3V_y6tffgSrTr3gA@mail.gmail.com>
Subject: Re: Connection sharing in SMB multichannel
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Tom,

As always, thanks for the detailed review. :)

On Wed, Jan 11, 2023 at 10:32 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 1/10/2023 4:16 AM, Shyam Prasad N wrote:
> > 3.
> > I saw that there was a bug in iface_cmp, where we did not do full
> > comparison of addresses to match them.
> > Fixed it here:
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/cef2448dc43d1313571e21ce8283bccacf01978e.patch
> >
> > @Tom Talpey Was this your concern with iface_cmp?
>
> Took a look at this and I do have some comments.
>
> Regarding the new address comparator cifs_ipaddr_cmp(), why
> does it return a three-value result? It seems to prefer
> AF_INET over AF_UNSPEC, and AF_INET6 over AF_INET. Won't
> this result in selecting the same physical interface more
> than once?

The idea is to return consistent values for a given pair, so that, for
interfaces with exactly same advertised speeds, they're ordered based
on address family first, then based on what memcmp returns.

>
> Also, it is comparing the entire contents of the sockaddrs,
> including padding and scope id's, which have no meaning on
> this end of the wire. That will lead to mismatch.

My familiarity with IPv6 is relatively low. Steve actually pointed me
to NFS client code which does a similar comparison. Let me redo this
part.

>
>
> Regarding the interface comparator, which I'll requote here:
>
> +/*
> + * compare two interfaces a and b
> + * return 0 if everything matches.
>
> This is fine, assuming the address comparator is fixed. Matching
> everything is the best result.
>
> + * return 1 if a has higher link speed, or rdma capable, or rss capable
>
> I'm still uneasy about selecting link speed first. If the mount
> specifies RDMA, I think RDMA should be the preferred parameter.
> The code you propose would select an ordinary interface, if it
> were one bps faster.

I could do that. But that only changes the order in which the
interfaces are ordered.
I think the place where you want this change more is where the
interface is actually getting selected for a new connection.
I'll do this.

>
> + * return -1 otherwise.
>
> Ok on this. :)
>
> + */
> +static int
> +iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
> +{
> +       int cmp_ret = 0;
> +
> +       WARN_ON(!a || !b);
> +       if (a->speed == b->speed) {
> +               if (a->rdma_capable == b->rdma_capable) {
> +                       if (a->rss_capable == b->rss_capable) {
>
> RSS is meaningless on an RDMA adapter. The RDMA kernel API uses
> Queue Pairs to direct completion interrupts, totally different
> and independent from RSS. It's only meaningful if rdma_capable
> is false.

Ok. I was not sure about whether they can co-exist, and decided to
make this extra comparison anyway.
Good that you shared this info. But I don't think this code hurts.

>
> +                               cmp_ret = cifs_ipaddr_cmp((struct sockaddr *) &a->sockaddr,
> +                                                      (struct sockaddr *) &b->sockaddr);
> +                               if (!cmp_ret)
> +                                       return 0;
> +                               else if (cmp_ret > 0)
> +                                       return 1;
>
> Again, I don't agree that the address family has anything to do
> with preferring an interface. This should return -1.

As explained above, this just decides the ordering of the interface list.
The items on the head of the list do get slight preference, the list
is first sorted based on speed, then on capabilities, then on family,
then on the actual value.

>
> +                               else
> +                                       return -1;
> +                       } else if (a->rss_capable > b->rss_capable)
> +                               return 1;
>
> It's good to prefer an RSS-capable interfgace over non-RSS, but
> again, only if the interface is not RDMA.
>
> +                       else
> +                               return -1;
> +               } else if (a->rdma_capable > b->rdma_capable)
> +                       return 1;
>
> And it's good to prefer RDMA over non-RDMA, but again, it's going
> to have very strange results if the client starts sending traffic
> over both interfaces for the same flow!

I understand your concern on this. And I can fix this.

>
> +               else
> +                       return -1;
> +       } else if (a->speed > b->speed)
> +               return 1;
> +       else
> +               return -1;
> +}
>
> And again, speeds are only one kind of tiebreaker. This code
> only looks at the RSS and RDMA attributes when the speeds
> match. The Windows client, for example, *always* prefers RDMA
> if available. But Windows has no explicit RDMA mode, it always
> starts with TCP. The Linux client is different, yet this code
> doesn't seem to check.
>
> Personally, I think that without an explicit -o rdma, the code
> should attempt to connect to any discovered RDMA server
> interfaces, via RDMA, and use them exclusively if they work.
> Otherwise, it should stay on TCP.

So even for this case, no mixing?

>
> OTOH, if -o rdma was specified, the client should ignore TCP,
> or at least, not silently fall back to TCP.

Understood.

>
> In other words, these tests are still too simplistic, and too
> likely to result in unexpected mixes of channels. Should we step
> back and write a flowchart?

I think I understood your concerns.
I'll address all these concerns with the next version of my patch and
then check if we're on the same page.

>
> Tom.



-- 
Regards,
Shyam
