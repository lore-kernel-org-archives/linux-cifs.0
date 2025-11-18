Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACEB30C601
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 12:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763467804; cv=none; b=ICgwMzB8Z69CTFEEzup8xkcKlMlD2soEj2hI16oehGHCHl90sFpM9KUdICFFqyB86TwKY5t13o8/E08BEGBVEeNxxfl3vgoNB2pxYAx+bdmG7JLF6ENIYt/85sDhdxYSQyu8BzyU/hwvS6RMBd4CSvSijsohhcbUKqshRmVPvRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763467804; c=relaxed/simple;
	bh=byOcPlpdfvk0F7G82i47iQoMRnYJcyJOzxrJGAhJmoc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qKjf7qLOplDTmfoIHLzD3JK015TqQ5a+plVKAhQSefypGbZeOPZXyheo8a+RLspBXSk5cwGlyP5JKlmUeDNoXk+MbghXUgJBPU6XuiO/rQI+4HztP5BhnA1iBFxIa8cj2QmE0g3LUvjBixWf3WUoGjJpubRZvGw72sjA9I12lAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-945c705df24so643829539f.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 04:10:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763467802; x=1764072602;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WLYt9N5wQEgzJ53nVxRgAlq1RG3P9zclJt9kSY9Tg+c=;
        b=SkFVaNU8wk9RJThzjyVBEYggA/dDzmanvYPpJLaiMf5mfnggJOrZFq1sY5jadY5xXV
         ftb5ZUiwoOIBRCKPdShBmTkZ8aHfROFzsXI6yTxDHmdM8bRzGeJJDywtlWwEqJ0VGhkb
         dWM4vgHWw1iUSaYXaR3Fdm36wo9pl+dgsndIKEjoNhh3EitMzpz/xxPKwvo8P3lPasXb
         vZPO1dj1Cbu6ntTqlA4GWfzSOVG6OFeI9fbaweltjJhkCOE0ENhFsVg/0Y34e9ivPoRo
         hTEODB1k7QsSfTcpSbhPg2/BHLeJfdmLGhjhwjdxl3blMjGdt7DcCLj/T0Rnip0pgMOD
         WWLg==
X-Gm-Message-State: AOJu0YxWPgfHJYU1O4kG2dM4Qq656FXrmqbgd2HTQ+SfD45fbABpOx/i
	klmytr76+CniTwlN8Hrln/Ra08dvSQYFCvxSLAhRa8ZeQvsylqM03Mu/iR03arSgfg9QmaZu3LP
	lAC4A4BN3Xi0W8Fh4PiAiEPxLeFEXYwfsPj9NLoI0SSQtC2Y8AvcNf0TgHfc=
X-Google-Smtp-Source: AGHT+IFb7fBUTN7mHre+rofh8ByeSd9ZzD0uow69Y9Cdo12E0VhEzZTG1Rgv0FbZcjT6dmdolGRC/nWJOaQ438e9U0/MGwMOYstp
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a63:b0:433:3060:f5b with SMTP id
 e9e14a558f8ab-43592e03999mr31824505ab.12.1763467802111; Tue, 18 Nov 2025
 04:10:02 -0800 (PST)
Date: Tue, 18 Nov 2025 04:10:02 -0800
In-Reply-To: <8819ae8c-93b8-4942-871d-a821359ca625@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691c621a.a70a0220.3124cb.00c3.GAE@google.com>
Subject: Re: [syzbot] [cifs?] memory leak in smb3_fs_context_fullpath
From: syzbot <syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com>
To: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssranevjti@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Tested-by: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com

Tested on:

commit:         e7c375b1 Merge tag 'vfs-6.18-rc7.fixes' of gitolite.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1399f212580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f30cc590c4f6da44
dashboard link: https://syzkaller.appspot.com/bug?extid=87be6809ed9bf6d718e3
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1129f212580000

Note: testing is done by a robot and is best-effort only.
