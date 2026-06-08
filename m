Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B293A1695
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 21:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954810; cv=pass; b=RWtWomNTkNC+R9fhsDcTwttfv3Ar8c3u1NNuXI9F08LBCMDxKwcefa6AgURgkUMpaGKV2hqUG6BVksOktCZCcPRWqZOrIkwS8l/9jvCC9l7L+KYS+pFto2e5G26vLxervyj3ngsyO6dJxqL6jCGJ+3jMUBFpdi6ITFegghbrwdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954810; c=relaxed/simple;
	bh=eXPOqhvCB8sDApV+IJwGbGgn3XGK/lGo0LZgZyQxA38=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=aq1wnZhMOTS2nQPECPHxUAng8yJD/SEvAM1mr9oYOS94/Ue9bv0yxUHq8n4vacPYKK+dcu2K0zJGfZntNc5Hzl79e8wmxhDCGzMKKin1KfE01kcslV1gh1mMac3BEzcu5vvBRAg7KjvJQhiN1Kar+3uQt8ow3nyTaLiO2a678Ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T81LP10a; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T81LP10a"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8cceaa6f75bso74384046d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jun 2026 14:40:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780954808; cv=none;
        d=google.com; s=arc-20240605;
        b=j52ezRaeqeBzMwjBfVPgEyiDRqiHaTNuLCEffYZvCzgqrXIT6HwOBRLdmUmqDh02bJ
         Mo+m3lH+91hDWBmLevHSPaIhR15WYI4sS+qCZtZKEUL+BcKI6EU/s1eklVpLxB4MiJ0e
         f9PzQS3jnOBPdmJdn/1KDFo79lCCR4jkr9twng4c2MVG825EZFu8m8sqfDN881FvZhcv
         pYwBqJGL/gRVINBw9M2exFQBzdr1ceueCIoKn5qR6zjOAlOCNUT6Y/Z0jiJgiLUXk5JW
         IlaecMDvb/wnmN2cFQqYe2C75JnI5hgYcJgdaKxKPF4ZyOy/PeiNt+h3lwAgVj7dj9V9
         eduw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=AE5OzQiGRrS9qvr3Ird7fgjoUEoJca1l/BIpU50eMHA=;
        fh=/093C4FnJH2PcQV95rOzCk/LyUP0dKhWHk+s5GvwO1Q=;
        b=MvNMq2WFfkdg5THFdCcWPEpKo8/ixbZAgl74x/HLMKUUfKdVgrilUJmePxnRLltktd
         VGBS4j3ae35pKqHpOAicwkPyOyiMC98U2HjfAWcSvUdliWAzcM9REsxFREq5whFwkD7S
         zH/lB2J8q0oHjI6bHvgozG2pjV2Ucl2Gtb5kiHV7cC3dWdg0m0Gc9OQ82U/VsmBzLHV/
         jqIxmiGcOBLzsRecZfkrAI/5HocbUp0hUEDQP3J3qe4ni0rAKwuQyMPZ4f/1MMG3y6/z
         wN++pWx6CiqtIZcbvnR9rBMPOZrcOaYCMR6UtGOxrztMC9QGPZ23DZA0LFDr4G8Ebz37
         yBXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780954808; x=1781559608; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AE5OzQiGRrS9qvr3Ird7fgjoUEoJca1l/BIpU50eMHA=;
        b=T81LP10arkgN3VC0zMCIH7AMHqPjUgFU1lFFL6vRzPMpqv+R7dNnrvBhlaw6mjpBvp
         otMKUdYo9AuSk209Z/Bwa3SgCnL8roc5S1h1C07VoF15NEPdpcUF9gdtJYNERwsCWzOK
         5hfWehYCZ0tJhTsC/cf1Nfv7OUG6dKLqckZqDL/DQNeK9wCF4QdIC2bUodHyK8P5bSB8
         cYDxqgg+ER4F92Z9N0vb0dawCOhTUwnlrVj/r7ZTTTx6H8sTaPHuvw/au5rst90C+vuC
         CqFJ5pxttMU3pnZ6s1ah6UQX1PiG93uSt02MSRoe/mcmbK4a7xSH+uihcTBg92wFClKo
         2yvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780954808; x=1781559608;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AE5OzQiGRrS9qvr3Ird7fgjoUEoJca1l/BIpU50eMHA=;
        b=pAeFXwym6cVi9RGRdCBLGMu3NVv41mWFOHE34K9YHa5pr0CRUBA2BxFmx4RP9TfrYn
         MUiiSwNt5fQMlRwsB+yyiXvJxEbK7qw9g49sDPhyYeMN4sonljbYMfdMfJXT+Ivj3UF0
         0QLQn/b1nDp8QjJpTU5yMX0wwyHntcE/eEhiuXsgcg/y76/7/VVMAS/MwgtqygpL2fSe
         T9VTbgiQbqADWz0bnrA9TOYTF6Ggt4cm2OsfKnqmNjmHTSVgLPuArmnYwkBvlJLrbKH6
         UJ+CZN4AURtEZM8bebqOZnipk2dLchDTXfcfqu4BKB5+2XoTWIaE32CBkB3NeCFfeDDN
         WV4Q==
