Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A052BC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Feb 2021 21:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FE46148E
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Feb 2021 21:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBSVGj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Feb 2021 16:06:39 -0500
Received: from blockout.pre-sense.de ([213.238.39.74]:53875 "EHLO
        mail.pre-sense.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229515AbhBSVGi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Feb 2021 16:06:38 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Feb 2021 16:06:38 EST
Received: from smtp.pre-sense.de (tetris_b.pre-sense.de [10.9.0.76])
        by mail.pre-sense.de (Postfix) with ESMTP id 41A5C5E6B3
        for <linux-cifs@vger.kernel.org>; Fri, 19 Feb 2021 21:57:35 +0100 (CET)
Received: from atlan.none (dynamic-077-001-043-192.77.1.pool.telefonica.de [77.1.43.192])
        by smtp.pre-sense.de (Postfix) with ESMTPS id B2DA8E72
        for <linux-cifs@vger.kernel.org>; Fri, 19 Feb 2021 21:57:04 +0100 (CET)
To:     linux-cifs <linux-cifs@vger.kernel.org>
From:   =?UTF-8?Q?Till_D=c3=b6rges?= <doerges@pre-sense.de>
Organization: PRESENSE Technologies GmbH
Subject: Mounting share on NetApp using SMB 3.1.1 and encryption
Message-ID: <c04ed8bc-9a36-0ff5-6b5f-1fce3d2d1402@pre-sense.de>
Date:   Fri, 19 Feb 2021 21:57:20 +0100
User-Agent: Thunderbird
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello everyone,

I'm trying to connect a Linux client to a NetApp server.

The server is running OnTap 9.7P6.

On the client I use:

--- snip ---
smbclnt:~ # modinfo cifs | egrep '^version'
version:        2.22
smbclnt:~ # mount.cifs -V
mount.cifs version: 6.9
smbclnt:~ # uname -a
Linux smbclnt 5.3.18-lp152.63-default #1 SMP Mon Feb 1 17:31:55 UTC 2021 (98caa86) 
x86_64 x86_64 x86_64 GNU/Linux
--- snap ---


Unfortunately it's not working out of the box.


According to the admins the server requires SMB 3.1.1 and encryption.

Moreover they say the server only offers a limited set of ciphers (i.e. 
DHE-RSA-AES128-GCM-SHA256 DHE-RSA-AES256-GCM-SHA384 ECDHE-ECDSA-AES128-GCM-SHA256 
ECDHE-ECDSA-AES256-GCM-SHA384 ECDHE-RSA-AES128-GCM-SHA256 ECDHE-RSA-AES256-GCM-SHA384).


Apart from the security requirements the server uses DFS and nested name spaces.


I don't have access to the server and Linux client knowledge is limited. So I'm 
somewhat stuck with trial and error.


My current understanding is that for "SMB 3.1.1 and encryption" I have to pass 
options "seal,vers=3.1.1" to mount.cifs.


I'm not sure what the make of the required ciphers though. I'm guessing that's only 
needed for doing LDAP over SSL (LDAPS).

But it seems that's nothing mount.cifs actually has to use?

(Quickly skimming through the source of cifs.ko I only found the symbols
SMB2_ENCRYPTION_AES128_CCM, SMB2_ENCRYPTION_AES128_GCM.)


So before digging any further, I'm wondering whether this should generally work with 
options "seal,vers=3.1.1", what to make of the ciphers requirement.


Thanks and regards -- Till
-- 
Dipl.-Inform. Till Dörges                  doerges@pre-sense.de

PRESENSE Technologies GmbH             Nagelsweg 41, D-20097 HH
Geschäftsführer/Managing Directors       AG Hamburg, HRB 107844
Till Dörges, Jürgen Sander               USt-IdNr.: DE263765024
