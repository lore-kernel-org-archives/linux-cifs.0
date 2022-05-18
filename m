Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E712C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 19:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241787AbiERTPo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 15:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241800AbiERTPn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 15:15:43 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21D4279
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 12:15:41 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 71E4B7FD1E;
        Wed, 18 May 2022 19:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1652901339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1w7BA4gllz6o7NzQN/qFd9/9GzmGmDSNtX1OAj6ZnNs=;
        b=SAcrpuHvwnhnYQomUTor9PazFq3spIrdWJ9nNZnZmPrT/lmlifnZrh493s2A61kmkJ7oCc
        S9a6WVxQapTsTS/APbN+V+XhPetwm21owwergZZxFG1O5ZwlLgFJ4JWHabTqwBBb7uVPmx
        DKVuNereJ336QxxByslChl6APX9nPI0SqcvNQWWNQ/bI93Pj895yh0JtDRB4aS8a27Q2DK
        JwqN4zIGrWnlzMvRvdu79bw5oz2STBdiuK1aNBRt8Rit6rg4LRXVerqZX04Zn2mtjXMLzS
        av0fdH1Bw1QvjLWMpvsjG7b7/PdkOIkpxxLWDJttJUH8teU6HURUKgqT50j8xA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Multichannel fixes
In-Reply-To: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
References: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
Date:   Wed, 18 May 2022 16:15:33 -0300
Message-ID: <874k1m3b56.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> This time, I've verified that it does not break the multiuser
> scenario. :)

Thanks!  What about DFS failover scenario?  :-)
