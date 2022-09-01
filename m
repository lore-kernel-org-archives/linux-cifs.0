Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1CFECAAD1
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 17:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiIARoW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 13:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbiIARnn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 13:43:43 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BA59D103
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 10:41:24 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id p18so15332183ljc.9
        for <linux-cifs@vger.kernel.org>; Thu, 01 Sep 2022 10:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=dfCoWYNi0GJOJvnqB5QbgcuvfTMkc0aVxNV4/BENDr0=;
        b=BhMCP0EJIb1lx30aK98RNo6kYm3RHNhnq8oz3sO/AACjMNmRt+G4xPDNOhF3zdqkK7
         zK9vulh+y6mScq1S4eDYjrT7gmrInQWIb+960I6GghmhdxHW5PaYI5Z8Yb9avZrxrwks
         T3IXa/1NUIRP3N6zShRjZYvx67B1F7tpb6XWuhg1hd8yaDf3lM58u2I6KgxKc3jboYTq
         mUL9xmkPYzpf/0X1gSe6OCI4J/9xgs5hGBDqFnk4Li3MgKGKR3MKhYK8kAMyO1c7mCyG
         tFMWc3OZ9kKoeVvz5x1T0aXhtYgwt8yZNggtKMwnaB/2GCcUrmIQLCXg95asiknIS+Jp
         +h0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=dfCoWYNi0GJOJvnqB5QbgcuvfTMkc0aVxNV4/BENDr0=;
        b=sYuFf7JsZxxSDwfe8lPgRgA0JXXL8WLDozMbSlvDBEFrPhjUWtyxSYQCaT9GnJbNew
         kRY1+yro3Yz3eAVUV0XJXQOn+/qFUR5UIJaNF5px43juyreRE0FVqMCstZpI9YQzM5+X
         zTxcV6o7+HGukcX4rCTfkKeYeSohQDgwxEAtqHsAebL+pHExw6l7ZCS5HlTnPzmFgytk
         FdG+Vbfj5bXIEAvt2N3zDk4YKJQ7hYK8kDfERHaTkp41t01qpG+ZFPt2C9iIyLc58t2F
         O3DdS7mYNA6qHdVGziQz9ncSlOytJOB5Zj4EOqL264wHs/+wdzyg63JPzYoGf0vFZ7lV
         7PYQ==
X-Gm-Message-State: ACgBeo2l2s5JgL3FJRzXWqMEn+EtbiKqYIS7zCnq/y92KcVD4uViIh4E
        oa71aqZcKylznT6Lb71KMgo=
X-Google-Smtp-Source: AA6agR5ErZNu3XvJjXDUbao2Ij835x7BrnmX/az/2H93g/d9nS+wmLCbuVLrRVCIFhU+QnjCrqMNMw==
X-Received: by 2002:a2e:a44b:0:b0:261:e7e7:b662 with SMTP id v11-20020a2ea44b000000b00261e7e7b662mr9173044ljn.417.1662054081835;
        Thu, 01 Sep 2022 10:41:21 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bf-218.dhcp.inet.fi. [46.132.191.218])
        by smtp.gmail.com with ESMTPSA id k27-20020a2ea27b000000b00268c58f580fsm242151ljm.6.2022.09.01.10.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 10:41:21 -0700 (PDT)
From:   atheik <atteh.mailbox@gmail.com>
To:     jra@samba.org
Cc:     atteh.mailbox@gmail.com, hyc.lee@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        smfrench@gmail.com, tom@talpey.com
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Date:   Thu,  1 Sep 2022 20:41:08 +0300
Message-Id: <20220901174108.24621-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <YxDaZxljVqC/4Riu@jeremy-acer>
References: <YxDaZxljVqC/4Riu@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 1 Sep 2022 09:14:31 -0700, Jeremy Allison wrote:
>On Thu, Sep 01, 2022 at 09:06:07AM -0400, Tom Talpey wrote:
>>
>>Ok, two things. What I found strange is the "man smb.conf.5ksmbd", and
>>as you say that should be man 5k smb.conf. Sounds ok to me.
>>
>>But the second thing I'm concerned about is the reuse of the smb.conf
>>filename. It's perfectly possible to install both Samba and ksmbd on
>>a system, they can be configured to use different ports, listen on
>>different interfaces, or any number of other deployment approaches.
>>
>>And, Samba provides MUCH more than an SMB server, and configures many
>>other services in smb.conf. So I feel ksmbd should avoid such filename
>>conflicts. To me, calling it "ksmbd.conf" is much more logical.
>
>+1 from me. Having 2 conflicting file contents both wanting
>to be called smb.conf is a disaster waiting to happen.

ksmbd-tools clearly has a goal of being compatible with smb.conf(5) of
Samba when it comes to the common subset of functionality they share.
ksmbd-tools has 7 global parameters that Samba does not have, but other
than, share parameters and global parameters of ksmbd-tools are subset
of those in Samba. Samba and ksmbd-tools do not have any conflicting
file locations. The smb.conf(5ksmbd) man page of ksmbd-tools does not
collide with and never overshadows smb.conf(5) of Samba. Please, help
me understand what sort of disaster this could lead to.

>
>Please use ksmbd.conf.

Atte Heikkilä
