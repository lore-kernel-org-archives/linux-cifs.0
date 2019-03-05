Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E121C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1EEE20661
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:45:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSuWykJA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfCEXp2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 18:45:28 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:46140 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfCEXp2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 18:45:28 -0500
Received: by mail-pf1-f181.google.com with SMTP id g6so6916325pfh.13
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 15:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=YVTLo6E0c0zOrq6Proi6VBlgM9VSJnZNjfxnzKqrkKA=;
        b=YSuWykJApwk8gELCwP1OzuR29GGRUEdMFYqGwC0ARPs4wJhehWNHTN0fh1CUPhMte5
         KvqPNeRNITstUu+1LkbvgE47LMrvzeNNKycdA3jjq9TQPmMEhExlr6EZPj8AzyP+h2FV
         L/1/HHRnxkJ35123HqJXJS/gwDP9OdWEmseGJUe6nDuxkTiQl1A0jIvFde9qyUJl57oA
         Tjkx0tRNjL3V4Pvi5iVZOVCImaCD3uhqT2nzsX81yjr5lLTWZm8NCavGU0m2mOTJzFZY
         3hCChYo3LoOqFcXOiHT7bF8Nav4DEUS/aLVjlBuKmS+ymqfjdPWCD4nFacbivRaOPEdJ
         qbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YVTLo6E0c0zOrq6Proi6VBlgM9VSJnZNjfxnzKqrkKA=;
        b=O/XuL/9lMhGCmRi1uMuzCggQGmltLTHIrFABd4rKNSQmtcH2+jikVJ05YjL7sA3Ame
         z4XjKxSYZrVswqQJxtsl8EXvvSkG0jEH8cUe7LRiqtqwSh9DcEXiCfNC9rNEEsHJon5O
         PmPlcqeOelZRXjxWJBbUGRfr5a6UpKE+j4PeuzSATUgpx2LCqsFbpMN7RhiPHd/Klquw
         jGyT98G5//FXHIAC2Mvpf9ZrtZdODSHGJGTMIUailm3bRR7+DSHTz8kLpTWufJVeLXvm
         3A01EozZQ2sAug2KsLEtHLzeGs6YUHBc14gUZthS5RNcfILkaSXmdA3wA23xlRyGisHX
         c+1w==
X-Gm-Message-State: APjAAAXVkKX+Ldy817w0v/TrCtSuu0t4mCcUq/f+DF0ZUk9b7EfD0fO/
        1iIhDkGeAtDEBg0ZP0ZPtbUYGLFOjRI1ondxiT5jp9j6
X-Google-Smtp-Source: APXvYqx1I/JlMV/w2NXCKJAWicSQP+Nz25CQgSOvZ7lHMnba5fpph9qijU3W8Jp3Nlilh3TI6Utd/KwXCogRskbUr1s=
X-Received: by 2002:a62:5385:: with SMTP id h127mr4292138pfb.10.1551829527391;
 Tue, 05 Mar 2019 15:45:27 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Mar 2019 17:45:16 -0600
Message-ID: <CAH2r5ms8C9cQSTY51neWvSRCahJ-dSMekZVza-9fA=LdZBY+qw@mail.gmail.com>
Subject: xfstests passing again to current for-next
To:     CIFS <linux-cifs@vger.kernel.org>, Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Moved the xfstest git branch back to December 6th (just before the
testcase problem patch Xiaoli pointed out) - and cherrypicked tests
524 and 528.  Looks like current for-next worked fine
(http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/111).
Will  kick off the cifs-testing bucket later today.

-- 
Thanks,

Steve
