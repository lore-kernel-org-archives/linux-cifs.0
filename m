From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 0/3] CIFS support for XFS test suite
Date: Wed, 27 Aug 2014 00:28:35 +0400
Message-ID: <1409084918-17764-1-git-send-email-pshilovsky@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

These are patches that adds CIFS support to XFS tests.

The first patch changes generic/013 test to use mount options provided for $TEST_DEV for remount. The second patch adds "-cifs" command line argument and CIFS specific variables. The third patch disables tests that need POSIX behavior from filesystem for unix cifs mounts.

With these patches applied, most of generic/shared $TEST_DEV tests pass for the recent kernel cifs module.

Pavel Shilovsky (3):
  generic/013: encapsulate remount during cleanup
  common: add cifs support
  cifs: skip tests that need POSIX support for nounix mounts

 README            |  5 +++--
 check             |  2 ++
 common/config     | 31 +++++++++++++++++++++++++++----
 common/rc         | 39 +++++++++++++++++++++++++++++++++++++++
 tests/generic/005 |  1 +
 tests/generic/013 |  2 +-
 tests/generic/023 |  1 +
 tests/generic/024 |  1 +
 tests/generic/025 |  1 +
 tests/generic/131 |  1 +
 10 files changed, 77 insertions(+), 7 deletions(-)

-- 
1.9.1
