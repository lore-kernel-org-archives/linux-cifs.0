Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68011ECAAD1
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Aug 2022 21:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiH0VLy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Aug 2022 17:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiH0VLw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 27 Aug 2022 17:11:52 -0400
Received: from sonic306-25.consmr.mail.ne1.yahoo.com (sonic306-25.consmr.mail.ne1.yahoo.com [66.163.189.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A99357C4
        for <linux-cifs@vger.kernel.org>; Sat, 27 Aug 2022 14:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1661634711; bh=bRoXnu9P5Jo1/X2hFBqVJjRsMel2ZDZTO3RzEcBhYCw=; h=Date:From:Subject:To:References:From:Subject:Reply-To; b=iBjHyAobsryUW3oiaHAjtTDPlVkEAGYlZ75SLPBe1Ut70xu7HIfe10KV2X9AAB73ua+dvy8fbE9gn/enACW0EH5si6UOPcqdEuqRdS/9p76krbZU0wdHrsZ6R7TBDXvY3MnE9O753yN9qy5KsRqLuMQLVcLED0yJwRerZ22iAhw=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661634711; bh=gE6KD49Dohomklnx1LIzULPdK4Zu9q6oGLvGwfN80+6=; h=X-Sonic-MF:Date:From:Subject:To:From:Subject; b=J3HxlnUAkGZHqDhN4lKvW0yjMztonKuHH5ecdd/6xanwXY+Ds68UORsHuFD0j3bVd289Lcyx7Qk6ettgSl+PibqFOV2t+rJKKrsPYCX0yQm58R4m4h1MO30bJGc3KG+G2rL+sDiOdRJOIKcYPBndfFhllqdYX/7z2xfA39iRS7sF+XGToo1/VB06lhYjBgHGWEzMAwzVqIEbZqmoYVNX7Ll/sAq0Sd2NFMuJFtSGZkWgoXh5AGiwsPqb1YU0XQQtPGdAyfGh3juEnJWOn+IVThPe4W34eFqRj56WL/0qXAPkuH3KBXCE1r7/MlZIo7MZjbemP8t2CsE+y/HfofoFGQ==
X-YMail-OSG: n6fw5VEVM1ms5OQ.DU4smAWaDF.phTF2WB4zAieIpq09jr.L20v1mCq2j7YYDmJ
 m68Q5yQpIbwm.0gVuaEh4.jW6F.sajC7dtn4k3RN_5PkESEEV1kuq6WcysdbPjchd.SlYTcZ2GP5
 1wYBc0w79X_P1rGH_hmPUR1_Slg7MqBwNikfkwjrOFaw8XejfqRv9RzR8hUxtAmR.hOths1Q8dGf
 TI8lDxttPrZzz9TMMFxQAn0V1NrcV6xNZ93CfC_ExPGY0ILkFYkUCAkZTVugzQAaW2Spu3aHjjLi
 SpY8zO_QaAJpwU6O1_73QlwSpfliQgDY8ghm0O0VLeZwQ9UiqilsQF18NleD2oIzuewgcSHVVPMI
 6h8GLyEvUoFXGfNoTAv8.zk1kxidrxcSOsBZzElWSK_jOSBIC8mxYI1hmKTBIofAYj2mDuUkjHae
 Zp8tPDxrCbeERLNiPLkFfCk5CPwur2Csi1eXsrawdEDn2oh895UQzNq7Osr0jwja5xn5h1Sj4TKc
 J.54czGSQz7gZI9J.GIesdgdFf8RBQCvmQ10bkgRBGLHgr4y9VuO_rjupsfXFhwN7TOveCW5tEJy
 7a8JJeMALkZKLFFJc0nHEpN7pkzEF1pQu3jAIJ0upjbgwsmVWkisru.G4jz8A6i8WLHS4pE4.6n3
 ofnNpmR4JwiJno97EeqUsimmzgSyzXiqW92ZD8UVJeVila6QiS1akw1Tn7h8ZRTDs4qLEwtQKulj
 nKzS3YqT8_oxFPaVOlTiOOxJJLBa44rBQguk1gvobGjcghmWNhjNa9zWYdJMjQxF1h_GIEa6ivbb
 yHe1g_6T2g7E_5m.vtcNHDKrkWqeW5xsI.yzu78wa5rizxOOo31lP.xSyNh9tnb3L33e5gsxIrJi
 etaqh3p8FnS5j3I1JuI9mRUiqY9htrhed29nCRsOTzqPHeX8OC9sEuatQ_eWLQDE_NkwOnSrd9p0
 .vwe61BDaR2KkNovNoeLWT0fqrBEJnN23LtWJIDJOjfQ9HNgb4e_RI_XDQgJp89ftyScALgPkw6o
 .VTQh96m0s2myGbIgLAu2hqGKEme.b.MRd3NvWrdIn2hE0L0WCYTnBy0q.dpfnHFyaM0RFKV26LZ
 saYsS1kXRCdGPhk9v.1kFZNpMb7HqRol_2MMvShz5aQ9iTRs6NBgg8j4mUkwlfzOQTbfQVBQq3gL
 XgbytAf7AWrQhBdAehJe04R4MQFOpgPkVKfAlEuuiaTmsFs0lm3lX2ha0A49bIy79n1AFYWpjLpT
 N0jiyUyjo5hfniKCapa3Td4OD1nrcSlCBQzzF.M2Tu50sitmEkHLFq_zfqzfDDp_aObbHRkBYBhx
 jKTGJNX02ju2gWBnvEBP4l_Ds3bVhhoJtJt5fWCtEEI9xYFE66D3meL.KPX7RdYJgFQQG2xODtFd
 HOYFbg_gw6oj6NSEQVt9lxmy50sFXwE3elhx1x3h_6CyozXztiLy1.ti8MshyiMWxCWlQlO1kpDH
 EVaJ5EqLQ0yZDIcQpueNvREuVaER68ZGUOQMZB5.oxYKfRG2riexuGXKsenA8UuD5y_SJgK.xGst
 8EEVre1Mq2rNRvQ0UgTHxmXINEtMneY0qk_hbOZ9Fl6jKXASIOrpmKTJbgK2MSSJiZFJX5ay46pz
 wljzX06ymH0g6RdErpMOpTdnrmq3_SD8cR_4.cKWuk1CcOp46ph7ok61pFRk2ygoAImWAghnh4cG
 PtaIjjBMGgKzZFykGN9bGjM1U0646.MnLbkmCdItdRDsXHaNtjtDGHCtUoFhs6Pp2Q2BDQ0EoTpM
 1N1_6IyZb02aJCxg8plRZW1Y8Z3FVtGwtf16oQr1UcU1Wnw31q7evo28OB_l6sT4mrZRBFV7Ooej
 Kcg8UjON5vta6IRzOYxIBAlCUdWErGW4LXhysC0RIEdoeXNlzLuVF_QtTCaSnb6VU24384Qipvdm
 GQAjUhuTb9u8xpX4rWPB5X0IjAzAHXTPb1Twvw9KHTDBfyrrPulq8YJ_PhOcEBcF2vAlfH.wwzR.
 xeVILQ5pb_NsECkDccfNp0MR4eCpBt.wPAbNo1x3LXwVysvq4maLgmZfAhdLmX8G5QLKSbSbqmRm
 vgFfM.cXGkuCArm4CdnwkwtN0ijFeUfrAuET8u6AtUwmnAm3cj5z6Liepqu4qLg52HTev1BsJO27
 2QlRyBWy2jEvP4ChAa4efc_vbUV5TzJJ4QgpMKaVl4Q6hlyKFX9.NVkUiyh9d0HHvqkcMSMKtBim
 thwec
X-Sonic-MF: <pheonix.sja@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Sat, 27 Aug 2022 21:11:51 +0000
Received: by hermes--production-ne1-6649c47445-q2mtq (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 265b3daa514bd42976b8e75dee2158a9;
          Sat, 27 Aug 2022 21:11:47 +0000 (UTC)
Date:   Sat, 27 Aug 2022 17:11:41 -0400
From:   Steven J Abner <pheonix.sja@att.net>
Subject: possible patch to mount.cifs.c
To:     linux-cifs@vger.kernel.org
Message-Id: <HJLAHR.KUPF9GW209YS@att.net>
X-Mailer: geary/3.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
References: <HJLAHR.KUPF9GW209YS.ref@att.net>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,
  long story short: updated to ubuntu 20.04, postponed so long because 
of broken networking,
among other things. Finally got it to work with resolved names, which I 
used in conjunction
with mounting my old mac mini, lots of data/back-up data retained 
there. In using:
sudo mount.cifs '//stevens-mac-mini.local/steven' /mnt/steven -o 
user=steven,vers=1.0
I get 'mount error(111): could not connect to (ipv6 address)' with 
forgotten '\n'.
However, it does mount, regardless of error.
  Purposed patch is replacement at mount.cifs.c:2268 with:
  case EHOSTUNREACH:
   fprintf(stderr, "could not connect to %s\n", currentaddress);
   currentaddress = nextaddress;
   if ((nextaddress == NULL) || (*nextaddress == 0))
    break;
   nextaddress = strchr(currentaddress, ',');
   if (nextaddress)
    *nextaddress++ = '\0';
   goto mount_retry;

Sorry about not in normal patch format, but gun shy when it comes to 
developers that
are unknown to me and apologies for bothering you if this a waste of 
email.
I wish to be personally CC'ed the answers/comments posted to the list
in response to this posting, please :)
  Steve


