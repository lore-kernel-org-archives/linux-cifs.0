Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDFF24B47
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jan 2024 11:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705664524; cv=none; b=Ml27NLrkEmaUyylI2ZfV+IfCv1Qdk7/P0XBiA7O8piLThZznUpcSyvuuqNQvPDHPiWK5KDxaIlArcV1+p1Rip9CNuZPC25DoMcnB/jQQLY8jDpUVLQ+U75vi5l1iRXdq6Uzv90Iz0eMG1YMrYj4o4cn1hyVWUuQVBJji9u/XrOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705664524; c=relaxed/simple;
	bh=tRHrL6ql5K26Jo+CH41fEB1iRUWkc+qmv65VOM2uhRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y3uf6KMjDWkEIyp7lQRhv3JfTrEoz8vc3XYu4Wko9C6Wp5wSnTYkCp6FsH5bWYIQSAmLP+LXndyVftS/x/oeEzs3tjpdfXVnAzrz4QMAZtPoijZGWSzy80ehtclC9S6fKRyl04+hasfNhZDAWeqdhLTVJ5ozeSVyIGxv8d4TthU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PzllsL9C; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PzllsL9C"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-50e7c6f0487so685955e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 19 Jan 2024 03:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705664521; x=1706269321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRHrL6ql5K26Jo+CH41fEB1iRUWkc+qmv65VOM2uhRg=;
        b=PzllsL9CjfzKh5Z1+7o4/O5ZRmXnPuCKaTTdjT/WQS9/rZjwbs60kaJ/vnjjk4yO0N
         /xuKc3nnB2W5PkhA1Y+Cu5/ApRzXMTw/XsCXY8+t4TtHiB5gRbe+VSjb+nhRbMBk12Ng
         nOREkqGpIEhWaAkr0WysNN1O6CkTNZorQhk6Euc+WqQ8cWcdapyo7/YZ6AObzQCoWjcN
         QkO9mvjPcQG7IzZyw8Lv+EcIy2x/dWtmocwySYlPBILDTnJDwXF+1/ehY5uscoPGezog
         u4KVGjK1z0JtgW0MQK1hbw6/pfc9ERmHxKiRnAK0nA8BHwVDBUFG7OJdWRKkmBBOdE4L
         UEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705664521; x=1706269321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tRHrL6ql5K26Jo+CH41fEB1iRUWkc+qmv65VOM2uhRg=;
        b=WNDjRdVJlLxS9E3DqxH9GecdHK7uCLY5d9anjPSw5oN6fnhgIwJznd9m0L3rm5ZE1B
         4GpW4Dswh5BDlu0PnRhYhpjt1albS45aR1IGKAhfsF8eJfwp2soCF62G6AkBlX2K7OCp
         POoSrQ2qZ9d43iRWi1DQLY2KZwyQK0YLrItu3WjnuFhte/18w9iHKSux8hrYzCXdayuX
         UzwJ1U7jGQOMNyC51X2ujdpldrXC0ouIe6ybwxo7/XY1pRYUy52xxy77pwLObOZjXiMw
         BZm7yOC4TqzF21OM00mqR4nk0qfVhYUPsfax36I5He3cW3Ls3RJNFkc6YKHNZSygAfIx
         VAlg==
X-Gm-Message-State: AOJu0YwzfN/zYsgFlSFV05ls7bhHe7DEgGKXxhWIJVUVF1nR/VKoh1sW
	WK5Jtg2Ups4bwzhI6R0LG0+ukOsuKpa9pI6kO4pQyl5ZIL4ZNek597UJbooCPYImCvt6PUHQK/s
	E5+N5+uN62JoJpS49Buh8HA9hreU=
X-Google-Smtp-Source: AGHT+IHOIGLX/1pAqPlKGrKesAHe30ZaorTFQcaJyEF18TCDizUo6QPipht9hfGUYN5Hyi4QFF86VZg4+uQM5dDpU1E=
X-Received: by 2002:a19:914b:0:b0:50e:7e55:1b0c with SMTP id
 y11-20020a19914b000000b0050e7e551b0cmr383372lfj.27.1705664520677; Fri, 19 Jan
 2024 03:42:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtnq1WjAiZ7sLB3uVdFHCxDh=_QEvB=YZfhCvL-SUCsRg@mail.gmail.com>
In-Reply-To: <CAH2r5mtnq1WjAiZ7sLB3uVdFHCxDh=_QEvB=YZfhCvL-SUCsRg@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 19 Jan 2024 17:11:49 +0530
Message-ID: <CANT5p=rj+8TBcF82-rB6F2iGQ6Tje4W1vNU0AQFGfbXg6JC6dQ@mail.gmail.com>
Subject: Re: lightly updated versions of Shyam's recent multichannel patches
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 19, 2024 at 8:35=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> multichannel set of patches from Shyam.
>
> There are three additional patches of his that need more fixup, but
> these eight looked ok (I did minor updates to a few)
>
>
>
> --
> Thanks,
>
> Steve

Please hold off on the following patch till I do some more rounds of testin=
g:
0004-cifs-cifs_pick_channel-should-try-selecting-active-c.patch

Rest looks good.
I'll send these out formally in some time with some additional patches.

--=20
Regards,
Shyam
