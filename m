From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 15 Sep 2013 23:57:19 -0500
Message-ID: <CAH2r5muOG7Pvg+7qhgb1BuQHQkse4h9GZsf_CMHLaxyPHnpFnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Two minor cifs fixes and a minor documentation cleanup for cifs.txt

The following changes since commit bdbdfdef5766c2a60185e946df242f1bc0d3=
7c09:

  Merge tag 'hwmon-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
(2013-09-13 10:58:41 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 81b66220a9ebea7dd1547388279ee1898d7fe0f9=
:

  cifs: update cifs.txt and remove some outdated infos (2013-09-13
16:29:58 -0500)

----------------------------------------------------------------
Bj=F6rn Jacke (1):
      cifs: update cifs.txt and remove some outdated infos

Sachin Prabhu (2):
      cifs: Do not take a reference to the page in cifs_readpage_worker=
()
      cifs: Avoid calling unlock_page() twice in cifs_readpage() when
using fscache

 Documentation/filesystems/cifs/cifs.txt | 42 +++++++++----------------=
--------
 fs/cifs/file.c                          | 15 ++++++++----
 2 files changed, 21 insertions(+), 36 deletions(-)

--=20
Thanks,

Steve
