Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC59C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 08:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79DE661106
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 08:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhKDIfq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 04:35:46 -0400
Received: from alderaan.xwing.info ([79.137.33.81]:57590 "EHLO
        alderaan.xwing.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhKDIfp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 04:35:45 -0400
Received: from [192.168.6.232] (143.90.7.93.rev.sfr.net [93.7.90.143])
        by alderaan.xwing.info (Postfix) with ESMTPSA id 62EEB1003C0;
        Thu,  4 Nov 2021 09:33:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=xwing.info; s=mail;
        t=1636014787; bh=74zFl2wTRWJN72SWpQ5YyjYocp4rtZ8vIpQOgfETwYU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=CYls1E6e0XlfqOq/T7ITCyIezbqyL1XzJuiGIkhnblCyt2lU2HSBbbARaz9uiEmVl
         e1Q4d6/lGDRyfLXA8EmwpVOgNborH4z++m9CHNRVe/BLqJAn815s/JRDIBicGjphN4
         Fwp2oB/IJUiX19zvBRIlH3lao/2lNaJvtCldfN6U=
Message-ID: <ab455921219e327ee9bf733d06f135d451b657b3.camel@xwing.info>
Subject: Re: [PATCH] ksmbd-tools: Standardize exit codes
From:   Guillaume Castagnino <casta@xwing.info>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
Date:   Thu, 04 Nov 2021 09:33:07 +0100
In-Reply-To: <CAKYAXd-tOGBo3XMzBrfMAFY0c4=s5xspj7FM=Jnt_Qfzt7DZSw@mail.gmail.com>
References: <20211103151018.172802-1-casta@xwing.info>
         <CAKYAXd-tOGBo3XMzBrfMAFY0c4=s5xspj7FM=Jnt_Qfzt7DZSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Le jeudi 04 novembre 2021 à 08:26 +0900, Namjae Jeon a écrit :
> 2021-11-04 0:10 GMT+09:00, Guillaume Castagnino <casta@xwing.info>:
> > In case of success, EXIT_SUCCESS must be returned by the control
> > binary
> > This standard behaviour is expected for example for the unit file
> > 
> > Signed-off-by: Guillaume Castagnino <casta@xwing.info>
> > ---
> >  control/control.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/control/control.c b/control/control.c
> > index 5b86355..5ff2780 100644
> > --- a/control/control.c
> > +++ b/control/control.c
> > @@ -43,7 +43,7 @@ static int ksmbd_control_shutdown(void)
> > 
> >         ret = write(fd, "hard", 4);
> >         close(fd);
> > -       return ret;
> > +       return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
> Shouldn't we also return such a return for open() failures?
> 

In case of open error, it already returns something != 0 (-1) in every
cases. So for me it’s less an an issue. But it would probably be better
if it’s EXIT_FAILURE indeed.

I will submit a new patch

Regards,


> >  }
> > 
> >  static int ksmbd_control_show_version(void)
> > @@ -61,7 +61,7 @@ static int ksmbd_control_show_version(void)
> >         close(fd);
> >         if (ret != -1)
> >                 pr_info("ksmbd version : %s\n", ver);
> > -       return ret;
> > +       return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
> Ditto.
> >  }
> > 
> >  static int ksmbd_control_debug(char *comp)
> > @@ -85,7 +85,7 @@ static int ksmbd_control_debug(char *comp)
> >         pr_info("%s\n", buf);
> >  out:
> >         close(fd);
> > -       return ret;
> > +       return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
> Ditto.
> >  }
> > 
> >  int main(int argc, char *argv[])
> > @@ -104,7 +104,7 @@ int main(int argc, char *argv[])
> >         while ((c = getopt(argc, argv, "sd:cVh")) != EOF)
> >                 switch (c) {
> >                 case 's':
> > -                       ksmbd_control_shutdown();
> > +                       ret = ksmbd_control_shutdown();
> >                         break;
> >                 case 'd':
> >                         ret = ksmbd_control_debug(optarg);
> > --
> > 2.33.1
> > 
> > 
