Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA8F19E7D0
	for <linux-cifs@vger.kernel.org>; Fri, 29 Nov 2024 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732900508; cv=none; b=dh5uecmC4F0FfHPZ6+XaStAKItNfAy5oxvAbSjmfQa3AMEmR0tZWY53WAsJBQPjGP60g51CZVS89KdWzrmpL3BfeS2WEhmJbBQEvYii+FAY3fqGOMRDxwP7O3pIHn63KYEkIqOyUeKqpJwF2RuE0AWU6eNj6H6qiqVKiv9veciU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732900508; c=relaxed/simple;
	bh=GnhFjpEQk2QTU3xMRMxYSIU7Dc+xnhMFHvUYOX0FzPs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WzykQwAeM+3kTa+crFDRkHad4d2qyEYEscVp3JaIOYqlA1MIAw9Te8f73EmFjsF8QSSMpXmERfWpopT+QEwe9NIJaCfWjoCSpphmoy8SugF1kQRZlLmhgi6nyTHVU+46P5xPP3kiSKxYaEIgiMf4MJ3qXzETBU5uUEoV0mbv1NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83e5dd390bfso219892539f.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Nov 2024 09:15:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732900505; x=1733505305;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cabndGigWtS979m0rIc0e06+sfnwrdqk4oGx1hUPQVw=;
        b=LupjGCYVkIFtLI1TWPRkxhgsJO+csFHe9le9guZLi+UL4JQnVl90lcAnWP4F0ACO+U
         U2do4aOo4S5zcy/KM8+40wmUuT3efqj6yEQ1vidpIgJdr3RlasgVnZeBV3jCTl6KHZPF
         Dhm0VtuL0l2UnAu+6WZzIE1XDWtPS6i6yvIC16bM5dNfXduKCli4sM5LHGxPy8V4EM8H
         eUIwsFlA00lVD+yvH32LzdICDSyAA3T4TWlLQkmrP6eHqhMRrvio6ROsPba+4SWEfx1N
         XaJScz/RjRd69pFcao2e8FMdZsgjGa7UT1BG1JmECZv1v3eOwCjOcQdqQHvXrIIGjVoq
         x9bg==
X-Forwarded-Encrypted: i=1; AJvYcCWqdIMWd8+z518HKxOGb/5+Vt3ZajX6FcWio4vl0Ic1Rl9AMwcOcVBe1s4AfBmF47OVN9WiH/tNtosl@vger.kernel.org
X-Gm-Message-State: AOJu0YyVjB5E8r3Q6I926UmQ1xnAo+8OAxPIkneyzovru+B1kHDRdENm
	dyKwsUE62MkAEYaGStrtyU9Yndhz9ew155ydQcG7voDLwOVlImFDjLOmXmpag1nf8l37yXHuKru
	Fld94U2GWPPmKjj9QNNpmtx7jTLGIe0AavvsJwTW3w6aASvB4PrwB3gU=
X-Google-Smtp-Source: AGHT+IHe8uD7Va/t9RghiydunC7nRHm/GXM4J1aMUOaYHKIypML+ORhOP4P4xsuLh0/azcIVXHk232/8no/NPRjgk/tTxHq54l6N
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a46:b0:3a7:c81e:825f with SMTP id
 e9e14a558f8ab-3a7cbd23d37mr83760205ab.9.1732900504111; Fri, 29 Nov 2024
 09:15:04 -0800 (PST)
Date: Fri, 29 Nov 2024 09:15:04 -0800
In-Reply-To: <4020304.1732897192@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6749f698.050a0220.253251.00bd.GAE@google.com>
Subject: Re: [syzbot] [netfs?] INFO: task hung in netfs_unbuffered_read_iter
From: syzbot <syzbot+8965fea6a159ab9aa32d@syzkaller.appspotmail.com>
To: asmadeus@codewreck.org, bharathsm@microsoft.com, brauner@kernel.org, 
	dhowells@redhat.com, ericvh@kernel.org, jlayton@kernel.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux_oss@crudebyte.com, lucho@ionkov.net, 
	marc.dionne@auristor.com, mathieu.desnoyers@efficios.com, mhiramat@kernel.org, 
	netfs@lists.linux.dev, pc@manguebit.com, ronniesahlberg@gmail.com, 
	rostedt@goodmis.org, samba-technical@lists.samba.org, sfrench@samba.org, 
	sprasad@microsoft.com, syzkaller-bugs@googlegroups.com, tom@talpey.com, 
	v9fs@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+8965fea6a159ab9aa32d@syzkaller.appspotmail.com
Tested-by: syzbot+8965fea6a159ab9aa32d@syzkaller.appspotmail.com

Tested on:

commit:         2aece382 netfs: Report on NULL folioq in netfs_writeba..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git netfs-writeback
console output: https://syzkaller.appspot.com/x/log.txt?x=159cf3c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=225053d900535838
dashboard link: https://syzkaller.appspot.com/bug?extid=8965fea6a159ab9aa32d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1328f3c0580000

Note: testing is done by a robot and is best-effort only.
