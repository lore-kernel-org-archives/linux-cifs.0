Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DD511707
	for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2024 19:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710791560; cv=none; b=iyYFtrr8DJWvEriXHtRM7NNL8id+IAbdE+V1ZSp6L2JZgFrNBHrEtCXasZMyzmTLCg1jfZkJwbecM+ZAJtd0VQEydv05cDNFjssagIqoWswA5/gVpwXEzkgOQzD306o3h6VcHIQMzsc7lJlmVMLT+/UeGfC+YQ+RFYndghMNuSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710791560; c=relaxed/simple;
	bh=geH2XtzljuCmn92eG+bgwN8e/qDV1IAPiJPVk/r91sw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=awOo20xQPnD5XJUMpI22v9o0H9Iy3hpqwdpKYR16hLpgyO1Hr5+PLfCGnQVE5eJjd8kInEUUYCfPDc5levDpgKVbthkmMDAJoYcSStUfoHcshuvbEWDuj/QyGrsyHB3TWbVa/la8D9mNBz5vuBRMvHkF50fPqqDohThDNUmRJ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YMN/EGHM; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMN/EGHM"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-513e134f73aso2232056e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2024 12:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710791557; x=1711396357; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hr+9Dfi/FTLuN/sdJVeahFuZEXXwnhMMstly3SY5k6c=;
        b=YMN/EGHMVurOoqcEwAiLCIuqEZn4QkINK10FsEIL9593sz6VtUG7bEbhjyApfaRCvN
         1vCCwVkfDVb3yraHqFSLiPGkPorgFrJuIcfZXVJDDSyOM8KAytFtgk8HadbbMUbiXxI9
         eKXSpf5lFgl7r0J84Aa5ziSfUxD6kfjCcm8uvCIXCA38eJVyWjyUp2q3F6dcypfegCdu
         MG+ywsJ7Q/NezwqQb51qLRhqkxrbuH2/GJTzV2VLLDDLBtKQWd9xPtLc07519Qql4Hi6
         DAE9VwfkedFBfBz6FhOu+cqUKv2O30GUvG+AtIYqQxB9QYvlhNgF4OLEGLVdnF1V4//q
         LcgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710791557; x=1711396357;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hr+9Dfi/FTLuN/sdJVeahFuZEXXwnhMMstly3SY5k6c=;
        b=bAjL/xbKn8WuwN94Op9t/GB1HaLPpJRCKdvP7TfdLql5cWsXDHd4qCsKxIsFeKMfYq
         sutNo+TuKBrKApue3pRG0S2anhMqKC7lylW946bC3A9COPb3gw9IiAWciTVLinyzB5gu
         jzakKnQ/y7Kl2ZtRqUVhMxT5rxNo0+6BnFRQacSf1BTtjWt5Gpn0+pUieP/sR4oZgxd2
         31IU2e6VBMIOEmEXxIzkuO97Idc5eHH07Cf9dOngJlTwbvIuGLxvoYmAhfNikYvaoqXo
         Xw6cGzlxx4ADId3SqhCs1gQ60H5B6PVedPempdvOHzjoXg3f9y+odGDScelBTDf0YkkX
         Rg6A==
X-Gm-Message-State: AOJu0YwuNieeYMYkEf0gJHdJ43SqtrMiGyHB7foSJimCNrQKQvijmG4S
	UECTtfoUUASjIT9+YAW7SryVB1fhG5Uzo8jRO9o/BqRyGigvtpDBFs0SFkp2+OsQbZY/yCcvuOl
	qhvW36qBZ5DgMYZCyMk7O8mrshF6wuucY7XJ9+w==
X-Google-Smtp-Source: AGHT+IGJKErgI5v7m01W2xfQ61smZkPuLWNQdPcwEQ6xm5KB3COCI5eO8/aOTOehf4VRR6rk1hAvl11k+45/cInu8iY=
X-Received: by 2002:a19:9116:0:b0:513:4764:2fa5 with SMTP id
 t22-20020a199116000000b0051347642fa5mr347189lfd.41.1710791556343; Mon, 18 Mar
 2024 12:52:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Mar 2024 14:52:24 -0500
Message-ID: <CAH2r5ms5C=G+J8GAU1SvPLniDpxzfiP+f8AFpx5RB+zQKyX+Vg@mail.gmail.com>
Subject: git function test 0003
To: CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

I noticed that git functional test 0003 fails to ksmbd (but works to
Windows).  We run it with "idsfromsid,modefromsid" mount options.  Any
ideas?

The test is:

cd /data/git-2.44.0/t
t0003-attributes.sh -i --root=$TEST_DIR/$$

expected output is:

QA output created by git 0003
ok 1 - open-quoted pathname
ok 2 - setup
ok 3 - setup branches
ok 4 - command line checks
ok 5 - attribute test
ok 6 - attribute matching is case sensitive when core.ignorecase=0
ok 7 - attribute matching is case insensitive when core.ignorecase=1
ok 8 - additional case insensitivity tests
ok 9 - unnormalized paths
ok 10 - relative paths
ok 11 - prefixes are not confused with leading directories
ok 12 - core.attributesfile
ok 13 - attribute test: read paths from stdin
ok 14 - setup --all option
ok 15 - attribute test: --all option
ok 16 - attribute test: --cached option
ok 17 - root subdir attribute test
ok 18 - negative patterns
ok 19 - patterns starting with exclamation
ok 20 - "**" test
ok 21 - "**" with no slashes test
ok 22 - using --git-dir and --work-tree
ok 23 - using --source
ok 24 - setup bare
ok 25 - bare repository: check that .gitattribute is ignored
ok 26 - --attr-source is bad
ok 27 - attr.tree when HEAD is unborn
ok 28 - bad attr source defaults to reading .gitattributes file
ok 29 - bare repo defaults to reading .gitattributes from HEAD
ok 30 - precedence of --attr-source, GIT_ATTR_SOURCE, then attr.tree
ok 31 - bare repository: with --source
ok 32 - bare repository: check that --cached honors index
ok 33 - bare repository: test info/attributes
ok 34 - binary macro expanded by -a
ok 35 - query binary macro directly
ok 36 - set up symlink tests
ok 37 - symlinks respected in core.attributesFile
ok 38 - symlinks respected in info/attributes
ok 39 - symlinks not respected in-tree
ok 40 - large attributes line ignored in tree
ok 41 - large attributes line ignores trailing content in tree
ok 42 # skip large attributes file ignored in tree (missing EXPENSIVE)
ok 43 - large attributes line ignored in index
ok 44 - large attributes line ignores trailing content in index
ok 45 # skip large attributes file ignored in index (missing EXPENSIVE)
ok 46 - builtin object mode attributes work (dir and regular paths)
ok 47 - builtin object mode attributes work (executable)
ok 48 - builtin object mode attributes work (symlinks)
ok 49 - native object mode attributes work with --cached
ok 50 - check object mode attributes work for submodules
ok 51 - we do not allow user defined builtin_* attributes
ok 52 - user defined builtin_objectmode values are ignored
# passed all 52 test(s)
1..52

-- 
Thanks,

Steve
