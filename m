From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: Re: [PATCH v3 0/3] CIFS support for XFS test suite
Date: Wed, 3 Sep 2014 10:23:47 +0400
Message-ID: <CAKywueRns+hehrZ3dQ8a8XnaHbd6tNh1BnZAwsTxNTV_w6V6SQ@mail.gmail.com>
References: <1409341340-27031-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	"samba-technical@samba.org" <samba-technical@samba.org>,
	David Disseldorp <ddiss@suse.de>,
	Steve French <smfrench@gmail.com>
To: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1409341340-27031-1-git-send-email-pshilovsky@samba.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2014-08-29 23:42 GMT+04:00 Pavel Shilovsky <pshilovsky@samba.org>:
> These are patches that adds CIFS support to XFS tests.
>
> The first patch changes generic/013 test to use mount options provided for $TEST_DEV for remount. The second patch adds "-cifs" command line argument and CIFS specific variables. The third patch disables tests that need POSIX behavior from filesystem for unix cifs mounts.
>
> With these patches applied, most of generic/shared $TEST_DEV tests pass for the recent kernel cifs module.
>
> Changes since v2:
> 1) patch #3 uses separate _require_test_{feature} functions rather than generic _require_test_posix_ext
> 2) patch #2 adds UDF notes to README
>
> Pavel Shilovsky (3):
>   generic/013: encapsulate remount during cleanup
>   common: add cifs support
>   cifs: skip tests that need POSIX support for nounix mounts
>
>  README            |  5 +++--
>  check             |  2 ++
>  common/config     | 31 +++++++++++++++++++++++++++----
>  common/rc         | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/005 |  8 ++------
>  tests/generic/013 |  2 +-
>  tests/generic/023 |  1 +
>  tests/generic/024 |  1 +
>  tests/generic/025 |  1 +
>  tests/generic/131 |  1 +
>  10 files changed, 94 insertions(+), 13 deletions(-)
>
> --
> 1.9.1
>

Any comments on the series?

-- 
Best regards,
Pavel Shilovsky.
