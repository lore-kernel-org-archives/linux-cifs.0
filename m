Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBC8C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 15:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C9220684
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 15:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihfTJfkZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfBYPyv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 10:54:51 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44540 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfBYPyu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 10:54:50 -0500
Received: by mail-pl1-f194.google.com with SMTP id c4so4674321pls.11
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 07:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Olc1JYBbOwmnyLx5bWytUnqnVOAFTM6mWwyWASHXndI=;
        b=ihfTJfkZ3HT/dMTmMHBx2sWIIUDtDskkJo6pH6cJFWMZxLOsIFSb/XWIfiuATD4i8i
         D5SR87W3prdb6/E+E2PmXBWj72ZiYNjAYX7S5XGEhB7CK20mJhZPORxYZnId+yklZcIM
         ZHVX5jtbvZRUCo5x29H7LESjYIp1s+DIyqFf+gpt1V7H5mplaMOKxZJWkXoegu/kUCnQ
         IWWxUE0UAl+5k42fuDTAX4YroW6Nk7OBNIcfhUIuxfOKfGxu87L/eOpqfk/SRnnz8LoX
         HqBJg3XCl0heOppgCcVmccGtGEpZ9qoYgZEX68xPbUIVWaxw08N7JHNiplKO5V29NFrJ
         3Zew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Olc1JYBbOwmnyLx5bWytUnqnVOAFTM6mWwyWASHXndI=;
        b=bKYLjODFDt7IQFekOrEJF9H8svOXtIa+txFIgKQ62h0VEIDlirlQB8sL87EHgQnUhV
         dAgcke4lq+H/sk+v/BjrC55kkV164RSCJpIrfSjPud7VuyGeCyYFuWnSagSwJyQyNE8H
         I2wMpwpH+/5dcCjG0tGTiOvkCtdck21i81PYTYPcVLv3wdzwmNgZMDgL9SGtBQGxYiSO
         qlQrmI/ljHpntOjPahflid3fsHWKQctsz8hn0JeERkoBewOogUhN6qrvhuVvt3XYpd73
         /YT/c2R4bWWENwQ1Dk3216CRUxFjmZdseCianyLJeB2fIxXhEq39IPtwpp2prTV+PmCm
         9RwQ==
X-Gm-Message-State: AHQUAuYefzskPDVaLwDlOT90R1K1ErLjB4s/XbGIDsKbefrqC8hlJatD
        EFURrl6Jvd0Llvmv9BPRYq84eNpw/stpvZdTVNhROQ==
X-Google-Smtp-Source: AHgI3IZIVzvD6f7GqABVHXlG+Alx4vvOr6Nct/eeDF6tuqN6d06N6hjNx8Arhm9/Wvbtlr7KsyfOOTEQ76zlR2CFpso=
X-Received: by 2002:a17:902:e090:: with SMTP id cb16mr20428707plb.32.1551110090043;
 Mon, 25 Feb 2019 07:54:50 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msoRSXFj=SM54Dg7A74yMj9X1XB=S8JY1zM=FgH13qzog@mail.gmail.com>
 <b3ffde7e-b8b1-b44c-a440-bcd2d1c9ca0b@samba.org> <CAH2r5muat94zgOLN6rqUF5pfFWfq=TN2FAJrEXLPtus9WCa78g@mail.gmail.com>
 <341721d1-0ac5-3c0f-9ea5-a9bd10816023@samba.org> <20190225142108.GB3181@jeremy-ThinkPad-X1>
In-Reply-To: <20190225142108.GB3181@jeremy-ThinkPad-X1>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 09:54:38 -0600
Message-ID: <CAH2r5ms=v-BA1PN00JRyUJ7HY8SCQ3oB8hWE=Ai2+epx-hA3Tw@mail.gmail.com>
Subject: Re: Update POSIX negotiate context during negprot to include GUID
To:     Jeremy Allison <jra@samba.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes - it fails (Samba returns error invalid parameter) without this change.

On Mon, Feb 25, 2019 at 8:21 AM Jeremy Allison <jra@samba.org> wrote:
>
> On Mon, Feb 25, 2019 at 08:43:33AM +0100, Stefan Metzmacher wrote:
> > Yes, that correct, I missed that sorry.
> >
> > Does your client still work without that chance, just sending 8 zero
> > bytes? Or does that fail?
> >
> > I guess it will fail at
> >
> > +               if ((inbuflen % 16) != 0) {
> > +                       return smbd_smb2_request_error(
> > +                               req, NT_STATUS_INVALID_PARAMETER);
> > +               }
>
> Yes, it's supposed to fail there :-).
>
> > I think we need to have something like this before:
> >
> >      static const uint64_t reserved64;
> >      DATA_BLOB reserved = data_blob_const(&reserved64,
> > sizeof(reserved6464));
> >      int cmp;
> >
> >      cmp = data_blob_cmp(&in_posix->data, &reserved_value);
> >      if (cmp == 0) {
> >            inbuf = (const uint8_t *)SMB2_CREATE_TAG_POSIX;
> >            inbuflen = 16;
> >            outbuf = reserved.blob;
> >            outbuflen = reserved.length;
> >      }
>
> I don't want to do that. None of this code is in any
> mainline/master/released code bases so I don't want
> to support what is "test" code in the Linux client.
>
> We are close to the point of making something
> that we can commit to support going forward,
> but we're not there yet.
>
> So I really don't want to support any Negprot
> variants other than the latest "list of create
> contexts" version.



-- 
Thanks,

Steve
