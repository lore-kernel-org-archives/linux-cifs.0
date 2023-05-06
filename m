Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA66BC77B7D
	for <linux-cifs@archiver.kernel.org>; Sat,  6 May 2023 03:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjEFDKs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 23:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjEFDKp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 23:10:45 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B3F7D81
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 20:10:44 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6439e6f5a33so986943b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 20:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683342644; x=1685934644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sqJvxCixFgE5RXjzXRndzF33xULZ/Bf0vpQ/vOldTUM=;
        b=eRDU0ztzFuvW0/NYj/0q2RN/xxSE7+rOfZXswyOKvELfQB/0Hu8YC93qmA6VukQANZ
         J2VHQfk4zJer3MDPeQoRLHR7kS3e/X9DasbsUj/CpkomwTAjH/UurtGg1MH4Yl6CM+hn
         RjdyX4MLN3FKzpqk2Bc6h/99NgBWx1Fg61gGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683342644; x=1685934644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqJvxCixFgE5RXjzXRndzF33xULZ/Bf0vpQ/vOldTUM=;
        b=WdUdcCjJGGU7nZwXKSotKCEltCmjzhx7gOfmMenmkjWi3umsp5aCGOTAhleJU5ijjO
         It5XYccfXv/soDB50u8xM4sjjN/gQ4DUVf6POpwsd6z6SYi08paKQ6Hf1DnOPdXv3gZe
         +91oXvjc5Ze3ndgRRINmVYrVpl/2YHcaTrf5sbWOU0JvSIRSt7G7O8rF+V8RjKz/WSOu
         YTdqKL6l2dAbeENf+l9CcNkmU2I1O7rasSwo7lBA7ZrS2YiH/6H0hfv4xmml5peURnXW
         U0Fv9aCY0XG3ayC94Oq5YG0XIPhB3vKfODlys80IsOJgegYVrKMu9SRUOLW8VzBZuE4s
         OtZg==
X-Gm-Message-State: AC+VfDzsPyXeGKOKhw7DU9x5ZyCWYFB9frZ7Y+QnNxkOVPLd7dob836D
        jlwoq0SW3t4+AbGU6zOhVg48Kg==
X-Google-Smtp-Source: ACHHUZ5HCyx9Yo4x/QxS4o/pPhYOxl3N/ektnwnWYQGT03iPh1rqiRyZ2SGal8xBZoKDAENwnA85Aw==
X-Received: by 2002:a05:6a00:14d6:b0:642:ec5c:dca9 with SMTP id w22-20020a056a0014d600b00642ec5cdca9mr3855205pfu.4.1683342644225;
        Fri, 05 May 2023 20:10:44 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id j9-20020aa79289000000b0063a5837d9e8sm2236291pfa.156.2023.05.05.20.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 20:10:43 -0700 (PDT)
Date:   Sat, 6 May 2023 12:10:39 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Pumpkin <cc85nod@gmail.com>
Subject: Re: [PATCH 2/6] ksmbd: fix wrong UserName check in session_user
Message-ID: <20230506031039.GD3281499@google.com>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
 <20230505151108.5911-2-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505151108.5911-2-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/06 00:11), Namjae Jeon wrote:
> The offset of UserName is related to the address of security
> buffer. To ensure the validaty of UserName, we need to compare name_off
> + name_len with secbuf_len instead of auth_msg_len.
> 
> [   27.096243] ==================================================================
> [   27.096890] BUG: KASAN: slab-out-of-bounds in smb_strndup_from_utf16+0x188/0x350
> [   27.097609] Read of size 2 at addr ffff888005e3b542 by task kworker/0:0/7
> ...
> [   27.099950] Call Trace:
> [   27.100194]  <TASK>
> [   27.100397]  dump_stack_lvl+0x33/0x50
> [   27.100752]  print_report+0xcc/0x620
> [   27.102305]  kasan_report+0xae/0xe0
> [   27.103072]  kasan_check_range+0x35/0x1b0
> [   27.103757]  smb_strndup_from_utf16+0x188/0x350
> [   27.105474]  smb2_sess_setup+0xaf8/0x19c0
> [   27.107935]  handle_ksmbd_work+0x274/0x810
> [   27.108315]  process_one_work+0x419/0x760
> [   27.108689]  worker_thread+0x2a2/0x6f0
> [   27.109385]  kthread+0x160/0x190
> [   27.110129]  ret_from_fork+0x1f/0x30
> [   27.110454]  </TASK>
> 
> Signed-off-by: Pumpkin <cc85nod@gmail.com>

Do we still have a requirement that there should be a real name in SoB?
