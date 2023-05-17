Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FCAC77B7A
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 11:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjEQLNl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 07:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjEQLNc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 07:13:32 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3A52D5E
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 04:13:32 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-643a6f993a7so432619b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 04:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684322011; x=1686914011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=190Jeeg3NhoW+/UQnQQ43bwbHd+n+U+76HP91IY+A0c=;
        b=jnYQcDQC12rgwMW1QFQbVTurXVRfr/gfFmphoFpXudXThgV6UAKd4BBAYhYtNGuAWt
         kwSXZrUb5BTIVtIse4hOKMy1LMulNHAzHF2SIXbX2NSV51THDZ323JfGdmNePQ2sKyCF
         TlVTSZbH579bzksp7YQvPROBEH8jQIrHsngmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684322011; x=1686914011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=190Jeeg3NhoW+/UQnQQ43bwbHd+n+U+76HP91IY+A0c=;
        b=EwqKENL56whQr5vpJ5kSb9pg70t4f4HWmTXGsuUxgRU+HPtYf+awnBdjOOI2X8/M0d
         cTle2m99Q7NMfyiMjYvQX5ui4GVrIVv7X79uAvhPuz7LTPrOC7YjmwSa5zt9U403bjwK
         vQUrAZk07478XDpS1tKlHsshrxHxkYtmlLgQ4HP0B4dxaXgqtSI3IEdYz77u2ttjov0D
         iPm9LRzdoahsWHwsSsQOmpSSD1Fzn3Nn+h2CyoQgRrSP3gZ+IG1jB2ES0Zz4Yz+me9+c
         DtBb1+kpvSbDXgBYK7VBfkAj38yfy0IzjcrHVoySeDTQpBXatDJ26DHk6h8LVSMi3Htp
         Yc0g==
X-Gm-Message-State: AC+VfDylYSmpNxmC6Ou6QNVBw1+he1Ryp+aL9P0InSJZMhk5b2HbTgtQ
        HpQxdKXJEnGqehRq8Wog5r5QiQ==
X-Google-Smtp-Source: ACHHUZ7JqNOy3L+PdpaJLjqVwVgHOAZV1RcC6CBZq81FjNt78Rzr96aKrNdQ/sppMNcYdeNJqYZ4QQ==
X-Received: by 2002:a05:6a00:1956:b0:63b:6149:7ad6 with SMTP id s22-20020a056a00195600b0063b61497ad6mr518352pfk.34.1684322011222;
        Wed, 17 May 2023 04:13:31 -0700 (PDT)
Received: from google.com ([110.11.159.72])
        by smtp.gmail.com with ESMTPSA id k5-20020aa792c5000000b0063b89300347sm15509871pfa.142.2023.05.17.04.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:13:30 -0700 (PDT)
Date:   Wed, 17 May 2023 20:13:25 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     HexRabbit <h3xrabbit@gmail.com>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, tom@talpey.com,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org
Subject: Re: [PATCH] ksmbd: fix slab-out-of-bounds read in
 smb2_handle_negotiate
Message-ID: <20230517111325.GC20467@google.com>
References: <20230517095951.3476020-1-h3xrabbit@gmail.com>
 <20230517110505.GB20467@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517110505.GB20467@google.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/17 20:05), Sergey Senozhatsky wrote:
> On (23/05/17 09:59), HexRabbit wrote:
> > [ 3350.990282] BUG: KASAN: slab-out-of-bounds in smb2_handle_negotiate+0x35d7/0x3e60
> > [ 3350.990282] Read of size 2 at addr ffff88810ad61346 by task kworker/5:0/276
> > [ 3351.000406] Workqueue: ksmbd-io handle_ksmbd_work
> > [ 3351.003499] Call Trace:
> > [ 3351.006473]  <TASK>
> > [ 3351.006473]  dump_stack_lvl+0x8d/0xe0
> > [ 3351.006473]  print_report+0xcc/0x620
> > [ 3351.006473]  kasan_report+0x92/0xc0
> > [ 3351.006473]  smb2_handle_negotiate+0x35d7/0x3e60
> > [ 3351.014760]  ksmbd_smb_negotiate_common+0x7a7/0xf00
> > [ 3351.014760]  handle_ksmbd_work+0x3f7/0x12d0
> > [ 3351.014760]  process_one_work+0xa85/0x1780
> 
> [..]
> 
> > -	if (req->DialectCount == 0) {
> > -		pr_err("malformed packet\n");
> > +	smb2_buf_len = get_rfc1002_len(work->request_buf);
> > +	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
> > +	if (smb2_neg_size > smb2_buf_len) {
> >  		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> >  		rc = -EINVAL;
> >  		goto err_out;
> >  	}
> >  
> > -	smb2_buf_len = get_rfc1002_len(work->request_buf);
> > -	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
> > -	if (smb2_neg_size > smb2_buf_len) {
> > +	if (req->DialectCount == 0) {
> > +		pr_err("malformed packet\n");
> >  		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> >  		rc = -EINVAL;
> >  		goto err_out;
> 
> May I please ask where out-of-bounds access happens and how does
> `smb2_neg_size > smb2_buf_len` fix it?

Correction: I meant to ask "how does moving `smb2_neg_size > smb2_buf_len`
up fixes it?".

We have this in the code at the moment

```
         if (req->DialectCount == 0) {
                 pr_err("malformed packet\n");
                 rsp->hdr.Status = STATUS_INVALID_PARAMETER;
                 rc = -EINVAL;
                 goto err_out;
         }

         smb2_buf_len = get_rfc1002_len(work->request_buf);
         smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
         if (smb2_neg_size > smb2_buf_len) {
                 rsp->hdr.Status = STATUS_INVALID_PARAMETER;
                 rc = -EINVAL;
                 goto err_out;
         }
```

But if we move `smb2_neg_size > smb2_buf_len` brunch up, then it cures
out-of-bounds access? Where is that out-of-bounds access? Looking at
the stack trace, smb2_handle_negotiate+0x35d7/0x3e60 should be somewhere
much-much later than these if-s.
