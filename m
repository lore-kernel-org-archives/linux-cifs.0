Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CC9C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 11:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 679B62083D
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 11:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731074AbfB1L4N convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:56:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:48088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730976AbfB1L4N (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Feb 2019 06:56:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9107AF8D;
        Thu, 28 Feb 2019 11:56:11 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] Add a dynamic tracepoint for smb3_cmd_enter
In-Reply-To: <CAKywueRw7aBj3AhSADbU1pSWuTNa=7LKaXWNPrhB6isf2x-DWw@mail.gmail.com>
References: <CAH2r5mt_bKGxNVCchmwCo-J7T_WqZRW+HXsn=V7c57_s6cBgxA@mail.gmail.com> <CAKywueRw7aBj3AhSADbU1pSWuTNa=7LKaXWNPrhB6isf2x-DWw@mail.gmail.com>
Date:   Thu, 28 Feb 2019 12:56:09 +0100
Message-ID: <87o96wnn3a.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel Shilovsky <piastryyy@gmail.com> writes:
> Thanks, now we have a great tool to start analyzing client latency.
> The more advanced step would be to start aggregate latency numbers and
> count percentiles (especially for specific commands).

As a side note, Wireshark can report some of this.

tshark -z smb2,srt  -r dump.pcap
SMB2 SRT Statistics:
Filter: smb2.cmd
Index  Commands               Calls    Min SRT    Max SRT    Avg SRT    Sum SRT
    5  Create                  14759   0.000387   0.035268   0.001288  19.003702
    6  Close                   14713   0.000253   0.029454   0.000629   9.260241
   14  Find                    27468   0.000237   0.035798   0.000678  18.634827
   16  GetInfo                   983   0.000276   0.020349   0.000553   0.543487

SRT is Service Response time. You have RTT and other metrics as well. I
discovered this via Ronnie's SDC talk from years back [1] very good
reference. You can also graph all sorts of things, look at the slides 28
and on.

1: https://wiki.wireshark.org/Presentations?action=AttachFile&do=view&target=RonnieSahlberg_UsingWireshark.pdf

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
