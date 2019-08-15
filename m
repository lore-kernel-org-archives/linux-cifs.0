Return-Path: <SRS0=/Ffk=WL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA43C3A589
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Aug 2019 15:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF5220665
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Aug 2019 15:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfHOPs5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Aug 2019 11:48:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:50342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730805AbfHOPs5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 15 Aug 2019 11:48:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 14738AD85;
        Thu, 15 Aug 2019 15:48:56 +0000 (UTC)
Date:   Thu, 15 Aug 2019 17:48:54 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
Message-ID: <20190815174854.05661672@suse.de>
In-Reply-To: <CAN05THT0OkbAoNu8ZVSHF-xY7w0ZW4q4i-jTxjNManrnz0OMfg@mail.gmail.com>
References: <CAN05THT0OkbAoNu8ZVSHF-xY7w0ZW4q4i-jTxjNManrnz0OMfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

Is the file flagged sparse (FSCTL_SET_SPARSE()) prior to the QAR
request? When implementing the Samba server-side I tried to match
Windows/spec behaviour with:

702         if (!fsp->is_sparse) {
703                 struct file_alloced_range_buf qar_buf;
704 
705                 /* file is non-sparse, claim file_off->max_off is allocated */
706                 qar_buf.file_off = qar_req.buf.file_off;
707                 /* + 1 to convert maximum offset back to length */
708                 qar_buf.len = max_off - qar_req.buf.file_off + 1;
709 
710                 status = fsctl_qar_buf_push(mem_ctx, &qar_buf, &qar_array_blob);
711         } else {
712                 status = fsctl_qar_seek_fill(mem_ctx, fsp, qar_req.buf.file_off,
713                                              max_off, &qar_array_blob);
714         }

...in which case you should see similar test results against Samba. This
also excersized via the ioctl_sparse_qar* smbtorture tests.

Cheers, David
