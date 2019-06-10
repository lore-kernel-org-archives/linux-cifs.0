Return-Path: <SRS0=PPE7=UJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48AAC31E40
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 14:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9122920859
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 14:56:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="LOqqrfPo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390125AbfFJO4w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jun 2019 10:56:52 -0400
Received: from hr2.samba.org ([144.76.82.148]:20748 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390087AbfFJO4w (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 10 Jun 2019 10:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Date:Cc:To:From;
        bh=ecaFau5kuUWRgp8qE+5WAHNyYAn0+EsWdtlEzfXizuI=; b=LOqqrfPoXHOoRC8hlZCpgQu2B9
        c1mmzqjf1VMFUfuu9RIOP4HfhmpFcvnj86XNZtuhPmjZ9eUoVcF5VYVZdpaZE9lqYg+ueS7R2SR8h
        DIU+9xyIyR9rKrZhYOntJx155Qn+V24C3Yx6qUxPdO74mkEnVphuMKfBIckc3IfZKffs=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1haLj8-0006rk-2c; Mon, 10 Jun 2019 14:56:50 +0000
From:   Andreas Schneider <asn@samba.org>
To:     samba-technical@lists.samba.org, Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [SMB3.1.1] Faster crypto (GCM) for Linux kernel SMB3.1.1 mounts
Date:   Mon, 10 Jun 2019 16:56:19 +0200
Message-ID: <48763148.viiOTLWQpP@krikkit>
In-Reply-To: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
References: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Friday, 7 June 2019 22:23:30 CEST Steve French via samba-technical wrote:
> I am seeing more than double the performance of copy to Samba on
> encrypted mount with this two patch set, and 80%+ faster on copy from
> Samba server (when running Ralph's GCM capable experimental branch of
> Samba)

I'm sorry but I have to disappoint you, my name is Andreas and not Ralph ;-)


