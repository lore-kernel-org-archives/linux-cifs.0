Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFEC1C93C2;
	Thu, 22 Aug 2024 11:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327365; cv=none; b=pqx/LUUqSbiY8s3MaZJmZru91zpFd2o27rOzNhQK4LcSkAlqJyrMCW9bKxNOM4iM27J4zWAjyVCKC5GBnA7oL0wE/OQlI53kczyghwbwXY68/tYLueu3zUvJJQ7xYPhFcVP9dtBUiZJR9E26+CaAsd5s+8M/Dx0My8MEvQ0pN2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327365; c=relaxed/simple;
	bh=BNDW587YsKY8yEWc4MS0dMtRyPHkvWg4Lcm4rd/463A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TcAWX1rHCJIkeZMq1053FsivMeoZZ28ixp4T4pLevNRjuvwC6ynCs5LKylmlEM0pcX69rdoi017DAolavUt8wSKr/xGb73FM4MvvcQxGBZuw/xfbJZemNPHg7T4ZSsnO+Wn2kzCpynXn6bSYa3yipDwVVbATGnQBA0nANNOET7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=of02kAkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="of02kAkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E49C4AF11;
	Thu, 22 Aug 2024 11:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327365;
	bh=BNDW587YsKY8yEWc4MS0dMtRyPHkvWg4Lcm4rd/463A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=of02kAkviZqNCRUBmEf09FH+VMqFLzK879BPpx36R4UGu2mJ+FlAwOVp60u4SWeZC
	 HGLTXp0MEjuA9g2TJDmuy7vkgdptj93HCqsxkTazQEAZq2PLKCeCYl+XJ8QktCjJyx
	 sLoLFbXejI232CWa8kgxRKs0tTB6jhacOTDjyWMAWO6zakeWJhwSo317Wmh3u5nP2N
	 d3GhXtuIBVxuFqJpFOux60iS3jMjVzxO47rwNlyufjAVXcAJb+va8+S10JPlr8TKRv
	 fOf3cD/0BFSaf2fsulMnzKg3evI3FldbYfolXFSHGHEgjIkItxqjd2ztoWOdSX7c5P
	 N6kEdST1IZkGQ==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f3f68dd44bso8092631fa.3;
        Thu, 22 Aug 2024 04:49:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUT9k76cBUuVp7g+NdUfwdzmczREwn0pnMui8oreeg1W6RF3Ge8ElFj8w5Pad7ZJPHX1neTsjXs5N+sEont@vger.kernel.org, AJvYcCV+NFMQNbSu0HIPb6N1isutTPse7ZOAOQIytwEEPgfW+Zu3J6kFn1ui7fRxXMMOvJv5rO5Rp6/g+T45@vger.kernel.org
X-Gm-Message-State: AOJu0YzGF9jT3BhYYTwbOI5rZGDf8T5Ywn+9snZBwKLqSZK+l5epoW3R
	n1egrVxxrQP/+rjsgFUsUQhVkL6MLl/ULpnLtbVl30D6rY084FuGdly0KKDozg4mMRaoCBVj/1K
	u5enycnzWx6jzraGnAHY6ZJtjpJQ=
X-Google-Smtp-Source: AGHT+IGwen32aS5EywGVk9YnSJNvbxHeOvQClmf5wptAQTs/ji/re7JOYG2qkqd2whk55UYEDGCsZ/gsz3FB+JuCjvk=
X-Received: by 2002:a05:651c:3c8:b0:2f3:d00f:24ea with SMTP id
 38308e7fff4ca-2f3f887b30dmr27501681fa.21.1724327363344; Thu, 22 Aug 2024
 04:49:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-2-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:49:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_BNAB+1UNFQMGD1vs7oxBtBb_Ck6tussPOrCrUvXtNDA@mail.gmail.com>
Message-ID: <CAKYAXd_BNAB+1UNFQMGD1vs7oxBtBb_Ck6tussPOrCrUvXtNDA@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb/server: fix return value of smb2_open()
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 5:22=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> In most error cases, error code is not returned in smb2_open(),
> __process_request() will not print error message.
>
> Fix this by returning the correct value at the end of smb2_open().
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks.
