Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2F8C77B7A
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 00:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjERArI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 20:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjERArH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 20:47:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74BC40C7
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 17:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=AaGS83smF/XlBb+hCF0fMrYW/VLs412qc5lc7uwI5S8=; b=lonhnMfqc+uxCJiChJe4Niy7zW
        nhvmOJa0QkPfpbJNbv+xq1HmriJvS4g57Y1GEMqAgdNlSy+DB52U8XyNmrFlIRHb2oyko8x6jzD7p
        F6FwoE+j2izu1NTYQ5JSp8fHj1M7xdz3+bve5ZBVUuahSCy0gGay+O/RLffQt12LxoCwMAUlCy34y
        hW2QdwVLSFRN/QFc2emnuWANhwFRDfej1ciLxApq7TYkzDdNPqerEvW/Q4R47nf90pRpWid/uUUQV
        fS2suW29RezqdFWinfeez1HKiuONP4dxSLr3BKwn334r1+XbT+DObAeIgb51gg49dfZ13nO05moiK
        /PggpHbHPqeQCUSw7XGCoZrE07PQGBhFWXe+6nMPS77LKRJFZ3zZdv4SE15LPdi1uXgMfMFYrmiUn
        qQ22DVVtpHWtaFIvw+L7yRjXzukXncVahUP3tNxgAxiLm/VJi4Pnj3kHDPhSWWFgNdEDUQINI6nU4
        eyutdPQtbG12terOq7CvsLJR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pzRnL-009kTL-Ig; Thu, 18 May 2023 00:47:03 +0000
Date:   Wed, 17 May 2023 17:46:59 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Hex Rabbit <h3xrabbit@gmail.com>, linkinjeon@kernel.org,
        sfrench@samba.org, tom@talpey.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context
 decoding
Message-ID: <ZGV1g01hOlvzUuvj@jeremy-rocky-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20230517185820.1264368-1-h3xrabbit@gmail.com>
 <ZGUk3O75foDOPaJ7@jeremy-rocky-laptop>
 <CAF3ZFedA=Q+ghkKNR=wnbNQ63LXPwagetmez0KqZthMySBNTJA@mail.gmail.com>
 <20230518003748.GE20467@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230518003748.GE20467@google.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 18, 2023 at 09:37:48AM +0900, Sergey Senozhatsky wrote:
>On (23/05/18 03:28), Hex Rabbit wrote:
>>
>>    Maybe it might be worth addressing these issues in the upcoming patches.
>>
>
>I guess that would be nice to see

More than nice. Essential IMHO.
