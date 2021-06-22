Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934A7C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 18:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7014460249
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 18:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhFVSdU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 14:33:20 -0400
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:51155
        "EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230146AbhFVSdU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 22 Jun 2021 14:33:20 -0400
Received: from [192.168.0.100] ([96.237.161.203])
        by :SMTPAUTH: with ESMTPSA
        id vlAslttD2gDYwvlAtllgCt; Tue, 22 Jun 2021 11:31:03 -0700
X-CMAE-Analysis: v=2.4 cv=T9xJ89GQ c=1 sm=1 tr=0 ts=60d22c67
 a=Pd5wr8UCr3ug+LLuBLYm7w==:117 a=Pd5wr8UCr3ug+LLuBLYm7w==:17
 a=IkcTkHD0fZMA:10 a=NKnj5_UAaIENT9y6Z7kA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: Processing ASYNC responses
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
References: <CAH2r5mvUXZtY3=LNzt8_icDfUAAeZpzjUK3sEErzpCksFDX2WA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <bf9d559d-e309-aac2-8406-e151453d8dae@talpey.com>
Date:   Tue, 22 Jun 2021 14:31:03 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvUXZtY3=LNzt8_icDfUAAeZpzjUK3sEErzpCksFDX2WA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfMoWcvHFjVMFEdBczZtpB1g1eSHNVQSEu0ECuOnqrCvvmFh86P7lpZDaCJrKcJXwoSy7mujTE5BOC2S+w/x1muYvzZ+V4rUKQ4kAGWjMiRV/dIA6qGUD
 2DC8JswP8OstB1YmFuJAe+xlXLZRK5dTRSQinEAgNl12FBXRpFW2tKequAx/VAHc/8EY9t7DTEJRk0c/cOT82TrDNdLFbWw28xam+LVDkeL747A3ezgLWCAK
 iCh3fDzWh6MJ/gdewo5uURQ73e6Y82m3K1VrHlIR/mRh+DWbDzQ2ed/Ek0fsX33VVORLSdagLi5AIcEhAlKuY+MYZCGOFfSpj5qFwXf3qro=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/22/2021 1:45 PM, Steve French wrote:
> I noticed that the client isn't checking for SMB2_FLAGS_ASYNC_COMMAND
> in the header flags field in the response processing.   Are there
> cases where we should be checking for this?  See section 3.2.5.1.5 of
> MS-SMB2

The header format is different when this flag is set. Looking
at smb2pdu.h, I don't even see a structure declaration for the
async header! How/where do async responses get processed??

Tom.