X-Gm-Message-State: AOJu0YxjOaQcctdQbDWuRAM1Ept4hrxtPUqhS/MhyNBnRFy4m+akYuR9
	KYGDN8gFOutw1yqFgNQtsxQzmUNeA+j4NTBTecu0mv7TCeBX7u8/D/3DCDVO7u7fYosE91jbGsh
	AHvrJbXC9Mug5oKhcocKeKOYVHYPb4nNHhO7jiPw=
X-Gm-Gg: Acq92OELCUWSJzKawKV4AebelZlaBORCOlJ0oB0gl8hPu5sDPaIWhW0lHpqW0H66x+L
	Fl5tFV+FL68ngbmGfb+mBrRJQDUVJzIsS7Qc88N/j51Le5maIJTV/H9DzjY2qmVRV3Gejt6j7/x
	eb+tC/AEHbY7v9Epxu3hUWlwuFGRT+b/b78ocZthk5BCu8d0osUQpUW/kK7h0HWjN96MUL6EaQ+
	KXdlZcn68MSfmLSKlZxpCXAtAd3YF9xXPfV9dfaqUCFuD5xbF8C2ayVKGBITXjGhzxPz40v/TWH
	j83NOch+NBNKTPXmZxDY3L4XR0zgn+2/8Wa5iAaSVSdIbE4QHvZ3y02wM20D4Ugg/IUdG79L5NT
	+5qnAbQOU78KHvBwUGocha59ywijUsM5gkXrd+kL28P8DOoxCn0BgM9Xd32aVbdPRcYuuAtjfMm
	B04M2uZTo6HmHjoLjoCm2VZPNxJgvpEwzY
X-Received: by 2002:a05:6214:1248:b0:8ce:a005:3ea4 with SMTP id
 6a1803df08f44-8cee626da7bmr289512026d6.37.1780954808120; Mon, 08 Jun 2026
 14:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Jun 2026 16:39:56 -0500
X-Gm-Features: AVVi8CccRNvbFWSdO1GXEJLTgWuKRbGluuReWlNkjL6JBc3pXwi3noJi7bx4Z_0
Message-ID: <CAH2r5mvxrS6zhGA4kF=NxK6ZSqkto9_hvyyZyNfA+gGS7bwURA@mail.gmail.com>
Subject: full fstest list for Linux client
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>, Huiwen He <hehuiwen@kylinos.cn>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: multipart/mixed; boundary="000000000000b3126e0653c4dad5"

--000000000000b3126e0653c4dad5
Content-Type: text/plain; charset="UTF-8"

