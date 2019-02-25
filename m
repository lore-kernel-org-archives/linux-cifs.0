Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F0AC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 14:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E696213A2
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 14:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="Sf7YnNd/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfBYOVN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 09:21:13 -0500
Received: from hr2.samba.org ([144.76.82.148]:23070 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbfBYOVN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Feb 2019 09:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=AVc3VOCK2v31inw66CO5N4eu5KzB1mNNPfp7W5CdGF4=; b=Sf7YnNd/Jt4erkvzY5CP+bribU
        xs8S8sdoo/vjjb12kkxThs6dbwes7pLwjwr6fQ48+Gm6/5EDzAfQERIWSDSgg/qko984GWnd48Ei9
        AXrocVtSFKWmBXobbzecB1JpH7zqrc63Ti1CrWKDaH0G7UYbIpJoa1kCVLGW2xGHVse0=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1gyH83-0005Zn-I1; Mon, 25 Feb 2019 14:21:12 +0000
Date:   Mon, 25 Feb 2019 06:21:08 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: Update POSIX negotiate context during negprot to include GUID
Message-ID: <20190225142108.GB3181@jeremy-ThinkPad-X1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5msoRSXFj=SM54Dg7A74yMj9X1XB=S8JY1zM=FgH13qzog@mail.gmail.com>
 <b3ffde7e-b8b1-b44c-a440-bcd2d1c9ca0b@samba.org>
 <CAH2r5muat94zgOLN6rqUF5pfFWfq=TN2FAJrEXLPtus9WCa78g@mail.gmail.com>
 <341721d1-0ac5-3c0f-9ea5-a9bd10816023@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <341721d1-0ac5-3c0f-9ea5-a9bd10816023@samba.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Feb 25, 2019 at 08:43:33AM +0100, Stefan Metzmacher wrote:
> Yes, that correct, I missed that sorry.
> 
> Does your client still work without that chance, just sending 8 zero
> bytes? Or does that fail?
> 
> I guess it will fail at
> 
> +               if ((inbuflen % 16) != 0) {
> +                       return smbd_smb2_request_error(
> +                               req, NT_STATUS_INVALID_PARAMETER);
> +               }

Yes, it's supposed to fail there :-).

> I think we need to have something like this before:
> 
>      static const uint64_t reserved64;
>      DATA_BLOB reserved = data_blob_const(&reserved64,
> sizeof(reserved6464));
>      int cmp;
> 
>      cmp = data_blob_cmp(&in_posix->data, &reserved_value);
>      if (cmp == 0) {
>            inbuf = (const uint8_t *)SMB2_CREATE_TAG_POSIX;
>            inbuflen = 16;
>            outbuf = reserved.blob;
>            outbuflen = reserved.length;
>      }

I don't want to do that. None of this code is in any
mainline/master/released code bases so I don't want
to support what is "test" code in the Linux client.

We are close to the point of making something
that we can commit to support going forward,
but we're not there yet.

So I really don't want to support any Negprot
variants other than the latest "list of create
contexts" version.
