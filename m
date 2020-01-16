Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538D8C33CB6
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 17:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25DA22073A
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 17:56:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLP9XLqt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393835AbgAPR4l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:56:41 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50137 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393358AbgAPR4l (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Jan 2020 12:56:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579197400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=QerJc6/aQDr6ruuG/hTCamhKdXY+mbDPy/lC3Mc4C2s=;
        b=PLP9XLqthjVfPQXkuGeUtpieTHgrwIDqCtIH6inH/rswuwo1kr/XYHxsZ+QF08dYIC5P6a
        1p1UXJvn64gTLfKy3pwIyKcDOwSX+XU8MJDahJmUC1XKudfm95k8KNMANuXxI141KsvsI+
        sDnNMciOYJSu6AbkAnzO/9/FBmKWX1M=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-IL7kZJmlOs2PSlpHq5-lvA-1; Thu, 16 Jan 2020 12:56:39 -0500
X-MC-Unique: IL7kZJmlOs2PSlpHq5-lvA-1
Received: by mail-pj1-f71.google.com with SMTP id s6so2577241pjn.7
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2020 09:56:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QerJc6/aQDr6ruuG/hTCamhKdXY+mbDPy/lC3Mc4C2s=;
        b=cFBpkTQuS4X0lHGQUOVKoe695Z65vjI/NQph59Psj5BFBDstEJQT5zGOLX4C8qYK+S
         EAn4a55/mJPfBz71wtVCoiAFdU1WWPeTcX0luv9NcAlsdmj4jFnggOAxXgWTTQaz1Kpc
         ebwcBWDgvSa8JlVWW4MvFpdwAEdyCtlYP6MlfE+mfROUS4DluRlejmZolmeEhGH2Nq3v
         b7eQw23Dms13DU3bdyxsdZkMnu2oacNwh4ng2kbIsnSbtMJeWqXP8lbThesHFYw432m9
         v+tUy43UFRiOdH8p6PTSqDBozTQ4asiHdBhpH65s2W/R7Ccv01sdW6+YNWecYn1QmVzU
         WwUA==
X-Gm-Message-State: APjAAAX6MJRRUS4lJRW6JKiY3fZ7+BKz9VJgVTfk1pOo41e4cRPe0+Pa
        czi5Tbao/G66CprvIv05E5w3goXaBAj4FRCdkBPIEsD5VnnAR5sQ349LsXqDV1Rb3gBkP7gpfm9
        uXgUrhfu9X+URsqvLoZ0O2IKuT9ZCOJjNtogP6g==
X-Received: by 2002:a17:902:788b:: with SMTP id q11mr33433821pll.21.1579197398000;
        Thu, 16 Jan 2020 09:56:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwh0rey7uHJ1paMRZsB5QrWwroJaR7B/pscxAWYW/vb57H4yzS7rZwglmSrXLqlYntkaHLYiQylwMcNBxfyKZA=
X-Received: by 2002:a17:902:788b:: with SMTP id q11mr33433802pll.21.1579197397744;
 Thu, 16 Jan 2020 09:56:37 -0800 (PST)
MIME-Version: 1.0
From:   Jacob Shivers <jshivers@redhat.com>
Date:   Thu, 16 Jan 2020 12:56:01 -0500
Message-ID: <CALe0_75KJMBOMMAtSWNH=GkHv-vzvYQxOVuj8Eht6jfVfoYCcA@mail.gmail.com>
Subject: cruid+multiuser mount options
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When mounting a Kerberized SMB share with both cruid and multiuser,
the multiuser mount option is negated. This is not documented as
explicit behavior. The question is whether this intended behavior or
if it is unexpected.

Does anyone have any existing thoughts on this?

