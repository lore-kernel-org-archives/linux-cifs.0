Return-Path: <SRS0=8LXX=Y5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2E5C5DF60
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 21:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C545B21882
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 21:38:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="By5GKG3/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfKEVi0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Nov 2019 16:38:26 -0500
Received: from mout.web.de ([212.227.15.4]:45601 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbfKEVi0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Nov 2019 16:38:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572989897;
        bh=Z0h9yJgXnSUcWdErBXHxvaR+qAseoj0Jwa1kwKZvWjs=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=By5GKG3/XauRyP4gGGo/jEQFdb5JlgyZ/lkCeciTGQjvQ70TBL/6c9nJOVD9ytTfQ
         Y81rZyXzB8tzj3Hmwh/kqzxVRh1xdRDBlLaZSc/6/eGI5jBbns6laW29yR7HsBzoeM
         7UPxQU3mwqnUUPiB5bpWDJHnwhLcxBG4KLNvzSoo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.164.204]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lxf1X-1hqkIl4Bzf-017AXB; Tue, 05
 Nov 2019 22:38:17 +0100
To:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH 0/2] CIFS: Adjustments for smb2_ioctl_query_info()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <b797b2fc-1a33-7311-70d7-dd258d721a03@web.de>
Date:   Tue, 5 Nov 2019 22:38:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:B+T63bsrdVK7IeDZFAXORLQRkM1LR5oi1X3PWAnIzQtetpH249q
 ZkQ/dJ2HnOpCiLx3HTQuS10Xw8JK4pAnLZ1BPY7kqcSlMdfkZMJVZPtR3lMTeaDA67zwFsz
 KW5YsR96AbDz6dvByurxtk8cDtK/vapGzDRAzQKEFx2zquTH9wGkIjIKiqPWbhxBn24xZEX
 veP5yVdWsZt6bBpkfGHtA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:25K7cMc+uzo=:suAa/4UDPTeSi6PRwAHKXN
 sa2tI8gEgU1s0DozqaCjb/iYgOJi5cAUcUCel57c4UQJHDueRCwskbr/0woz9oAj/M1XkWgaj
 WkA7s308uQsi3t+oOqR5dhVl0Ewscl5/K1lazje1+lSsa7g7DLGH3QcyOWruhCAuMTPSX6U1o
 tINe5to8MasWU+HyKSCoAoH36aGmdXQ88xMAE25xeoviIAUDORW1kgIOI4b4tTowMvPxhLlsD
 uaMU6f7SLbhpccVY6i9icoYE/Y1ey6yX4qnVAVEM+lDNW9Jup8IHqXhiyzrr4m/D9kDyMv0an
 GRRakd669Kyb2WUXsQxXlaklCbJ4mZEWjRugq2suw7heDtf6aYpHyvIBkXI9mpYq04mP4zb0M
 OUbLukvRQOO0pN4+dE3ZL0zCmhxHDD1H0sBJbnLCpTmUmcNRA/FE8//De9OpQy0Js+qS8L/Jy
 NRNc+mRiJ5qG/ruDlS+Z99EtV40SgPs1YLvUg2SJHkNUCgeAW399DwGcI8EHoKmM/+4mxO578
 b0Uyi0nenTW+FW229WcdhwkIpPqJbrIeDlfC+EKNFmIYQzWsfKuUxE/lslrFqPQxCzbtNctEL
 A7OS2a24ImONlYGfpb2AafHaY64UMCG+2ob7vw1CRqrsgscAOMR9E9htHkBmOX3pkAJeqWAKR
 kMHq+dWDeiiNdUkHZ9PPQDxFDHdYkBaoZZAQ5Br3qVe22trI+WAlT+62QCbQDmPgGTCBXatvy
 IYkcg1SWU5YItuJJZrztzJxJxHIUo3fOgkalFq8PNGK5jzevLLqktljXcL8fPJQFFEvFvlG7c
 5SWvdeRLBEwTbU3z+kR+JoU125jyFFB+vHIrtPM0SCzWAkmeXX72Ak7aVrt0bv2YYASA2Afj4
 6k3I+m0wuSRTd5RGPu9HPRDXtbGCuKFEuZ1jJFi0y8W7tg58G4fZmt6+XbX3QrYvfJER8FX6i
 /rmH1IT6wrZ7gCobFEdsw1O+LyRHOPkOYb6DPQt5xtIhAIjx28uE8hu5w5MzpNz2LPTb+zyW3
 Hx9X26X4bcGDkUziiS5MBFHoDf+EPiLhMyZcFG2aTSYSAWIcYhjAqkf6meei2VVk3bKsnp6/B
 K1ZxzQR5NCTtQal1oDMJMhPgBQa1lG7q+KI+ejLG+ehoJYvyH5U+fHoCiY55CXD7UUlDfJjq9
 ud46X8byLCaaaNyg1Fl+MR0QeUkOtPixRF8mmVZSCnWvCK3s1srtYxaFlD7/HbvV0jOSuU6kP
 N4I1P5Qs+KQnCFpyf0aDzyYJ2+h6JeAOxEE6Qqjmgzfey3DlOIppWm6rNR2k=
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 5 Nov 2019 22:32:23 +0100

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use memdup_user() rather than duplicating its implementation
  Use common error handling code in smb2_ioctl_query_info()

 fs/cifs/smb2ops.c | 58 ++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

=2D-
2.24.0

