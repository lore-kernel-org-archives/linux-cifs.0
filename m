Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95410C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 23:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5376103C
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 23:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhKCX3B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhKCX3B (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 3 Nov 2021 19:29:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6912F608FB
        for <linux-cifs@vger.kernel.org>; Wed,  3 Nov 2021 23:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635981984;
        bh=WHYI/LsIHf35b2Zha7XynaAR79aXLdtWvI48K+mOqJY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=DZHTR1WoIPGssPEK8juTZAwDiEPh7vvPCrMNvbaHq44sFKmhP6Gw5w+W2EcSWEV4b
         Mg7853NNOJn/QQlO3YCcucTslZ7VcnrzyRyTFDfDF8SyoEWwK7o+LqGMAYVblsWD3w
         hZH30VLw41gU2S8PkY/Kb0GaCLcK9QuUMcMyKZQKiSbd1cRI+TD4f3f4NEkomxw70q
         kpfCQC0MoDpOxoBbVIUQMQmfsJ2Hm5IUELtANelTU2CSuAb+XSJZaLDlNrfig3KX3K
         KzzTo9GFPH+p1NlPUVlU2KVeYn/Ffj2H/dsaLGFlNyo4O6pExY+DZtl/LyB6Iu6unI
         W9hUpibDiwg2A==
Received: by mail-ot1-f48.google.com with SMTP id c2-20020a056830348200b0055a46c889a8so5769664otu.5
        for <linux-cifs@vger.kernel.org>; Wed, 03 Nov 2021 16:26:24 -0700 (PDT)
X-Gm-Message-State: AOAM531zWrS7I6LhIhxxW1b3aTcIBIkMjv9rJcubkfwl4upYVloYFIfv
        Hq0fHPNifUpO79pLq6FAkMqNJ7GfPEWedyx1KD8=
X-Google-Smtp-Source: ABdhPJxbjqj+R1YOljuIm/EDR9QGGGy0HGlsUYVYXz/vVMxGe0D6DILHST6bTq5ye+h0OqySp+ER0TwFDu5yvlpQu2g=
X-Received: by 2002:a05:6830:923:: with SMTP id v35mr19064083ott.116.1635981983738;
 Wed, 03 Nov 2021 16:26:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Wed, 3 Nov 2021 16:26:23 -0700 (PDT)
In-Reply-To: <20211103151018.172802-1-casta@xwing.info>
References: <20211103151018.172802-1-casta@xwing.info>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 4 Nov 2021 08:26:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-tOGBo3XMzBrfMAFY0c4=s5xspj7FM=Jnt_Qfzt7DZSw@mail.gmail.com>
Message-ID: <CAKYAXd-tOGBo3XMzBrfMAFY0c4=s5xspj7FM=Jnt_Qfzt7DZSw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: Standardize exit codes
To:     Guillaume Castagnino <casta@xwing.info>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-04 0:10 GMT+09:00, Guillaume Castagnino <casta@xwing.info>:
> In case of success, EXIT_SUCCESS must be returned by the control binary
> This standard behaviour is expected for example for the unit file
>
> Signed-off-by: Guillaume Castagnino <casta@xwing.info>
> ---
>  control/control.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/control/control.c b/control/control.c
> index 5b86355..5ff2780 100644
> --- a/control/control.c
> +++ b/control/control.c
> @@ -43,7 +43,7 @@ static int ksmbd_control_shutdown(void)
>
>  	ret = write(fd, "hard", 4);
>  	close(fd);
> -	return ret;
> +	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
Shouldn't we also return such a return for open() failures?

>  }
>
>  static int ksmbd_control_show_version(void)
> @@ -61,7 +61,7 @@ static int ksmbd_control_show_version(void)
>  	close(fd);
>  	if (ret != -1)
>  		pr_info("ksmbd version : %s\n", ver);
> -	return ret;
> +	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
Ditto.
>  }
>
>  static int ksmbd_control_debug(char *comp)
> @@ -85,7 +85,7 @@ static int ksmbd_control_debug(char *comp)
>  	pr_info("%s\n", buf);
>  out:
>  	close(fd);
> -	return ret;
> +	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
Ditto.
>  }
>
>  int main(int argc, char *argv[])
> @@ -104,7 +104,7 @@ int main(int argc, char *argv[])
>  	while ((c = getopt(argc, argv, "sd:cVh")) != EOF)
>  		switch (c) {
>  		case 's':
> -			ksmbd_control_shutdown();
> +			ret = ksmbd_control_shutdown();
>  			break;
>  		case 'd':
>  			ret = ksmbd_control_debug(optarg);
> --
> 2.33.1
>
>
