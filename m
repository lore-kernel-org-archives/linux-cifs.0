Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05325C43603
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Apr 2021 14:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC068613F0
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Apr 2021 14:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhDOOy0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Apr 2021 10:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbhDOOwq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Apr 2021 10:52:46 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B83C06138D;
        Thu, 15 Apr 2021 07:52:16 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o21-20020a1c4d150000b029012e52898006so2883374wmh.0;
        Thu, 15 Apr 2021 07:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Yhv+oIi881Wgsc3Q1qGBC+RzhabNoWArSeuEYCDa/2E=;
        b=EzArC/Zm3EHVt1YR03UnvVaqbepPonzJGS4D7tcivNVIi4F+WUhaIeYG4lTwaok4kH
         MUGH+LBTxu7RRgzIOysyK6k8W8KJMNGDNe0zGjrfq/lSfUGuv/E4/9OxNsm9CdEVPpbf
         6Z5bm9qn8G5iIhuajEwvl0r7aQw0p9SvZcK06s4rotVdqiN55OUKQ3fshrjxcpQCVkDy
         YsC1uNxY/dbWTTyBq9wj2LQqgH9BBGLR23yN5MHjvaJKkbQ7I71HmXZm9E3Fij4kDWzO
         hGoWAqNgcHaTUrKrOkNsre78E3a2SM1Cqhw/4Wf1OlkrhiPKM56/g9wg8WcgzBd54A6M
         zgWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Yhv+oIi881Wgsc3Q1qGBC+RzhabNoWArSeuEYCDa/2E=;
        b=bWJR5Zvq1te8H+wF8liYrsgsK+79BScdpOa1dZ2uwc8biTGMw+Fx+gI43HRhWI3ySa
         +xIFxaP12QM6wM+Pb/fkNhlj9AfhQbzHUT8DOUKa0viiZmfKRkktoDUxKsdSn7UOb5cv
         pTyFB3mm1VoqKjhdcDwlrTKm4MPAUAfORxqpQPPi/o23Nb0HU76sJo1ZOKWcJW1S34LI
         IYPOtET6UtwpDrSBt2WdNUTMdEHSHIuRkc10iLWv/38paZv+dKqt/iZy++k73f7nllLu
         Dm+AH4+6EJEVw6Su7vk/1/+kNzO3Esj3YLA+QOznrAX7B/JWJ9cEi9FGisrOBUQnGCd1
         UPqQ==
X-Gm-Message-State: AOAM532QWly7YSuCWERpZwbs+1ch1DiNbcgdNzyLObiD+mik0UPZS9rI
        PkWB5yngWhJMkojrbmdc6h/0U/hk/6pApddd
X-Google-Smtp-Source: ABdhPJz2fF36if8PpXB2ecPSa4MAtQnxwn46LMYIzoHF7JTR5lhBKXGH3dlffhiBagkyTYBPMw4L+Q==
X-Received: by 2002:a1c:730e:: with SMTP id d14mr2847757wmb.20.1618498335024;
        Thu, 15 Apr 2021 07:52:15 -0700 (PDT)
Received: from 192.168.10.5 ([39.46.65.172])
        by smtp.gmail.com with ESMTPSA id 64sm3187015wmz.7.2021.04.15.07.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 07:52:14 -0700 (PDT)
Message-ID: <654ae83eb92077ab01b962890fdf57453d889d7c.camel@gmail.com>
Subject: Re: [PATCH] cifs: remove unnecessary copies of tcon->crfid.fid
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)" 
        <linux-cifs@vger.kernel.org>,
        "moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)" 
        <samba-technical@lists.samba.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     musamaanjum@gmail.com, kernel-janitors@vger.kernel.org,
        dan.carpenter@oracle.com, colin.king@canonical.com
Date:   Thu, 15 Apr 2021 19:52:09 +0500
In-Reply-To: <87tuo913g6.fsf@suse.com>
References: <20210413232558.GA1136036@LEGION> <87tuo913g6.fsf@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 2021-04-14 at 14:00 +0200, Aurélien Aptel wrote:
> Muhammad Usama Anjum <musamaanjum@gmail.com> writes:
> > pfid is being set to tcon->crfid.fid and they are copied in each other
> > multiple times. Remove the memcopy between same pointers.
> > 
> > Addresses-Coverity: ("Overlapped copy")
> > Fixes: 9e81e8ff74b9 ("cifs: return cached_fid from open_shroot")
> > Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
> > ---
> > I'm not sure why refcount was being incremented here. This file has been
> > evoloved so much. Any ideas?
> 
> The fact that pfid is the same as the cache is very weird... Probably
> due to recent change.
> 
> This function returns a cached dir entry for the root of the share which
> can be accessed/shared by multiple task.
> 
Aurélien Aptel,

Thank you so much for awesome explanation. The whole function makes
sense now. We need to remove the memcpy calls only. We need to
increment the refcount (it was removed in this patch). I'll send a V2.

Regards,
Usama

