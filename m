Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C02C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Apr 2022 12:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiDGMDn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Apr 2022 08:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiDGMDm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Apr 2022 08:03:42 -0400
X-Greylist: delayed 406 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Apr 2022 05:01:42 PDT
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826E14BFE9
        for <linux-cifs@vger.kernel.org>; Thu,  7 Apr 2022 05:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
         s=20210621-rsa; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q7a/RGjuFkhKCGxDvqJFUUcZoAE74Fty6J6hrgiDj/g=; b=pmZq8rqgevHifdn/zHhjRNX2SU
        YTH9BVwbUGMEHjWo9K0iOumx0rdSeJDQVj4/DBVB3OWjz1gHICLDKt6Q5UctcNzpmtkwJVyDg+lCA
        Yq6aHkmB2ptdhllx5NfOTZYwPMdzgakEdmEK7JKnQh7MeO6lYdJ8XCPLebT7QHJESNLgBXIY+gppY
        hoermpDdk98a0GpVXA6NqOoA9CHXXbud/u+xxX+JgOwbnit9ZrgzExy/XngRxV1IWtknT/V/Wg8KP
        CHchBMEjlONe2HlONYCBuFYUxLkcx+pchscWJ+FRsf98fMu3yPa5b3TUfERA0HCeUUDdGKvV6oza5
        8liVZz9w==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q7a/RGjuFkhKCGxDvqJFUUcZoAE74Fty6J6hrgiDj/g=; b=oCESFFhroUgd5uMBD3OgFVsd0A
        94PEJ6/4nN/4NzIn2O8bbq8QQbv66Ai21Mtau79nXhyHJWgZvO9cVxmOLJDA==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1ncQiz-0002ga-QS; Thu, 07 Apr 2022 13:54:53 +0200
Received: by intern.sernet.de
        id 1ncQiz-0001HI-OI; Thu, 07 Apr 2022 13:54:53 +0200
Received: from bjacke by pell.sernet.de with local (Exim 4.93)
        (envelope-from <bjacke@sernet.de>)
        id 1ncQfy-005MxB-B1; Thu, 07 Apr 2022 13:51:46 +0200
Date:   Thu, 7 Apr 2022 13:51:46 +0200
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bjacke@SerNet.DE>
To:     Rowland Penny via samba <samba@lists.samba.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [Samba] samba-ad linux clients random access denied to network
 share
Message-ID: <20220407115146.GA1277129@sernet.de>
Mail-Followup-To: Rowland Penny via samba <samba@lists.samba.org>,
        linux-cifs@vger.kernel.org
References: <20220406231135.024f1ea5@jeeg20151223.verlata.it>
 <48371ac062c13d0acb1ac4266e46ac65a49af023.camel@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <48371ac062c13d0acb1ac4266e46ac65a49af023.camel@samba.org>
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2022-04-07 at 08:51 +0100 Rowland Penny via samba sent off:
> > Linux clients mount this share using nfs4.
>=20
> Why ? You can use cifs and mount it directly.

=66rom personal experience I can say I had to realize that there are actual=
ly
reasons why people need to use NFS instead of cifs. The Linux cifs module g=
ets
new features constantly, which is great and which is why the yearly statist=
ic
about commits in cifs vs nfs kernel code look so nice for cifs.

However existing problems, which are blockers for serious/enterprise usage =
of
cifs on Linux clients too often don't get much attention unfortunately.
Bugzilla's search is your friend to see more specifically what I'm talking
about.

Bj=F6rn