After doing some full test runs of all xfstests to investigate what
new tests pass, I have updated a test script for the Linux client that
runs all (or very nearly all) of the passing xfstests.   This is going
to be useful to improve regression testing for the Linux client (it
e.g. caught problems in two recent patches that were in for-next that
I then removed from for-next).  This also shows some of the
improvement in quality over the past year as more tests pass now.  And
with upcoming changes in for-next targetted for 7.2-rc we will be
adding at least five more.  These tests were run with
"modefromsid,idsfromsid" on top of the default mount options.

             Passed all 288 tests


-- 
Thanks,

Steve

--000000000000b3126e0653c4dad5
Content-Type: application/octet-stream; name=full-fstest-run
Content-Disposition: attachment; filename=full-fstest-run
Content-Transfer-Encoding: base64
Content-ID: <f_mq5qgfrh0>
X-Attachment-Id: f_mq5qgfrh0

Li9jaGVjayAtY2lmcyBjaWZzLzAwMSBjaWZzLzAwNiBjaWZzLzAwNyBjaWZzLzAwOCBnZW5lcmlj
LzAwMSBnZW5lcmljLzAwMiBnZW5lcmljLzAwNCBnZW5lcmljLzAwNSBnZW5lcmljLzAwNiBnZW5l
cmljLzAwNyBnZW5lcmljLzAwOCBnZW5lcmljLzAxMCBnZW5lcmljLzAxMSBnZW5lcmljLzAxMiBn
ZW5lcmljLzAxMyBnZW5lcmljLzAxNCBnZW5lcmljLzAxNiBnZW5lcmljLzAyMCBnZW5lcmljLzAy
MSBnZW5lcmljLzAyMiBnZW5lcmljLzAyMyBnZW5lcmljLzAyNCBnZW5lcmljLzAyOCBnZW5lcmlj
LzAyOSBnZW5lcmljLzAzMCBnZW5lcmljLzAzMSBnZW5lcmljLzAzMiBnZW5lcmljLzAzMyBnZW5l
cmljLzAzNSBnZW5lcmljLzAzNiBnZW5lcmljLzAzNyBnZW5lcmljLzA0MyBnZW5lcmljLzA0NCBn
ZW5lcmljLzA0NSBnZW5lcmljLzA0NiBnZW5lcmljLzA0NyBnZW5lcmljLzA0OCBnZW5lcmljLzA0
OSBnZW5lcmljLzA1MSBnZW5lcmljLzA2OCBnZW5lcmljLzA2OSBnZW5lcmljLzA3MCBnZW5lcmlj
LzA3MSBnZW5lcmljLzA3MiBnZW5lcmljLzA3NCBnZW5lcmljLzA3NSBnZW5lcmljLzA4MCBnZW5l
cmljLzA4NCBnZW5lcmljLzA4NiBnZW5lcmljLzA4OCBnZW5lcmljLzA5MSBnZW5lcmljLzA5NSBn
ZW5lcmljLzA5OCBnZW5lcmljLzEwMCBnZW5lcmljLzEwMyBnZW5lcmljLzEwOSBnZW5lcmljLzEx
MCBnZW5lcmljLzExMSBnZW5lcmljLzExMiBnZW5lcmljLzExMyBnZW5lcmljLzExNSBnZW5lcmlj
LzExNiBnZW5lcmljLzExNyBnZW5lcmljLzExOCBnZW5lcmljLzExOSBnZW5lcmljLzEyNCBnZW5l
cmljLzEyNSBnZW5lcmljLzEyNyBnZW5lcmljLzEyOSBnZW5lcmljLzEzMCBnZW5lcmljLzEzMiBn
ZW5lcmljLzEzMyBnZW5lcmljLzEzNCBnZW5lcmljLzEzNSBnZW5lcmljLzEzOCBnZW5lcmljLzEz
OSBnZW5lcmljLzE0MCBnZW5lcmljLzE0MSBnZW5lcmljLzE0MiBnZW5lcmljLzE0MyBnZW5lcmlj
LzE0NCBnZW5lcmljLzE0NSBnZW5lcmljLzE0NiBnZW5lcmljLzE0NyBnZW5lcmljLzE0OCBnZW5l
cmljLzE0OSBnZW5lcmljLzE1MCBnZW5lcmljLzE1MSBnZW5lcmljLzE1MiBnZW5lcmljLzE1MyBn
ZW5lcmljLzE1NCBnZW5lcmljLzE1NSBnZW5lcmljLzE2MSBnZW5lcmljLzE2NCBnZW5lcmljLzE2
NSBnZW5lcmljLzE2NiBnZW5lcmljLzE2NyBnZW5lcmljLzE2OCBnZW5lcmljLzE2OSBnZW5lcmlj
LzE3MCBnZW5lcmljLzE3NiBnZW5lcmljLzE3OCBnZW5lcmljLzE3OSBnZW5lcmljLzE4MCBnZW5l
cmljLzE4MSBnZW5lcmljLzE4MyBnZW5lcmljLzE4NSBnZW5lcmljLzE4NiBnZW5lcmljLzE4NyBn
ZW5lcmljLzE4OCBnZW5lcmljLzE4OSBnZW5lcmljLzE5MCBnZW5lcmljLzE5MSBnZW5lcmljLzE5
NiBnZW5lcmljLzE5NyBnZW5lcmljLzE5OCBnZW5lcmljLzIwMSBnZW5lcmljLzIwMiBnZW5lcmlj
LzIwMyBnZW5lcmljLzIwNyBnZW5lcmljLzIwOCBnZW5lcmljLzIwOSBnZW5lcmljLzIxMCBnZW5l
cmljLzIxMiBnZW5lcmljLzIxNCBnZW5lcmljLzIxNSBnZW5lcmljLzIyMSBnZW5lcmljLzIyOCBn
ZW5lcmljLzIzNiBnZW5lcmljLzIzOSBnZW5lcmljLzI0MSBnZW5lcmljLzI0MiBnZW5lcmljLzI0
MyBnZW5lcmljLzI0NSBnZW5lcmljLzI0NiBnZW5lcmljLzI0NyBnZW5lcmljLzI0OCBnZW5lcmlj
LzI0OSBnZW5lcmljLzI1MyBnZW5lcmljLzI1NCBnZW5lcmljLzI1NSBnZW5lcmljLzI1NyBnZW5l
cmljLzI1OCBnZW5lcmljLzI1OSBnZW5lcmljLzI2MSBnZW5lcmljLzI2MiBnZW5lcmljLzI2MyBn
ZW5lcmljLzI4NCBnZW5lcmljLzI4NyBnZW5lcmljLzI4OSBnZW5lcmljLzI5MCBnZW5lcmljLzI5
NiBnZW5lcmljLzMwMSBnZW5lcmljLzMwMiBnZW5lcmljLzMwOCBnZW5lcmljLzMwOSBnZW5lcmlj
LzMxMCBnZW5lcmljLzMxMyBnZW5lcmljLzMxNSBnZW5lcmljLzMxNiBnZW5lcmljLzMyMyBnZW5l
cmljLzMzMCBnZW5lcmljLzMzMiBnZW5lcmljLzMzNyBnZW5lcmljLzMzOSBnZW5lcmljLzM0MCBn
ZW5lcmljLzM0NCBnZW5lcmljLzM0NSBnZW5lcmljLzM0NiBnZW5lcmljLzM0OSBnZW5lcmljLzM1
MCBnZW5lcmljLzM1MSBnZW5lcmljLzM1MyBnZW5lcmljLzM1NCBnZW5lcmljLzM1OCBnZW5lcmlj
LzM1OSBnZW5lcmljLzM2MCBnZW5lcmljLzM2MiBnZW5lcmljLzM2NCBnZW5lcmljLzM2NiBnZW5l
cmljLzM3MyBnZW5lcmljLzM3NyBnZW5lcmljLzM5MCBnZW5lcmljLzM5MSBnZW5lcmljLzM5MyBn
ZW5lcmljLzM5NCBnZW5lcmljLzQwNiBnZW5lcmljLzQwNyBnZW5lcmljLzQxMiBnZW5lcmljLzQx
NSBnZW5lcmljLzQxNyBnZW5lcmljLzQyMCBnZW5lcmljLzQyMiBnZW5lcmljLzQyOCBnZW5lcmlj
LzQzMCBnZW5lcmljLzQzMSBnZW5lcmljLzQzMiBnZW5lcmljLzQzMyBnZW5lcmljLzQzNiBnZW5l
cmljLzQzNyBnZW5lcmljLzQzOCBnZW5lcmljLzQzOSBnZW5lcmljLzQ0MyBnZW5lcmljLzQ0NSBn
ZW5lcmljLzQ0NiBnZW5lcmljLzQ0NyBnZW5lcmljLzQ0OCBnZW5lcmljLzQ1MSBnZW5lcmljLzQ1
MiBnZW5lcmljLzQ1OCBnZW5lcmljLzQ2MCBnZW5lcmljLzQ2MSBnZW5lcmljLzQ2MyBnZW5lcmlj
LzQ2NCBnZW5lcmljLzQ2NSBnZW5lcmljLzQ2OSBnZW5lcmljLzQ3MSBnZW5lcmljLzQ3NCBnZW5l
cmljLzQ3NiBnZW5lcmljLzQ5MSBnZW5lcmljLzQ5OSBnZW5lcmljLzUwNCBnZW5lcmljLzUxOCBn
ZW5lcmljLzUyNCBnZW5lcmljLzUyOCBnZW5lcmljLzUzMiBnZW5lcmljLzUzMyBnZW5lcmljLzU0
NCBnZW5lcmljLzU1MSBnZW5lcmljLzU2NSBnZW5lcmljLzU2NyBnZW5lcmljLzU2OCBnZW5lcmlj
LzU4NiBnZW5lcmljLzU5MCBnZW5lcmljLzU5MSBnZW5lcmljLzU5OSBnZW5lcmljLzYwNCBnZW5l
cmljLzYwOSBnZW5lcmljLzYxMCBnZW5lcmljLzYxMiBnZW5lcmljLzYxNSBnZW5lcmljLzYxNiBn
ZW5lcmljLzYxNyBnZW5lcmljLzYxOCBnZW5lcmljLzYyMyBnZW5lcmljLzYzMiBnZW5lcmljLzYz
NyBnZW5lcmljLzYzOCBnZW5lcmljLzYzOSBnZW5lcmljLzY0MiBnZW5lcmljLzY0NiBnZW5lcmlj
LzY0NyBnZW5lcmljLzY1MCBnZW5lcmljLzY1NyBnZW5lcmljLzY1OCBnZW5lcmljLzY1OSBnZW5l
cmljLzY2MCBnZW5lcmljLzY2MyBnZW5lcmljLzY2NCBnZW5lcmljLzY3MCBnZW5lcmljLzY3MSBn
ZW5lcmljLzY3MiBnZW5lcmljLzY3NiBnZW5lcmljLzY3OCBnZW5lcmljLzY4MCBnZW5lcmljLzcw
MSBnZW5lcmljLzcwNSBnZW5lcmljLzcwNiBnZW5lcmljLzcwNyBnZW5lcmljLzcwOCBnZW5lcmlj
LzcyOCBnZW5lcmljLzcyOSBnZW5lcmljLzczMiBnZW5lcmljLzczNiBnZW5lcmljLzczNyBnZW5l
cmljLzczOCBnZW5lcmljLzc0MiBnZW5lcmljLzc0OCBnZW5lcmljLzc0OSBnZW5lcmljLzc1MCBn
ZW5lcmljLzc1MSBnZW5lcmljLzc1NCBnZW5lcmljLzc1NSBnZW5lcmljLzc1OCBnZW5lcmljLzc1
OSBnZW5lcmljLzc2MCBnZW5lcmljLzc2MSBnZW5lcmljLzc2MyAK
--000000000000b3126e0653c4dad5--
