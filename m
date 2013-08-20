From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 0/3] cifs: fix case-insensitive filename matching and hashing
Date: Tue, 20 Aug 2013 15:50:08 -0400
Message-ID: <1377028211-17624-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	glogow@fbihome.de, bj@sernet.de
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This patchset embodies a new scheme for handling case-insensitive
filename matching. The problem currently is that we rely in the NLS
subsystem to handle this, and it's quite frankly not up to the task
if the local charset is UTF8. There are two major problems:

1) The NLS subsystem assumes that characters are always a single byte
   which is clearly wrong in the case of UTF8.

...and even if it did handle that better:

2) nls_utf8.ko has no concept of upper or lowercase characters. All
   bytes passed in are identity-mapped, and there are no tables to
   do this mapping.

This scheme instead converts the characters to wchar_t's using the
normal NLS routines, and then uses a converted version of the mapping
table that Windows uses to convert those to uppercase. With that
scheme, case-insensitive handling now works, even if UTF8 is in use.

This patchset is fairly new, but I've given it some smoke testing and
it seems to be ok. It's possibly a candidate for 3.12, given the
brokenness of the existing CI code. Getting it into linux-next soonish
would be good.

FWIW, it might be reasonable to move the winucase.c file into generic
NLS code if other filesystems have the desire to use it. I'm not opposed
to doing that, but didn't want to do so unless there was interest in
using this in other filesystems.

Jeff Layton (3):
  cifs: add new case-insensitive conversion routines that are based on
    wchar_t's
  cifs: convert case-insensitive dentry ops to use new case conversion
    routines
  cifs: add winucase_convert.pl to Documentation/ directory

 Documentation/filesystems/cifs/winucase_convert.pl |  62 ++
 fs/cifs/Makefile                                   |   2 +-
 fs/cifs/cifs_unicode.h                             |   2 +
 fs/cifs/dir.c                                      |  58 +-
 fs/cifs/winucase.c                                 | 661 +++++++++++++++++++++
 5 files changed, 776 insertions(+), 9 deletions(-)
 create mode 100755 Documentation/filesystems/cifs/winucase_convert.pl
 create mode 100644 fs/cifs/winucase.c

-- 
1.8.3.1

