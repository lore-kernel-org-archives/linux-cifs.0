Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A8BC61DA4
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Feb 2023 01:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjBGBwq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBGBwp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Feb 2023 20:52:45 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DCC2006C
        for <linux-cifs@vger.kernel.org>; Mon,  6 Feb 2023 17:52:37 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id g9so9736136pfo.5
        for <linux-cifs@vger.kernel.org>; Mon, 06 Feb 2023 17:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1gulD7/kEHZP9aV24EBXw4BTF6qeGzgE3oWiXaNuNyM=;
        b=NnftswKdW/GuNHmKgvrK/YjFAXvgrmAgKu4HhzDGFosWw1T1E5KnEEGUmNksLJZ6mC
         Mp6PFpGNBHNIK8n3k/nUG4spq2I9kRUVNz0EWn2ZAG+jzrS585ET/bhpJ7SZhQaIpcM0
         KtyPBKvZk1GAh5Ik3rFK1zNJHpoBpExhRtSAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1gulD7/kEHZP9aV24EBXw4BTF6qeGzgE3oWiXaNuNyM=;
        b=nkQmh2TSxMz1d+5o+rUru3Avd+YwdFsFR8BS6Y8FEI5d9VqDjgvC2d/sr5wMJc1q82
         oG3jfYdlKm1ztD/HSkrd2IousN5Ye+2FfdbWOhjcO83oB8TbBDZX/zeP7hmcQIL7iYDE
         BMMEp+b4EXuFjLj2xcAAnas3gusZrklJudl4YwTUj1RvlGNQRhMYXMobWVcA/yu8cG7F
         xAXUG+M3WbKfx/7iLqFxGLSWHeikr1YM5BIahcqA38rePCKzgtNE0Z9qx8p4uTFhl0Ne
         oeQ4cHOklZ4Q44kGtDvUMOvhUFD+LHgvh6PGOC/uPOeuzYNUfH1t7DEsSg4m5AjhuDXL
         RFKg==
X-Gm-Message-State: AO0yUKWZrf3hu33n6oZ/D87m8FR+M1HfGxYIe/OlfBBCl38odzVofIIG
        OydnJivW0sIgkPyowsTx6vntEw==
X-Google-Smtp-Source: AK7set8H+dbd0lJWJrpQxSUZ22uAN3nmgTC75O9U7b3Or9fM6qgLl71NV1ZLUSb6i+Pgt8FcSG+KUQ==
X-Received: by 2002:a62:384f:0:b0:593:c41e:474 with SMTP id f76-20020a62384f000000b00593c41e0474mr1299789pfa.9.1675734757406;
        Mon, 06 Feb 2023 17:52:37 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id h11-20020a056a00230b00b0058837da69edsm7817189pfh.128.2023.02.06.17.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 17:52:36 -0800 (PST)
Date:   Tue, 7 Feb 2023 10:52:32 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
        tom@talpey.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] ksmbd: Fix parameter name and comment mismatch
Message-ID: <Y+Gu4Fg00D//CGpo@google.com>
References: <20230206072029.32574-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206072029.32574-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/02/06 15:20), Jiapeng Chong wrote:
> 
> fs/ksmbd/vfs.c:965: warning: Function parameter or member 'attr_value' not described in 'ksmbd_vfs_setxattr'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3946
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
