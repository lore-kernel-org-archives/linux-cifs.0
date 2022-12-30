Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDAFC4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Dec 2022 02:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiL3Csq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 21:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiL3Cso (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 21:48:44 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A4C15FE4
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 18:48:43 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id s67so4132780pgs.3
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 18:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dJ291QJYxt9yvVrJKDRjAY8ztcb1+SbUjL5NnNE4w7w=;
        b=Y6k4wVveADz8PI5VeBNJX/VxgV7JUto9yKarYM/SvdX+2z13eXdPLRWgBNxFx/6goy
         ZFmf9zY3Y8g16w++ORo7WYbuwCF7Tyv3OzMkk6wFpWO8ZoHTV4V1DUfVvz56yPdUmoZn
         ndsbYeETg7YDk1gNSBFcZkhK7VMGQjK7L/Mow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJ291QJYxt9yvVrJKDRjAY8ztcb1+SbUjL5NnNE4w7w=;
        b=o91UNrEN2Bn2L0A3CpekUx+0yq507gw4bvvT7foZ5O/U7YP1mtR86ZyCPuZpZERav9
         VxGi5AH3+W+X3SUWQ6xUzMJMEdgdykaAPHkD/iPbgBnP+4YOCdaTQOazsmDjc6Ov9d6a
         laljGQt+/7EYay/ZMlygfFerg9IGwXsfDNMVcL6ENjW4U6aMlG9rnBfUHQ464S+w9rhh
         rSsI0Wfe5GtFo7ZKq0Xa306QDytkrVZV7wACUVpw/zepwBs71bjk8wYLlAz3Mft7LkCp
         +/CaZ6XTJDGQZc/D8Ohf7SINY2Gy2Q/MToziAFm6DJv91lXfVQCSB++IJF4NisSqIAQP
         XaqA==
X-Gm-Message-State: AFqh2krJS2S25VbMM9KJRg03HEbtnBawj0o4XuwqBMgEjQTzF+vBK7CQ
        YaztihvPlrRbs8tC6+PGibXyFw==
X-Google-Smtp-Source: AMrXdXtYLwOp8zy8rgUSUQdrPI2D6AnGQQoi95BKNYZ+h0WvGExaU9jxZLKVjPVcPWcmRxD/fGRSnw==
X-Received: by 2002:a05:6a00:99d:b0:581:38bc:b5bc with SMTP id u29-20020a056a00099d00b0058138bcb5bcmr20407075pfg.1.1672368522626;
        Thu, 29 Dec 2022 18:48:42 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id g75-20020a62524e000000b005817fa83bcesm4483342pfb.76.2022.12.29.18.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 18:48:42 -0800 (PST)
Date:   Fri, 30 Dec 2022 11:48:37 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH v2] ksmbd: add max connections parameter
Message-ID: <Y65RhY+lPJUDWBbx@google.com>
References: <20221229093836.7804-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229093836.7804-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/12/29 18:38), Namjae Jeon wrote:
> 
> Add max connections parameter to limit number of maximum simultaneous
> connections.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
