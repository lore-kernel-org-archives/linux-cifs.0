Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD12C433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 16:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244065AbiDAQno (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 12:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350504AbiDAQng (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 12:43:36 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D5E15468E
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 09:25:11 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C5D1F7FC23;
        Fri,  1 Apr 2022 16:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1648830309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CZoOFv8F+9s/N3IdPLnPyqVgOEmOxHcqDBLK1how8yI=;
        b=pTkkfVFUNagRcm9fEp6rtrQCCy1ETKwJu1QlGJpY2aiOcY2vF9ao2Bg/L25ZQgPKNe8M4d
        dzS3sk/aIZjnRb9n0HqAeO+XA30x0KQ+HekDie4zGhtMgS/mJg5K5F9EwMecypFeBHD4+h
        xcPL06tV0w00CBAwsChWXrehWCvRLUHsfpXMFum9ds5GgsYMZX9I1p6h7qaOJyl0/6n8KO
        kyfGpV8mglEWxQbWOulJZrhDqfowqurqNFu2Rh4JyUorggnobGXDLrIfLW9OFEQVXAAA+/
        8HdN5YOxHnzWjlr4KC+zlcXcGobyI4Rd5sGlZJ4hse+uoAOvEtOeBN1mv07crw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: Re: [PATCH 2/2] cifs: force new session setup and tcon for dfs
In-Reply-To: <20220331194944.72cpzns6hako7lcx@cyberdelia>
References: <20220331180151.5301-1-pc@cjr.nz>
 <20220331180151.5301-2-pc@cjr.nz>
 <20220331194944.72cpzns6hako7lcx@cyberdelia>
Date:   Fri, 01 Apr 2022 13:25:04 -0300
Message-ID: <87k0c8g49r.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> If you're ignoring @mark_smb_session, why not just leave @server for
> reconnect_dfs_server()?

Good point, yes.  I'll send v2 with it removed.
