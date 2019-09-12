Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6696DC5ACAE
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 08:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 396B92084F
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 08:50:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZRwRaHT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbfILIuL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 04:50:11 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:41988 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfILIuK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 04:50:10 -0400
Received: by mail-pg1-f170.google.com with SMTP id z12so1543618pgp.9
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 01:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XnqtvprO5xJWw6CDWLBbR0w2T0fd53CbhD8cDhOIEbw=;
        b=GZRwRaHT0d/m+WBkuUZjfuVKPXmKtitZML1yfRv4d52F6g7UVQwHJztpW7OVSiVXaT
         9s59LLeadT2vo8gAql+vHQFE4XZCQYKbOT9/1vz9lgglcPQ95ZseKGZBZPQYmo6KkoXA
         OYsABEbRiFbqfAKhbXmDNGgqAMyOCkifBR6JzlpqvcnpYJ8N7L8f02sQBn6BAc2blxHF
         /+TL/jx/xrjbzYTnWw94w4dC3dwbzyag25/1/Y29d1Q0Rlk2MA+pa9jXOUsJ+hN+AKE8
         TogjtFDk4hszGP73tqlrdKiGIlFWhRuqIERMDC+Fd3R7oadDSW0cf7VNSsyzA1t+tIso
         uuog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XnqtvprO5xJWw6CDWLBbR0w2T0fd53CbhD8cDhOIEbw=;
        b=GzfidV0xLl2v9AvuNwzuzaF/qoGcaRbtLYfa1BGPaTOxZxhsSKFGwd4lWS5oeXnptc
         HPeOZe4KF2qhdv84/DHOzxoOcFISvePA0c1wvdqlJEN1BCn3VgHfq0V2NghulFHXdOHs
         JKA5n+dNJarU+UxJF5KT7f+tGc+JP4EtZXk8VfpeZ1nGiI6t2t/Dp8e9D9bYVStyb5RS
         bPV/upZoqKYIK8BcG+JTzZHK3BMbl6OV0jS/9RE7A/iYkCrojR0Scvn77rEc1aPRTUbQ
         QzPjh8DH3KUmx9cF3FO01xVcACUVGw9cBno0f8sy58rOeqmjJ9v8/D9xGpEZrDqbAxET
         d1bg==
X-Gm-Message-State: APjAAAWWILdcwSrBgy7VW0DQps0p9FzSTBQpz32WhpCFUiXiyZo4Gkt5
        klVc2C5fCgOBpZ5yC9JJX7E=
X-Google-Smtp-Source: APXvYqy0eEI+DHuvygSHkXRpDAD1OeicxhHnfmBlC5/TP5BdUlmtswIC3gEmPV7kBeAv7awfuJIrqA==
X-Received: by 2002:a63:534d:: with SMTP id t13mr37288168pgl.313.1568278210119;
        Thu, 12 Sep 2019 01:50:10 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e192sm34287941pfh.83.2019.09.12.01.50.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 01:50:09 -0700 (PDT)
Date:   Thu, 12 Sep 2019 16:50:02 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
Message-ID: <20190912085002.nbbzrtiqoa7iltnc@XZHOUW.usersys.redhat.com>
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
 <87mufdiw0u.fsf@suse.com>
 <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
 <CAN05THREAX12uBdWULEQnP+Ko52uDzTjry3dYKM3ZFiB2cYaJw@mail.gmail.com>
 <87h85kidj9.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h85kidj9.fsf@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 10, 2019 at 01:41:46PM +0200, Aurélien Aptel wrote:
> "ronnie sahlberg" <ronniesahlberg@gmail.com> writes:
> > Lets get rid of the list of tests from the wiki and let the buildbot
> > be the single canonical source of truth.
> 
> Sounds good to me. Ideally this list should be exportable (perhaps
> automatically from the buildbot script) in a format that can be used
> directly by the check script for others to use.

That would be perfect! Thank you very much Ronnie and Aurélien!

> 
> -- 
> Aurélien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
> GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
