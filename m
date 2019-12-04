Return-Path: <SRS0=LMmx=Z2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E66C43603
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 17:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4761E2073B
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 17:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tdj7DQuR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfLDRzZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:55:25 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:41790 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRzZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Dec 2019 12:55:25 -0500
Received: by mail-il1-f196.google.com with SMTP id z90so343080ilc.8
        for <linux-cifs@vger.kernel.org>; Wed, 04 Dec 2019 09:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zEgziEyxriQE1JQ9hICSSk0qlMpCcPp74hmSuXy0lNs=;
        b=tdj7DQuRfvLd5Xivbb+NrLJJbcrYQ5F+Gig6POJDYnw8NpXO2Cpo7kDk14O1QliOVX
         DPquhz2S6XhtQ7komJhDBvdBvqcMAXOOZInQ2s5KIjyNWr3A5ouGOmkjbxcDLlBhDgpP
         NRtBgR6fLGQ0gSVmOHuFjp1f+8nZFayFZrplNDTVwYQSORXvWr9i3UkLw1ia+gUpNoWA
         TvEygFwL0sV7jwonQjMdcNt0hELso89mCJDLK9Q1jvJeZu2/gOxCDMW373H5AyuO10wc
         9W+tKO5je9hrRN+mTInMvN3EQzTQcl3c7d4Su3GSiJdEpI4tUiLAGbd1CK2zYKvc2Vns
         Dv5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zEgziEyxriQE1JQ9hICSSk0qlMpCcPp74hmSuXy0lNs=;
        b=q567jlo5JJ6HjDzojk3xzWQ9aPgnuipGEtu2AMAQQu2jJvmP2GkXJ2l9IT9P8OIyh6
         jHkcO/Jqhtx84KxpFzy97NuZGMyGalNDdRbG+806JRSsn7HgElSEeak/gMDewj5DrKM8
         8haQFxIsKSoIaYHvJ+nEF+286p6SgVx9BC10aWGKSpafHk8Fsp5x4+RS/Gm8TqWW3WqH
         1KS4q8y6SIhwbGeU6TYyW/PcB47LxKM2kVug6vICHswy4lREFW4u1SRj3a/ws4yCfxnV
         1PHJR0ONcRrZrDcP330Me4ZB1+6iGeDtfhv1smDRTP02VMSlIIgHURo++YmDVl2Dd8ZX
         pfiQ==
X-Gm-Message-State: APjAAAW4WaScZdhXKHgYEBc0ycpP/SrEtqU+rVpe15vQDq7XK7+VDPIr
        Vi+TE0OqBa/Quqs5NgMUwufDkLPsnJKXL/EUElc=
X-Google-Smtp-Source: APXvYqyZNJLgdGgcnaNF07r8+DFoTa0r4PUHvRHj+OewOli4quOnzA3mttzbLwavXeiV0nTndvshzwKLru/GQFbZa5c=
X-Received: by 2002:a92:1607:: with SMTP id r7mr4467450ill.272.1575482124795;
 Wed, 04 Dec 2019 09:55:24 -0800 (PST)
MIME-Version: 1.0
References: <20191204133806.27431-1-aaptel@suse.com> <20191204151454.29253-1-aaptel@suse.com>
 <7FD5F9C5-58B0-40D5-A5AD-13CCD75E625E@pretty.Easy.privacy>
In-Reply-To: <7FD5F9C5-58B0-40D5-A5AD-13CCD75E625E@pretty.Easy.privacy>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Dec 2019 11:55:14 -0600
Message-ID: <CAH2r5muG_cysxDYtzO2feuu1VUMbW2ydPQvvyOWY82WkyObfag@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: fix possible uninitialized access and race on iface_list
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Aurelien Aptel <aaptel@suse.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next and buildbot github tree
pending testing

On Wed, Dec 4, 2019 at 9:59 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>
> On December 4, 2019 12:14:54 PM GMT-03:00, Aurelien Aptel <aaptel@suse.co=
m> wrote:
>>
>> iface[0] was accessed regardless of the count value and without
>> locking.
>>
>> * check count before accessing any ifaces
>> * make copy of iface list (it's a simple POD array) and use it without
>>   locking.
>>
>> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
>> ________________________________
>> changes since v1:
>> * remove unecessary kfree()
>>
>>  fs/cifs/sess.c | 29 ++++++++++++++++++++++++++---
>>  1 file changed, 26 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index fb3bdc44775c..396400cf2800 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -77,6 +77,8 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>>   int i =3D 0;
>>   int rc =3D 0;
>>   int tries =3D 0;
>> + struct cifs_server_iface *ifaces =3D NULL;
>> + size_t iface_count;
>>
>>   if (left <=3D 0) {
>>   cifs_dbg(FYI,
>> @@ -90,6 +92,26 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>>   return 0;
>>   }
>>
>> + /*
>> + * Make a copy of the iface list at the time and use that
>> + * instead so as to not hold the iface spinlock for opening
>> + * channels
>> + */
>> + spin_lock(&ses->iface_lock);
>> + iface_count =3D ses->iface_count;
>> + if (iface_count <=3D 0) {
>> + spin_unlock(&ses->iface_lock);
>> + cifs_dbg(FYI, "no iface list available to open channels\n");
>> + return 0;
>> + }
>> + ifaces =3D kmemdup(ses->iface_list, iface_count*sizeof(*ifaces),
>> + GFP_ATOMIC);
>> + if (!ifaces) {
>> + spin_unlock(&ses->iface_lock);
>> + return 0;
>> + }
>> + spin_unlock(&ses->iface_lock);
>> +
>>   /*
>>   * Keep connecting to same, fastest, iface for all channels as
>>   * long as its RSS. Try next fastest one if not RSS or channel
>> @@ -105,9 +127,9 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>>   break;
>>   }
>>
>> - iface =3D &ses->iface_list[i];
>> + iface =3D &ifaces[i];
>>   if (is_ses_using_iface(ses, iface) && !iface->rss_capable) {
>> - i =3D (i+1) % ses->iface_count;
>> + i =3D (i+1) % iface_count;
>>   continue;
>>   }
>>
>> @@ -115,7 +137,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>>   if (rc) {
>>   cifs_dbg(FYI, "failed to open extra channel on iface#%d rc=3D%d\n",
>>   i, rc);
>> - i =3D (i+1) % ses->iface_count;
>> + i =3D (i+1) % iface_count;
>>   continue;
>>   }
>>
>> @@ -124,6 +146,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>>   left--;
>>   }
>>
>> + kfree(ifaces);
>>   return ses->chan_count - old_chan_count;
>>  }
>>
>
>
> --
> Sent from my p=E2=89=A1p for Android.



--=20
Thanks,

Steve
