Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD96C3DA4D
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 16:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352864AbjHQQTm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 12:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353576AbjHQQTL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 12:19:11 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABC530F6
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 09:19:10 -0700 (PDT)
Message-ID: <ef250b95761099718c3903b89da062d7.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692289148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y3urZj9XjFXG8XLgYw3WU5s5sJGzfyAp7AJ2y6fZPSw=;
        b=SyfUnUyBF0DGThhgiE8k77yR5usDJaqURBT+5+ksgOVoJo6biWtrdqR0b1swCZiKbiVZip
        KYGC2cdzzFTI7Yk81cA2oIol8MIjz+wzAq528lGIjptt3ZIS1P4YAdMA+9LgJQgiHomg8N
        xkMxUNxaZhFdBzXzTp7s6YA9lcajI+eDfpQfgUsQ8IUUcYOlPSZAJck5eboIHcF2ZLzqcg
        Gjtb7wn390a7foyw0O4LQDeSPyfop8ubyDcLO8mGqME2eXFC/g5qSRnCfc4cUJYHckRM+c
        0c1xrqXHVLDOJ6RuBtUjxVmpojFbnadu0aHNGYF6PIs0Y3sQjhE/C+RfaNNUwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692289148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y3urZj9XjFXG8XLgYw3WU5s5sJGzfyAp7AJ2y6fZPSw=;
        b=Kp9OqjuY0yjq23QVTeAzif6i87FovXZsKnOBYYYEyXEpZB2HESYQdNVp46nHe28hpjMZ3U
        wRQjZRtE1hNXT8j879nSYIVmLcJ5W8rZBPcW9GGJ6+k5lYedMX682wyJou+EAfuxRmCdWK
        SSc78WZGrPSEBkWFOhiUHtF8KhMrpbWzI4V4RAixEMMAkuJ+EtIYufZQf88y19xLrx6Uy8
        ilr/eUwHSCsMxQSxpTycLqjaceO8HyotGqWAnXCkbL5MHUKqSmZ0hlbI3e0oGKZU4lsNFr
        4Ck56VcSDKIgUN1GTCe/xQLAPxtyL5rztnb9FxmUk/j6GF4atn6gwL2JK2oJbQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692289148; a=rsa-sha256;
        cv=none;
        b=ajrpvZ1lcQ6dI3a2YzQDZv6dGeLwdEoSpohAmHDK4N3cZPRZ160/0oUDNZEoyfdfXSy26N
        CRVAwkiMSICwTqQ9oOTwur2rZ57bGXCLuW1ydyaLDPjhP8iaH1t+0PdWzy11AklU9cOti4
        dVxuMAdP9DNZeCJdHXe2WOhp9t4Acxw5sOn95N0XBXKk0Z6n9xsUgVH5SWLY1EOHQ4TbDt
        ALLEd3xUokTDxHpiSSlGWRhS8ntZccpTP3nB+SUydPziZFu1xz701EY663+DthFH+xlIhI
        Uq7ErF4Btpkk0oqnNfkLTod33s8t2o3gojO/O2iTSyZNa9vCaWWnQXHEBafEWg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Fwd: [PATCH 09/17] smb: client: do not query reparse points
 twice on symlinks
In-Reply-To: <CAH2r5msoEON7SE9H9sEMLMZcH2BgT94wOhhtXBnkpC3PAJCKXQ@mail.gmail.com>
References: <20230817153416.28083-1-pc@manguebit.com>
 <20230817153416.28083-10-pc@manguebit.com>
 <CAH2r5msoEON7SE9H9sEMLMZcH2BgT94wOhhtXBnkpC3PAJCKXQ@mail.gmail.com>
Date:   Thu, 17 Aug 2023 13:19:04 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Am also curious about the problem where we do an extra query on
> mfsymlinks with ls -l

When we find regular files in QUERY_DIRECTORY response that could be a
potential mfsymlink, we always mark those dentries for revalidation so
we can read its target when it is an actual mfsymlink.
