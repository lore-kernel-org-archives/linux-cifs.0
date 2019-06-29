Return-Path: <SRS0=BNJn=U4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F2DC4321A
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Jun 2019 18:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 296D7215EA
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Jun 2019 18:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1mqsBMB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfF2SEt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Jun 2019 14:04:49 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:44071 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfF2SEt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 Jun 2019 14:04:49 -0400
Received: by mail-pf1-f176.google.com with SMTP id t16so4514284pfe.11
        for <linux-cifs@vger.kernel.org>; Sat, 29 Jun 2019 11:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XXj3ujn7pwYQUI/kAKz1/N8bEa5iygjSrKCwyHDSDTM=;
        b=N1mqsBMBUvPTfFUd82+laerFRDcRUATRkoyEFnMIfgRGVRBuui6Fz3bvy05zAG0B+g
         IWvR8tZ8tTFD8FY9hW6oSF47Q4wCb1I7Vj6nJSsSgGEVa2peU3EmXXmpcjSUkACsUSAj
         fVAeLlVGpWZg0QIQIGKISF/vDNwHPQiEgGhTp2G6MojQwTSHZAYoYFx0fvAoXZg0eTBs
         nlPlvVkgV7iJHHGItEg7abKdc7gWqKbIIX8vPUsOFH/y04MmBMsCkN7FHK6uhlRi2SrV
         WKBkWgHXD3GwcBFw5BCHkAY4SC6Zu60OiMpDLn+PHteXhIje1JaJvH9B7ADz6CK3ju08
         e91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XXj3ujn7pwYQUI/kAKz1/N8bEa5iygjSrKCwyHDSDTM=;
        b=q0EqmtyuyqFS+pP4vuU3O3gcSouHDFqcdjjILDcfjF9FXkThkEACx8Ok8QKMzLCt1A
         1iWbctGR8uFnfezYMqx2wx0XC0oPLxfvlG382CJOV9e/KcWt6WZzLV5Q3SIpYU86hPP5
         BatA4Xf7YGw83yy+xPvnfX1XmUW6VAqF5OywjlbX+TGDu6fKjucsnSPDXpvUhZ6tPZWU
         dFgP61hUX5L8fbyM1UKxkWfGPD5V4Mu1Ghch/LwwiF2bt7eQNXlYFDG/GonXkndMZ9c+
         pqfAxE1fAAr1w2LKurjjxID6iZg7ps9cubepdFcgqU3onvnrxMxxi5iXY5HHvCy7H1eX
         htOA==
X-Gm-Message-State: APjAAAVgx1X6QMQ+KrbZsxD40y7R+TumQKEuMaxz9JLjicywbT5pIbyg
        dILZV9dPNfh+gxaAJU35hFY=
X-Google-Smtp-Source: APXvYqx3K6BvfWnbx+fFxbgy55iW8BWs2VXURwl9YDCZjSNV801g5PLVSoVkkmLwRT638LPkOu1QWg==
X-Received: by 2002:a65:4085:: with SMTP id t5mr15850811pgp.109.1561831489041;
        Sat, 29 Jun 2019 11:04:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f186sm6044221pfb.5.2019.06.29.11.04.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 11:04:47 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:04:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][CIFS] simplify code by removing CONFIG_CIFS_ACL ifdef
Message-ID: <20190629180446.GA14534@roeck-us.net>
References: <CAH2r5mtSKQtFRNHpiiPDqCwGGLNgooj_1zZiyG=5N+cpA0bQ2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtSKQtFRNHpiiPDqCwGGLNgooj_1zZiyG=5N+cpA0bQ2w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 24, 2019 at 01:47:16AM -0500, Steve French wrote:
> SMB3 ACL support is needed for many use cases now and should not be
> ifdeffed out, even for SMB1 (CIFS).  Remove the CONFIG_CIFS_ACL
> ifdef so ACL support is always built into cifs.ko
> 
> Signed-off-by: Steve French <stfrench@microsoft.com>

This patch results in:

cifs/cifsacl.c:36:15: error: variable 'cifs_idmap_key_acl' has initializer but incomplete type
 static struct key_acl cifs_idmap_key_acl = {
               ^~~~~~~
fs/cifs/cifsacl.c:37:3: error: 'struct key_acl' has no member named 'usage'

if CONFIG_KEYS=n and CONFIG_CIFS!=n (eg arm:nhk8815_defconfig).

Guenter
