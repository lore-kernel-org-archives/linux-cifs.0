Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106E428151E
	for <linux-cifs@vger.kernel.org>; Thu,  9 Oct 2025 23:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760051636; cv=none; b=cQGF1si8xW/0CV8tROOtZxWK1+BwGJBeeuQk9G4TpCQOnBS5iqV4oHd+HOSmmPN2kRMP5NBaW6PDenUY+73mSvkk6YXCAEXctPcl0mLeFuCZfCzXw7uaEBZH4mab36LUoK6SBho6DRt5JJvOB/mc1e7xTchulehjYB/VKY3Yjhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760051636; c=relaxed/simple;
	bh=icD5g3JrakgqAzLdZNgzn4FXNUhgYYqnMP5I70/mOwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xv9eZJNMLD0w8GAWqYB6e+Ai8D3kpdCTKESltkiMdB+49Ya+6l17IwvpCy2WwZkCwxnlYAOxvWMk6ozPBwh5SunWEgsannzstfM7QQgLGnA3ee6CNPsdUgFRRPPT/QXlURgcN5bqpN4rb0ulHAb/ZF4NaZ0Ht7j/h7YN41x8xPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UMDtp2rI; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMDtp2rI"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8738c6fdbe8so19662676d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Oct 2025 16:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760051634; x=1760656434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EoBfUDQUyoBNh4GKZoH0GFg+k3/ZMM7A65pnmU46O/w=;
        b=UMDtp2rIbzSCFqqexny+zJeM80q/xPAUw0PcuzMpBidzRtQzJWWRDL+ruFOprumG7R
         3ek3XbVRthH3BTUk/hG2BF1U0qZ2Jt3jncohf5rh7h5sowxu9p93dJ4F25+QoOXnK1XU
         0yxgmIpPxMTROU4d0wyJwzrkBDhF8aSQh5sM6rH/8XcVTZVD5BjBr93x4xcB4AQdRO1i
         zttjPc5VMNkrTqEWRlCEZx3P5a3PlF5TKsAEhgxNq2e/qbcJXMaVZBoW44GWPtldvGb6
         wJRvbwpDoGstg5vRH5epZOOuaB0iN4GOg/XWzJaHcM38Kjv/8uk8cD1v7IQPXSsAtDX/
         npXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760051634; x=1760656434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EoBfUDQUyoBNh4GKZoH0GFg+k3/ZMM7A65pnmU46O/w=;
        b=K9L7f3B0xXVtOqR8gwAQHNdtmcGOnfOQYVpVicQ1xgvsN2H4kEjgDiAljdOexbnGT6
         5dX2k3SvoHbDnPFdBHFAKZ55KLj8xiBgzVm3gCzA/RelNwCoa5qdCAa+HuQftoeEdy3Y
         dsDs85ydo65asXKzT3cTxBxRDr7Wr3g0O4sZgGO21pR5iNF9Njfmtl2ubJr3CSm70MLL
         kYkZMzXAzpK/B0YJeta3wsJkFvz+eD/MZLBU99MvbldYT2dq3FLtAW0XwFNWgvJgYlQD
         gf9gDPvNCo94n9NU+/ro1XfcEka28aE6REtpuyLSR1tvQ2m8xDNjgqy9kfgLjoVsslNk
         xoXQ==
X-Gm-Message-State: AOJu0YxVSeUqQnXalzo8WHHFNE3bED+pg207y4jk0lvZn8H0sS1x6aFY
	q49H7bDfKvbULTlXedLLdt1fWhyLNB62dxu4fVXBjljxRAE6XTDCRRIucq9vdeL4FXeyeiEnd4A
	UOMyfecMnWd3ls8jAx68sfFOGwJiUqGQ=
