Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABD08248D
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713200060; cv=none; b=eMn4Gaqv2xKV1ywDgEKoiAM4c041V3xKxCs59JiRa088i3eNyBGEGRpYsbGuRf6ykHzDodKkMGTKJr6VymSMlatPkF55LcYDsND7HqYRDarLUn9jtIVRJ/We5SW0Ubrt5pddi7kFYoZjzU8L21QGPzspoe3GZ9VXr5X2+8LxmC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713200060; c=relaxed/simple;
	bh=gJDsfleUrDlmu0AvLW57nDmEL5JJn6qndmMcXUjfhbE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Eg0AWvYRp97OnYFAp2MA+rJzEJ+EoH5C8Q8aO/oTI52znLvGDAQ3tP/hRUxzpPfYkFES+4gcJP/CeT/L1nFuooTGxcObC0m+lyHjIm2o1AsOmQquFWX7zI0GRlaYBiuUojo4NApmLYiJ6IT3p6rfcxfZP6e+YTDYNDqLyJHH3Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1m55Y6l; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1m55Y6l"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d48d75ab70so48672281fa.0
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 09:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713200056; x=1713804856; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WCkGk/wyeJPxvX4GPCPt5k2Ckw/YjVz9eWkCKVmg0Es=;
        b=F1m55Y6lI9wivl/vz/7/rbHxRpRwY2cAXL/rGHkRzIbfPqD12WqgBBja980ZuGWA/S
         +fHtbIG6BTWM0TIy2t4oQtXtaiSgVsSRnDnuHEZ4K4a+Wa8yvMsXMRy9VN3rCEziUjNx
         vK3lsHfO5aPcYxwyFCl/gfttZ0zlJB3QrlLIMIYbGP6wqdKx8tjX55NEa8HGtKn4p3xw
         +qiij3XdOTkYST1a4GWiXmaiK6O+DMwr8E66Q1ydB2j6DVXy0wuLLW1UeWUuiQMLXSBb
         zW4Yh14UfzMrjbJuI0cxqepCh5SLhhLriZxW5PzyzcCgDkXQ9gYRG9ZRwbkEuZUx6/3j
         WLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713200056; x=1713804856;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WCkGk/wyeJPxvX4GPCPt5k2Ckw/YjVz9eWkCKVmg0Es=;
        b=nKybd92VQ9pdleBBaFusnWi/FfXhsJ9/e2yT/uGl5LC5mRlytHGtVa4RLoKUBdWY0B
         2rPs2DaNwS5cEATTQhKfkBPqu5P6U0sK8uCqvdk6CiFLhxFjFJgdOForKhooTEC0mTsr
         D8RatSBKz86S/+g19dmYyilgc2GTZuyp7QL83zdtJwha3U+ks31ngchP492xsAUdhAkJ
         jwTAsQCnZjVzZwpR8+8pvCFGeSgFpwPTvEDo+Z1Faxmt8ZtvILfEQ1qImufOwwU3fxKA
         sVPHF4jODkqjokGcw3Y/H6H0ymgfTFq4qJKplUBLZI6nBz57lNzYuokASVFxKBVKAymo
         JP1A==
X-Forwarded-Encrypted: i=1; AJvYcCUWyA9TP3ahSp2YmTuxuSfYo8Yacz57c7pCzlzgF1PbHpQr8KVniNqCpJwudcixPFINaa+snsBoqK3xe89whV8jb0StodW65rxrtg==
X-Gm-Message-State: AOJu0YxUAsWWcJ2BUuqxPNZCP4cchHh4o9yqJc7Fs9yAo/m19sVFrIVc
	RRqdpY39JnkJVc9efOADwSu1yWSZxlKV8qwuznwwNQXzuGCv8SS3p4tMeyZhacHy0wqbg0/LI+f
	xLo4EmNtyhIMiMpZwlQaY3A3a+etxn3ks
X-Google-Smtp-Source: AGHT+IE3mnc1QgRI8s4hmIaW7FSoRefXUw9LoIh/n0ONRWa5C48H8mvN0QPp2+WdS7LYC2EMhJ3uKAdWZ5qmC697rCA=
X-Received: by 2002:a05:651c:10ba:b0:2d6:db84:5e93 with SMTP id
 k26-20020a05651c10ba00b002d6db845e93mr5508160ljn.47.1713200056351; Mon, 15
 Apr 2024 09:54:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 15 Apr 2024 11:54:04 -0500
Message-ID: <CAH2r5ms7EWvNFVJ7_D7QXWOyj+oViKDJD2EuoY3n=w1c5wLTKQ@mail.gmail.com>
Subject: current ksmbd
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

We are up to 221 fstests run vs. ksmbd, and buildbot tests pass with
current ksmb (this is with 6.9-rc4):
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/10/builds/52

There are lots of minor features (and some fixes) that should be able
to be doable to increase this number even more.

Note that Samba passes some tests that are skipped when run to ksmbd
that should be investigated:
e.g. generic/022 ("xfs_io fcollapse") and generic/351 ("xfs_io
fsinsert") and also generic/021 and 031 ("fallocate: Invalid argument)
and generic/525 ("pread: invalid argument") and generic/568 (which
looks like fallocate bug)

Samba fails two tests that pass to ksmbd generic/286 ("create sparse
file failed") and generic/591 (splice test) that also should be
investigated.


-- 
Thanks,

Steve
