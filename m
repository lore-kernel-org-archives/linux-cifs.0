From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/2] CIFS support for XFS test suite
Date: Sat, 23 Aug 2014 12:16:01 +0400
Message-ID: <1408781763-30127-1-git-send-email-pshilovsky@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

These are two patches that adds CIFS support to XFS tests.

The first patch adds "-cifs" command line argument and CIFS specific variables. The second patch setups a directory tree for possible CIFS specific tests.

With these patches applied, most of generic/shared $TEST_DEV tests pass for the recent kernel cifs module.

Pavel Shilovsky (2):
  common: add cifs support
  common: add a directory tree for cifs tests

 README              |  5 +++--
 check               |  2 ++
 common/config       | 17 +++++++++++++----
 common/rc           | 33 +++++++++++++++++++++++++++++++++
 tests/cifs/Makefile | 14 ++++++++++++++
 tests/cifs/group    |  5 +++++
 tests/generic/013   |  7 ++++++-
 7 files changed, 76 insertions(+), 7 deletions(-)
 create mode 100644 tests/cifs/Makefile
 create mode 100644 tests/cifs/group

-- 
1.9.1
