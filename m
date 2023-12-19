Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39E218022;
	Tue, 19 Dec 2023 11:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ze0y6cBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EEEC433C7;
	Tue, 19 Dec 2023 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702984836;
	bh=u/Gx4/EWK+SES7Afvs++3jRiipFZvGhlSsdRsoGcCmM=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=Ze0y6cBNfd00ot9+Q+ea6jCb+7AtYekTMkE4PZbgjyCLtAGo7C2jPyuoLaLJofk3N
	 NR3zNgRrjH30pMffk4qLhI4/BliW5f/6VdrIah9HPGnKPaE9cuhwrjcv/lp1gJcYmn
	 /sHtTbWRbAo13cpT2+EsyTMVc1Y3R6DCOLngeEUwDJcPI46cCQLg4LvX4aUfXejdhP
	 jvdrISD3pyLP+dIK1Q/4Xc4kfWg3oxHkB6g1XXhFzQ5xA2sdBkk3q/aU1BYNIEiqiB
	 hKWqQLvYsCgLcZxnoVFeTsV599Oc44Ve1eCzkmyDDA08QysoqEZHIOJufglUbi+4o3
	 oZgWWtJOCGwjg==
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-58dd3528497so3141838eaf.3;
        Tue, 19 Dec 2023 03:20:36 -0800 (PST)
X-Gm-Message-State: AOJu0YwBQnkdYJrzWz8qs4M1e/uMtb5Kn0QQtEoFpiO8mIwFtdkgGVMa
	RYni8q6G0+bmcx/wdb0HQR2NOXlTbja5okCTdjo=
X-Google-Smtp-Source: AGHT+IFYqMJMvjidgbQxM2UPu1GVlgtaSEUWlERC7v7yGodRBFSKtfUsZlz7vxAu3362oPz0xtaMkX/VIr8A8WgAB/A=
X-Received: by 2002:a05:6820:551:b0:590:96a7:34c2 with SMTP id
 n17-20020a056820055100b0059096a734c2mr13756995ooj.14.1702984835836; Tue, 19
 Dec 2023 03:20:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a8a:746:0:b0:507:5de0:116e with HTTP; Tue, 19 Dec 2023
 03:20:34 -0800 (PST)
In-Reply-To: <2023121933-bunkhouse-snack-8ae5@gregkh>
References: <20231218135049.738602288@linuxfoundation.org> <20231218135053.258325456@linuxfoundation.org>
 <CAKYAXd952=Y54gwM4KBDca52ZFcg+yjJeuiy+6o3jG+zYYUF1w@mail.gmail.com> <2023121933-bunkhouse-snack-8ae5@gregkh>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 19 Dec 2023 20:20:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_v8tFQgKMWR3LXcHZj-bXKZmJxnUXD2k6NwDaudWr=TA@mail.gmail.com>
Message-ID: <CAKYAXd_v8tFQgKMWR3LXcHZj-bXKZmJxnUXD2k6NwDaudWr=TA@mail.gmail.com>
Subject: Re: [PATCH 5.15 80/83] ksmbd: Mark as BROKEN in the 5.15.y kernel
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Steve French <sfrench@samba.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

2023-12-19 16:47 GMT+09:00, Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Tue, Dec 19, 2023 at 12:54:25AM +0900, Namjae Jeon wrote:
>> 2023-12-18 22:52 GMT+09:00, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org>:
>> > 5.15-stable review patch.  If anyone has any objections, please let me
>> > know.
>> Hi Greg,
>>
>> It took some time as there were a lot of backport patches and testing,
>> but I just sent the patchset to you and stable list. Could you please
>> remove this patch in your queue ?
>
> Now dropped, thanks.  I'll look at your backports after this round of
> stable releases happen in a day or so, thanks.
Okay:) Thank you!
>
> greg k-h
>
