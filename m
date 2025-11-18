Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4173375C2
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 11:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763466487; cv=none; b=X3ePkxKtOcGDQDrAwwQd3IM2UEhZTTjtaVzEgBCiI+bh7thnp0kRNBOhKPpcIX9XdkX8dXnIhpuGsMFmB+S1Jh8jgAWL7PzyAwwnt37/VO54TCTV0+H019/DaQTM2JCb0kIWaou0X3YXDRs6aGLjAOfp9rt1M9iTU6l2lPdizwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763466487; c=relaxed/simple;
	bh=/jokgqhSAFMekCYYiMc0GS/66+rDx4g6ozF0Oi1fw2Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bh+kpoy6pgn1wsOVGu/WeLn7EF+F5Es9TyC3ljvzyy/ZMGjrLafmpaFjwA2BJkhemCUz8iWE1Bt/Y6qfshXJJDcDvGNimOj93rqyBmhgkI7uD+X4c92nvhvHa/gVS7UAtnXZhxHleRA+GkrFtgEr/UU7LTz/o0v89lxnfvWP0ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-43329b607e0so60602725ab.2
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 03:48:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763466485; x=1764071285;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7eHg1UJdJJTmlR4Sm8mwISV1t3EoazLR6jPZAk6scl4=;
        b=D5kfJY9kR+eOgGy2R2clSG4YXgtB31Z1QiKpX1FzkenH7U2G096eLHVYV+qhs/1UIs
         dAaEbsBNBXkGRJLCFgcicYYlZNqfkOjPgFZQFSQV9a0i/mRpm9NZRlx5GfiQz3dOr/Zk
         +wJ/uIHdQchf7zxvU6/+NuicIJJSdpOZC2lxLkM+JfQDSdn9CVsFlmJsj0pEco+RlbcZ
         hsMhJTMW2IbImb4T4WXjv7TSP1GMNffLre9MfRUDpcjprI9IiU9NgokecM4bVmCIWwkE
         73aQ9+ygvht6V5LF/bswHU8SRd83jaxJQIISNIEcRymdDdQNWMspX/VN5vxpvrGh7I87
         Yj0g==
X-Gm-Message-State: AOJu0Yx713XA+rTr8FDy5CZmkyGlwYUEK6zZPAE9qiGW55OHCbYwhHQt
	wtv5q7XAK3THIjDHQjbbDkRTWVR+1bs+CskRiSgfS39tnjOTxdAulLNH3N2bnzy6+kuoG+H3dH8
	XUVJe8reEHPg0OuVTqpQHTIIKgGnBujubgP5Nl3v/anorz7xwrnDWEcs1reA=
X-Google-Smtp-Source: AGHT+IFGo+wGmp9kZSzSscOhyaDWwpIfZs/K9X8BNFV8wmigZyCjilJz1y2ile5XdmhqZRjekvN28+Sru6u2kvqzyYTNDAARqZ5e
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3181:b0:433:7c77:be5a with SMTP id
 e9e14a558f8ab-4348c939ad9mr241364585ab.28.1763466485255; Tue, 18 Nov 2025
 03:48:05 -0800 (PST)
Date: Tue, 18 Nov 2025 03:48:05 -0800
In-Reply-To: <8831475d-0eeb-4107-ad87-c9c8736c219c@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691c5cf5.a70a0220.3124cb.00c1.GAE@google.com>
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
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17661658580000

