Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89126C77B7E
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 22:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbjEYWO5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 18:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242111AbjEYWO4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 18:14:56 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAAA1A2
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 15:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3eZAgKIBQv9a78xj/T8D4m2MEU8G/Fe/i8jppO4GU8Y=; b=sBC/Or76iu0Vy0H8ptCl30R7UL
        mWid88qSfs0bZa2Du1fvkUi1yHxI+jIQiFzQnxKjJgI0AtMd1ffSAdq1FlkFKBXcpsf2GgHP3wF/E
        PoOH/UlZTjC1NfWAofTZr4ThKjqDewDQIQREYmnU2L9oCJcXM9Y/fE0kYfKBUN9kDrddNEVohgH6Y
        wnDPzQwqEAm0FhtWQLrtv3ze1UT6gVl6HHQI1RWuR+sOXma1pZJEvZp+/1IxIGwcuK4RFoOQcFxTi
        vOIpkzNrmLeyT8cvu3xSoranLpewp7oFpFND32MTTC2dXeSD0zTlNVdB2/2uQtMZvXDFTcWCZlEyG
        aKLc5kUA==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:To:From:Date:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3eZAgKIBQv9a78xj/T8D4m2MEU8G/Fe/i8jppO4GU8Y=; b=wu1DNzFMT10WdrXvov/pMzhexE
        W1TpI1ojcWukrQLzFw2amlIrWpfia5yZNSlB6PcOm/afLtfFcLhiRqYzXkAQ==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1q2JES-008uRU-8c; Fri, 26 May 2023 00:14:52 +0200
Received: by intern.sernet.de
        id 1q2JER-004r34-W3; Fri, 26 May 2023 00:14:52 +0200
Received: from bjacke by pell.sernet.de with local (Exim 4.93)
        (envelope-from <bjacke@sernet.de>)
        id 1q2JEP-00034a-G6; Fri, 26 May 2023 00:14:49 +0200
Date:   Fri, 26 May 2023 00:14:49 +0200
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@sernet.de>
To:     Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: Displaying streams as xattrs
Message-ID: <20230525221449.GA9932@sernet.de>
Mail-Followup-To: Jeremy Allison <jra@samba.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@lst.de>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
 <20230525093900.GA261009@sernet.de>
 <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com>
 <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop>
 <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
 <ZG/DajG6spMO6A7v@jeremy-rocky-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZG/DajG6spMO6A7v@jeremy-rocky-laptop>
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2023-05-25 at 13:22 -0700 Jeremy Allison sent off:
> I think cifsfs providing access to ADS remotely on Windows
> and Samba shares is fine.
> 
> What I'm scared of is adding ADS as a generic "feature" to
> the Linux VFS and other filesystems :-).

full ack on Jeremy's view here.

If there is something the the Linux VFS layer should *really* add to help 
interopearbility with basically all other major OS implementations is NFSv4
ACLs.  Seriously, for so many people living with Linux is a real pain due to
the lack of NFS4 ACLs here.

Björn
> 
