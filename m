From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Fri, 12 Apr 2013 11:53:46 -0500
Message-ID: <CAH2r5msLL35BEzzCEcKg1xDBry4MzoDoOjNb78Du7-SugHxYrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixes a regression in cifs in which a password which begins with a
comma is parsed incorrectly as a blank password

The following changes since commit 66ade474237745a57b7e87da9a93c7ec69fd52bb:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
(2013-04-03 16:15:17 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor

 fs/cifs/connect.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

--
Thanks,

Steve
