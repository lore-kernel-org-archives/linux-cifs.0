Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F0A268C42
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 09:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763459945; cv=none; b=AXopFIUMSa/fG3gDOdCLNyIqVOmOuWoLsa7TFXzAhDDZnTJYiRVodlibfrgYeiyVXKSZg8k5NZv5XQVfidR4wISE6eFnZ1Q9mGWLQp3Q2X1Kbk4neq8vS2uGt+SUtLktheX11sY5DUoZ3djbfBKgTkog6VYhp7YK27z+ZW0rXd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763459945; c=relaxed/simple;
	bh=eYVK5tHF99gmNVBpMrLKs0ClXmamXMM467i2roKtSIc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Yq09YY+D6V9m/x8Uw3WeuUw9vQEfmMPzcubYyYsvwV7MCxGohUepYgQTI6/i3U64fwEwC0hCU1lUbkhEgB462nqJsbsCI5ggT31nAloKd9zzfdO0HqDGOSgmFptO5fMf4j2mDbv5IxrKttCUFbqp/ePOWNxRGxprHhE3co18oiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-9486c2da7f6so445782039f.2
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 01:59:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763459943; x=1764064743;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1F4+39iWa7k+l/mpdoL1DzhX7KHVuD11tR9zgOHCaaQ=;
        b=j1kGS3Uu/nNm9Tw8iCld5krnfIWmMKNKVGRgq4y0kF/0V+wkkH1g6vVOimucxUUlIb
         +/6F1ukwzCYEHKSgxkQkRnhRVeG8RosuSHKku+ksBCwfVY80l5BMfdSS9YKmyKsrQEXa
         Q+B8VAAZAuXMk7vIcnF3BKR6B6MyX5kOMyEAlbXDsKIQwM1gd0TSyIAK5ZA88yM58H2w
         uhInFsx5ZO6F8CWJFQnDw0uOFrwNmDBIn9b+eYU0jpF3rEzUWkZKpIBUWbjItT8cuBJt
         y5HzPl/v4E1CHkcWTNZpQM7JcSCQNZiFapAx+U5nD0DNb8QwAx2hyJ8rCLGSjaFyqxgV
         G2GQ==
X-Gm-Message-State: AOJu0YzpOq2mWJdfra342W7QDFz3EeoQnD3QroqwIWok/2bd1Q/opTV5
	MzvJYXWFM83qHGA3UagEYFjZCd/66AJk0D2VT19nZa5q6HiVbvHkpZMXmNVtrGvL6nuGphuq7FU
	r0+7lnlfAmzd5+z79j+UWVtHSd3EESpZOO8ag0WsVlZqHJ4E+c/HLAuQbOSg=
X-Google-Smtp-Source: AGHT+IFxmJyfGpkCxNxDKj46b5OXv0hf66FZ5sG8bVy+N0TB/Pp+7i6SvLsOu4Hc82BFBH65R8WV1kArk7debQf/sKeUXsjNrzhM
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a26:b0:433:1e9b:61de with SMTP id
 e9e14a558f8ab-4348c93f13cmr160188085ab.24.1763459943435; Tue, 18 Nov 2025
 01:59:03 -0800 (PST)
Date: Tue, 18 Nov 2025 01:59:03 -0800
In-Reply-To: <01e16af7-4f76-40eb-89c2-79386850d756@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691c4367.a70a0220.3124cb.00ba.GAE@google.com>
Subject: Re: [syzbot] [cifs?] memory leak in smb3_fs_context_fullpath
From: syzbot <syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com>
To: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssranevjti@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file fs/smb/client/fs_context.c
patch: **** unexpected end of file in patch



Tested on:

commit:         e7c375b1 Merge tag 'vfs-6.18-rc7.fixes' of gitolite.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb128cd5cb439809
dashboard link: https://syzkaller.appspot.com/bug?extid=87be6809ed9bf6d718e3
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=125ef212580000

