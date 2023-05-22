Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B562C7EE23
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 16:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjEVQVi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 12:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjEVQVh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 12:21:37 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4159CE9
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 09:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=YsOTrpqC/nUNjWwm/2EcGoDbGfwHE0gi+Kt786GAkPg=; b=LVmaiP+mguMwz44MSZ0on3QTJW
        uYuezWpjv4hLfc1NGh6D1MARLBde+zte+Bjr93AX6s0CF/BsAC4QXtn8yYE7E8jM+u4Ai/e+/QNuo
        oavRkoKbD4FSmBlM3FlqUX1rspoj46RNSkQJdIJYTuH4bcTOu2Xhqfn1WEtSICR1njo2UaTVX+UWp
        ku6JStMWxP2q1j5Wq3aOVRhB5olqKQGwPeHx2GnvS3GPJea8/nTtriGAiBTKo9j1GCygxyhBzq0XA
        FCeT8hL3a12CzVyavjuIc2DWbKiTJyfQAlDcaClZfNqYxy5laVSFmQzfw3YOWdQWejVST3QlR80Li
        SO3jIaoJDp6pZEPDBZgZZkfGJ+JmWHWEusDPVnKdMHAIXyUEF/i8Fwg/KuuZVgG72oYtVX4BWcF5C
        G0oefLVy06JuEv2pZ+K/+ZiMjqLuB5upwcWJnpxsK8HmqHRL3Pfip7tEaz5g24hry8rF/Npe1Z9oF
        qnxEIWLZJiBS9Zi3/dfyyjPF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1q18Ht-00B8zB-HS; Mon, 22 May 2023 16:21:33 +0000
Date:   Mon, 22 May 2023 09:21:27 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Displaying streams as xattrs
Message-ID: <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, May 22, 2023 at 01:39:50AM -0500, Steve French wrote:
>On Sun, May 21, 2023 at 11:33 PM ronnie sahlberg
><ronniesahlberg@gmail.com> wrote:
>>
>> A problem  we have with xattrs today is that we use EAs and these are
>> case insensitive.
>> Even worse I think windows may also convert the names to uppercase :-(
>> And there is no way to change it in the registry :-(
>
>But for alternate data streams if we allowed them to be retrieved via xattrs,
>would case sensitivity matter?  Alternate data streams IIRC are already
>case preserving.   Presumably the more common case is for a Linux user
>to read (or backup) an existing alternate data stream (which are usually
>created by Windows so case sensitivity would not be relevant).

Warning Will Robinson ! Mixing ADS and xattrs on the client side is a receipe for
confusion and disaster IMHO.

They really are different things. No good will come of trying to mix
the two into one client namespace.
