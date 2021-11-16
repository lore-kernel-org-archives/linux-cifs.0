Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0571C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 03:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B91A561BFB
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 03:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbhKPDyM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Nov 2021 22:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbhKPDxo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 15 Nov 2021 22:53:44 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57D1C1A16DD
        for <linux-cifs@vger.kernel.org>; Mon, 15 Nov 2021 16:27:18 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id k2so31723321lji.4
        for <linux-cifs@vger.kernel.org>; Mon, 15 Nov 2021 16:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=oU68AkphVE+yjSX6PcL6AWriSdFHb9UDEuGlHNKpaf4=;
        b=TjJr6ok9l6tgJXT2h3TCF3nTeYVWEzZ0KAwpmCaSEYH5eEJ979pVJDcgbyE5IUNqDw
         J5F1ObNPnN2xE/eYuoL8kXDZce2hG78Zh4BFS/Rex2ePtyzoroI4yX7rngVmon/SofuK
         uB9aN36pJ7X/asdXQYCregGoIRRBRC7X+ynry0QRDQN6/RW8PKuT1qBA2woGzhWDZ8us
         b0jip1nnmmrTk+jX0RokB7bRJxFPGNeNLwkW//gO6G64Ra5HoSDEZjFZRfEUt1meq83v
         DCNRPFfEMqEgOmSljzg9jIINEStJ5Qg2okpEYWbbYtnoYo1WoWHXJn2A/awxCTVi2aNx
         sTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=oU68AkphVE+yjSX6PcL6AWriSdFHb9UDEuGlHNKpaf4=;
        b=DEdFmDomz4smy/LLem1S3Zo0aGNNw9MhjZxiA0zHsdgqrF9NJ7/p9Er87UBjT53WT1
         J/AGRtI6m4zdHOmqJX0DakMbOI06sEAGTVG54d5FddIr/xPGNEI0K14vrxiderNgcujt
         ykIew0Ice6loDkQoCNBh9XATJIfcVEPQR8K3YBUL1sEqMmUnAMFNbeLbhAmFEhj82itK
         96H2yERLRvP2beLgQYhuMoC5N1KEdrOs9cTqQvpJoc5HUx8GVBNDPvvw/O4nzmr6ihsL
         gE/yXPgaRf8wax3owEqEbqYZ59/OCKdY/c5VZq8XCBLZJdej9sBmAepJBIwnK0KZSuHX
         8I2w==
X-Gm-Message-State: AOAM533FV6BbatSW4IlXNrEwxW64aYoOOC3mDvO6LJY3UhJHCKqRtP4R
        zPr9QCZ/xFVPQyGjGcrVaYegi6D4iQkDb5nCeSt1AyrC
X-Google-Smtp-Source: ABdhPJwOVVtBdTlxlAyLdRSALD2wZUKLct3cSCtu6TTfQGGFkH8Sx/hb2dIhTxM1yVCZhE0aGrAVG9Q0l4IpFTgoFjU=
X-Received: by 2002:a2e:2a46:: with SMTP id q67mr2774542ljq.398.1637022436976;
 Mon, 15 Nov 2021 16:27:16 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 15 Nov 2021 18:27:06 -0600
Message-ID: <CAH2r5mtr=1g3tDqDLpcjcK477ncDqOSYfZ0=m_euMT+cNnm6Wg@mail.gmail.com>
Subject: [PATCH] protect srv_count with cifs_tcp_ses_lock
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000d8e23505d0dcfcfd"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d8e23505d0dcfcfd
Content-Type: text/plain; charset="UTF-8"

See attached patch that fixes a missing spinlock in multichannel patch series



-- 
Thanks,

Steve

--000000000000d8e23505d0dcfcfd
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-protect-srv_count-with-cifs_tcp_ses_lock.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-protect-srv_count-with-cifs_tcp_ses_lock.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kw1cvv300>
X-Attachment-Id: f_kw1cvv300

RnJvbSA3YTg1OGI2YTcwMzIwNDk3YmIyNGM0OTNhNzlmMjUyZDdhYjNiMjdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTUgTm92IDIwMjEgMTg6MDI6MjcgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBwcm90ZWN0IHNydl9jb3VudCB3aXRoIGNpZnNfdGNwX3Nlc19sb2NrCgpVcGRhdGVzIHRv
IHRoZSBzcnZfY291bnQgZmllbGQgYXJlIHByb3RlY3RlZCBlbHNld2hlcmUKd2l0aCB0aGUgY2lm
c190Y3Bfc2VzX2xvY2sgc3BpbmxvY2suICBBZGQgb25lIG1pc3NpbmcgcGxhY2UKKGNpZnNfZ2V0
X3RjcF9zZXNpb24pLgoKQ0M6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmlu
ZGV4IDgyNTc3YTdhNWJiMS4uYjk4NzExYjYyODk3IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5l
Y3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMTQ1Miw4ICsxNDUyLDEwIEBAIGNpZnNf
Z2V0X3RjcF9zZXNzaW9uKHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCwKIAl0Y3Bfc2VzLT5t
YXhfaW5fZmxpZ2h0ID0gMDsKIAl0Y3Bfc2VzLT5jcmVkaXRzID0gMTsKIAlpZiAocHJpbWFyeV9z
ZXJ2ZXIpIHsKKwkJc3Bpbl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CiAJCSsrcHJpbWFyeV9z
ZXJ2ZXItPnNydl9jb3VudDsKIAkJdGNwX3Nlcy0+cHJpbWFyeV9zZXJ2ZXIgPSBwcmltYXJ5X3Nl
cnZlcjsKKwkJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIAl9CiAJaW5pdF93YWl0
cXVldWVfaGVhZCgmdGNwX3Nlcy0+cmVzcG9uc2VfcSk7CiAJaW5pdF93YWl0cXVldWVfaGVhZCgm
dGNwX3Nlcy0+cmVxdWVzdF9xKTsKLS0gCjIuMzIuMAoK
--000000000000d8e23505d0dcfcfd--
