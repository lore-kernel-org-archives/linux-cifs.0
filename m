Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BA31F03CE
	for <linux-cifs@vger.kernel.org>; Thu, 13 Mar 2025 12:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741867937; cv=none; b=Hw+pwQQW40PcXKYdezMKMK09X2JXsQCpseoi2KUYMJoWaUHthTje368unvpYsnjGR3uhhUFAiCJ0/lt1epZIXtQiEl5g6ZoRmV37H9VzxwlH+vaUUAGuYCrF7rGTrIi3l2juLHRJzzPsDASwnD++EvON9nOyoV5hYSDk6/rva1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741867937; c=relaxed/simple;
	bh=CmABCopn9hnAftYgQG7oCQ3D+PwyLCduLoDODPTQGQU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=SZp9vIQGwopxyOwbgYul8dVo+KFbNNvKLaueX/pxQeiOG11u9gD94ULvI0IvM8x/+4/Qv5jsZmt9DbFeIFZILy2JXldjumX9OifhA2q5hKCjQLjWZDHYhWx4y3ZQ+UrJpRER+UaChNg7i3ArabuXh6KK8E+Ga/HnGLoeUK1CLS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FYMPUy1T; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FYMPUy1T"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3913d129c1aso692059f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Mar 2025 05:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741867933; x=1742472733; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CmABCopn9hnAftYgQG7oCQ3D+PwyLCduLoDODPTQGQU=;
        b=FYMPUy1Ty/5Epz00l0ISxxsuPHYkZBH4cH5rNSqGZxr4g5WefBBqgF0m0a2EQaoU2v
         QwVmOck8bMO/wqZOmV0TGemISpkkLeNRJ5eLK5e2fR7FLGrHFmEb4CwZEm4Y2VSTy07j
         iVirlbPsVoltNvNTzWI0alf+YwzEFBvyujU7ZfcnC7yPkMNvXyT/8yIZA5aFAT9UCcQF
         /C0dRZSTQ3Whq7KnWMuI6H816r6KDut3873KmznbQMc3D4Bjgdz8OUe6Y/8iYx8u+tAr
         xUB/cbMHlgRqIZ+E13WSEsKH138413Y8C31O0Ouhf5r+CaBsbrOVUseLDZBJ4ARwUQUA
         euEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741867933; x=1742472733;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CmABCopn9hnAftYgQG7oCQ3D+PwyLCduLoDODPTQGQU=;
        b=NIMCUX9jZ8BPdZzYp/F/+b8Pe+1EL3Ef9A0GqwOqas35nbw0dUInAk6r7jS1ctYQ6n
         rIu9XJaMUItGniOXDpc5PAMHFeD4YbVuWqGdi3vG+UsSYfveEIM7mfApSRRMw/IW2mE4
         1limPMIvcaS4GG690aZhOIP3CwmEp5LOLLa859XdiQ891kFzH0Tvth0/zNc9atvdAe+C
         NH8UgR2lAbjKFKEOQoy9Qsv3zY8AiGyRt6pimrzT+AZMo/9cMqiHyxeTnwXj4VRZam5o
         LtckivmawQhWUWvbb+Au23QASeyzt/BQX1m+ahiLJuh92JeSuXEWlYhl2+6tU/j53mkF
         kM5Q==
X-Gm-Message-State: AOJu0YzEYuwLmIeKRs0Ztlr+OEviqJNCnry43SSiDm9GYuo5uxh8Jk28
	sB8f8C6hqPFmjdFbDzZKz7L5GVSjGmsU0Nr9pH2uZBXpFI64naS/G9R70vx/SEuNVEn/FCOfg6K
	0NfwPjioQz0d4t/AKTte6qwc7x8JeEUXr
X-Gm-Gg: ASbGnct9bvBmeiybd5WZvzoh/Qv41i5XBFtHxDeHVNVLjCFcWRYZQz8LPFzLlwl4Nvj
	8gldtCeaCKzs65IEbhHC1QYhy6NhJvPqkMWAzSp2zmF2uu+S2xS0CqprQtv1o3sD3c8hl4sISse
	iYpVGXzM1gvG0ePZ68jT+ugMbJ
X-Google-Smtp-Source: AGHT+IEysKzf5yVHBPPkjwC9HKeIn6kgQXZfqkBjv1XX384+jRWxAtQmK60ZInkECZwD9CJzohtLnVqoAzRXndDR7/o=
X-Received: by 2002:a5d:64cb:0:b0:38f:23c4:208c with SMTP id
 ffacd0b85a97d-395b954ea75mr1889894f8f.18.1741867933165; Thu, 13 Mar 2025
 05:12:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jiadong Liu <jiadong.liu.cn@gmail.com>
Date: Thu, 13 Mar 2025 14:12:02 +0200
X-Gm-Features: AQ5f1JqGMmh1kHkFab5C26MMM7a42RfHOyx_KaUMRmJoV-pVEVGXHjysjhsZszc
Message-ID: <CANrFC8U0FywyScrBUCVisKyXhO3h3G0XaJp4soSKOZgQNW82qw@mail.gmail.com>
Subject: SMB Share Deleted Automatically
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear CIFS Experts,

I hope you are all doing well.

I am currently running AWS Linux 2023 and using cifs-utils with SMB3
to mount a share hosted on a Windows Server 2016. Recently, I
encountered an issue after applying the February 2025 cumulative
update to the Windows Server. Unfortunately, the update failed, and I
reboot the server in a regular routine.

After the reboot, I noticed that my Linux machine's journalctl logs
contained the following messages:

kernel:CIFS: Server share \\MyServer\Myshare deleted.
kernel:CIFS: Server share \\MyServer\Myshare deleted.

It appears that the mounted share was removed, and I am unsure how to
proceed with troubleshooting this issue or what steps I can take to
prevent similar occurrences in the future. My mount cmd options are
"-t smb3 -o vers=3.0,rw,nocase,hard,file_mode=0700,dir_mode=0700" with
other options about uid/gid, force them and login related.

Would anyone be able to provide guidance or suggestions on how to
diagnose and mitigate this problem? I would greatly appreciate any
insights or recommendations you can share.
In normal case, e.g if I shutdown the windows file server, the mount
will remain and file access will be hung. And once the windows server
is back, file access will be made again.

Thank you in advance for your time and support.

Best Regards,
Jiadong
