Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617F45F859
	for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2024 23:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710805457; cv=none; b=BF/FCCYJH7Mh0jiNH3b7fENuWDJzEJNM0hJy+UvK8tIbXuFNgcYSmRChTj4mVcMHo4bWvXHVbNjN4KHUloamBzDUcqRi+abyWP+Mx7RsejQpE2LCmi4aIXs+zaz1SpsRwjCxJDbKiop7hP19mrLOU7kgoXLmljEg5MurW13zSMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710805457; c=relaxed/simple;
	bh=c3q63boFNO8z+dPo6uS13jGdHk0nSzZZ32OknKhMy/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oNgkXucgKL6+6aq3dLGJ2qREhQRU+8nMRxgvPACpbqhN1MkcPNeOZnEECG2k3MtmDDtN6dz7OC/GBaUIxGrpFXSn6jKwenZwXz9jkccjEC50zoomT2H+tNn6uuMwcC7klytjjAc1eP1SxmVD+UqBiuUw4MrpvsVMDxG/tiIas2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYMQBWI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYMQBWI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6384C43390
	for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2024 23:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710805456;
	bh=c3q63boFNO8z+dPo6uS13jGdHk0nSzZZ32OknKhMy/4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fYMQBWI1Eapy4s0iqX/Ss+n5+s/6EKnYl9RVjxoBdCHjZ3dWBMVQaRC145vvZ6Wmw
	 xU7AkSpcymrY9utprGsusXRETu2aoHfA2HLcCBJFtq1k/udqftwKXDfUnXNUrrhIYS
	 kFT7zQ9UuFZZV2754Onp/OgiyKowAg9SU36tXkuyXEv4r194rd4Jjnaef4dRIjq5iV
	 m3HGJIBTicmyCL5wgx7WgTo8HfuaP+B0JYkqwK87Z3VnspHnOk0u1fpVo/k/BAQMCc
	 xeLgTWc3LR2peFbqoa5r03Y+VIs38crOHq+8nix1boZkICqGKahCYBIK9Crm7ZrhXb
	 jvh3fznFnBQMA==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-222a7703048so1260806fac.1
        for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2024 16:44:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YxwKazhGo83ZUouQT/EX4N3Nj00RIGgDfzXwlxBJVrlRqSc/vNI
	lID2JyKCgc4/9kcL8zPBbPVv+OlggE7NiR0Qkk4OjK+GOYBbFyfw/7TznOzF8FyWPpf3pzIqnA3
	BhtTFIdFZ4gFaxXTc/v3EuIaLbvA=
X-Google-Smtp-Source: AGHT+IEe16Gd6BXepjO3+OyKCfKwGAEvm7blRKUj5yat/IdDzvDW4N5Ng5em+33el3F/S63aZMn30TVwGyHOOGKSQO0=
X-Received: by 2002:a05:6871:a913:b0:21e:8cc7:c7c8 with SMTP id
 wn19-20020a056871a91300b0021e8cc7c7c8mr13311871oab.37.1710805456285; Mon, 18
 Mar 2024 16:44:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5ms5C=G+J8GAU1SvPLniDpxzfiP+f8AFpx5RB+zQKyX+Vg@mail.gmail.com>
In-Reply-To: <CAH2r5ms5C=G+J8GAU1SvPLniDpxzfiP+f8AFpx5RB+zQKyX+Vg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 19 Mar 2024 08:44:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-gQ338LZbzb2kZJpnZodaTPmu=Hu4O3OwjR0-SRtVyug@mail.gmail.com>
Message-ID: <CAKYAXd-gQ338LZbzb2kZJpnZodaTPmu=Hu4O3OwjR0-SRtVyug@mail.gmail.com>
Subject: Re: git function test 0003
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Okay, I will check it.

Thanks.

2024=EB=85=84 3=EC=9B=94 19=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 4:52, S=
teve French <smfrench@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> I noticed that git functional test 0003 fails to ksmbd (but works to
> Windows).  We run it with "idsfromsid,modefromsid" mount options.  Any
> ideas?
>
> The test is:
>
> cd /data/git-2.44.0/t
> t0003-attributes.sh -i --root=3D$TEST_DIR/$$
>
> expected output is:
>
> QA output created by git 0003
> ok 1 - open-quoted pathname
> ok 2 - setup
> ok 3 - setup branches
> ok 4 - command line checks
> ok 5 - attribute test
> ok 6 - attribute matching is case sensitive when core.ignorecase=3D0
> ok 7 - attribute matching is case insensitive when core.ignorecase=3D1
> ok 8 - additional case insensitivity tests
> ok 9 - unnormalized paths
> ok 10 - relative paths
> ok 11 - prefixes are not confused with leading directories
> ok 12 - core.attributesfile
> ok 13 - attribute test: read paths from stdin
> ok 14 - setup --all option
> ok 15 - attribute test: --all option
> ok 16 - attribute test: --cached option
> ok 17 - root subdir attribute test
> ok 18 - negative patterns
> ok 19 - patterns starting with exclamation
> ok 20 - "**" test
> ok 21 - "**" with no slashes test
> ok 22 - using --git-dir and --work-tree
> ok 23 - using --source
> ok 24 - setup bare
> ok 25 - bare repository: check that .gitattribute is ignored
> ok 26 - --attr-source is bad
> ok 27 - attr.tree when HEAD is unborn
> ok 28 - bad attr source defaults to reading .gitattributes file
> ok 29 - bare repo defaults to reading .gitattributes from HEAD
> ok 30 - precedence of --attr-source, GIT_ATTR_SOURCE, then attr.tree
> ok 31 - bare repository: with --source
> ok 32 - bare repository: check that --cached honors index
> ok 33 - bare repository: test info/attributes
> ok 34 - binary macro expanded by -a
> ok 35 - query binary macro directly
> ok 36 - set up symlink tests
> ok 37 - symlinks respected in core.attributesFile
> ok 38 - symlinks respected in info/attributes
> ok 39 - symlinks not respected in-tree
> ok 40 - large attributes line ignored in tree
> ok 41 - large attributes line ignores trailing content in tree
> ok 42 # skip large attributes file ignored in tree (missing EXPENSIVE)
> ok 43 - large attributes line ignored in index
> ok 44 - large attributes line ignores trailing content in index
> ok 45 # skip large attributes file ignored in index (missing EXPENSIVE)
> ok 46 - builtin object mode attributes work (dir and regular paths)
> ok 47 - builtin object mode attributes work (executable)
> ok 48 - builtin object mode attributes work (symlinks)
> ok 49 - native object mode attributes work with --cached
> ok 50 - check object mode attributes work for submodules
> ok 51 - we do not allow user defined builtin_* attributes
> ok 52 - user defined builtin_objectmode values are ignored
> # passed all 52 test(s)
> 1..52
>
> --
> Thanks,
>
> Steve
