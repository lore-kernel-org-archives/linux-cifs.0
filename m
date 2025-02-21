Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444EE20D51D
	for <linux-cifs@vger.kernel.org>; Fri, 21 Feb 2025 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740144005; cv=none; b=RVW6ljHocMT8xdmAwIOvqUuMe5YSseY62O5A8ZwPINaqXCuzSXlABnQFMrpdMaLKXA2s/TIw3FNPzIzTlIgZ6GAqCfQdMn9Xpp0yN2iuDSLA48FQKciYurjaliNNc01EX+HHhhl7E9eQJVvkSrD9GTX9eypZLrwYJ5dKb/BgSPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740144005; c=relaxed/simple;
	bh=4vCKVNEsEgWIs64ubjYODu9ezwCabVqJz8/9mUMtinc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=O6vYExR6uNmOmq40fsPM5QD02kbukanmLFAAWoN7OyXzllYiSeWq2RkNJYmPA+GBibp9gCXywckvTWJV2nEP+B9USkSA41AXQvjKyi49f62qMbaeQPcXddPExM4Pz+Hh8gw6sVq1E9zyWnbPUoAtj/gfTVXOKi0XYmYJZoDQoZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d2b6d933acso16249695ab.3
        for <linux-cifs@vger.kernel.org>; Fri, 21 Feb 2025 05:20:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740144002; x=1740748802;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TKOeUNmgFq9mGFTlFKpVDLkAHhwJwc1BYdbAZYlmsac=;
        b=VoTMiuEWzq8yKQijHX9tziwABV3u57SVY2e+8b37z7YLRMlUjv1yQb98RCVirpEhTR
         ugid5Ci6ablSXsjXWJ+l1dwPgTLpVrPh/OOro/BKDuePCljyLWez7qEOqmgrVtattkDj
         ZEUeguGr8rjs39yY/SRnExtx9dY2yrDmlmZOsE77e8x+3pmg4mNC/LORSRUjkF34kvER
         x7Zi5rmBgXaHn7hU9lhKzEeYOypZaI5WrmrkhELQDZz46eVTxqRmmcvxZqCvZ15ifCWn
         hJqogfmdCe9/lO0M1MTyD0t77U2yIL1jaJYDpaISO+BIBF7fEBXw8/rMA1sFpQZwqOQi
         0VGw==
X-Forwarded-Encrypted: i=1; AJvYcCWFjBms+RRzAoXanxe/N6ygiUqxgxYeGrBBmrHdPlpu1AeUpWQAP56XrXwTqPDX04YbpWbA3xudLXVJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyir3tUr6IzOWHhPvE3hGAK4cObzD+PW0pPRvPTmrhv19lAdpmK
	CTTp1J/1/6w4LoCNsn5JNZITz9ZybTVUYI2v1IUB7okTSAHc1MwXx+lGB3FDn6tsPLCFyha35B2
	/1WMj3K8QkJOUjsUr2IXsfCUaSHW+amNGZqMvwuBN54CrkZrWPkz3tAE=
X-Google-Smtp-Source: AGHT+IFk7iXIGjPM3Cd4yMSgfW4vr1fE96DRJ9EACQSHU1A21Wn9X6x85b6VG+vkzitZxJM+02ayoLSehtNh39Na0i/XwqFmq+M9
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c5:b0:3d2:5a0a:7227 with SMTP id
 e9e14a558f8ab-3d2cb48229dmr21416275ab.13.1740144002400; Fri, 21 Feb 2025
 05:20:02 -0800 (PST)
Date: Fri, 21 Feb 2025 05:20:02 -0800
In-Reply-To: <6792ffb7.050a0220.3ab881.0005.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b87d82.050a0220.14d86d.04d4.GAE@google.com>
Subject: Re: [syzbot] [mm?] [v9fs?] BUG: stack guard page was hit in sys_openat
From: syzbot <syzbot+1f18c9b1bb51239d82f2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, asmadeus@codewreck.org, bharathsm@microsoft.com, 
	brauner@kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com, 
	ericvh@kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux_oss@crudebyte.com, lucho@ionkov.net, marc.dionne@auristor.com, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, netfs@lists.linux.dev, 
	pc@manguebit.com, ronniesahlberg@gmail.com, rostedt@goodmis.org, 
	samba-technical@lists.samba.org, sfrench@samba.org, sprasad@microsoft.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com, v9fs@lists.linux.dev, 
	xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit e2d46f2ec332533816417b60933954173f602121
Author: David Howells <dhowells@redhat.com>
Date:   Mon Dec 16 20:41:17 2024 +0000

    netfs: Change the read result collector to only use one work item

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15cb3ae4580000
start commit:   9528d418de4d Merge tag 'x86_urgent_for_v6.13' of git://git..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d7f05e16f48c5834
dashboard link: https://syzkaller.appspot.com/bug?extid=1f18c9b1bb51239d82f2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17808824580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129252b0580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfs: Change the read result collector to only use one work item

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
