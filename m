Return-Path: <SRS0=I8HW=TX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819AAC282DD
	for <linux-cifs@archiver.kernel.org>; Thu, 23 May 2019 23:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D9482175B
	for <linux-cifs@archiver.kernel.org>; Thu, 23 May 2019 23:07:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="VRpMiOYM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbfEWXHD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 May 2019 19:07:03 -0400
Received: from hr2.samba.org ([144.76.82.148]:65144 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387725AbfEWXHD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 May 2019 19:07:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=Bh+ovhzdEVP67Vg/8o62NaiMYHoYL77GIEw9oxgHIEY=; b=VRpMiOYM6MLDdVBcl/tTr+137+
        zYfxf3/3Aj8XXUlTP4DcHV94/5KMOEoMDuSYN0dq/BlQXXjxxOiZlaR3xw2KaAItty6bqreX5rA0A
        kxAzMkAdmG/OZK+NZU8QqkSZNP8AAjvcNJJCwg78Z7BSz/UFf08G4OPQ5n5umcRQrkL0=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hTwnd-00048a-D4; Thu, 23 May 2019 23:07:01 +0000
Date:   Thu, 23 May 2019 16:06:58 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Tom Talpey <ttalpey@microsoft.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][SMB3] Add missing defines for new negotiate contexts
Message-ID: <20190523230658.GH244578@jra4>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mvEYMEUjz8BDRUumn0yGq__VntNKx-8AzWcZgCDOJQv-Q@mail.gmail.com>
 <20190418172353.GB236057@jra4>
 <BN8PR21MB11863B736AA5D284CC213118A0220@BN8PR21MB1186.namprd21.prod.outlook.com>
 <CY4PR21MB0149DC81B079BCD36D580AC5A0350@CY4PR21MB0149.namprd21.prod.outlook.com>
 <4591362b-cb4e-7e22-00a6-bf7239584957@samba.org>
 <CY4PR21MB014907F825DED7F5057E69E2A0010@CY4PR21MB0149.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR21MB014907F825DED7F5057E69E2A0010@CY4PR21MB0149.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 23, 2019 at 06:24:16PM +0000, Tom Talpey via samba-technical wrote:
> > -----Original Message-----
> > From: Stefan Metzmacher <metze@samba.org>
> > Sent: Thursday, May 23, 2019 9:51 AM
> > To: Tom Talpey <ttalpey@microsoft.com>; Jeremy Allison <jra@samba.org>;
> > Steve French <smfrench@gmail.com>
> > Cc: CIFS <linux-cifs@vger.kernel.org>; samba-technical <samba-
> > technical@lists.samba.org>
> > Subject: Re: [PATCH][SMB3] Add missing defines for new negotiate contexts
> > 
> > Hi Tom,
> > 
> > >> The Windows protocol documents were updated on March 13 for the
> > >> upcoming "19H1" update cycle.
> > >>
> > >> MS-SMB2 version page, with latest, diffs, etc:
> > >>
> > >> https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-
> > smb2/5606ad47-5ee0-437a-817e-70c366052962
> > >
> > > So, there was a defect in the published spec which we just corrected, there's a
> > new
> > > update online at the above page.
> > >
> > > The value of the new compression contextid is actually "3", but the earlier
> > document
> > > incorrectly said "4". There were several other fixes and clarifications in the
> > pipeline
> > > which have also been included.
> > >
> > > Redline diffs as well as the usual standard publication formats are available.
> > 
> > There's no server behavior defined for
> > SMB2_NETNAME_NEGOTIATE_CONTEXT_ID. If there's none, why was it added
> > at all?
> 
> It's an advisory payload, and can be used to direct the connection appropriately
> by load balancers, servers hosting multiple names, and the like. It's basically the
> same servername that will be presented later in SMB2_TREE_CONNECT, only it's
> available early, prior to any SMB3 processing. Other possible uses are for logging
> and diagnosis.
> 
> It has no actual function in the SMB3 protocol, so apart from defining the payload
> it's not a matter for the MS-SMB2 document. We would hope, however, that clients
> will include the context when sending SMB2_NEGOTIATE.

IMHO Looks like a reinvention of the 'netbios name' field that
allowed us to do clever things with the smb.conf 'netbios
alias' parameter :-).
