Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556763B9618
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 23:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716057; cv=none; b=n12RZqgNoWmSs9JKQoQGPYVGKtFSz5w+JSX1+xQNlGbxFY9JSHVDPO8bHQQ01FJfP/a6nH9vrnGynPBxF2cHLKG4j2MyUCWV9/8nrYpMncM9KJqaiv3DhH1bEe5g0n7MP80oA1CNeo/8lzPmOEsK+cwL7KIyMuCNl2JVKffHAro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716057; c=relaxed/simple;
	bh=6czxAn1n4hAAYHtaFNQSj/x87tjmr9NCpZlQXqiJ7yE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qcd7GOuQzUnFqerrukCuVXGI6f3SL2ZiHsLzdjRpB/VnQ4FihorOLgcDys6ju0n2mNQNDsjoU3jso0N5XOw7BpGu3VSDn+wg19axSRdIUSB+JX2YuF8jt2rFFAVNU+/vEK4ryGeXG+yVv+3MmxpS/VfU8bTgPNWMnwPFub/EU5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbEHo1zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbEHo1zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17F9C2BCC7
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 23:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778716057;
	bh=6czxAn1n4hAAYHtaFNQSj/x87tjmr9NCpZlQXqiJ7yE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kbEHo1zfBEXMQRdedThlqlCKGRIzwAw5Y4iTzsQLsehLAFT0NhCKqKXXvoECbD8BI
	 McJgUNhfvu//+1E7Hq3RGVxdxJQ0sqBeJz+ws1gjhH6gePSOGyquP26zHr6QAeGEzX
	 bQ9VxdMFrx0ZbvUs1xdFSYZxyzobi1cFuk9Quh0INxWDrhmtHK2Zo+/yoZgE9ppb1P
	 TxXhlahmaJbVGcFlGg9mNnbSvI8pCAkj7t/GDI/BwkSFXGDrUC6wEhj+A5cXiJhWQN
	 NS+W9PFkrvZuDQxwxnuCwhZfGZRT7+WZEFUby+AlBjIRM+JcakF7TCnjVtdJ9GJfUB
	 mJ7DpvPf6x+bQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67bc8609a9bso13385515a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 16:47:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/NVsh/9GCZYn4eU/SAQI9PKLZMKLZaEAeP0LNyxIWEn9QLfPIUqImQkQBbINJgT4WyX5lYzT6ukOHp@vger.kernel.org
X-Gm-Message-State: AOJu0YytzYAd20CSyjC5e5wfWd4fvDQ3zSghJWBg4xejd0zHWVwEz+zL
	oMR62S1ahsXMRRqipfc4l7BFssQRdYCSfirPFM1e9A0qk/jhIoADHoh8MPXgvD1nmbQoSYA8g07
	8bfnEBWti2GMDQFWIaFxG/M7mdaI7K0c=
X-Received: by 2002:a17:907:3c8e:b0:bca:a09:9212 with SMTP id
 a640c23a62f3a-bd3c183bee6mr355634566b.45.1778716055554; Wed, 13 May 2026
 16:47:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvP9s_KMc2G-_AsP__G0S5JCmrigOT-7U_ZNu1pLf+Q2g@mail.gmail.com>
 <CAKYAXd-8VmgLNX=0TnsPL1LP2u-V-zOs+Z08dKHDZUbt+q2AAw@mail.gmail.com> <b5400da0-b60e-4bed-87a6-92b1b009c2dd@chenxiaosong.com>
In-Reply-To: <b5400da0-b60e-4bed-87a6-92b1b009c2dd@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 14 May 2026 08:47:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9-gUkGspfZyv_LEBjST4CChB-ffk8BbOfGzK+FSEhF9Q@mail.gmail.com>
X-Gm-Features: AVHnY4LZQYHf0wUIN1cLT1HKtKERwGBvF--tNgaM4f9gb6fxcV0ffBpgZsu35QY
Message-ID: <CAKYAXd9-gUkGspfZyv_LEBjST4CChB-ffk8BbOfGzK+FSEhF9Q@mail.gmail.com>
Subject: Re: generic/004 server bug
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Steve French <smfrench@gmail.com>, Huiwen He <hehuiwen@kylinos.cn>, 
	Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 1:54=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> I am currently debugging this issue:
> https://chenxiaosong.com/en/smb-xfstests-generic-004.html
Sound great!
>
> My team member Huiwen He <hehuiwen@kylinos.cn> will continue my work.
Really appreciate your work on this!
