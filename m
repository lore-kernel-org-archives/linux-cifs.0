From: Steve French <smfrench@gmail.com>
Subject: [GIT] CIFS Fixes
Date: Wed, 4 Jan 2012 11:18:01 -0600
Message-ID: <CAH2r5mup_rpBGmiUGFexaaZtdN2zRP8=v9Dy5YTiQ0pY0U89nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The following changes since commit f9fab10bbd768b0e5254e53a4a8477a94bfc4b96:

  hung_task: fix false positive during vfork (2012-01-03 16:14:32 -0800)

are available in the git repository at:
  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix bad buffer length check in coalesce_t2

Steve French (1):
      [CIFS] default ntlmv2 for cifs mount delayed to 3.3

 fs/cifs/connect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


-- 
Thanks,

Steve
