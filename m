Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13977C761A6
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 12:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjC3ME7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 08:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC3ME6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 08:04:58 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF661FE8
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 05:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=MZCNt0oZ+YpH+8I9vdc3K2qCsqt9K1p5uf9wQG4DMQM=; b=pz+Q73CZpGZduO//1R6xNm3Wv6
        m+wh3fgTsqK7Q8CTA/B4eC1zeKpRK+sYrvKiMQD7H/BYFDaSrYVwTQQ5VCWAkpqvl8US/iEjqQTnr
        M8oAjpYeDlk4+Pnsdry23brU7M3h9JB2h3uUMhuMHxVIzkGjnrsT6zd/y2uKq4LycyVBmroXFpRMd
        lYv25AsG+RvSAWVWSLPizYR6ahuGx4iQnLUOe7kPDnb2XR7SMsdMIT6JAao2qo/cmpuozrtutwvJy
        jjYCMXLPq7nVizX2Mh9o+m3omjRhjiVPAxHhmHx+4jlKdCq3p4EHOPxzD6YTIMRu1996m6RPbaINs
        OgJgKZEigQiPrP1xVvImpzyzEQk3p4y9zPD8O/y3HFKeEGLfxvZaGWjooMdKgAqEUn13KM/PaEw3K
        fpKbY2FB9a4KLNMCD8FYlHMOjzEFHCTAkFrh7dwR/liAqAWW2EfONwbTWg7HLwOHrE7SX4ufMd+la
        VhpqXm4M9VSrVGqy3Gltolk9;
Received: from [2a01:4f8:252:410e::177:224] (port=52126 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1phr1T-006GnE-Fx; Thu, 30 Mar 2023 12:04:55 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 0/3] Simplify SMB2_open_init
Date:   Thu, 30 Mar 2023 12:04:44 +0000
Message-Id: <cover.1680177540.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stitching together can be done in one place, there's no need to do
this in every add_*_context function.

This supersedes the patchet in

https://www.spinics.net/lists/linux-cifs/msg28087.html.

Volker Lendecke (3):
  cifs: Simplify SMB2_open_init()
  cifs: Simplify SMB2_open_init()
  cifs: Simplify SMB2_open_init()

 fs/cifs/smb2pdu.c | 106 +++++++++++-----------------------------------
 1 file changed, 25 insertions(+), 81 deletions(-)

-- 
2.30.2

