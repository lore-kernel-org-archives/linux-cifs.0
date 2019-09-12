Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04066C49ED9
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 08:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7444208E4
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 08:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sjDrQVTc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbfILIpN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 04:45:13 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:41487 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfILIpN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 04:45:13 -0400
Received: by mail-pf1-f176.google.com with SMTP id b13so15514703pfo.8
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 01:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oWhk4mY9kaQumLncfrLHlm8v2yU2jwOxKrRiPvY2Bi4=;
        b=sjDrQVTczNVJlXuATe/VCL1Oiebzx83Dzq2xYY25kHV1aOfS6c6oO6Vd5mXPkRkTob
         +y/gT5eWFxO1oDb4VGnnh+yRDANR9BfuXBfIv94AEH945jJ550nWjRDI7XqIdwhpkDRO
         L8WLkG229TMhrrZGcOzqJ6fsMSUoU0VfYl9EvD7qPTrmhptM0g+ggN73OE7k9Y6mQNdU
         JFc6bipAxm+JD5XbzN41E7krJvwXkSNley49a3GeLdZiI83BtlgUScwjI6/5oVzFJswi
         Jb8IcXH7HyFU6vawvzYm0MWBBwoJuFdIpjIcKbPocytH2CwuX1I01nOrAGwqk7clJNk3
         aHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oWhk4mY9kaQumLncfrLHlm8v2yU2jwOxKrRiPvY2Bi4=;
        b=X6cWJq3iQYL9OsCPb1GHE4UxdgPQ88rpu99Cy2rw0hH+OWVWVzQ2jlTqZdJB41fspg
         xUF05ImBp0FgNzmwui0/GdVXnrtCGEiRT09xrlFoz049ESDTMfNSV/Xzb3L9UuEuPY/z
         WVvMIq7kCjPyHsBBh1mjwpZYrpXO7sB0rza/9l9X1QW66kpX22RSh9hCmf4gbUwtx3zo
         CB5THmOOBkP0tTboMFwLSDODXVIf5nriNqpM6qrypfXvnXzNSv2d8VFd8ASsZarXdqNh
         hUpFjlarWCVKifwV+P+Ugqr9jjhuBKX4Rt4k5pmmSChewGCG0vM3DOEPUBcMwJta7HAc
         MlWw==
X-Gm-Message-State: APjAAAUW43nmQ/VAr4DdllFE3zyBHRU1EUO2JDgArERdkYaOnzMl0ALT
        G8k7ydYS7z26hAtSkus6pxo=
X-Google-Smtp-Source: APXvYqyd08dC5Nf1gDrgSZ1gp13iJjnxLSbehl/CViuKUaCPnya0hDsPd+oNo5tsTbBR/9eVQ1mCCQ==
X-Received: by 2002:a62:d445:: with SMTP id u5mr48255595pfl.92.1568277912397;
        Thu, 12 Sep 2019 01:45:12 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l124sm22007849pgl.54.2019.09.12.01.45.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 01:45:11 -0700 (PDT)
Date:   Thu, 12 Sep 2019 16:45:04 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
Message-ID: <20190912084504.olymktr7h3ixq3uk@XZHOUW.usersys.redhat.com>
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
 <87mufdiw0u.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mufdiw0u.fsf@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 09, 2019 at 12:50:09PM +0200, Aurélien Aptel wrote:
> "Murphy Zhou" <jencce.kernel@gmail.com> writes:
> > As $subject. Is this wiki being maintained ?
> >
> > Looks like the last update was in January 2019.
> >
> > https://wiki.samba.org/index.php/Xfstesting-cifs#Exclusion_files
> 
> We have a buildbot running xfstests relatively often here
> 
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/
> 
> Each group has slightly different tests run, you can see which one gets
> run by clicking on a build:
> 
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/249

Looks like I am unauthorised to access these sites.

> 
> Overall xfstests+cifs is very finicky and frustrating to get working
> reliably. Not to mention long. So good luck :)

Indeed. Thanks :)

> 
> Cheers,
> -- 
> Aurélien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
> GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
