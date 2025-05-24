Received: from rx2.rx-server.de (rx2.rx-server.de [176.96.139.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C38238F91
	for <linux-cifs@vger.kernel.org>; Sat, 24 May 2025 21:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.96.139.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748123833; cv=none; b=TVjLdTP35Bb0dTNcRS30SofVSlphBCxEtfywpO4tggd8hsxXfRofEmkvwGPn93kDf2z7haTKni8bsl9cmIu7ueRIAhKe1adcQ8qdIQ0n/EChH8YxSMM/TBTQjfWNMT1GG5cThL+wbFgjbsox850WQn8Ba91Lk+m167GtXM6UQqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748123833; c=relaxed/simple;
	bh=6S8HVkDy/Hy48JZuWKtuz+8N7CCZW20ipKfyu7IUO9w=;
	h=Message-Id:Subject:From:To:Date:Content-Type:MIME-Version; b=tiG/Os16w725CD+M8wH/OjfGmWOpuTJdsPtYppUjCKrLDTI/SR8eYwGmzGhCalREkkRaXZ3yzfSIfjXoUOaSivl0qqzcLMx7q9DoxuQjdneMbnJOsfJQVs3zV+5I9mYNnqjn4XPVASdYpc1hrV1QFbQNS0h2rTdGFsydd1htYII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org; spf=pass smtp.mailfrom=casix.org; dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b=u6KGlz9e; arc=none smtp.client-ip=176.96.139.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=casix.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b="u6KGlz9e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casix.org; s=rx2;
	t=1748123262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ukIIzOS2lBTFJ3rGana2HJU7jAsN0oW6KE0Zmp6fmNM=;
	b=u6KGlz9erS8LBU6CQ4ktvHaXlwU37gbx8WURwlAHVdtp6XpzMmCSr59cCWlRQ3rRPydjSy
	FBxCX6ROuwDyV2q2mTvnYfKS3BJyXPn/FtJOqMF89iFgirY9pYtTjecjSk0HUJWdVRU+oP
	53gS27pX3BU0zj0zzKz+bpBoaJqsLhSKnkuehWjOdW63fAbqPOZEjmTfwrF1SOTdTNm9S7
	LnVHymLk51p3m2L5Fr5Fj9CHr6O2vam8NvJLrsPiD1Y24LixtoumNtFR+wfgBxwaVGt6zP
	T7vrlFW+ZDIp7YcQwN8v0tcWgc+9ih9sJJpi+C/KgVsTPFG9GtCMOlnQxR9dTA==
Message-Id: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
Subject: ksmbd and special characters in file names
From: Philipp Kerling <pkerling@casix.org>
To: linux-cifs@vger.kernel.org
Date: Sat, 24 May 2025 23:47:41 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

I've been reading a lot about the SAMBA 3.1.1 POSIX extensions and had
(perhaps wrongly?) hoped that they would allow native support for all
file names valid in POSIX if the server and client agree, so I could
continue to access my files that contain colons or quotes as I did
using nfs. I know there are remapping options for the reserved
characters, but they are very annoying to use if you want to have
direct access to the files on the server machine as well or want to
serve a directory that already exists and has "problematic" file names.

I have been playing with this on Linux 6.14.6 with ksmbd as server and
Linux cifs as client. Unfortunately, I was not able to access any
file/folder containing, for example, a double quote character ("). From
what I can tell in the logs, this is due to ksmbd validating the name
and failing:

   May 24 22:25:15 takaishi kernel: ksmbd: converted name =3D Jazz/SOIL&"PI=
MP" SESSIONS                                 =20
   May 24 22:25:15 takaishi kernel: ksmbd: File name validation failed: 0x2=
2        =20

This seems to be an explicit and intentional check for various
characters including ?"<>|* [1]. If not for that check, I could access
my files just fine (mounting with -o nomapposix of course). I've
patched it out locally to test and it's working great. Even smbclient
and gvfs are happy with it. Is this something that would make sense
(even if only as an option), or are there other restrictions/security
concerns in the SMB protocol that prevent having the special characters
be treated as valid?

Best regards
Philipp

[1] https://elixir.bootlin.com/linux/v6.15-rc7/source/fs/smb/server/misc.c#=
L80-L84