X-Gm-Gg: ASbGncvjoSEYDBiILykrBZlQLyGAcj6p8JtokPoFOJuaPAYQYUbGWBGj/YCsfI4bZnC
	yYiStbYjKqfCA7GGVuZ0LtzqnGUoVEI8if0BEqBPieEER3gn1l9g1hiriPIbHqdFyjmmRYu6Kum
	Xs8P0iHhDjEocsImdTjQ6yRyDAmNZUBEu7BpDsFkCp8EVV4LWH4lqhMY5b/1p0mtiCEL3JSRHmg
	/YyVJ7F0s3hOcy34KMpPuNltb1sBnTAFiUlwhnuB15Num3+SSRSfI2tsOdj8NljSxxMVsh+ZFHa
	/iD6SYeP+O+5FskcBjfr7BLJbzgT8LuO6FCV3x3laB6oJnU0svmv9Gqb530aVFFUxsD4Bf+kb2q
	2iWQmTrglG2ZM2Jnfqxi3oiNUM0K+yE5hxSX78uIFpIUBaw==
X-Google-Smtp-Source: AGHT+IEnZybB/pQoR8mg9We79EFOiBBpDNgcNw2U1+RtMh7JiFiYQpflxHEIHvLvGjG3GkqOQfeQC3ZgJpNo++61zSM=
X-Received: by 2002:a05:6214:f0b:b0:765:1642:2ca0 with SMTP id
 6a1803df08f44-87b3a7a16f7mr108786206d6.8.1760051633631; Thu, 09 Oct 2025
 16:13:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muZ8KPXD8-KN+PsAfrhJzJXtR7EdVhtSbS+M5TCvyPEfA@mail.gmail.com>
 <CAH2r5mvsQ6raxt9dMp6YLpjxstr3kiZftmk1ay7QZ3k0PKM6gQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvsQ6raxt9dMp6YLpjxstr3kiZftmk1ay7QZ3k0PKM6gQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Oct 2025 18:13:42 -0500
X-Gm-Features: AS18NWD81tW4TuPQuihR3kU0YaZMJZOOYmVmMTN2oMJTRixSau8SUMzy7027sBU
Message-ID: <CAH2r5ms3EZ-R5QmOYzJb-1jF9Mnc3rL5eKeD2k=tDpLz+o0NAA@mail.gmail.com>
Subject: Re: directory lease patch series
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: CIFS <linux-cifs@vger.kernel.org>, Bharath S M <bharathsm@microsoft.com>, 
	Henrique Carvalho <henrique.carvalho@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Interestingly the overall test run only took 2x longer, so many of the
tests were not affected, but at least 20+ tests were much slower

On Thu, Oct 9, 2025 at 3:45=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> Note that this run is comparing Enzo's patches on mainline from a few day=
s ago, so is missing a few patches in for next (like Paulo's) that might he=
lp perf if included?!
>
> Thanks,
>
> Steve
>
> On Thu, Oct 9, 2025, 1:52=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>>
>> Enzo,
>> Was running tests with your 20 patch directory lease series (with
>> mainline from a few days ago) and noticed a HUGE slowdown in
>> generic/165 (run to Samba) it went from taking 41 seconds, to taking
>> over 31 minutes (and thus timing out).  I also noticed that more than
>> 1/3 of the tests were also running much slower - e.g. test cifs/105
>> went from 4 seconds to 39 seconds (but only from Samba, didn't have
>> this problem to older Windows), generic/014 to Azure was about 50%
>> slower, generic/109 (to Windows) went from 15-->25 seconds,
>> generic/129 to Azure was about 40% slower, generic/138 and 139 and 140
>> (all three to Samba) slowed down as well going from 5 seconds to about
>> 40 seconds when run with the patches, generic/142 (to Samba) went from
>> 5 seconds to 4:46, generic/143 (to Samba) went from 26 seconds to
>> 5:06, generic/144 (to Samba) went from 5 seconds to 41 seconds.
>> Similarly tests generic/145, 147, 148, 149, 150, 151, 153, 155 (to
>> Samba) were about 20x slower run with Enzo's patches
>>
>> Do you notice this perf degradation?
>> --
>> Thanks,
>>
>> Steve



--=20
Thanks,

Steve
