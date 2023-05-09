Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC796C77B7F
	for <linux-cifs@archiver.kernel.org>; Tue,  9 May 2023 03:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbjEIDF6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 May 2023 23:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbjEIDF5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 May 2023 23:05:57 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FBD4C15
        for <linux-cifs@vger.kernel.org>; Mon,  8 May 2023 20:05:56 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-51b661097bfso3764409a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 May 2023 20:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683601556; x=1686193556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kHlrG/qXUe+PuVUVOtc1QZlU8b5+hWAFlmrfbbpwa/M=;
        b=WzYSLJMD8vpCi8RJOA6KgpYPgfgLlyZCT5OzR3N5gARBPPsw8+UCcTFQHdSFljpp9e
         x7UNNB6osJjfMH1zXhr8km3rmpsffoRs2ARBNrjIVxtqCzAdhxNh5TjswioQ6v9jEvUv
         gTcWJtMMv8sGbnqeN1TJvyOduecqOpC9QwOJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683601556; x=1686193556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHlrG/qXUe+PuVUVOtc1QZlU8b5+hWAFlmrfbbpwa/M=;
        b=Ep7As0SlGNTDnTfioTo/RlvHtADfW3ofN0nuhGQFnH63Iu/sYU6Lu0OVpJVH3Bcz7g
         ciJeE7gUpcJxNQ3wcIVObzCxgT92/DgqxbFBQdSApfIGtPJb1UPUnE4wHOaJFy+HC/mQ
         ZaqKkHXfMaV/Aaa6gv3Kv0Jx2ScY9r5L249EkmDoec5PeX+MlOxi6M03Tqqfybtd1pBl
         Uu1S3zDMZrDem8LCMoeY/cXE6hcxKqtY3JrVoI+YiMK6X9Cs3rIgBd4Pe+1dyF+U4G6q
         N3izulApPc1AAKQOTMAGTCmYvFMX+2q7TQSoz+RvLIekrdl2HyMWxiAJ9/zR7AxNWGzw
         MRjw==
X-Gm-Message-State: AC+VfDw0L6Ut/XmL3WPo3yGE3eoQ9+t1J8pfXJqaixGwiAjk7cYGRyXB
        FLcFLhKfT5BvkQ4iTDtey3Gu+w==
X-Google-Smtp-Source: ACHHUZ4ZBLdkr315cTtZjVQL4ma2bbBoT6gMr0krg7qGd3Pt41ImGEu9UDN+HRiSdyHY98PzGk1hyQ==
X-Received: by 2002:a05:6a21:7896:b0:101:1951:d4ae with SMTP id bf22-20020a056a21789600b001011951d4aemr2504497pzc.14.1683601556120;
        Mon, 08 May 2023 20:05:56 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id c4-20020aa781c4000000b00640e12b6464sm634689pfn.178.2023.05.08.20.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 20:05:55 -0700 (PDT)
Date:   Tue, 9 May 2023 12:05:51 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Pumpkin <cc85nod@gmail.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, tom@talpey.com, atteh.mailbox@gmail.com,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 1/6] ksmbd: fix global-out-of-bounds in
 smb2_find_context_vals
Message-ID: <20230509030551.GE11511@google.com>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
 <20230508010506.GA11511@google.com>
 <CAKYAXd-upEqLP8zSqZbR0FcznGfWLejkqQ6QKLh=taxb0mMiLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd-upEqLP8zSqZbR0FcznGfWLejkqQ6QKLh=taxb0mMiLQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/08 21:58), Namjae Jeon wrote:
> 2023-05-08 10:05 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> > On (23/05/06 00:11), Namjae Jeon wrote:
> >> From: Pumpkin <cc85nod@gmail.com>
> >>
> >> If the length of CreateContext name is larger than the tag, it will
> >> access
> >> the data following the tag and trigger KASAN global-out-of-bounds.
> >>
> >> Currently all CreateContext names are defined as string, so we can use
> >> strcmp instead of memcmp to avoid the out-of-bound access.
> Hi Chih-Yen,
> 
> Please reply to Sergey's review comment. If needed, please send v2
> patch after updating it.

Chih-Yen replied privately, but let me move the discussion back to
public list.

> >> +++ b/fs/ksmbd/oplock.c
> >> @@ -1492,7 +1492,7 @@ struct create_context *smb2_find_context_vals(void
> >> *open_req, const char *tag)
> >>  			return ERR_PTR(-EINVAL);
> >>
> >>  		name = (char *)cc + name_off;
> >> -		if (memcmp(name, tag, name_len) == 0)
> >> +		if (!strcmp(name, tag))
> >>  			return cc;
> >>
> >>  		remain_len -= next;
> >
> > I'm slightly surprised that that huge `if` before memcmp() doesn't catch
> > it
> >
> > 		if ((next & 0x7) != 0 ||
> > 		    next > remain_len ||
> > 		    name_off != offsetof(struct create_context, Buffer) ||
> > 		    name_len < 4 ||
> > 		    name_off + name_len > cc_len ||
> > 		    (value_off & 0x7) != 0 ||
> > 		    (value_off && (value_off < name_off + name_len)) ||
> > 		    ((u64)value_off + value_len > cc_len))
> > 			return ERR_PTR(-EINVAL);

So the question is: why doesn't this `if` catch that problem?
I'd rather add one extra condition here, it doesn't make a lot
of sense to strcmp/memcmp if we know beforehand that two strings
have different sizes. So a simple "name len != context len" should
do the trick. No?
