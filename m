Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D009C7EE26
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 22:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjEWWeU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 18:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjEWWeT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 18:34:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20851BF
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 15:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=+nVBZuBgcji+1j4qtgc+iB02oqboGs04iLJSwktjiJ4=; b=qj6YMUGmM50olz9FXyE55DxQtL
        8NDtQDKl3ZMbWSgt+RFHPLxpyXvHiy6Kalvt9wYVorEywxRva9vVCNgFyqcbL+5rELZGHgQDQ4b02
        KnAaHggpayGzcdhzrdPnyJn9KBHrmK2ELsqjhlVazR8xFkTwq6xrkvMWk3KMdE3Vzirpo+zelL5T9
        epKVXGgRnFGdnda6d+34gHRqcBJl1aallVKZN5GGTk6E9VvwSY5rCRs8ojTEYa6v+ZAQGX9YoWcmX
        4jl+a16DasbeXYY1/ytNj1fIAMT7uPTsLZ/NqvrNfIFI4zWAUfqq7GxdxUayi3t7sfaPnBCQrmJ5Q
        QMtOepQ801+abINE5x6WIffEwQljnD/wApHDOwO8Bzy8lzTA31jP+yx7OOTaj+pvalvwYZgOpGtRf
        al/D0vTGVmRAG0XgChcZizM2+iHW3MrxiigGXgrn98G1yqWBQqBiYDwFLJ52QgqUpOZD1j2Jv66DF
        Hsl9x5qyvA8JVF12VCUPu+7X;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1q1aa7-00BaLM-Lv; Tue, 23 May 2023 22:34:16 +0000
Date:   Tue, 23 May 2023 15:34:11 -0700
From:   Jeremy Allison <jra@samba.org>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Displaying streams as xattrs
Message-ID: <ZG0/YyAqqf0NqUuO@jeremy-rocky-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
 <CAN05THRnHcZtTMLxUSCYQXULVHiOXVYDU9TRy9K+_wBQQ1CFAw@mail.gmail.com>
 <ZGzo+KVlSTNk/B0r@jeremy-rocky-laptop>
 <CAN05THQyraiyQ9tV=iAbDiirWzPxqPq9rY4WsrnqavguJCEjgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAN05THQyraiyQ9tV=iAbDiirWzPxqPq9rY4WsrnqavguJCEjgg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, May 24, 2023 at 07:44:36AM +1000, ronnie sahlberg wrote:
>On Wed, 24 May 2023 at 02:25, Jeremy Allison <jra@samba.org> wrote:
>>
>> On Tue, May 23, 2023 at 10:59:27AM +1000, ronnie sahlberg wrote:
>>
>> >There are really nice use-cases for ADS where one can store additional
>> >metadata within the "file" itself.
>>
>> "Nice" for virus writers, yeah. A complete swamp for everyone
>> else :-).
>
>Viruses? I don't think they use ADS much since most tools under
>windows understand ADS.

https://insights.sei.cmu.edu/blog/using-alternate-data-streams-in-the-colle=
ction-and-exfiltration-of-data/

"Malware that takes advantage of ADSs is not new. MITRE lists over a
dozen named malware examples that use ADSs to hide artifacts and evade
detection. Attack tools, such as Astaroth, Bitpaymer, and PowerDuke,
have been extensively detailed by various parties, providing insight
into how these threats take advantage of ADS evasion on a host system.
Authors, such as Berghel and Brajkovska, downplay the risks of ADSs. Our
opinion, however, is that ADSs introduced the host of concealment and
obfuscation techniques outlined above, but little has been done to
mitigate these worries since their publication in 2004."

As I also recall the published US "hacking toolset" also used
an ADS on the root directory of a share to exfiltrate data
=66rom the target.

ADS - "Just Say No !"

:-).
