Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4D21D7E4A
	for <linux-cifs@vger.kernel.org>; Tue,  3 Jun 2025 10:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748948121; cv=none; b=u8oJCdITwJnSqAs+syC4XZ6A1v6UJN89o1pH3GVhb4cBaqnmijidxs7EVbRfl34UH/33DubUVHOUzXqyGsX26qTnS6QgGnz/HWOKZd1h9hXcIeWdxPLVgajbpB3BlZj88rqgl+JNpNw26OcyALap9D8ZSh+XrNIb5JsU6NV5vxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748948121; c=relaxed/simple;
	bh=zFpFdiXPa8Ywzn0rrAw8EyRZuRpVSKRFjceGthIEdxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=orkkf6AeTQeF+ydv4mwLlnB4CCk7o9CX7h7mhPmjs2NP8fBQ1hmKMhqsY+le2XyGHsYZBp8UPVaGSn+Zhh4WlnqeDkphQaJ0a4YiGCkwkfLY4dLT4SsQK2+qJgjvvhNmS/QvEzbOJ+Ufd5g7ztAR1R9g2s92S9Jt+IgkIrPnWGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlVikvJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlVikvJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017B7C4AF09
	for <linux-cifs@vger.kernel.org>; Tue,  3 Jun 2025 10:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748948121;
	bh=zFpFdiXPa8Ywzn0rrAw8EyRZuRpVSKRFjceGthIEdxg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QlVikvJBnDL0zl76Op6HGPujQwAPxUgCUPQBVEtDy9eLOqFv2GRCc07rGnPb/Oyb7
	 1SU5ZGGhwbX4hjESYbEoIjN6jgR84LnBdyDuihkEjqRtH1MWb/sQ9ct87aqCbiqLRW
	 rDC02GXr6IcQ76AV5g3jNiZ0LG4ejc+Q/s9leN5BTPSsYxeEgzWMTv7Wu1ydCSge40
	 R3KfXVWu0NCKTkPhLJ5i/32R4vm15TxXZsuHao49Au9uiy3hXsmL72hgJVvK7mYlQO
	 iMcPAU2jxDTI/Jvd3PaPsErA74q1vkQOiBRIcJaeczgpC8b/4WJzBKVDWXMuiyYc1k
	 ePAmQstw8jzwQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ad8826c05f2so969764366b.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Jun 2025 03:55:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW/9sORPzFMTSqjJ6EmKRJyowhozXJjzsxVMkb/7Vd8lQ7ekq1T9P+HWoYu6ARYmSsxUh49w3+u2Cos@vger.kernel.org
X-Gm-Message-State: AOJu0YwumKnM7pUh42lnRszs7VBlxUmzHm4bhr3OK1w7BeSVBPCIbht2
	NZukarO4M2yQ89r7gXHVv/Mp7DWlmHgl4NrJ2LvN9SFw3PZv5womW9R5ldBxZYCZNMSi3AQV337
	SiuBQPeD3iLjHQ+BBQ5W09Fxs1ByI0U8=
X-Google-Smtp-Source: AGHT+IEojaa2DQEOCIUZcRc7rI77r5EK6ofSlUiyoucP1p4NPZKiQTTTrvmEqQhNNA6FsUZPFzBO5KzuqIZaAhltAtI=
X-Received: by 2002:a17:907:2dac:b0:ad8:a329:b490 with SMTP id
 a640c23a62f3a-adb36b2447fmr1477054766b.23.1748948119509; Tue, 03 Jun 2025
 03:55:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1748446473.git.metze@samba.org> <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
 <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com>
 <096f20e9-3e59-4e80-8eeb-8a51f214c6f1@samba.org> <CAKYAXd86mLGAaAEUFcp1Vv+6p2O3MSJcwoor8MmjEypUo+Ofrg@mail.gmail.com>
 <CAH2r5mvQbL_R9wrFRHF9_3XwM3e-=2vK=i1uaSCk37-FZmJq9g@mail.gmail.com>
 <CAKYAXd9T81En40i3OigiTAmJabMr8yuCX9E1LT_JfaTmyefTag@mail.gmail.com>
 <CAH2r5mso54sXPcoJWDSU4E--XMH44wFY-cdww6_6yx5CxrFtdg@mail.gmail.com>
 <CAKYAXd_BVHPA8Jj6mtc_nsbby1HizZFEmCft20B_wcTM3pDUVg@mail.gmail.com>
 <CAH2r5mvygcy0-WwZNu6NvjXGrMtB5ZFLK7_w0rc6rVpaVDeBxA@mail.gmail.com>
 <CAKYAXd-4-WRw9bL-shqELhMO70fyznmeh0HByA=pyOcccu3sgg@mail.gmail.com>
 <5d0f7f91-8726-4707-abd4-c1898c8ba65c@samba.org> <CAKYAXd9h8LpaOX9JA5Mdduw1CQ4RnYFgkU9dXf6NnNbTFYFJ8g@mail.gmail.com>
 <995fde08-3fed-47a0-b984-876f426e9076@samba.org>
In-Reply-To: <995fde08-3fed-47a0-b984-876f426e9076@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 3 Jun 2025 19:55:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8=Y97yZXHibR1hi5ZY0eD3cH32zkBHr0FTZG9a7tzoBQ@mail.gmail.com>
X-Gm-Features: AX0GCFuYZv24EL25zpkOsc1U_OuGmCFB8YA55JPScxCuHJlsN6ueveMd4LwN0-o
Message-ID: <CAKYAXd8=Y97yZXHibR1hi5ZY0eD3cH32zkBHr0FTZG9a7tzoBQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

[snip]
> >>> He can just put these changes in his own queue and work on them.
> >>> I am pointing out why he is trying to put unfinished things in the public queue.
> >>
> >> Because I want to base the next steps on something that is already accepted.
> >>
> >> I really don't want to work on it for weeks and then some review will void
> >> that work completely and I can start again.
> > It was too tiny a step and unclear.
> > i.e. the patch description should not have comments like "It will be
> > used in the next commits..."
>
> What should it say if something is introduced but not yet used?
>
> I mean I could explain in more detail how it will be used in
> the next commits?
It should be added when it is used. If it is not used, it does not
need to be added now.
>
> >>> If You want to apply it, Please do it only on cifs.ko. When it is
> >>> properly implemented, I want to apply it to ksmbd.
> >>
> >> I can keep the ksmbd patches rebased on top and send them again
> >> each time to get more feedback.
> >>
> >> Would that work for you?
> > Okay, Please re-include the ksmbd patches in the next patch-set and I
> > will check them.
> >>
> >> The key for me is discuss patches first and have them reviewed early
> >> so that the following work rely on. Any the tiny steps should
> >> make it possible to do easy review and make it possible to test each
> >> tiny step.
> > Okay. I agreed. But It should not be too tiny.
> > As I said above, please don't send it in pieces that I can understand
> > by looking at the next commits.
>
> I'll try to keep them tiny they can always be squashed later,
> but splitting them again would be a pain.
I am sorry, there was a misunderstanding.
What I mean is not that each patch is too tiny, but that the entire
patch-set is small.
So It is not clearly concluded in the patch-set and I have to wait for
the next commits to understand it.
>
> You can apply them and do a diff over multiple patches
> and tell me which commits I should squash.
Okay. Let me check them on the next patch-set.
Thanks!
>
> Thanks!
> metze
