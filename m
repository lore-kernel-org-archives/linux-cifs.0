Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D14C636CD
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Feb 2023 12:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjBJM34 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Feb 2023 07:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjBJM3z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Feb 2023 07:29:55 -0500
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9443733456
        for <linux-cifs@vger.kernel.org>; Fri, 10 Feb 2023 04:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Type:MIME-Version:References:Reply-To:
        Message-ID:Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c1JHuREojxcsJz01lu9Yebdv+Esjs4HmUac6TdxoRqc=; b=MkiyqjLjCAlHr5vTcewDhr9fkn
        3izVxa7O8qvdVmayCO1Gx8w+EOra+BNs3V3Hu4xPrCKMHZnmRk/cunHJVyWD2l6SNVOlQhOfktes8
        qd0fgf9yhEUYCX3Be4Eav1u6hIkFydDYD62xfinMaw7EoEtR1Ifrpy/mrjHb1LNKVsL0ms8s+ec4h
        /U2dIR5PRMvVzoiXTqOuYHrt3KVUulDca4IjWNe69GDcdOkmtE/9TI+1dACjQdY07kGF4LAadiH06
        q5hU1uxGdUUqZvQaCa9FBXJ3qCq/fza8IWi4g/W50TTuwXs6TRtfW7PTygjvlC8IRoNjOE8Ic1/Wk
        8VhguwDA==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Type:MIME-Version:
        References:Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c1JHuREojxcsJz01lu9Yebdv+Esjs4HmUac6TdxoRqc=; b=RSv/JJvQqSOPh89bwRBLlMvt6y
        0kfgfU+jCE2iT54OfB/k9VsbTngtWv3uyP9OMf1bvgYuz08WcCBtx/6BNeAg==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1pQSXI-00HRwe-Ky; Fri, 10 Feb 2023 13:29:52 +0100
Received: by intern.sernet.de
        id 1pQSXI-00AAQO-B2; Fri, 10 Feb 2023 13:29:52 +0100
Date:   Fri, 10 Feb 2023 13:29:48 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org
Subject: Re: Fix an uninitialized read in smb3_qfs_tcon()
Message-ID: <Y+Y4vMiTFdev4V1L@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
References: <Y+UrrjvGrOT6Bcmy@sernet.de>
 <87lel6enq6.fsf@cjr.nz>
 <CAH2r5mvGWJVjPJo1Guyd7W0eiHyRD9Wd7F0ndKLaGCj6VyHUwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mvGWJVjPJo1Guyd7W0eiHyRD9Wd7F0ndKLaGCj6VyHUwA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am Thu, Feb 09, 2023 at 01:43:34PM -0600 schrieb Steve French:
> merged into cifs-2.6.git for-next

This was only the initial one. I have squashed all the other ones into
my latter submission to this list. Do you want me to re-submit on top
of for-next?

Thanks, Volker
